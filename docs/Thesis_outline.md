
# I. Introduction



part II, III, : b
part IV: 

# II. Data Stream Model
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






#II Continuous Query Semantics and Operators
**Features of stream processing languages**(Fundamental of Stream Processing boook page 110)
**Query** : [14] Model and issues in Data Stream System


### Semantics and algebra
Two types of continuous query algebras have been proposed in the literature, both based on relational algebra
- Stream-to-stream algebra:
- Mixed algebra:s2r, r2r, r2s

### Operators
- 2 important concepts:
    + monotonicity
    + non-blocking
incrementally produce new results over time
**Blocking Operators** [14]


### Trigger/Eviction policies

### Continous Queries as Views
the DSMS itself usually does not materialize the views. Continuous queries produce streams of updates over time, but it is up to the user or application to maintain the final result.
### Semantics of Relations in Continous Queries





# III. Continous Query Language
**Features of stream processing languages**(Fundamental of Stream Processing boook page 110)

**Query** : [14] Model and issues in Data Stream System

### Semantics and algebra
Two types of continuous query algebras have been proposed in the literature, both based on relational algebra
- Stream-to-stream algebra:
- Mixed algebra:s2r, r2r, r2s
## Data Type
## Streams, Relations and Windows Operators
- 2 important concepts:
    + monotonicity
    + non-blocking
incrementally produce new results over time
**Blocking Operators** [14]

### Standard Operators [12]
### Window operators
## Trigger/Eviction policies
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
- Evaluation of the Stream Query Language CQL
- toward 
- SECRET: time-driven, batch-driven, tuple-driven

## Built-in Function

## Data Definition Language (DDL)

## Data Manipulation Language (DML)

#IV: Translation Rules and Implementation

# V. Random Query Generator

The Linear Road Benchmark


# VI. Conclusion



# Figure
[esper_reference_5.2.pdf

# type checking : rule
cc14/lec16.pdf (compiler EPFL)


- deep vs shallow DSL
	http://www.cs.ox.ac.uk/jeremy.gibbons/publications/embedding.pdf
	https://www.youtube.com/watch?v=xS7TJrrhYe8