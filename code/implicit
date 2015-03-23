
### implicitly and context bound
```Scala
def mapify[T: Mappable](t: T) = implicitly[Mappable[T]].toMap(t)

//def mapify[T](t: T)(implicit evidence$1: $read.Mappable[T]) = Predef.implicitly[$read.Mappable[T]](evidence$1).toMap(t);
```
### macro
```scala
trait Mappable[T] {
  def toMap(t: T): Map[String, Any]
  def fromMap(map: Map[String, Any]): T
}

object Mappable {
  	implicit def materializeMappable[T]: Mappable[T] = macro materializeMappableImpl[T]

    // from scala 2.11 , the macro impl can return c.Tree
  	def materializeMappableImpl[T: c.WeakTypeTag](c: Context): c.Expr[Mappable[T]] = {

  	........

    // from scala 2.11 , the macro impl can return c.Tree
    // since quasiquote return a Tree, one can remove c.Expr[Mappable[T]]
      c.Expr[Mappable[T]] { q"""
          new Mappable[$tpe] {
            def toMap(t: $tpe): Map[String, Any] = Map(..$toMapParams)
            def fromMap(map: Map[String, Any]): $tpe = $companion(..$fromMapParams)
          }
        """ }

  	}
}

// main
def mapify[T: Mappable](t: T) = implicitly[Mappable[T]].toMap(t)



```

