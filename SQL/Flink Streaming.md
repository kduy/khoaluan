#Flink Streaming

##Introduction
##Flink Streaming API
##Example Program
##Program Skeleton
##Basics
- Map
- FlatMap
- Filter
- Reduce
- Merge
###DataStream
**DataStream**: A continous stream of data of a certain type from either a data source / a transformed data stream.

There are many DataStream types : _GroupDataStream_ (return by _groupBy_ method, can be used for grouped trans such as aggregating by key)

###Partitioning
Partitioning controls how individual data points are distributed among the parallel instances of the transformation operators.
- *Forward*(default) :  Usage : `dataStream.forward()`
- *Shuffle*:            Usage: `dataStream.shuffle()`
- *Distribute*:         Usage: `dataStream.distributed()`
- *Field/key*:          this partitions is applied when using the `groupBy` operators. 
- *Broadcast*:          Usage: `dataStream:broadcast()`
- *Global*:             Usage: `operator.setParallelism(1)`

###Connecting to the outside world:
Through the source and sink interfaces. The `cancel()` method where allocated resources can be freed up in cae some other parts of the topology failed. is called upon termination.
####Source
call `StreamExecutionEnvironment.addSource(sourceFunction)`. In contrast with other operators, DataStreamSources have a default operator parallelism of 1.

To create parallel sources the users source funtion need to implement `ParallelSourceFunction` or extend `RichParalellSourceFunction`. The parallelism for ParallelSourceFunctions can be changed afterwards using `source.setParallelism(parallelism)`.

Some streaming specific:
- `socketTextStream(hostname, port)`
- `readTextStream(filepath)`
- `generateSequence(from, to)`
- `fromElements(elements…)`
- `fromCollection(collection)`
- `readTextFile(filepath)`

There are pre-implemented connectors for a number of the most popular message queue services, please refer to the section on `connectors` for more detail.

####Sink

- `dataStream.print()` – Writes the DataStream to the standard output, practical for testing purposes
- `dataStream.writeAsText(parameters)` – Writes the DataStream to a text file
- `dataStream.writeAsCsv(parameters)` – Writes the DataStream to CSV format

The user can also implement arbitrary sink functionality by implementing the `SinkFunction` interface and using it with `dataStream.addSink(sinkFunction)`.
##Operatios
###Basic Operations
- *Map*
- *Flatmap*
- *Filter*
- *Reduce*:  A streaming reduce on a full or grouped data stream emits the current reduced value for every new element on a data stream.On a windowed data stream it works as a batch reduce: it produces at most one value.
- Merge: Merges two or more datastreams creating a new stream containing all the elements from all the streams.

###Grouped operators
Some transformations require that the elements of a `DataStream` are grouped on some key. The user can create a `GroupedDataStream` by calling the `groupBy(key)` method of a non-grouped `DataStream`. 

Keys can be of three types: 
- fields positions (applicable for tuple/array types), 
- field expressions (applicable for pojo types), 
- KeySelector instances.
####Reduce on GroupedDataStream
`ReduceFunction`

###Aggregations
Types of aggregations: 
- sum(field), 
- min(field), 
- max(field), 
- minBy(field, first), 
- maxBy(field, first).

With `sum`, `min`, and `max` for every incoming tuple the selected field is replaced with the current aggregated value. Fields can be selected using either field positions or field expressions (similarly to grouping).

With `minBy` and `maxBy` the output of the operator is the element with the *current minimal or maximal value at the given field*. If more components share the minimum or maximum value, the user can decide if the operator should return the first or last element. This can be set by the `first` boolean parameter.

There is also an option to apply user defined aggregations with the usage of the `aggregate(…)` function of the data stream.

### Window/Batch operators
`dataStream.groupBy(0).batch(100, 10)` produces batches of the last 100 elements for each key value with 10 record step size.
#### Reduce on windowed/batched data streams
A window reduce that sums the elements in the last minute with 10 seconds slide interval:
```scala
dataStream.window(60000, 10000).sum();
```
#### ReduceGroup on windowed/batched data streams
```scala
dataStream.batch(1000, 100).reduceGroup(reducer);
```
###Window operators
- to create *arbitrary windows* (also referred to as discretizations or slices) of the data streams and apply reduce, map or aggregation transformations on the windows acquired. 
- to create rolling aggregations of the most recent N elements, where N could be defined by *Time*, *Count* or *any arbitrary user defined measure*.

The user can control the size (**eviction**) of the windows and the frequency of reduction or aggregation calls (**trigger**) on them in an intuitive API (some examples):

- `dataStream.window(eviction).every(trigger).reduceWindow(…)`
- `dataStream.window(…).every(…).mapWindow(…).flatten()`
- `dataStream.window(…).every(…).groupBy(…).aggregate(…).getDiscretizedStream()`

The core abstraction of the Windowing semantics is the `WindowedDataStream` and the `StreamWindow`:
- The `WindowedDataStream` is created when we call the `window(…)` method of the `DataStream` and represents the windowed discretisation of the underlying stream. The user can think about it simply as a `DataStream<StreamWindow<T>>` where additional API functions are supplied to provide efficient transformations of individual windows.
- The result of a window transformation is again a `WindowedDataStream` which can also be used to further transform the resulting windows. In this sense, window transformations define mapping from **stream windows** to **stream windows**

The user has different ways of using the a result of a window operation:
- `windowedDataStream.flatten()` - streams the results element wise and returns a `DataStream<T>` where `T` is the type of the underlying windowed stream
- `windowedDataStream.getDiscretizedStream()` - returns a `DataStream<StreamWindow<T>>`for applying some advanced logic on the stream windows itself
- Calling any window transformation further transforms the windows, while preserving the windowing logic

Example:
- create windows that hold elements of the last 5 seconds, and the user defined transformation would be executed on the windows every second (sliding the window by 1 second). **policy based windowing**
```scala
dataStream.window(Time.of(5, TimeUnit.SECONDS)).every(Time.of(1, TimeUnit.SECONDS))
```
- a window (hopping window) that takes the latest 100 elements of the stream every minute
```scala
    dataStream.window(Count.of(100)).every(Time.of(1, TimeUnit.MINUTES))
```
The user can also omit the `every(…)` call which results in a **tumbling window** emptying the window after every transformation call.

Several predefined **policies**. These can be accessed through the static methods provided by the *PolicyHelper* classes:
- `Time.of(…)`: time-based
- `Count.of(…)`: count-based
- `Delta.of(…)`: delta-based

#### Policy based 
 to specify stream discretisation also called windowing semantics
 - TriggerPolicy: defines when to trigger the reduce UDF on the current window and emit the result. In the API it completes a window statement such as: `window(…).every(…)`, while the triggering policy is passed within `every`.Several predefined policies :
     + delta-based
     + punctuation based
     + count-based
     + time-based
 - EvictionPolicy: defines the length of a window as a means of a predicate for evicting tuples when they are no longer needed. In the API this can be defined by the `window(…)` operation on a stream

Time-based trigger and eviction policies can work with user defined `TimeStamp` implementations, these policies already cover most use cases

####Reduce on windowed data streams
`WindowedDataStream<T>.reduceWindow(ReduceFunction<T>)` transformation calls the user-defined ReduceFunction at every trigger on the records currently in the window

Work with `min` ,`max`, `sum`, `minBy`, `maxBy`

Example: reduce that sums the elements in the last minute with 10 seconds slide interval:
```scala
dataStream.window(Time.of(1, TimeUnit.MINUTES)).every(Time.of(10,TimeUnit.SECONDS)).sum(field)
```

#### Map on Windowed Data Streams
The `WindowedDataStream<T>.mapWindow(WindowMapFunction<T,O>)` transformation calls `mapWindow(…)` for each `StreamWindow` in the discretised stream. This allows a straightforward way of mapping one stream window to another.
```scala
windowedDataStream.mapWindow(windowMapFunction)
```

#### Grouped transformations on windowed data streams
Calling the `groupBy(…)` method on a windowed stream groups the elements by the given fields inside the stream windows

call `windowedStream.groupBy(…).reduceWindow(…)` will transform each window into another window consisting of as many elements as groups, with the reduced values per key

Example:
- took the last 100 elements, divided it into groups by key then applied the aggregation
```scala
dataStream.window(Count.of(100)).every(…).groupBy(groupingField).max(field)
```

- take the max for the last 100 elements in Each group. 
```scala
dataStream.groupBy(groupingField).window(Count.of(100)).every(…).max(field)
```
This will create separate windows for different keys and apply the trigger and eviction policies on a per group basis

#### Applying multiple transformation on a window

Example: 
global windows of 1000 elements group it by the first key and then apply a mapWindow transformation. The resulting windowed stream will then be grouped by the second key and further reduced. The results of the reduce transformation are then flattened
```scala
dataStream.window(Count.of(1000)).groupBy(firstKey).mapWindow(…)
    .groupBy(secondKey).reduceWindow(…).flatten()
```

Notice:
`(groupBy(firstKey).mapWindow(…).groupBy(secondKey).reduceWindow(…))` happens inside the 1000 element windows

#### Global and local discretisation
- *Global*: By default all window discretisation calls (`dataStream.window(…)`) define global windows meaning that a global window of count 100 will contain the last 100 elements arrived at the discretisation operator in order
- *Local* :allows the discretiser to run in parallel and apply the given discretisation logic at every discretiser instance. use the `local()` method of the windowed data stream
Example: `dataStream.window(Count.of(100)).local().maxBy(field)` would create several count discretisers (as defined by the environment parallelism) and compute the max values accordingly.

###Temporal database style operators
Currently _join_ and _cross_ operation are supported on _time windows_
- *Join*: produces a new Tuple DataStream with two fields:
    + 1st field: hould a joined element of the first input DataStream
    + 2nd field: a matching element of the second DataStream
```scala
    dataStream1.join(dataStream2)
        .onWindow(windowing_params)
        .where(key_in_first)
        .equalTo(key_in_second)
```
- *Cross* : combines two DataStreams into one DataStream.  it builds a temporal Cartesian product.
```scala
dataStream1 cross dataStream2 onWindow (windowing_params)
```


###Co operators
- allow the users to jointly transform two DataStreams of different types 
- where merging is not appropriate due to :
    + different data types
    + in case the user needs explicit tracking of the joined stream origin
- applied to `ConnectedDataStreams` which represent two DataStreams of possibly different types. Created by `connect(otherDataStream) method of a DataStream`

####Map on ConnectedDataStream
2 DataStream -> a DataStream with a common output type
```scala
    val dataStream1 : DataStream[Int] = ...
    val dataStream2 : DataStream[String] = ...

    (dataStream1 connect dataStream2)
        .map(
            (_ : Int) => true, //CoMapFunction.map1() for each element of the 1st input
        (_ : String) => false //CoMapFunction.map2() for each element of the 2nd input
    )
```
####FlatMap on ConnectedDataStream
after each map call the user can output arbitrarily many values using the `Collector` interface.
```scala
    val dataStream1 : DataStream[Int] = ...
    val dataStream2 : DataStream[String] = ...

    (dataStream1 connect dataStream2)
        .flatMap(
        (num : Int) => List(num.toString), // flatmap1
        (str : String) => str.split(" ")    //flatmap2f
    )
```

####WindowReduce on ConnectedDataSteram
applies a user defined `CoWindowFunction` to time aligned windows of the two data streams and return zero or more elements of an arbitrary type

#### Reduce on ConnectedDataStream
applies a simple reduce transformation on the joined data streams and then maps the reduced elements to a common output type

###Output splitting
```scala
val split = someDataStream.split(
  (num: Int) =>
    (num % 2) match {
      case 0 => List("even")
      case 1 => List("odd")
    }
)

val even = split select "even" 
val odd = split select "odd"
```
- select multiple output name by `splitStream.select("output1", "output2", ...)`
- select all `split.selectAll`

###Iterations
-  implement a _step function_ and embed it into an `IterativeDataStream`
- at the tail of each iteration part of the output is streamed forward to the next operator and part is streamed back to the iteration head
- controls the output of the iteration tail by defining a step function that return two DataStreams:
    + feedback
    + output

```scala
val iteratedStream = someDataStream.iterate(maxWaitTime) {// wait for maxWaitTime , stop if no input
  iteration => {
    val head = iteration.map(iterationHead)
    val tail = head.map(iterationTail)
    (tail.filter(isFeedback), tail.filter(isOutput))
  }
}.map(…).project(…)
```


###Rich functions
Rich functions provide, in addition to the user-defined function (`map()`, `reduce()`, etc), the `open()` and `close()` methods for initialization and finalization.
```scala
    dataStream map
    new RichMapFunction[Int, String] {
        override def open(config: Configuration) = {
        /* initialization of function */
        }
        override def map(value: Int): String = value.toString
    }
```
##Lambda expressions with Java 8
##Operator Settings
###Parallelism
###Buffer timeout

##Stream connectors
###Apache Kafka
###Apache Flume
###RabbitMQ
###Twitter Streaming API
###Docker containers for connectors
