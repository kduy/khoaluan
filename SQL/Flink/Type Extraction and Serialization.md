Type Extraction and Serialization

### Type handling in Flink


### TypeInformation class
The class `TypeInformation`

- Basic types: All Java primitives and their boxed form, plus void, String, and Date.
- Primitive arrays and Object arrays
- Composite types  
    +   Flink Java Tuples (part of the Flink Java API)
    +   Scala case classes (including Scala tuples)
    +   POJOs: classes that follow a certain bean-like pattern

- Scala auxiliary types (Option, Either, Lists, Maps, …)
- Generic types: These will not be serialized by Flink itself, but by Kryo.

### Type Information in Scala API

Within the macro, we create a `TypeInformation` for the function’s return types (or parameter types) and make it part of the operation
####No Implicit Value for Evidence Parameter Error
Make sure to import 
```scala
import org.apache.flink.api.scala
```

#### Generic methods
```scala
def[T] selectFirst(input: DataSet[(T, _)]) : DataSet[T] = {
  input.map { v => v._1 }
}

val data : DataSet[(String, Long) = ...

val result = selectFirst(data)
```
 The code above will result in an error that not enough implicit evidence is available.

 The following code tells Scala to bring a type information for T into the function. The type information will then be generated at the sites where the method is invoked, rather than where the method is defined.
```scala
 def[T : TypeInformation] selectFirst(input: DataSet[(T, _)]) : DataSet[T] = {
  input.map { v => v._1 }
}
```
### Type Information in Java API
Java in general erases generic type information. Only for subclasses of generic classes, the subclass stores the type to which the generic type variables bind

Flink uses reflection on the (anonymous) classes that implement the user functions to figure out the types of the generic parameters of the function
####Type Hints in the Java API
```java
DataSet<SomeType> result = dataSet
    .map(new MyGenericNonInferrableFunction<Long, SomeType>())
        .returns(SomeType.class);
```
The `returns` statement specifies the produced type, in this case via a class
