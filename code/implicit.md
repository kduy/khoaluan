


## I. implicit argument

### 1. Implicit argument with values val/var
```scala
def calcTax(amount: Float)(implicit rate: Float): Float = amount * rate
object SimpleStateSalesTax { 
  implicit val rate: Float = 0.05F   // implicit argument here
}
```

import
```scala
import SimpleStateSalesTax.rate

val amount = 100F
println(s"Tax on $amount  = ${calcTax(amount)") // calcTax(amount)(tax) = 0.05 * 100
```

------
### 2. implicit function argument

```scala

def calcTax(amount: Float)(implicit rate: Float): Float = amount * rate

case class RateData( 
  baseRate: Float,
  isTaxHoliday: Boolean
)

object Tax {
  //NOTE: To function as an implicit value, it must not take  arg itself, unless the arg are also implicit
  implicit def rate(implicit cstd: TaxData): Float = // implicit Float is available
    if (cstd.isTaxHoliday) 0.0F
    else cstd.baseRate 
}
```

call: 
```scala
{
  import Tax.rate

  implicit val myStoreData = TaxData(0.05F, false)

  calcTax(100F) // calcTax(100F) (rate(myStoreData))

}
```

### 3. Using  `implicitly`

`implicitly` + a type signature addition (`context bound`)

```scala
def implicitly[T](implicit e: T): T = e // implicit a value of T

def implicitly[Ordering[B]] (implicit e: Ordering[B]): Ordering[B] = e
```

**Context Bound**

Syntaxt
```scala
def function [A : B](...)                         = {....implicitly[B[A]]....}
def function [A]    (...)(implicit bValue : B[A]) = {....bValue....}
```

Example: 
```scala
import math.Ordering

////----------------------
case class MyList[A](list: List[A]) {

  def sortBy1[B](f: A => B)(implicit ord: Ordering[B]): List[A] =
          list.sortBy(f)(ord)

  // `sortBy1` is identical to `sortBy2`
  // Ordering is called a context bound. 
  def sortBy2[B : Ordering](f: A => B): List[A] = 
          list.sortBy(f)(implicitly[Ordering[B]])    // implicitly[Ordering[B]] = ord
}
////----------------------
// test
val list = MyList(List(1,3,5,2,4))
list sortBy1 (i => -i) //List(5, 4, 3, 2, 1)
list sortBy2 (i => -i) //List(5, 4, 3, 2, 1)


```

### II. Scenarios for implicit Argument

#### 1. Execution Contexts

Passing context:
```scala
apply[T](body: => T)(implicit executor: ExecutionContext): Future[T]
```

`ExecutionContext` is implicitly imported using 
```scala
 import scala.concurrent.ExecutionContext.Implicits.global
```

Other example contexts : transactions, database connections, thread pools, and user sessions

#### 2. Capacibilities
**Case**: an implicit user session arg may contain Authorization Tokens that control whether or not a certain API can be called for that user

```scala
def createMenu(implicit session: Session): Menu = { // implicit user session
  val defaultItems = List(helpItem, searchItem)
  val accountItems =
    if (session.loggedin()) List(viewAccountItem, editAccountItem) // decide here
    else List(loginItem) Menu(defaultItems ++ accountItems)
}
```

#### 3. Constraining Allowed Instances

we can use an implicit argument to limit the allowed types

Many of the methods supported by the concrete collections classes are implemented by parent types. For example, List[A].map(f: A ⇒ B): List[B]

However, we want to return the same collection type we started with, so how can we tell the one map method to do that?

The Scala API uses a convention of passing a “builder” as an implicit argument to map. The builder knows how to construct a new collection of the same type. 
```scala
trait TraversableLike[+A, +Repr] extends ... 
{ 
  ...
  def map[B, That](f: A => B)
                  (implicit bf: CanBuildFrom[Repr, B, That]): That = {...} 
  ... 
}
```

`CanBuildFrom` is our builder. It’s named that way to emphasize the idea that you can build any new collection you want, _as long as an implicit builder object exists_.

`Repr` is the type of the actual collection used internally to hold the items. `B` is the type of elements created by the function `f`.

Recall that `+A` means that `TraversableLike[A]` is covariant in `A`; if `B` is a subtype of `A`, then `TraversableLike[B]` is a subtype of `TraversableLike[A]`.

`That` is the type parameter of the target collection we want to create

**Case**: If you implement your own collections and reuse method implementations like TraversableLike.map: 
  - need to create your own CanBuildFrom types 
  - import implicit instances of them in code that uses your collections.


Example: 

```scala
    // src/main/scala/progscala2/implicits/scala-database-api.scala
    object implicits {      

      implicit class SRow(jrow: JRow) {
        def get[T](colName: String)(implicit toT: (JRow,String) => T): T =
          toT(jrow, colName)
      }

      // implicit argument 
      implicit val jrowToInt: (JRow,String) => Int = 
        (jrow: JRow, colName: String) => jrow.getInt(colName)
      implicit val jrowToDouble: (JRow,String) => Double = 
        (jrow: JRow, colName: String) => jrow.getDouble(colName)
      implicit val jrowToString: (JRow,String) => String = 
        (jrow: JRow, colName: String) => jrow.getText(colName)
    }
```

```scala
    object DB {
      import implicits._
      def main(args: Array[String]) = {
        val row = javadb.JRow("one" -> 1, "two" -> 2.2, "three" -> "THREE!")
        val oneValue1: Int = row.get("one")
      }
    }
```

#### 4. Implicit Evidence
**Why**To constrains the allowed types, but doesn’t require them to conform to a common super‐type.

_“evidence” only has to exist to enforce a type constraint_

**Example** : We can’t allow the user to call `toMap` if the sequence is not a sequence of pairs.

```scala
  trait TraversableOnce[+A] ... { ...
    def toMap[T, U](implicit ev: <:< [A, (T, U)]): immutable.Map[T, U]
    ... 
  }

```
The implicit argument `ev` is the “evidence” we need to enforce our constraint. It uses a type defined in Predef called `<:<` named to resemble the type parameter constraint `<:`

```scala
<:<(A, (T, U))
A <:< (T, U)
```

the implicit evidence `ev` value we need will be synthesized by the compiler, but only if `A <: (T,U)`; that is, if `A` is actually a pair

```scala
scala> val l1 = List(1, 2, 3) 
pp l1: List[Int] = List(1, 2, 3)
scala> l1.toMap
<console>:9: error: Cannot prove that Int <:< (T, U).
l1.toMap
```
**Note**: With implicit evidence, we didn’t use the implicit object in the computation. Rather, we only used its existence as confirmation that certain type constraints were satisfied.

#### Working Around Erasure
Another example where the implicit object _only provides evidence is a technique for working around limitations due to type erasure._
**Why**: the JVM “forgets” the type arguments for parameterized types. For example, consider the following definitions for an overloaded method
-> make the compiler confused

we can add an implicit argument to disambiguate the method

```scala
    // src/main/scala/progscala2/implicits/implicit-erasure.sc
object M {
  implicit object IntMarker                                          // <1>
  implicit object StringMarker

  def m(seq: Seq[Int])(implicit i: IntMarker.type): Unit =           // <2>
    println(s"Seq[Int]: $seq")

  def m(seq: Seq[String])(implicit s: StringMarker.type): Unit =     // <3>
    println(s"Seq[String]: $seq")
}

import M._                                                           // <4>
m(List(1,2,3))
m(List("one", "two", "three"))

```

Note the type, `IntMarker.type`. This is how to reference the type of a singleton object

#### Improving Error Messages
```scala
  //when it can’t find an implicit value for an implicit argument
  @implicitNotFound(msg =
    "Cannot construct a collection of type ${To} with elements of type ${Elem}" + " based on a collection of type ${From}.")
  trait CanBuildFrom[-From, -Elem, +To] {...}
```

#### Phantom Types
Phantom types are very useful for defining work flows that must proceed in a particular order. 

When such types are defined that have no instances at all, they are called phantom types. we only care that the type exists. _It functions as a “marker.” _We won’t actually use any instances of it.

```scala
    // phantom type // markers
    sealed trait PreTaxDeductions
    sealed trait PostTaxDeductions
    sealed trait Final

    case class Pay[Step](employee: Employee, netPay: Float)
    ....
    def start(employee: Employee): Pay[PreTaxDeductions] = ???
    def minusTax(pay: Pay[PreTaxDeductions]): Pay[PostTaxDeductions] = ???
    def minusFinalDeductions(pay: Pay[PostTaxDeductions]): Pay[Final] = ???
    ....

```
Note: order: `start` -> `minusTax` ->  `minusFinalDeduction`

Pipeline 
```scala

    // src/main/scala/progscala2/implicits/phantom-types-pipeline.scala
    object Pipeline {
      implicit class toPiped[V](value:V) {
        def |>[R] (f : V => R) = f(value) 
      }
    }

    object Calculator {
      def main (args: Array[String]){
        import Pipeline._
        ......
        val pay = start(e) |> minusTax |>  minusFinalDeductions
        val twoWeekNet = pay.netPay
        ......
      }
    }

```

#### Rules for Implicits Arguments

1. Only the last argument list,including the only list for a single-list method, can have implicit arguments.

2. The implicit keyword must appear first and only once in the argument list. The list can’t have “nonimplicit” arguments followed by implicit arguments.

3. All the arguments are implicit when the list starts with the implicit keyword
```scala
scala> class Good1 {
          def m(i: Int)(implicit s: String, d: Double) = "boo" 
        }

scala> class Good2 {
          def m(implicit i: Int, s: String, d: Double) = "boo" 
        }
```


## Lookup Implicit

Here is a summary of the lookup rules used by the compiler to find and apply conver‐ sions methods:

1. No conversion will be attempted if the object and method combination type check successfully.
2. Only classes and methods with the implicit keyword are considered.
3. Only implicit classes and methods in the current scope are considered, as well as implicit methods defined in the companion object of the target type (see the following discussion).
  - First, no implicit conversion is used unless it’s already in the current scope, either because it’s declared in an enclosing scope or it was imported from another scope, such as a separate object that defines some implicit conversions.
  - However, another scope automatically searched last is _the companion object of the type to which a conversion is needed_, if there is one
    ```scala
      import scala.language.implicitConversions
        
        case class Foo(s: String)  
        object Foo {
          implicit def fromString(s: String): Foo = Foo(s) 
        }
        
        class O {
          def m1(foo: Foo) = println(foo) 
          def m(s: String) = m1(s) // m1 expects Foo. So they looking for Foo.fromString from class and companion object
        }

    ```

    However, if there is another `Foo` conversion in scope, it will override the `Foo.fromString` conversion 
    ```scala
        import scala.language.implicitConversions
        
        case class Foo(s: String)  
        object Foo {
          implicit def fromString(s: String): Foo = Foo(s) 
        }

        // m1(s) will look for implicit conversion here
        // overridingConversion will be used instead
        implicit def overridingConversion(s: String): Foo = Foo("Boo: "+s)

        class O {
          def m1(foo: Foo) = println(foo) 
          def m(s: String) = m1(s) 
        }

    ```
4. Implicit methods aren’t chained to get from the available type,through intermediate types, to the target type. Only a method that takes a single available type instance and returns a target type instance will be considered.

5. No conversion is attempted if more than one possible conversion method could be applied. There must be one and only one, unambiguous possibility.

## Implicit Conversion
_The idea is to be able to extend an existing class with new methods in a type safe manner_. 

### implicit function

Essentially what happens is a developer defines an implicit method (or imports an implicit method) which converts one object from one type to another type. Once the implicit method is within scope all methods are available from both types.


```scala
  class MyInteger( i:Int ) {
     def myNewMethod = println("hello from myNewMethod")
  }

  implicit def int2MyInt( i:Int ) = new MyInteger(i)

  reify{1.myNewMethod}.tree
    res12: reflect.runtime.universe.Tree = $read.int2MyInt(1).myNewMethod
```



### Implicit class

http://docs.scala-lang.org/sips/completed/implicit-classes.html

```scala
implicit class RichInt(n: Int) extends Ordered[Int] {
  def min(m: Int): Int = if (n <= m) n else m
  ...
}
```
will be transformed by the compiler as follows:
```scala
class RichInt(n: Int) extends Ordered[Int] {
  def min(m: Int): Int = if (n <= m) n else m
  ...
}
implicit final def RichInt(n: Int): RichInt = new RichInt(n)

```

Now can call `2.min`
-----------

**Example** : using an implicit conversion in the usual way to “extend” `StringContext` with new methods.

**Pattern**: we’ve effectively added a new method to all types without editing the source code for any of them

```scala
  object Interpolators {
      implicit class jsonForStringContext(val sc: StringContext) { 
        def json(values: Any*): JSONObject = {
              ...
              JSONObject(...)
              ...
        }
```
**Note**: Implicit classes must be defined inside objects to limit their scope.
```scala
    import Interpolators._
    val jsonobj = json"{name: $name, book: $book}" // compiler looking for `json` func in StringContext
                = StringContext(...).json(...)
```

**How** : whenever it see a `StringContext`, it will implicitly generate a new `jsonForStringContext(sc)` and call it's `json`

```scala
res9: reflect.runtime.universe.Tree = $read.Interpolators.
jsonForStringContext(StringContext.apply("{name: ", ", book: ", "}")) 
  .json($read.name, $read.book)
```


But 
```scala
reify{s"{name: $name, book: $book}"}.tree
res11: reflect.runtime.universe.Tree = 

StringContext.apply("{name: ", ", book: ", "}").s($read.name, $read.book)
```





## Type class Pattern

## Technical issues with Implicits


## Scala's built-in implicit
```scala
    object Int { ...
      implicit def int2long(x: Int): Long = x.toLong
    ... }
```

## Best Practices

-  putting implicit values in a special package named implicits or an object named Implicits. 

That way, readers of code see the word “implicit” in the imports and know to be aware of their presence, in addition to Scala’s ubiquitous, built-in implicits. 

- Fortunately, IDEs can now show when implicits are being invoked, too.
https://confluence.jetbrains.com/display/IntelliJIDEA/Working+with+Scala+Implicit+Conversions







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

