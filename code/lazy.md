# Lazy

Also lazy is useful without cyclic dependencies, as in the following code:
```scala
abstract class X {
  val x: String
  println ("x is "+x.length)
}

object Y extends X { val x = "Hello" }
Y
```

Accessing Y will now throw null pointer exception, because x is not yet initialized. The following, however, works fine:
```scala
abstract class X {
  val x: String
  println ("x is "+x.length)
}

object Y extends X { lazy val x = "Hello" }
Y
```
EDIT: the following will also work:

```scala
object Y extends { val x = "Hello" } with X 
```

This is called an `early initializer`


http://stackoverflow.com/questions/4712468/in-scala-what-is-an-early-initializer
http://www.scala-lang.org/old/node/8610

