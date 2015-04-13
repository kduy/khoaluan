##Data Type
1. Java Tuples and Scala Case Classes
2. Java POJOs
3. Primitive Types: all Java, Scala primitive types
4. Regular Classes
5. Values
6. Hadoop Writables


|JDBC Type |  Java Type|
|----------|:---------:|
|CHAR |   String|
|VARCHAR |String|
|LONGVARCHAR| String|
|NUMERIC |java.math.BigDecimal|
|DECIMAL |java.math.BigDecimal|
|BIT |boolean|
|BOOLEAN |boolean|
|TINYINT |byte|
|SMALLINT |   short|
|INTEGER |int|
|BIGINT  |long|
|REAL    |float|
|FLOAT   |double|
|DOUBLE  |double|
|BINARY  |byte[]|
|VARBINARY   |byte[]|
|LONGVARBINARY|   byte[]|
|DATE    |java.sql.Date|
|TIME    |java.sql.Time|
|TIMESTAMP|   java.sql.Timestamp|
|CLOB    |Clob|
|BLOB    |Blob|
|ARRAY   |Array|
|DISTINCT|    mapping of underlying type|
|STRUCT  |Struct|
|REF |Ref|
|DATALINK  |  java.net.URL|
|JAVA_OBJECT| underlying Java class|

http://www.tutorialspoint.com/scala/scala_data_types.htm

|Scala Data Type |  Description|
|----------------|:-----------:|
|Byte   | 8 bit signed value. Range from -128 to 127|
|Short |  16 bit signed value. Range -32768 to 32767|
|Int| 32 bit signed value. Range -2147483648 to 2147483647|
|Long  |  64 bit signed value. -9223372036854775808 to 9223372036854775807|
|Float |  32 bit IEEE 754 single-precision float|
|Double | 64 bit IEEE 754 double-precision float|
|Char  |  16 bit unsigned Unicode character. Range from U+0000 to U+FFFF|
|String | A sequence of Chars|
|Boolean |Either the literal true or the literal false|
|Unit  |  Corresponds to no value|
|Null  |  null or empty reference|
|Nothing |The subtype of every other type; includes no values|
|Any |The supertype of any type; any object is of type Any|
|AnyRef|  The supertype of any reference type|

####Scala basic literal
- Integer : 0 ,035, 21 , 0xFFFFFFFF , 0777L
- Floating poitn: 0.0  ,1e30f ,3.14159f ,1.0e100,.1
- Boolean
- Symbol
- Character: 'a' ,'\u0041','\n','\t'
- String: "Hello,\nWorld!" , 
"This string contains a \" character."
- MULTI-LINE STRINGS : """abc \n abc"""
- Null

#### Escape sequence:
`\b`, `\t`, `\n`, \f , \r , \", \', \\



### Event Properties

|Type |Syntax |
|-----|:-----:|
|Simple |name|
|Nested |name.nestedname|
|Indexed |name[index]|
|Mapped |name('key')|

## Operators
### Arithmetic
`+, - , *, / , %`

###Logical and Comparison
- `Not`, `or`, `and`
- `=, !=, <, >, <=, >=,<>`

### Binary 
`& | ^`

### List and Range Operators
#### In
```sql
test_expression [NOT] IN (expression [,expression [,...]] )
```

```sql
WHERE command IN ('OBSERVATION', 'SIGNAL')
WHERE command = 'OBSERVATION' OR symbol = 'SIGNAL'
```

#### Between
```sql
test_expression [NOT] BETWEEN begin_expression AND end_expression
```

### String Operators
#### Like
```sql
test_expression [NOT] LIKE pattern_expression [ESCAPE string_literal]
```

```sql
WHERE name LIKE '%Jack%'
WHERE suffix LIKE '!_' ESCAPE '!'
```

#### Regex
```sql
test_expression [NOT] REGEXP pattern_expression
```

```sql
WHERE name REGEXP '*Jack*'
```



## Build-in Func

### Aggregate Func
`sum`, `min`, `max`, `minBy`, `maxBy`, `avg/count?`

```sql
MAX(expression, expression [, expression [,...])
```
```sql
aggregate_function( [ALL | DISTINCT] expression)
AVG(price * 2)
```
```sql
SUM([ALL|DISTINCT] expression)
```
###Coversion Func
`cast`
```sql
cast(price, double)
```

### Data & Time Func
`day`, `month`, `year` ...

### String func
`substring`

## Data Definition Language (DDL)
### create stream
```sql
// streamBase
CREATE STREAM OpenAuction( itemID int, price real , start_time timestamp)
    ORDER BY start_time
    SOURCE 'port4445'
```

```sql
CREATE SCHEMA SymbolSchema (ID int, Symbol string, Price double);
CREATE STREAM Input1 SymbolSchema;
```

```sql
CREATE STREAM source_stream_identifier (field_identifier_1 field_type_1) SOURCE ...;
CREATE STREAM stream_identifier (field_identifier_2 field_type_1);
SELECT field_identifier_1 AS field_identifier_2 FROM source_stream_identifier 
  INTO stream_identifier
```


## Data Manipulation Language (DML)
SELECT  - FROM - WHERE - GROUP BY - HAVING - CASE - JOIN - UNION - WITH

### Select
```sql
SELECT expression [, expression] [, ...]
FROM stream_def
```

```sql
SELECT [event_property | expression] AS identifier [,...]
```
### From
```sql
FROM stream_expression [ join ]
```

 *stream_expression*
```sql
(stream_name | subquery_expr | param_sql_query) [[AS] alias]] [RETAIN retain_expr]
subquery_expr: ( epl_statement )
param_sql_query: database_name ('parameterized_sql_query')
```

### join 
```sql
JOIN stream_expression ON prop_name = prop_name)* // outer join
```

```sql
(, stream_expression )* // inner join
```

### cross


### merge  

```sql
\\EsperTech
    insert into MergedStream select * from OrderEvent
```


### retain
```sql
RETAIN // from Oracle EPL
( ALL [EVENTS] ) |
( [BATCH OF]
    ( integer (EVENT|EVENTS) ) | ( time_interval (BASED ON prop_name)* ) ( WITH [n] (LARGEST | SMALLEST | UNIQUE) prop_name )*
    ( PARTITION BY prop_name )* )
```

### where
```sql
WHERE aggregate_free_expression
```

### GroupBy
```sql
GROUP BY arregate_free_expression [, arregate_free_expression] [, ...]
```

### Having
```sql
HAVING expression
```

### OrderBy
```sql
ORDER BY expression [ASC | DESC] [, expression [ASC | DESC] [,...]]
```


### spliting
```sql
// EsperTech
on OrderEvent
  insert into LargeOrders select orderId, customer where orderQty >= 100
  insert into MediumOrders select orderId, customer where orderQty between 20 and 100
  insert into SmallOrders select orderId, customer where orderQty > 0
```
## Windowing
Note that a tumbling window is simply a hopping window whose ‘hop’ is equal to its ‘size’

### Windowed DataStream(Stream to Relation)

- Policy based
        * TriggerPolicy : `every(...)`
            - delta-based
            - punctuation-based
            - count-based (tubple-based)
            - time-based
        * EvictionPolicy: `window(...)`
```sql
// oracle EPL
FROM StockTick RETAIN 100 EVENTS
FROM StockTick RETAIN 1 MINUTE
RETAIN BATCH OF 100 EVENTS
RETAIN 1 MINUTE BASED ON timestamp //delta-based
```


```sql
//CQL
FROM stream_name [Range 1 minute
                    Slide 1 minute]
FROM stream_name [Rows 100
                    Slide 1 minute]
```

```sql
//stream mill: SQL 2003
SELECT itemId, sum(price)
    OVER (PARTITION BY itemID
        ROWS 49 PRECEDING SLICE 10)
FROM bid
```

```SQL
//ATLAS
FROM bid  b [PARTITION BY b.customerID
            ROWS 10 
            PRECEDING WHERE b.type = 'Long Distance' ] // could apply for delta-based
```

```sql
//EsperTech
￼select * from Withdrawal.win:time(4 sec)
 select * from StockTickEvent.win:length(10)
```
- Partition:
    + *Forward*(default) :  Usage : `dataStream.forward()`
    + *Shuffle*:            Usage: `dataStream.shuffle()`
    + *Distribute*:         Usage: `dataStream.distributed()`
    + *Field/key*:          this partitions is applied when using the `groupBy` operators. 
    ```scala
    dataStream.groupBy(groupingField).window(Count.of(100)).every(…).max(field)
    ```
    ```sql
    \\EsperTech
    ￼select symbol, sum(price) from StockTickEvent.win:time(30 sec) group by symbol
    ```
    + *Broadcast*:          Usage: `dataStream:broadcast()`
    + *Global*:             Usage: `operator.setParallelism(1)`


```sql
// oracle EPL
RETAIN 3 EVENTS PARTITION BY stockSymbol
```

- Operation
    + Reduce/aggregate
    + Map
    + GroupBy
    + Global/local



### Connected DataStream
- Map
- Flat
- WindowReduce
- Reduce




## appendix
```sql
time_interval: [day-part][hour-part][minute-part][seconds-part][milliseconds-part]
day-part: number ("days" | "day") hour-part: number ("hours" | "hour" | "hr")
minute-part: number ("minutes" | "minute" | "min")
seconds-part: number ("seconds" | "second" | "sec")
milliseconds-part: number ("milliseconds" | "millisecond" | "msec" | "ms")
```




--------------------------------------------------
[a] Azure.md 

[1]: Oracle Complex Event Processing: Lightweight Modular Application Event Stream Processing in the Real World , page 10

[2]: [Oracle BEA. EPL Reference Guide. Oracle; 2011](http://docs.oracle.com/cd/E13157_01/wlevs/docs30/epl_guide/index.html) epl_guide.pdf

[b]: [scala type] (http://www.tutorialspoint.com/scala/scala_data_types.htm)
[c]: [java<->jdbc type]http://www.cis.upenn.edu/~bcpierce/courses/629/jdkdocs/guide/jdbc/getstart/mapping.doc.html
[d]: [scala operators](http://www.tutorialspoint.com/scala/scala_operators.htm)