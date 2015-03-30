#Flink Streaming

##Introduction
##Flink Streaming API
##Example Program
##Program Skeleton
##Basics
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
##Transformations
###Basic transformations
- *Map*
- *Flatmap*
- *Filter*
- *Reduce*:  A streaming reduce on a full or grouped data stream emits the current reduced value for every new element on a data stream.On a windowed data stream it works as a batch reduce: it produces at most one value. 
- **Merge**: Merges two or more datastreams creating a new stream containing all the elements from all the streams.

- 
###Grouped operators
###Aggregations
###Window operators
###Temporal database style operators
###Co operators
###Output splitting
###Iterations
###Rich functions
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
