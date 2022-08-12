/**
 * @name TODO
 * @description TODO
 * @kind path-problem
 * @problem.severity error
 * @security-severity TODO
 * @precision high
 * @id swift/tls3-is-not-used
 * @tags security
 *       external/cwe/cwe-757
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import DataFlow::PathGraph

/**
 * TODO
 */
class TLS3IsNotUsedConfig extends TaintTracking::Configuration {
  TLS3IsNotUsedConfig() { this = "TLS3IsNotUsedConfig" }

  override predicate isSource(DataFlow::Node node) {
    exists(MemberRefExpr member, ConcreteVarDecl factory |
      member = node.asExpr() and
      factory = member.getMember() and
      factory.getName() = "default"
    )
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ApplyExpr call, Expr arg |
      arg = call.getAnArgument().getExpr() and
      arg = node.asExpr() and
      arg.getType().getName() = "URLSessionConfiguration"
    )
  }
  // override predicate isSanitizer(DataFlow::Node node) {
  //   exists (
  //     AssignExpr assign, MemberRefExpr member |
  //     member = assign.getDest() and
  //     member.getBaseExpr() = node.asExpr()
  //   )
  // }
}

from TLS3IsNotUsedConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "TLS 3 should be used"
