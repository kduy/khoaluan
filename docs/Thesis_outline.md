
# I. Introduction


# II. Data Stream
- Time
- Tuple
- Data Stream

## Stream Model
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

## Stream Window
Window may be classified accourding the following criteria:
    + Direction of movement : fixed window, sliding window
    + Definition of contents: time-based, count-based/tuple-based, partitioned windows, predicate window
    + Frequency of movement: jumping window, mixed jumping window, tumbling window

## Continuous Query Semantics and Operators
**Query** : [14] Model and issues in Data Stream System
**Blocking Operators** [14]

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


# III. Continous Query Language
## Data Type
## Streams, Relations and Windows Operators
### Standard Operators [12]
### Window operators
It contains three types of operators: 
- relation-to-relation operators that are similar to standard relational operators

- stream-to-relation: sliding windows that convert streams to time-varying relations. There classes of sliding window operators in CQL:
    + time-based
    + tuple-based
    + partioned
    + other types: fixed windows, tumbling windows, value-based windows

- relation-to-stream operators

### Processing tuples
- Smart Vortex

## Built-in Function

## Data Definition Language (DDL)

## Data Manipulation Language (DML)

# IV. Random Query Generator

The Linear Road Benchmark

# V. Conclusion





- deep vs shallow DSL
	http://www.cs.ox.ac.uk/jeremy.gibbons/publications/embedding.pdf
	https://www.youtube.com/watch?v=xS7TJrrhYe8