/*
 GenericSQL.g, for ANTLR 3.4

 Copyright 2010, 2011 Jason Osgood 

 Generic SQL grammar. Compile with ANTLR's generate parse tree command line option.

 Synthesized from MacroScope.g, tsqlselect.g, the official SQL 92 BNF, etc. 

 ** Header from MacroScope.g **

 From http://www.antlr.org/grammar/1062280680642/MS_SQL_SELECT.html ,
 simplified & extended with other SQL commands.

 ** Header from tsqlselect.g **

 Version: 0.8
 ANTLR Version: 2.7.2
 Date: 2003.08.25

 Description: This is a MS SQL Server 2000 SELECT statement grammar.

 =======================================================================================
 Author: Tomasz Jastrzebski
 Contact: tdjastrzebski@yahoo.com
 Working parser/lexer generated based on this grammar will available for some time at:
 http://jastrzebski.europe.webmatrixhosting.net/mssqlparser.aspx
*/

grammar GenericSQL;

options 
{
	language  = Java;
	backtrack = true;
//	memoize   = true;
}

@parser::header 
{ 
package fado.parse;
}

@parser::members
{
}

@lexer::header 
{ 
package fado.parse; 
}

statement
  : select ( SEMI )? EOF
  | insert ( SEMI )? EOF
	| update ( SEMI )? EOF
//	| delete ( SEMI )? EOF
  ;
  
subSelect
  : select
  | LPAREN select RPAREN
  ;
  
select
  : SELECT
    ( ALL | DISTINCT | UNIQUE )?
    ( TOP Integer ( PERCENT )? )?
    itemList
    ( into )?
    from
    ( joinList )?
    ( where )?
    ( groupBy )?
    ( having )?
    ( orderBy )?
  ;
  
insert
  : INSERT into ( columnList )?
  ( values
//| select_statement
  )
  ;  

update
  : UPDATE tableRef SET setter ( COMMA setter )*
    ( where )?
  ;
  
setter
  : columnName EQ literal
  ;
  
into
  : INTO tableRef ( COMMA tableRef )*
  ;

columnList
  : LPAREN columnName ( COMMA columnName )* RPAREN
  ;
  
values
  : VALUES LPAREN literal ( COMMA literal )* RPAREN
  ;  

itemList
  : STAR
  | item ( COMMA item )*
  ;
  
item
  : value ( ( AS )? alias )?
  | allColumns
  | function ( AS? alias )? 
  ;

allColumns
  : tableAlias DOT STAR
  ;

alias
  : Identifier
  ;
  
function
  : functionName LPAREN ( value ( COMMA value )* )? RPAREN
  ;  

functionName
  : COUNT
  | MIN
  | MAX
  ;
  
from
  : FROM fromItem ( COMMA fromItem )*
  ;
  
fromItem
  : ( ( LPAREN subSelect RPAREN ) 
    | tableRef 
    )
    ( ( AS )? alias )?
  ;

joinList
  : ( join )*
  ;
  
join
  : 
    ( JOIN
    | INNER JOIN
    | LEFT JOIN
    | LEFT OUTER JOIN
    | RIGHT JOIN 
    | RIGHT OUTER JOIN
    | OUTER JOIN 
    | NATURAL JOIN
    ) 
  fromItem
  ( ON conditionList
  | USING LPAREN columnRef ( COMMA columnRef )* RPAREN
  )?
  ;
  

//union
//  : UNION // Wrong
//  ;
//  

where
  : WHERE conditionList
  ;
  
groupBy
  : GROUP BY columnRef ( COMMA columnRef )*
  ;
  
having
  : HAVING conditionList
  ;
  
orderBy
  : ORDER BY orderByItem ( COMMA orderByItem )*
  ;
  
orderByItem
  : columnRef ( ASC | DESC )?
  ;
  
nestedCondition
  : LPAREN conditionList RPAREN
  ;
  
conditionList
  : condition ( ( OR | AND ) condition )*
  ;
  
condition
  : ( NOT )?
    ( nestedCondition
    | in
    | between
    | isNull
    | exists
    | like
    | quantifier
	  | comparison
    )
  ;

in
  : expression ( NOT )? IN LPAREN ( subSelect | expressionList ) RPAREN
  ;
  
between
  : expression ( NOT )? BETWEEN expression AND expression
  ;
  
isNull
  : expression IS ( NOT )? NULL
  ;
  
exists
  : EXISTS expression
  ;
  
like
//  : columnRef ( NOT )? LIKE String
  
  : expression ( NOT )? LIKE expression
//    ESCAPE Literal
  ;
    
comparison
  : expression comparator expression
  ;

comparator 
  : EQ
  | NEQ1
  | NEQ2
  | LTE
  | LT
  | GTE
  | GT
  ;
  
quantifier
  : expression ( ALL | ANY | SOME ) LPAREN subSelect RPAREN
  ;
  
expressionList
  : expression ( COMMA expression )*
  ;

nestedExpression
  : LPAREN expression RPAREN
  ;
  
expression
  : multiply ( ( PLUS | MINUS ) multiply )*
  ;
 
multiply
  : value ( ( STAR | DIVIDE ) value )* 
  ;
   
//value
//  : NULL 
////  | caseWhenExpression
//  | ( unary )?
//    ( Float
//    | Integer
//    | column
//    | nestedExpression
////    | LPAREN subSelect RPAREN
//    )
//  | '{d' Timestamp '}' // Date
//  | '{t' Timestamp '}' // Time
//  | '{ts' Timestamp '}' // Timestamp
//  ;
    
value
  : literal 
//  | caseWhenExpression
  | ( unary )?
    ( columnRef
    | nestedExpression
//    | LPAREN subSelect RPAREN
    )
  ;
  
literal
  : ( unary )? Float
  | ( unary )? Integer
  | String
  | TRUE
  | FALSE
  | date
  ;

date
  : '{d' Timestamp '}' // Date
  | '{t' Timestamp '}' // Time
  | '{ts' Timestamp '}' // Timestamp
  ;
    
unary
  : MINUS
  | PLUS
  ;
 
//caseWhenExpression
//  : CASE
//    ( ( whenThenSearchCondition )+ ELSE 
//    | value ( whenThenValue )* 
//    )
//    END
//  ;
//  
//whenThenSearchCondition
//  : WHEN condition THEN value
//  ;
//  
//whenThenValue
//  : WHEN value THEN value
//  ;
//  

tableRef
  : tableName
  | databaseName DOT tableName
  ;
  
columnRef
  : columnName 
  | tableAlias DOT columnName
  ;

databaseName
  : Identifier
  | QuotedIdentifier
  ;
  
tableName
  : Identifier
  | QuotedIdentifier
  ;
  
tableAlias
  : Identifier
  ;
  
columnName
  : Identifier
  | QuotedIdentifier
  ;
  
ALL       : A L L ;
AND       : A N D ;
ANY       : A N Y ;
AS        : A S ;
ASC       : A S C ;
BETWEEN   : B E T W E E N ;
BY        : B Y ;
CASE      : C A S E ;
//CAST      : C A S T ;
//CROSS     : C R O S S ;
//CONTAINS  : C O N T A I N S ;
//DAY       : D A Y ;
//DEFAULT   : D E F A U L T ;
DELETE    : D E L E T E ;
DESC      : D E S C ;
DISTINCT  : D I S T I N C T ;
ELSE      : E L S E ;
END       : E N D ;
//ESCAPE    : E S C A P E ;
EXISTS    : E X I S T S ;
//EXTRACT   : E X T R A C T ;
FALSE     : F A L S E ;
//FOR       : F O R ;
//FREETEXT  : F R E E T E X T ;
FROM      : F R O M ;
FULL      : F U L L ;
GROUP     : G R O U P ;
HAVING    : H A V I N G ;
//HOUR      : H O U R ;
IN        : I N ;
INNER     : I N N E R ;
INSERT    : I N S E R T ;
//INTERVAL  : I N T E R V A L ;
INTO      : I N T O ;
IS        : I S ;
JOIN      : J O I N ;
LEFT      : L E F T ;
LIKE      : L I K E ;
//MINUTE    : M I N U T E ;
//MONTH     : M O N T H ;
NATURAL   : N A T U R A L ;
NOT       : N O T ;
NULL      : N U L L ;
ON        : O N ;
OR        : O R ;
ORDER     : O R D E R ;
OUTER     : O U T E R ;
PERCENT   : P E R C E N T ;
RIGHT     : R I G H T ;
//SECOND    : S E C O N D ;
SELECT    : S E L E C T ;
SET       : S E T ;
SOME      : S O M E ;
//SUBSTRING : S U B S T R I N G ;
THEN      : T H E N ;
TRUE      : T R U E ;
//TIMESTAMP : T I M E S T A M P ;
TOP       : T O P ;
UNION     : U N I O N ;
UNIQUE    : U N I Q U E ;
UPDATE    : U P D A T E ;
USING     : U S I N G ;
VALUES    : V A L U E S ;
WHEN      : W H E N ;
WHERE     : W H E R E ;
//YEAR      : Y E A R ;

MAX       : M A X ;
MIN       : M I N ;
COUNT     : C O U N T ;

fragment A:('a'|'A');
fragment B:('b'|'B');
fragment C:('c'|'C');
fragment D:('d'|'D');
fragment E:('e'|'E');
fragment F:('f'|'F');
fragment G:('g'|'G');
fragment H:('h'|'H');
fragment I:('i'|'I');
fragment J:('j'|'J');
fragment K:('k'|'K');
fragment L:('l'|'L');
fragment M:('m'|'M');
fragment N:('n'|'N');
fragment O:('o'|'O');
fragment P:('p'|'P');
fragment Q:('q'|'Q');
fragment R:('r'|'R');
fragment S:('s'|'S');
fragment T:('t'|'T');
fragment U:('u'|'U');
fragment V:('v'|'V');
fragment W:('w'|'W');
fragment X:('x'|'X');
fragment Y:('y'|'Y');
fragment Z:('z'|'Z');

DOT      : '.'  ;
COMMA    : ','  ;
LPAREN   : '('  ;
RPAREN   : ')'  ;
LCURLY   : '{'  ;
RCURLY   : '}'  ;
STRCAT   : '||' ;
QUESTION : '?'  ;
COLON    : ':'  ;
SEMI     : ';'  ;

EQ       : '='  ;
NEQ1     : '<>' ;
NEQ2     : '!=' ;
LTE      : '<=' ;
LT       : '<'  ;
GTE      : '>=' ;
GT       : '>'  ;

PLUS     : '+'  ;
MINUS    : '-'  ;
DIVIDE   : '/'  ;
STAR     : '*'  ;
MOD      : '%'  ;

fragment
Digit : '0'..'9' ;

Integer 
  : ( Digit )+ 
  ;
  
Float
  : ('0'..'9')+ '.' ('0'..'9')* Exponent?
  | '.' ('0'..'9')+ Exponent?
  | ('0'..'9')+ Exponent
  ;
  
fragment
Exponent 
  : ('e'|'E') ('+'|'-')? ('0'..'9')+ 
  ;

String 
  : '\'' ( options {greedy=false;} : . )* '\''
  ;
  
Timestamp 
  : Digit Digit Digit Digit '-'
		Digit Digit '-' 
		Digit Digit ( 't' | ' ' )
		Digit Digit ':' Digit Digit ':' Digit Digit
	;

Identifier 
  : ('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_'|'$')*
  ;

QuotedIdentifier 
  : '[' ( options {greedy=false;} : . )* ']'
  | '"' ( options {greedy=false;} : . )* '"'
  ;
 
Comment
  : '--' ~('\n'|'\r')* '\r'? '\n' { $channel=HIDDEN; }
  | '//' ~('\n'|'\r')* '\r'? '\n' { $channel=HIDDEN; }
  | '/*' ( options {greedy=false;} : . )* '*/' { $channel=HIDDEN; }
  ;
  
Whitespace 
  : ( '\t' | ' ' | '\r' | '\n' )+ { $channel = HIDDEN; }
	;
