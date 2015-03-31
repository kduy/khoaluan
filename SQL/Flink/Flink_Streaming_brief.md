

1. Source

- `socketTextStream(hostname, port)`
- `readTextStream(filepath)`
- `generateSequence(from, to)`
- `fromElements(elements…)`
- `fromCollection(collection)`
- `readTextFile(filepath)`

2. Sink

3. Partitioning 
- *Forward*(default) :  Usage : `dataStream.forward()`
- *Shuffle*:            Usage: `dataStream.shuffle()`
- *Distribute*:         Usage: `dataStream.distributed()`
- *Field/key*:          this partitions is applied when using the `groupBy` operators. 
- *Broadcast*:          Usage: `dataStream:broadcast()`
- *Global*:             Usage: `operator.setParallelism(1)`

4. Transformation
- Basic : Map, Flatmap, Reduce, Merge
- Grouped operator: `groupBy(key) -> GroupedDataStream`
- Aggregations: `sum`,  `min`, `max`, `minby`, `maxBy`
- Window operator
    +   `DataStream.window` -> `WindowedDataStream`
    +   `WindowedDataStream.flatten()` -> `DataStream`
    + Policy based
        * TriggerPolicy : `every(...)`
            - delta-based
            - punctuation-based
            - count-based
            - time-based
        * EvictionPolicy: `window(...)`
    + Reduce/aggregate on WindowedDatastream: min , max , sum, minBy, maxBy
    + Map on WindowedDataStream: `windowedDataStream.mapWindow(windowMapFunction)`
    + Grouped on WindowedDataStream: `groupBy`
    + Global/local discretisation: `dataStream.window(Count.of(100)).local().maxBy(field)`
- Temporal database stype operators
    + `join`
    + `cross`

- Co operators
    + Map on ConnectedDataStream
    + Flatmap
    + WindowReduce
    + Reduce
- Output splitting
- Iteration
- Rich function