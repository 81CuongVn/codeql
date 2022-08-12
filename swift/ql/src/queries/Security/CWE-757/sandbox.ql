import swift

// from AssignExpr assign, MemberRefExpr lhs, ApplyExpr rhs, EnumElementDecl enum
// where
//   lhs = assign.getDest() and
//   rhs = assign.getSource() and
//   lhs.getMember().(ConcreteVarDecl).getName() = "tlsMinimumSupportedProtocolVersion" and
//   enum = rhs.getFunction().(DeclRefExpr).getDecl()
// select enum, enum.getName()
// select rhs, rhs.getFunction().(ApplyExpr).getStaticTarget()
//  assign.getSource(), assign.getSource().getAPrimaryQlClass()
from MemberRefExpr c, ConcreteVarDecl var
where var = c.getMember()
select var.getName(), var.getAPrimaryQlClass()
