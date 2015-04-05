object DQC{

  implicit class DynSQLContext(sc: StringContext) {
      def sql(exprs: Any*) :String = macro DQC.dynsqlImpl
    }

  def dynsqlImpl
        (c: Context)(exprs: c.Expr[Any]*): c.Expr[String] = {

      import c.universe._

      def append(t1: Tree, t2: Tree) = Apply(Select(t1, newTermName("+").encoded), List(t2))

      val Expr(Apply(_, List(Apply(_, parts)))) = c.prefix

      val select = parts.head
      val sqlExpr = exprs.zip(parts.tail).foldLeft(select) { 
        case (acc, (Expr(expr), part)) => append(acc, append(expr, part)) 
      }

      val sql = select match {
        case Literal(Constant(sql: String)) => sql
        case _ => c.abort(c.enclosingPosition, "Expected String literal as first part of interpolation")
      }

      //reify{c.Expr[String](c.prefix.tree).splice}
      c.literal(showRaw(c.prefix.tree))
    }
}

  object Test {
    import DQC._
    val name = "name"
    println(sql"select agen from person p where $name = ?")
  }


Apply(
  Select(Select(Select DQC), TermName("DynSQLContext")),
  List(Apply(
          Select(Select(Ident(scala), scala.StringContext), TermName("apply")), 
          List(Literal(Constant("select agen from person p where ")), Literal(Constant(" = ?")))
      )
  )
)