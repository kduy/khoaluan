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

## Data Definition Language (DDL)
### create stream
```sql
CREATE STREAM OpenAuction( itemID int, price real , start_time timestamp)
    ORDER BY start_time
    SOURCE 'port4445'
```

```sql
CREATE SCHEMA SymbolSchema (ID int, Symbol string, Price double);
CREATE STREAM Input1 SymbolSchema;
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

### retain
```sql
RETAIN
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
## Windowing



## Build-in Func

### Aggregate Func
`sum`, `min`, `max`, `minBy`, `maxBy`

###Coversion Func
`cast`

### Data & Time Func
`day`, `month`, `year` ...

### String func
`substring`





--------------------------------------------------
[a] Azure.md 

[1]: Oracle Complex Event Processing: Lightweight Modular Application Event Stream Processing in the Real World , page 10

[2]: [Oracle BEA. EPL Reference Guide. Oracle; 2011](http://docs.oracle.com/cd/E13157_01/wlevs/docs30/epl_guide/index.html) epl_guide.pdf

[b]: [scala type] (http://www.tutorialspoint.com/scala/scala_data_types.htm)