## Transformation
- Map
- FlatMap
- MapPartition
- Filter
- Reduce
- ReduceGroup
- Aggregate
- Join
- CoGroup
- Cross
- Union
- Hash-Partition
- Sort Partition
- First-m


## Specifying Key
```java
DataSet<...> input = // [...]
DataSet<...> reduced = input
    .groupBy(/*define key here*/)
    .reduceGroup(/*do something*/);
```
### Define keys for Typle
`groupBy(0,1)`
### Define keys using Field Expr
`words.groupBy("word")`
- POJO:  fields by their field name. For example "user"
- nested fields in POJOs and Tuples: Example: `_2.user.zipCode`
- the full type using the "_" wildcard expressions
### Define keys using Key Selector Func

## Data Types
1. Java Tuples and Scala Case Classes
2. Java POJOs
3. Primitive Types: all Java, Scala primitive types
4. Regular Classes
5. Values
6. Hadoop Writables

## Data Sources
- File-based
- Collection-based
- Generic

## Data Sink

## Iteration Operators
### Bulk iteration
### Delta iteration

## Semantic Annotations

