###April 28
#### How Window is selected ?
    + `WindowedDataStream`
    + `WindowBuffer`, `BasicWindowBuffer` and other subclasses
    + `discretize` function
        ```scala
private DiscretizedStream<OUT> discretize(WindowTransformation transformation,
            WindowBuffer<OUT> windowBuffer)
        ```

- `mapWindow` : at first, they are using `BasicWindowBuffer` which contain a LinkedList to store the elements
- For `aggregate` function , they are using `reduceWindow`
```scala
public DiscretizedStream<OUT> reduceWindow(ReduceFunction<OUT> reduceFunction) 
```
- `WindowedDataStream` contains `DataStream` and specific windowing features


#### When store new elements
- `StreamWindowBuffer.java`: 
    + `handleWindowEvent(windowEvent, buffer)` function: `buffer.store(windowEvent.getElement()`
    + `windowEvent` is either Element, Eviction or Trigger
    + the above windowEvent is `nextObject` in `StreamOperator`
    
#### Process Real Elements
- `processRealElement(IN input)` in `StreamDiscretizer.java`


- `recordIterator.next(nextRecord)` in `StreamOperator.java` line 98
    + `nextObject = nextRecord.getObject()` return `IN streamObject`(int, tuple...)
 
Reads the next record from the reader iterator and stores it in the
nextRecord variable

- `IndexedReaderIterator<StreamRecord<IN>> recordIterator`
- `StreamRecord<IN> nextRecord`
- `IN nextObject` 
- **IndexedReaderIterator**

#### Basic Window
`StreamWindow` will be add to collector `emitWindow(Collector<StreamWindow<T>> collector)`

- `Collector<OUT> collector` in `StreamOperator.java`

- StreamOperator<IN, OUT> (OUT The output type of the operator)
- `StreamOperator<StreamWindow<Integer>, StreamWindow<Integer>>`
- `StreamOperator<StreamWindow<Integer>, Integer> flattener `

---> dataStream.transform  to get a SingleOutputStreamOperator ---> a stream of OUT

#### Trigger/Eviction policies
- `window` alone: trigger
- `window` + `every`
    + `window`: eviction
    + `every`: trigger
- `trigger`: when the start of window
    + `TriggerPolicy.java`
    + Proves and returns if a new window should be started. In case the trigger
     occurs (return value true) the UDF will be executed on the current
     element buffer without the last added element which is provided as
     parameter. This element will be added to the buffer after the execution
     of the UDF.
- `eviction`: number of elements to keep/delete
    + `EvictionPolicy.java`
    + Proves if and how many elements should be deleted from the element
     buffer. The eviction takes place after the trigger and after the call to
     the UDF but before the adding of the new data point.
- `startTime` in custom `timestamp`: end of the first Window



#### Timestamp
- `timestamp`
    + `SystemTimestamp.java` : implementation to be used when system time is needed to determine windows. Granuarity: `System.currentTimeMillis`

- `TimestampWrapper`
    + 2 fields: `startTime` and `Timestamp`

- `Time.java` class

#### Count
- `Count.java`: 




--------> using T(app) and T(system) ~ position order






----------------------------------


