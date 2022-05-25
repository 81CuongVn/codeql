use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() -> std::io::Result<()> {
    let dist = env::var("CODEQL_DIST").expect("CODEQL_DIST not set");
    let db = env::var("CODEQL_EXTRACTOR_QL_WIP_DATABASE")
        .expect("CODEQL_EXTRACTOR_QL_WIP_DATABASE not set");
    let codeql = if env::consts::OS == "windows" {
        "codeql.exe"
    } else {
        "codeql"
    };
    let codeql: PathBuf = [&dist, codeql].iter().collect();
    let mut cmd = Command::new(codeql);
    cmd.arg("database")
        .arg("index-files")
        .arg("--include-extension=.ql")
        .arg("--include-extension=.qll")
        .arg("--include-extension=.dbscheme")
        .arg("--include=**/qlpack.yml")
        .arg("--size-limit=5m")
        .arg("--language=ql")
        .arg("--working-dir=.")
        .arg(db);

    let pwd = env::current_dir()?;
    for line in env::var("LGTM_INDEX_FILTERS")
        .unwrap_or_default()
        .split('\n')
    {
        if let Some(stripped) = line.strip_prefix("include:") {
            let path = pwd
                .join(stripped)
                .join("**")
                .into_os_string()
                .into_string()
                .unwrap();
            cmd.arg("--also-match").arg(path);
        } else if let Some(stripped) = line.strip_prefix("exclude:") {
            let path = pwd
                .join(stripped)
                .join("**")
                .into_os_string()
                .into_string()
                .unwrap();
            // the same as above, but starting with "!"
            cmd.arg("--also-match").arg("!".to_owned() + &path);
        }
    }
    let exit = &cmd.spawn()?.wait()?;
    std::process::exit(exit.code().unwrap_or(1))
}
