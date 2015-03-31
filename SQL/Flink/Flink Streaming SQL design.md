

1. Source

```sql
CREATE STREAM OpenAuction( itemID int, price real , start_time timestamp)
    ORDER BY start_time
    SOURCE 'port4445'
```

- `socketTextStream(hostname, port)`
```sql
SOURCE HOST ('localhost',4445)
```
- `readTextStream(filepath)`
```sql
SOURCE FILE ('/temp/file.txt')
```

- `generateSequence(from, to)`
```sql
    SOURCE SEQ (1,1000)
```

- `fromElements(elements…)`
`\\TODO`
- `fromCollection(collection)`:   
`\\TODO`
- `readTextFile(filepath)`
`\\TODO`


- deriving a new Data Stream
```sql
CREATE STREAM expensiveItem AS 
    SELECT itemId, price, start_time
    FROM OpenAuction WHERE price > 1000 
```

- streambase
```sql
CREATE SCHEMA SymbolSchema (ID int, Symbol string, Price double);
CREATE STREAM Input1 SymbolSchema;
```
2. Sink
```sql
SELECT * >> '/temp/output.txt'
FROM OpenAuction
```
- `dataStream.writeAsText(parameters)`
- `dataStream.writeAsCsv(parameters)`
- `dataStream.print()`

3. Partitioning 
```sql

```
- *Forward*(default) :  Usage : `dataStream.forward()`
- *Shuffle*:            Usage: `dataStream.shuffle()`
- *Distribute*:         Usage: `dataStream.distributed()`
- *Field/key*:          this partitions is applied when using the `groupBy` operators. 
- *Broadcast*:          Usage: `dataStream:broadcast()`
- *Global*:             Usage: `operator.setParallelism(1)`

4. Operations
- Basic : Map, Flatmap, Reduce, Merge, Filter
- Grouped operator: `groupBy(key) -> GroupedDataStream`
    + Reduce on GroupedDataStream: `ReduceFunction`
- Aggregations: `sum`,  `min`, `max`, `minby`, `maxBy`
- Window/batch operator
- 
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