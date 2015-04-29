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

#### Trigger/Eviction policies
- `window` alone: trigger
- `window` + `every`
    + `window`: eviction
    + `every`: trigger
- `trigger`: when the end of window
- `eviction`: number of elements to keep
- `startTime` in custom `timestamp`: end of the first Window

