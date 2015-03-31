### companion object
```scala
    val tpe = weakTypeOf[T] // t
    val companion = tpe.typeSymbol.companion
```

```scala
import scala.reflect.runtime.universe._
case class Person(name: String, age: Int)
val person = Person("john", 24)
```

###type of object
```scala
val tpe = weakTypeOf[Person]
tpe: reflect.runtime.universe.Type = Person
```

### list of instance field names
```scala
val fields = tpe.decls.collectFirst {
     |       case m: MethodSymbol if m.isPrimaryConstructor => m
     |     }.get.paramLists.head

val fields = tpe.members.filter(!_.isMethod).toList
val fields = tpe.members.filter(_.isConstructor).head.asMethod.paramLists
fields: List[reflect.runtime.universe.Symbol] = List(value name, value age)
```
### how to get the 'type' for a field using reflection api
```scala
    scala> typeOf[Account].members.filter(!_.isMethod).foreach(
    sym => println(sym + " is a " + sym.typeSignature)
  )
variable accountNumber is a String
variable name is a String
```

### Type of a given instance field 
scala>       val returnType = tpe.decl(name).typeSignature // name: TermName
returnType: reflect.runtime.universe.Type = => String
```

```scala
val field = fields.head
field: reflect.runtime.universe.Symbol = value name
```
### Symbol has a Type ,converted using asTerm/asMethod/..., TermName
```scala
scala> typeOf[Person].members.filter(!_.isMethod).head
res152: ru.Symbol = value age
                           
scala> typeOf[Person].members.filter(!_.isMethod).head.typeSignature
res154: ru.Type = scala.Int

scala> typeOf[Person].members.filter(!_.isMethod).head.asTerm
res155: ru.TermSymbol = value age

scala> typeOf[Person].members.filter(!_.isMethod).head.asTerm.name
res156: ru.TermName = age
```
###Symbol ---> TermName
```scala
scala> val name = field.name.toTermName // Symbol->NameType->TermName
name: reflect.runtime.universe.TermName = name

Scala: field.asTerm.name   // Symbol -> TermSymbol -> TermName

### decode Symbol to String
scala>       val decoded = name.decodedName.toString  //"k$minusduy -> "k-duy" 
decoded: String = name




```scala
val (toMapParams, fromMapParams) = fields.map { field =>
     |       val name = field.name.toTermName
     |       val decoded = name.decodedName.toString
     |       val returnType = tpe.decl(name).typeSignature
     |
     |       (q"$decoded -> t.$name", q"map($decoded).asInstanceOf[$returnType]")
     |     }.unzip

// ("name" -> "John", map("name").asIstanceOf[String])
//$decodeed : String
//$name : TermName
//$returnType: Type

toMapParams: List[reflect.runtime.universe.Tree] = List("name".$minus$greater(t.name), "age".$minus$greater(t.age))

fromMapParams: List[reflect.runtime.universe.Tree] = List(map("name").asInstanceOf[=> String], map("age").asInstanceOf[=> scala.Int])
```

### quasiquote
```scala
c.Expr[Mappable[T]] { q"""
      new Mappable[$tpe] {
        def toMap(t: $tpe): Map[String, Any] = Map(..$toMapParams)
        def fromMap(map: Map[String, Any]): $tpe = $companion(..$fromMapParams)
      }
    """ }
//val companion = tpe.typeSymbol.companion
//companion: reflect.runtime.universe.Symbol = object Person
//$tpe: Type
//..$toMapParams : List[Tree]
```


### context bound and WeakTypeTag (or TypeTag)
```scala
def toType2[T](t: T)(implicit tag: WeakTypeTag[T]): Type = tag.tpe // -> tpe      
def toType[T : WeakTypeTag](t: T): Type = typeOf[T]   // -> tpe
```


### import universe
```scala
val ru = scala.reflect.runtime.universe
val tpe = ru.typeOf[Int] // -> tpe: ru.Type = Int
```

### Method Symbol
```scala
val methodX = ru.typeOf[C].declaration(ru.newTermName("x")).asMethod // ru -> Type -> Symbol -> MethodSymbol
methodX: scala.reflect.runtime.universe.MethodSymbol = method x
```
### Class Symbol
```scala
ru.typeOf[C].typeSymbol.asClass   // -> ru -> Type -> Symbol -> ClassSymbol 
classC: scala.reflect.runtime.universe.ClassSymbol = class C
```


### reify and splice
```scala
scala> var a = reify{"2"}
a: ru.Expr[String] = Expr[String("2")]("2")

scala> reify{a.splice}  // Expr.slice 
res191: ru.Expr[String] = Expr[String]("2")

scala> reify{a.splice}.tree
res192: ru.Tree = "2"

scala> showRaw(res192)
res193: String = Literal(Constant("2"))

```

### conducting an assignment
```scala
scala> val freshName = TermName("eval")
freshName: ru.TermName = eval

scala> Ident(freshName)
res189: ru.Ident = eval

scala> val tpe = typeOf[Int]
tpe: ru.Type = Int

scala> ValDef(Modifiers(), freshName, TypeTree(tpe), reify{"2"}.tree)
res188: ru.ValDef = val eval: Int = "2"
// now eval = 2
```

### using splice in macro to print value
```scala
scala> reify{val x =2}
res215: ru.Expr[Unit] =
Expr[Unit]({
  val x = 2;
  ()
})

scala> reify{println(res215.splice)} // -> Expr[Unit]
res216: ru.Tree =
Predef.println({
  val x = 2;
  ()
})
```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```


```scala

```
