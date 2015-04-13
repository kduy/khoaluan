
### Data Model
There are three main types of objects in this model:


-  **Expression**: Can be a reference to a column of a table or a field of a tuple or a property of a nested data structure, a arithmetic expression, a logical expression, a function or expressions that can be used in where clauses, having clauses, field based window clauses

-  **DataSource**: Data source can be a stream, a table or a time varying relation results from applying a window operator to a stream. (I'm not sure whether DataSource is the correct naming. We need to discuss this.)

-  **Statement**: Stream SQL statements like SELECT, INSERT and UPDATE


Then we have a simple factory (**StreamSQLFactory**) which creates different types of expressions. And I have implemented a fluent style API for Select to demonstrate how building a query using this OM will looks like. Two examples queries can be found in **StreamSQLSamples**.