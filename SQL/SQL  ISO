[8][BNF Grammar for ISO/IEC 9075-2:2003 - Database Language SQL (SQL-2003) SQL/Foundation](http://savage.net.au/SQL/sql-2003-2.bnf.html)

[9][Database SQL Language Reference] (http://docs.oracle.com/cd/B28359_01/server.111/b28286/wnsql.htm#SQLRF000)



[10]http://en.wikibooks.org/wiki/SQL_Dialects_Reference


[ISO/IEC 9075-2:2006] (http://www.wiscorp.com/sql200n.zip)
http://savage.net.au/SQL/
http://en.wikibooks.org/wiki/Structured_Query_Language/Standard_Track_Print

[paper]Generating Highly Customizable SQL Parsers
BNF spec

[thesis] Continous Query over Data Stream [BNF]
http://archiv.ub.uni-marburg.de/diss/z2007/0671/pdf/djk.pdf

Rewritting Query:
http://www.dpriver.com/blog/list-of-demos-illustrate-how-to-use-general-sql-parser/oracle-sql-query-rewrite/

------------------


The latest SQL standard was adopted in July 2003 and is often called SQL:2003. One part of the SQL standard, Part 14, SQL/XML (ISO/IEC 9075-14) was revised in 2006 and is often referenced as "SQL/XML:2006". The formal names of this standard, with the exception of SQL/XML, are:


ANSI/ISO/IEC 9075:2003, "Database Language SQL", Parts 1 ("SQL/Framework"), 2 ("SQL/Foundation"), 3 ("SQL/CLI"), 4 ("SQL/PSM"), 9 ("SQL/MED"), 10 ("SQL/OLB"), 11("SQL/Schemata"), and 13 ("SQL/JRT")


ISO/IEC 9075:2003, "Database Language SQL", Parts 1 ("SQL/Framework"), 2 ("SQL/Foundation"), 3 ("SQL/CLI"), 4 ("SQL/PSM"), 9 ("SQL/MED"), 10 ("SQL/OLB"), 11("SQL/Schemata"), and 13 ("SQL/JRT")



The SQL:2003 standard is also split into a number of parts. Each is known by a shorthand name. Note that these parts are not consecutively numbered.

ISO/IEC 9075-1 Framework (SQL/Framework)

ISO/IEC 9075-2 Foundation (SQL/Foundation)

ISO/IEC 9075-3 Call Level Interface (SQL/CLI)

ISO/IEC 9075-4 Persistent Stored Modules (SQL/PSM)

ISO/IEC 9075-9 Management of External Data (SQL/MED)

ISO/IEC 9075-10 Object Language Bindings (SQL/OLB)

ISO/IEC 9075-11 Information and Definition Schemas (SQL/Schemata)

ISO/IEC 9075-13 Routines and Types using the Java Language (SQL/JRT)

ISO/IEC 9075-14 XML-related specifications (SQL/XML)

**PostgreSQL covers parts 1, 2, and 11**. Part 3 is similar to the ODBC interface, and part 4 is similar to the PL/pgSQL programming language, but exact conformance is not specifically intended or verified in either case.

PostgreSQL supports most of the major features of SQL:2003. Out of 164 mandatory features required for full Core conformance, PostgreSQL conforms to at least 150. In addition, there is a long list of supported optional features. It may be worth noting that at the time of writing, no current version of any database management system claims full conformance to Core SQL:2003.



----------

The SQL standard arranges statements into 9 groups:

"The main classes of SQL-statements are:
SQL-schema statements; these may have a persistent effect on the set of schemas.
SQL-data statements; some of these, the SQL-data change statements, may have a persistent effect on SQL data.
SQL-transaction statements; except for the <commit statement>, these, and the following classes, have no effects that persist when an SQL-session is terminated.
SQL-control statements.
SQL-connection statements.
SQL-session statements.
SQL-diagnostics statements.
SQL-dynamic statements.
SQL embedded exception declaration."
This detailed grouping is unusual in common speech. Usually it is distinguish between three groups:

Data Definition Language (DDL): Managing the structure of database objects (CREATE/ALTER/DROP tables, views, columns, ...)
Data Manipulation Language (DML): Managing and retrieval of data with the statements INSERT, UPDATE, MERGE, DELETE, SELECT, COMMIT, ROLLBACK and SAVEPOINT.
Data Control Language (DCL): Managing access rights (GRANT, REVOKE).
Hint: In some publications the SELECT statement is said to build its own group Data Query Language. This group has no other statements than SELECT.

