<!-- MarkdownTOC -->

- I. Lexical
    - Scala basic literal
    - Escape sequence:
    - Event Properties
- II. Operation
    - 1. Scala-based Operators
        - Arithmetic
        - Logical
        - Comparison / Relational
        - Bitwise
        - [Assignment  //][NOTUSE]
    - List and Range Operators
        - In / Not in
        - Between
        - Null
    - String Operators
        - Like
        - Regex
- g
    - Aggregate Func
    - Coversion Func
    - Data & Time Func
    - String func
- III. Data Definition Language (DDL)
    - 1. Create stream / Source
        - a. Create a SCHEMA
        - b. Define a new stream
- IV. Data Manipulation Language
    - Select statement
    - Merge statement
    - Split statement
    - Join/cross statement
    - From clause
    - Window clause
    - Where clase
    - GroupBy clause / Partition  ???
    - Having clause
    - OrderBy clause
    - [ Delete statement][TODO]
    - [ Sink][TODO]
    - Stream Mill
    - Stream base

<!-- /MarkdownTOC -->

## I. Lexical 

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

### Scala basic literal
- Integer : 0 ,035, 21 , 0xFFFFFFFF , 0777L
- Floating poitn: 0.0  ,1e30f ,3.14159f ,1.0e100,.1
- Boolean
- Symbol
- Character: 'a' ,'\u0041','\n','\t'
- String: "Hello,\nWorld!" , 
"This string contains a \" character."
- MULTI-LINE STRINGS : """abc \n abc"""
- Null

### Escape sequence:
`\b`, `\t`, `\n`, \f , \r , \", \', \\

http://www.tutorialspoint.com/scala/scala_data_types.htm

**Azure** : bigint, float, nvarchar(max), datetime, record
https://msdn.microsoft.com/en-us/library/azure/dn835065.aspx

### Event Properties

|Type |Syntax |
|-----|:-----:|
|Simple |name|
|Nested |name.nestedname|
|Indexed |name[index]|
|Mapped |name('key')|

## II. Operation

### 1. Scala-based Operators

#### Arithmetic
`+, - , *, / , %`

#### Logical 
- `Not`, `or`, `and` (`&&, ||, !`)

#### Comparison / Relational 
- `==, !=, <, >, <=, >=`. option:`<>`

#### Bitwise 
- `& | ^`
- `~, << , >> , >>>`

#### Assignment  // [NOTUSE]
http://www.tutorialspoint.com/scala/scala_operators.htm


#### In / Not in
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

#### Null
- `not exist, exists, is null  , is not null` //


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

## g
III.Build-in Func

#### Aggregate Func
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

#### Coversion Func
`cast`
```sql
cast(price, double)
```

#### Data & Time Func  
`day`, `month`, `year` ...

#### String func
`substring`


### 1. Create stream / Source

#### a. Create a SCHEMA
```sql
    CREATE SCHEMA StockSchema (ID int, Symbol string, Price double);
```

```sql
//azure
CREATE SCHEMA 
    schema_name 
    ( column_name <data_type> [ ,...n ] );

```

#### b. Define a new stream
- With SCHEMA
```sql    
    CREATE STREAM StockStream StockSchema;
```

- Without SCHEMA
```sql
    CREATE STREAM OpenAuction( itemID int, price real)
```

c. Populating new Stream with Source

```sql
    CREATE STREAM OpenAuction (itemID int, price real) // opt: schema
        SOURCE HOST ('localhost',4445) // `socketTextStream(hostname, port)`
        | SOURCE FILE ('/temp/file.txt')  //`readTextStream(filepath)`
        | SOURCE SEQ (1,1000)             // `generateSequence(from, to)`
        | SOURCE STREAM flinkStream       // 
```

d. Deriving a new Stream
```sql
    CREATE STREAM expensiveItem AS // option: add new SChema
        SELECT itemId, price, start_time // stream-to-stream
        FROM OpenAuction   
        WHERE price > 1000 
```

## IV. Data Manipulation Language
Managing and retrieval of data with the statements INSERT, UPDATE, MERGE, DELETE, SELECT ...

SELECT  - FROM - WHERE - GROUP BY - HAVING - CASE - JOIN - UNION - WITH

### Select statement


### Merge statement


### Split statement
```sql
// EsperTech
on OrderEvent
  insert into LargeOrders select orderId, customer where orderQty >= 100
  insert into MediumOrders select orderId, customer where orderQty between 20 and 100
  insert into SmallOrders select orderId, customer where orderQty > 0
```


### Join/cross statement






### OrderBy clause




###  Delete statement [TODO]

// de-register a stream

###  Sink [TODO]
```sql
    SELECT * >> '/temp/output.txt'   // `>>` conflict to Scala operators
    FROM OpenAuction
```



----------

### Stream Mill
- Unifying the Processing of XML Streams and Relational Data Streams.pdf
```sql
CREATE STREAM UsedBookBidStream (BookID int, BidderID char(10), BidPrice real, BidTime timestamp)
SOURCE ‘port4445’
```


```sql
CREATE STREAM expensiveItems AS
SELECT BookID, BidderID, BidPrice, BidTime FROM UsedBookBidStream WHERE BidPrice > 200
```

Continuously return the total number of bids
in the last 10 minutes.
```sql
SELECT current time, COUNT(BidPrice)
OVER (RANGE 10 MINUTE PRECEDING)
FROM BidStream
```


Continuously return the average bid price of last 5 bids for every book.
```sql
SELECT current time, BookID, avg(BidPrice)
OVER (PARTITION BY BookID ROWS 5 PRECEDING) FROM BidStream
```

### Stream base
```sql
CREATE SCHEMA SymbolSchema (ID int, Symbol string, Price double);
CREATE STREAM Input1 SymbolSchema;
```


----------
- Clauses: Statements are subdivided into clauses. The most popular one is the WHERE clause. 

- Predicates: Predicates specify conditions which can be evaluated to a boolean value. E.g.: a boolean
comparison, BETWEEN, LIKE, IS NULL, IN, SOME/ANY, ALL, EXISTS.

- Expressions: Expressions are numeric or string values by itself, or the result of arithmetic or concatenation operators, or the result of functions.
- Object names: Names of database objects like tables, views, columns, functions. 
- Values: Numeric or string values.
- Arithmetic operators: The plus sign, minus sign, asterisk and solidus (+, –, * and /) specify addition, subtraction, multiplication and division.
- Concatenation operator: The '||' sign specifies the concatenation of character strings.
- Comparison operators: The equals operator, not equals operator, less than operator, greater than operator, less than or equals operator, greater than or equals operator ( =, <>, <, >, <=, >= ) compares values and expressions.
- Boolean operators: AND, OR, NOT combines boolean values.

