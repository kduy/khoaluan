## Preliminaries
### Stream Model
- 3 properties of Data Stream: 
    + sequences of records, ordered by arrival time or by another ordered attribute
    + produced by a variety of externam sources
    + produced continually , unbounded  
- 2 kinds of stream: 
    + `base stream`: from source, append-only 
    + `derived stream`: produced by continous queries and operators, may or may not be append- only
        * Logical stream ? [12]
        * Physical stream ? [12]
- 4  ways in which a data stream can represent a signal :
    + aggregate model
    + cash register model
    + turnstile model
    + reset model

### Stream Window
Window may be classified accourding the following criteria:
    + Direction of movement : fixed window, sliding window
    + Definition of contents: time-based, count-based/tuple-based, partitioned windows, predicate window
    + Frequency of movement: jumping window, mixed jumping window, tumbling window

## Continuous Query Semantics and Operators
### Semantics and algebra
Two types of continuous query algebras have been proposed in the literature, both based on relational algebra
- Stream-to-stream algebra:
- Mixed algebra:s2r, r2r, r2s

### Operators
- 2 important concepts:
    + monotonicity
    + non-blocking
incrementally produce new results over time

### Continous Queries as Views
the DSMS itself usually does not materialize the views. Continuous queries produce streams of updates over time, but it is up to the user or application to maintain the final result.
### Semantics of Relations in Continous Queries


## CQL
###Streams,Relations and Windows
###User-Defined Functions
###Sampling




[5s] Supporting views in data stream management systems
