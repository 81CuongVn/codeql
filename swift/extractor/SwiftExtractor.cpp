#include "SwiftExtractor.h"

#include <iostream>
#include <memory>
#include <unordered_set>
#include <queue>

#include <swift/AST/SourceFile.h>
#include <swift/Basic/FileTypes.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>

#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/visitors/SwiftVisitor.h"
#include "swift/extractor/TargetTrapFile.h"

using namespace codeql;
using namespace std::string_literals;

static void archiveFile(const SwiftExtractorConfiguration& config, swift::SourceFile& file) {
  if (std::error_code ec = llvm::sys::fs::create_directories(config.trapDir)) {
    std::cerr << "Cannot create TRAP directory: " << ec.message() << "\n";
    return;
  }

  if (std::error_code ec = llvm::sys::fs::create_directories(config.sourceArchiveDir)) {
    std::cerr << "Cannot create source archive directory: " << ec.message() << "\n";
    return;
  }

  llvm::SmallString<PATH_MAX> srcFilePath(file.getFilename());
  llvm::sys::fs::make_absolute(srcFilePath);

  llvm::SmallString<PATH_MAX> dstFilePath(config.sourceArchiveDir);
  llvm::sys::path::append(dstFilePath, srcFilePath);

  llvm::StringRef parent = llvm::sys::path::parent_path(dstFilePath);
  if (std::error_code ec = llvm::sys::fs::create_directories(parent)) {
    std::cerr << "Cannot create source archive destination directory '" << parent.str()
              << "': " << ec.message() << "\n";
    return;
  }

  if (std::error_code ec = llvm::sys::fs::copy_file(srcFilePath, dstFilePath)) {
    std::cerr << "Cannot archive source file '" << srcFilePath.str().str() << "' -> '"
              << dstFilePath.str().str() << "': " << ec.message() << "\n";
    return;
  }
}

static std::string getFilename(swift::ModuleDecl& module, swift::SourceFile* primaryFile) {
  if (primaryFile) {
    return primaryFile->getFilename().str();
  }
  // PCM clang module
  if (module.isNonSwiftModule()) {
    // Several modules with different names might come from .pcm (clang module) files
    // In this case we want to differentiate them
    // Moreover, pcm files may come from caches located in different directories, but are
    // unambiguously identified by the base file name, so we can discard the absolute directory
    std::string filename = "/pcms/"s + llvm::sys::path::filename(module.getModuleFilename()).str();
    filename += "-";
    filename += module.getName().str();
    return filename;
  }
  return module.getModuleFilename().str();
}

static llvm::SmallVector<swift::Decl*> getTopLevelDecls(swift::ModuleDecl& module,
                                                        swift::SourceFile* primaryFile = nullptr) {
  llvm::SmallVector<swift::Decl*> ret;
  ret.push_back(&module);
  if (primaryFile) {
    primaryFile->getTopLevelDecls(ret);
  } else {
    module.getTopLevelDecls(ret);
  }
  return ret;
}

static void extractDeclarations(const SwiftExtractorConfiguration& config,
                                swift::CompilerInstance& compiler,
                                std::unordered_set<const swift::Decl*>& extractedDecls,
                                swift::ModuleDecl& module,
                                swift::SourceFile* primaryFile = nullptr) {
  auto filename = getFilename(module, primaryFile);

  // The extractor can be called several times from different processes with
  // the same input file(s). Using `TargetFile` the first process will win, and the following
  // will just skip the work
  auto trapTarget = createTargetTrapFile(config, filename);
  if (!trapTarget) {
    // another process arrived first, nothing to do for us
    return;
  }
  TrapDomain trap{*trapTarget};

  // TODO: remove this and recreate it with IPA when we have that
  // the following cannot conflict with actual files as those have an absolute path starting with /
  File unknownFileEntry{trap.createLabel<FileTag>("unknown")};
  Location unknownLocationEntry{trap.createLabel<LocationTag>("unknown")};
  unknownLocationEntry.file = unknownFileEntry.id;
  trap.emit(unknownFileEntry);
  trap.emit(unknownLocationEntry);

  std::vector<swift::Token> comments;
  if (primaryFile && primaryFile->getBufferID().hasValue()) {
    auto& sourceManager = compiler.getSourceMgr();
    auto tokens = swift::tokenize(compiler.getInvocation().getLangOptions(), sourceManager,
                                  primaryFile->getBufferID().getValue());
    for (auto& token : tokens) {
      if (token.getKind() == swift::tok::comment) {
        comments.push_back(token);
      }
    }
  }

  std::vector<swift::Decl*> pending;
  SwiftVisitor globalVisitor(compiler.getSourceMgr(), pending, trap, nullptr, primaryFile);
  for (auto& comment : comments) {
    globalVisitor.extract(comment);
  }

  auto topLevelDecls = getTopLevelDecls(module, primaryFile);

  std::queue<swift::Decl*> worklist;
  for (auto decl : topLevelDecls) {
    if (extractedDecls.count(decl)) {
      continue;
    }
    worklist.push(decl);
  }

  while (!worklist.empty()) {
    auto decl = worklist.front();
    extractedDecls.insert(decl);
    worklist.pop();
    if (namedDecl(*decl)) {
      auto declName = mangledName(llvm::cast<swift::ValueDecl>(*decl));
      auto hashName = std::to_string(std::hash<std::string>{}(declName));
      auto localTrapTarget = createTargetTrapFile(config, hashName);
      if (!localTrapTarget) {
        // declaration was already extracted
        continue;
      }
      TrapDomain localTrap{*localTrapTarget};
      SwiftVisitor visitor(compiler.getSourceMgr(), pending, localTrap, decl, primaryFile);
      visitor.extract(decl);
      for (auto pend : pending) {
        if (extractedDecls.count(pend)) {
          continue;
        }
        extractedDecls.insert(pend);
        worklist.push(pend);
      }
    } else {
      globalVisitor.extract(decl);
    }
  }
}

static std::unordered_set<std::string> collectInputFilenames(swift::CompilerInstance& compiler) {
  // The frontend can be called in many different ways.
  // At each invocation we only extract system and builtin modules and any input source files that
  // have an output associated with them.
  std::unordered_set<std::string> sourceFiles;
  auto inputFiles = compiler.getInvocation().getFrontendOptions().InputsAndOutputs.getAllInputs();
  for (auto& input : inputFiles) {
    if (input.getType() == swift::file_types::TY_Swift && !input.outputFilename().empty()) {
      sourceFiles.insert(input.getFileName());
    }
  }
  return sourceFiles;
}

static std::unordered_set<swift::ModuleDecl*> collectModules(swift::CompilerInstance& compiler) {
  // getASTContext().getLoadedModules() does not provide all the modules available within the
  // program.
  // We need to iterate over all the imported modules (recursively) to see the whole "universe."
  std::unordered_set<swift::ModuleDecl*> allModules;
  std::queue<swift::ModuleDecl*> worklist;
  for (auto& [_, module] : compiler.getASTContext().getLoadedModules()) {
    worklist.push(module);
    allModules.insert(module);
  }

  while (!worklist.empty()) {
    auto module = worklist.front();
    worklist.pop();
    llvm::SmallVector<swift::ImportedModule> importedModules;
    // TODO: we may need more than just Exported ones
    module->getImportedModules(importedModules, swift::ModuleDecl::ImportFilterKind::Exported);
    for (auto& imported : importedModules) {
      if (allModules.count(imported.importedModule) == 0) {
        worklist.push(imported.importedModule);
        allModules.insert(imported.importedModule);
      }
    }
  }
  return allModules;
}

void codeql::extractSwiftFiles(const SwiftExtractorConfiguration& config,
                               swift::CompilerInstance& compiler) {
  auto inputFiles = collectInputFilenames(compiler);
  auto modules = collectModules(compiler);
  std::unordered_set<const swift::Decl*> extractedDecls;
  for (auto& module : modules) {
    bool isFromSourceFile = false;
    for (auto file : module->getFiles()) {
      auto sourceFile = llvm::dyn_cast<swift::SourceFile>(file);
      if (!sourceFile) {
        continue;
      }
      isFromSourceFile = true;
      if (inputFiles.count(sourceFile->getFilename().str()) == 0) {
        continue;
      }
      archiveFile(config, *sourceFile);
      extractDeclarations(config, compiler, extractedDecls, *module, sourceFile);
    }
    if (!isFromSourceFile) {
      extractDeclarations(config, compiler, extractedDecls, *module);
    }
  }
}
