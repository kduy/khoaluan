[Key CQL Concept][1]

Oracle offers Oracle Continuous Query Language (Oracle CQL), a query language based on SQL with added constructs that support streaming data. Oracle CQL is designed to be:

* Scalable with support for a large number of queries over continuous streams of data and traditional stored data sets
* Adaptive and capable of dealing with cases where abrupt changes in data stream rates and system resource limitations


The major concept within CQL include : Stream / Relations / Operator / Functions and Patterns

- Stream 

Streams feed raw data to the Oracle Complex Event Processor. Stream sources can include any database, file, or JMS topic. CEP can access data from stream sources through either a push-based mechanism whereby the source raises data to CEP or through a pull based mechanism, whereby CEP pulls or queries data from the source system. 

Streams are created in CQL by using the CREATE STREAM DDL. Every stream created to feed data into CEP has two elements, the data itself, which are called tuples and a timestamp. Timestamps in any stream reflect an application's notion of time, not particularly system or wall-clock time. The timestamp is part of the schema of a stream, and there could be zero, one, or multiple elements with the same timestamp in a stream.
There are two classes of streams: base streams, which are the source data streams that arrive at the CEP engine, and derived streams, which are intermediate streams produced by operators in CQL.

- Relations

Relations identify the relationships between incoming data elements in CEP. In the standard relational model a relation is simply a set (or bag) of tuples, with no notion of time as far as the semantics of relational query languages are concerned.

In CQL the term instantaneous relation is used to denote a relation in the traditional bag-of-tuples sense, and relation to denote a time-varying bag of tuples.

The term base relation is used for input relations and derived relation for relations produced by CQL query operators.


- Operators

There are three classes of operators used with streams and relations in CEP:
    • Relation-to-Relation – These operators take 1 or more relations as inputs (depending on the specific operator) and produce a relation as output.

    Examples are Join, Select (Filter), and Project etc A CQL stream-to relation operator takes a stream as input and produces a relation as output.

    • Stream-to-Relation – These operators take a stream as input and produce a relation as output. The concept of a window over a stream can be used to define operators belonging to this class. Unlike relational database tables, data streams typically do not end. It is therefore useful to be able to define windows, or subsets of the streams. CQL supports 6 types of windows: Time, Row, Partition, Predicate, Extensible and Landmark.

    • Relation-to-Stream – These operators take a relation as input and produce a stream as output. CQL supports 3 Relation-to-Stream operators: Insert Stream (IStream), Delete Stream (DStream), and Relation Stream (RStream).

- Functions

Oracle CEP supports a library of functions including standard SQL functions, mathematical and statistical functions. Examples of supported SQL functions are in the following table.

Oracle CEP also enables users to “plug” in off-the-shelf software into the CEP engine to reference pre-defined algorithms while defining CQL. These include existing open source providers of Java algorithms, off-the-shelf mathematical packages and use-defined implementations of algorithms. Oracle CEP provides an extensibility framework through which users can registers functions (with Java implementations) with the CEP system and also reference these external functions in their CQL. Oracle CQL supports CREATE, ALTER, and DROP with userdefined functions.

* Pattern 

Patterns
Oracle CEP also has the capability to detect regular expression patterns in realtime. This is supported through the pattern recognition extensions to SQL in CEP. In CEP, pattern recognition comes in two flavors:

1. Recognize patterns in streams

2. Recognize patterns in relations

The pattern recognition extensions, add a number of sub-clauses to SQL for the specifications of patterns. We add a MATCH_RECOGNIZE sub-clause which takes a regular expression pattern defined over a regular expression of alphabets as argument. This can be followed by an optional PARTITION BY over an attribute of the incoming stream or relation. In addition to these, we allow a user to specify expressions through a MEASURES sub-clause, followed by a choice of ONE or ALL ROWS PER MATCH. The latter dictates whether or not overlapping patterns are matched or not. All this is then followed by a DEFINE sub-clause, which defines the alphabets in the pattern. For example:


```sql
    
        SELECT <select-list> FROM <stream|relation-name> 
        MATCH_RECOGNIZE (PARTITION BY)
                MEASURES (...)
                    ONE | ALL ROWS PER MATCH 
                    PATTERN <pattern-expression> 
                    DEFINE <define-alphabets>)
```


Example 
```sql
    CREATE STREAM TradeInputs (tradeId integer)
    CREATE STREAM TradeUpdates (tradeId integer)
```

Views:
```SQL
    CREATE VIEW CutOffTrades(tradeId, tradeVolume) AS
        DStream(SELECT * from TradeInputs[RANGE 200 SECONDS]);
```

```SQL
    CREATE VIEW OKTrades(tradeId) AS
    IStream(SELECT T.tradeId FROM CutOffTrades[NOW] AS R, TradeUpdates[RANGE 200 seconds] AS T
    WHERE R.tradeId = T.tradeId);
```
[1]: Oracle Complex Event Processing: Lightweight Modular Application Event Stream Processing in the Real World , page 10

[2]: Fundamentals of Stream Processing- Application Design, Systems, and Analytics [2014]

[3]: [Oracle BEA. EPL Reference Guide. Oracle; 2011](http://docs.oracle.com/cd/E13157_01/wlevs/docs30/epl_guide/index.html)

[4]: ArasuA,BabuS,WidomJ.The CQL continuous query language: semantic foundations and query execution. Very Large Databases Journal (VLDBJ). 2006;15(2):121–142.

[5]: Lukasz Golab, M. Tamer Özsu. Data Stream Management. Synthesis Lectures on Data Management, Morgan & Claypool Publishers 2010




------

This is [an example][id] reference-style link.

This is [an example](http://example.com/ "Title") inline link.
[id]: http://example.com/  "Optional Title Here"