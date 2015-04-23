/*
 * [The "MIT license"]
 * Copyright © 2014 Sam Harwell, Tunnel Vision Laboratories, LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * 1. The above copyright notice and this permission notice shall be included in
 *    all copies or substantial portions of the Software.
 * 2. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *    DEALINGS IN THE SOFTWARE.
 * 3. Except as contained in this notice, the name of Tunnel Vision
 *    Laboratories, LLC. shall not be used in advertising or otherwise to
 *    promote the sale, use or other dealings in this Software without prior
 *    written authorization from Tunnel Vision Laboratories, LLC.
 */
lexer grammar PostgreSqlLexer;

/* Reference:
 * http://www.postgresql.org/docs/9.3/static/sql-syntax-lexical.html
 */

@header {
import java.util.ArrayDeque;
import java.util.Deque;
}

@members {
/* This field stores the tags which are used to detect the end of a dollar-quoted string literal.
 */
private final Deque<String> _tags = new ArrayDeque<String>();
}

//
// SPECIAL CHARACTERS (§4.1.4)
//

// Note that Asterisk is a valid operator, but does not have the type Operator due to its syntactic use in locations
// that are not expressions.

Dollar			: '$';
LeftParen		: '(';
RightParen		: ')';
LeftBracket		: '[';
RightBracket	: ']';
Comma			: ',';
Semicolon		: ';';
Colon			: ':';
Asterisk		: '*';
Equal			: '=';
Period			: '.';
NamedArgument	: ':=';

//
// OPERATORS (§4.1.3)
//

// this rule does not allow + or - at the end of a multi-character operator
Operator
	:	(	OperatorCharacter
		|	(	'+'
			|	'-' {_input.LA(1) != '-'}?
			)+
			(	OperatorCharacter
			|	'/' {_input.LA(1) != '*'}?
			)
		|	'/' {_input.LA(1) != '*'}?
		)+
	|	// special handling for the single-character operators + and -
		[+-]
	;

/* This rule handles operators which end with + or -, and sets the token type to Operator. It is comprised of four
 * parts, in order:
 *
 *   1. A prefix, which does not contain a character from the required set which allows + or - to appear at the end of
 *      the operator.
 *   2. A character from the required set which allows + or - to appear at the end of the operator.
 *   3. An optional sub-token which takes the form of an operator which does not include a + or - at the end of the
 *      sub-token.
 *   4. A suffix sequence of + and - characters.
 */
OperatorEndingWithPlusMinus
	:	(	OperatorCharacterNotAllowPlusMinusAtEnd
		|	'-' {_input.LA(1) != '-'}?
		|	'/' {_input.LA(1) != '*'}?
		)*
		OperatorCharacterAllowPlusMinusAtEnd
		Operator?
		(	'+'
		|	'-' {_input.LA(1) != '-'}?
		)+
		-> type(Operator)
	;

// Each of the following fragment rules omits the +, -, and / characters, which must always be handled in a special way
// by the operator rules above.

fragment
OperatorCharacter
	:	[*<>=~!@#%^&|`?]
	;

// these are the operator characters that don't count towards one ending with + or -
fragment
OperatorCharacterNotAllowPlusMinusAtEnd
	:	[*<>=+]
	;

// an operator may end with + or - if it contains one of these characters
fragment
OperatorCharacterAllowPlusMinusAtEnd
	:	[~!@#%^&|`?]
	;

//
// KEYWORDS (Appendix C)
//

//
// reserved keywords
//
ALL					: [Aa][Ll][Ll];
ANALYSE				: [Aa][Nn][Aa][Ll][Yy][Ss][Ee];
ANALYZE				: [Aa][Nn][Aa][Ll][Yy][Zz][Ee];
AND					: [Aa][Nn][Dd];
ANY					: [Aa][Nn][Yy];
ARRAY				: [Aa][Rr][Rr][Aa][Yy];
AS					: [Aa][Ss];
ASC					: [Aa][Ss][Cc];
ASYMMETRIC			: [Aa][Ss][Yy][Mm][Mm][Ee][Tt][Rr][Ii][Cc];
BOTH				: [Bb][Oo][Tt][Hh];
CASE				: [Cc][Aa][Ss][Ee];
CAST				: [Cc][Aa][Ss][Tt];
CHECK				: [Cc][Hh][Ee][Cc][Kk];
COLLATE				: [Cc][Oo][Ll][Ll][Aa][Tt][Ee];
COLUMN				: [Cc][Oo][Ll][Uu][Mm][Nn];
CONSTRAINT			: [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt];
CREATE				: [Cc][Rr][Ee][Aa][Tt][Ee];
CURRENT_CATALOG		: [Cc][Uu][Rr][Rr][Ee][Nn][Tt][_][Cc][Aa][Tt][Aa][Ll][Oo][Gg];
CURRENT_DATE		: [Cc][Uu][Rr][Rr][Ee][Nn][Tt][_][Dd][Aa][Tt][Ee];
CURRENT_ROLE		: [Cc][Uu][Rr][Rr][Ee][Nn][Tt][_][Rr][Oo][Ll][Ee];
CURRENT_TIME		: [Cc][Uu][Rr][Rr][Ee][Nn][Tt][_][Tt][Ii][Mm][Ee];
CURRENT_TIMESTAMP	: [Cc][Uu][Rr][Rr][Ee][Nn][Tt][_][Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp];
CURRENT_USER		: [Cc][Uu][Rr][Rr][Ee][Nn][Tt][_][Uu][Ss][Ee][Rr];
DEFAULT				: [Dd][Ee][Ff][Aa][Uu][Ll][Tt];
DEFERRABLE			: [Dd][Ee][Ff][Ee][Rr][Rr][Aa][Bb][Ll][Ee];
DESC				: [Dd][Ee][Ss][Cc];
DISTINCT			: [Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt];
DO					: [Dd][Oo];
ELSE				: [Ee][Ll][Ss][Ee];
END					: [Ee][Nn][Dd];
EXCEPT				: [Ee][Xx][Cc][Ee][Pp][Tt];
FALSE				: [Ff][Aa][Ll][Ss][Ee];
FETCH				: [Ff][Ee][Tt][Cc][Hh];
FOR					: [Ff][Oo][Rr];
FOREIGN				: [Ff][Oo][Rr][Ee][Ii][Gg][Nn];
FROM				: [Ff][Rr][Oo][Mm];
GRANT				: [Gg][Rr][Aa][Nn][Tt];
GROUP				: [Gg][Rr][Oo][Uu][Pp];
HAVING				: [Hh][Aa][Vv][Ii][Nn][Gg];
IN					: [Ii][Nn];
INITIALLY			: [Ii][Nn][Ii][Tt][Ii][Aa][Ll][Ll][Yy];
INTERSECT			: [Ii][Nn][Tt][Ee][Rr][Ss][Ee][Cc][Tt];
INTO				: [Ii][Nn][Tt][Oo];
LATERAL				: [Ll][Aa][Tt][Ee][Rr][Aa][Ll];
LEADING				: [Ll][Ee][Aa][Dd][Ii][Nn][Gg];
LIMIT				: [Ll][Ii][Mm][Ii][Tt];
LOCALTIME			: [Ll][Oo][Cc][Aa][Ll][Tt][Ii][Mm][Ee];
LOCALTIMESTAMP		: [Ll][Oo][Cc][Aa][Ll][Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp];
NOT					: [Nn][Oo][Tt];
NULL				: [Nn][Uu][Ll][Ll];
OFFSET				: [Oo][Ff][Ff][Ss][Ee][Tt];
ON					: [Oo][Nn];
ONLY				: [Oo][Nn][Ll][Yy];
OR					: [Oo][Rr];
ORDER				: [Oo][Rr][Dd][Ee][Rr];
PLACING				: [Pp][Ll][Aa][Cc][Ii][Nn][Gg];
PRIMARY				: [Pp][Rr][Ii][Mm][Aa][Rr][Yy];
REFERENCES			: [Rr][Ee][Ff][Ee][Rr][Ee][Nn][Cc][Ee][Ss];
RETURNING			: [Rr][Ee][Tt][Uu][Rr][Nn][Ii][Nn][Gg];
SELECT				: [Ss][Ee][Ll][Ee][Cc][Tt];
SESSION_USER		: [Ss][Ee][Ss][Ss][Ii][Oo][Nn][_][Uu][Ss][Ee][Rr];
SOME				: [Ss][Oo][Mm][Ee];
SYMMETRIC			: [Ss][Yy][Mm][Mm][Ee][Tt][Rr][Ii][Cc];
TABLE				: [Tt][Aa][Bb][Ll][Ee];
THEN				: [Tt][Hh][Ee][Nn];
TO					: [Tt][Oo];
TRAILING			: [Tt][Rr][Aa][Ii][Ll][Ii][Nn][Gg];
TRUE				: [Tt][Rr][Uu][Ee];
UNION				: [Uu][Nn][Ii][Oo][Nn];
UNIQUE				: [Uu][Nn][Ii][Qq][Uu][Ee];
USER				: [Uu][Ss][Ee][Rr];
USING				: [Uu][Ss][Ii][Nn][Gg];
VARIADIC			: [Vv][Aa][Rr][Ii][Aa][Dd][Ii][Cc];
WHEN				: [Ww][Hh][Ee][Nn];
WHERE				: [Ww][Hh][Ee][Rr][Ee];
WINDOW				: [Ww][Ii][Nn][Dd][Oo][Ww];
WITH				: [Ww][Ii][Tt][Hh];

//
// reserved keywords (can be function or type)
//
AUTHORIZATION		: [Aa][Uu][Tt][Hh][Oo][Rr][Ii][Zz][Aa][Tt][Ii][Oo][Nn];
BINARY				: [Bb][Ii][Nn][Aa][Rr][Yy];
COLLATION			: [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn];
CONCURRENTLY		: [Cc][Oo][Nn][Cc][Uu][Rr][Rr][Ee][Nn][Tt][Ll][Yy];
CROSS				: [Cc][Rr][Oo][Ss][Ss];
CURRENT_SCHEMA		: [Cc][Uu][Rr][Rr][Ee][Nn][Tt][_][Ss][Cc][Hh][Ee][Mm][Aa];
FREEZE				: [Ff][Rr][Ee][Ee][Zz][Ee];
FULL				: [Ff][Uu][Ll][Ll];
ILIKE				: [Ii][Ll][Ii][Kk][Ee];
INNER				: [Ii][Nn][Nn][Ee][Rr];
IS					: [Ii][Ss];
ISNULL				: [Ii][Ss][Nn][Uu][Ll][Ll];
JOIN				: [Jj][Oo][Ii][Nn];
LEFT				: [Ll][Ee][Ff][Tt];
LIKE				: [Ll][Ii][Kk][Ee];
NATURAL				: [Nn][Aa][Tt][Uu][Rr][Aa][Ll];
NOTNULL				: [Nn][Oo][Tt][Nn][Uu][Ll][Ll];
OUTER				: [Oo][Uu][Tt][Ee][Rr];
OVER				: [Oo][Vv][Ee][Rr];
OVERLAPS			: [Oo][Vv][Ee][Rr][Ll][Aa][Pp][Ss];
RIGHT				: [Rr][Ii][Gg][Hh][Tt];
SIMILAR				: [Ss][Ii][Mm][Ii][Ll][Aa][Rr];
VERBOSE				: [Vv][Ee][Rr][Bb][Oo][Ss][Ee];

//
// non-reserved keywords
//
ABORT				: [Aa][Bb][Oo][Rr][Tt];
ABSOLUTE			: [Aa][Bb][Ss][Oo][Ll][Uu][Tt][Ee];
ACCESS				: [Aa][Cc][Cc][Ee][Ss][Ss];
ACTION				: [Aa][Cc][Tt][Ii][Oo][Nn];
ADD					: [Aa][Dd][Dd];
ADMIN				: [Aa][Dd][Mm][Ii][Nn];
AFTER				: [Aa][Ff][Tt][Ee][Rr];
AGGREGATE			: [Aa][Gg][Gg][Rr][Ee][Gg][Aa][Tt][Ee];
ALSO				: [Aa][Ll][Ss][Oo];
ALTER				: [Aa][Ll][Tt][Ee][Rr];
ALWAYS				: [Aa][Ll][Ww][Aa][Yy][Ss];
ASSERTION			: [Aa][Ss][Ss][Ee][Rr][Tt][Ii][Oo][Nn];
ASSIGNMENT			: [Aa][Ss][Ss][Ii][Gg][Nn][Mm][Ee][Nn][Tt];
AT					: [Aa][Tt];
ATTRIBUTE			: [Aa][Tt][Tt][Rr][Ii][Bb][Uu][Tt][Ee];
BACKWARD			: [Bb][Aa][Cc][Kk][Ww][Aa][Rr][Dd];
BEFORE				: [Bb][Ee][Ff][Oo][Rr][Ee];
BEGIN				: [Bb][Ee][Gg][Ii][Nn];
BY					: [Bb][Yy];
CACHE				: [Cc][Aa][Cc][Hh][Ee];
CALLED				: [Cc][Aa][Ll][Ll][Ee][Dd];
CASCADE				: [Cc][Aa][Ss][Cc][Aa][Dd][Ee];
CASCADED			: [Cc][Aa][Ss][Cc][Aa][Dd][Ee][Dd];
CATALOG				: [Cc][Aa][Tt][Aa][Ll][Oo][Gg];
CHAIN				: [Cc][Hh][Aa][Ii][Nn];
CHARACTERISTICS		: [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr][Ii][Ss][Tt][Ii][Cc][Ss];
CHECKPOINT			: [Cc][Hh][Ee][Cc][Kk][Pp][Oo][Ii][Nn][Tt];
CLASS				: [Cc][Ll][Aa][Ss][Ss];
CLOSE				: [Cc][Ll][Oo][Ss][Ee];
CLUSTER				: [Cc][Ll][Uu][Ss][Tt][Ee][Rr];
COMMENT				: [Cc][Oo][Mm][Mm][Ee][Nn][Tt];
COMMENTS			: [Cc][Oo][Mm][Mm][Ee][Nn][Tt][Ss];
COMMIT				: [Cc][Oo][Mm][Mm][Ii][Tt];
COMMITTED			: [Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd];
CONFIGURATION		: [Cc][Oo][Nn][Ff][Ii][Gg][Uu][Rr][Aa][Tt][Ii][Oo][Nn];
CONNECTION			: [Cc][Oo][Nn][Nn][Ee][Cc][Tt][Ii][Oo][Nn];
CONSTRAINTS			: [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt][Ss];
CONTENT				: [Cc][Oo][Nn][Tt][Ee][Nn][Tt];
CONTINUE			: [Cc][Oo][Nn][Tt][Ii][Nn][Uu][Ee];
CONVERSION			: [Cc][Oo][Nn][Vv][Ee][Rr][Ss][Ii][Oo][Nn];
COPY				: [Cc][Oo][Pp][Yy];
COST				: [Cc][Oo][Ss][Tt];
CSV					: [Cc][Ss][Vv];
CURRENT				: [Cc][Uu][Rr][Rr][Ee][Nn][Tt];
CURSOR				: [Cc][Uu][Rr][Ss][Oo][Rr];
CYCLE				: [Cc][Yy][Cc][Ll][Ee];
DATA				: [Dd][Aa][Tt][Aa];
DATABASE			: [Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee];
DAY					: [Dd][Aa][Yy];
DEALLOCATE			: [Dd][Ee][Aa][Ll][Ll][Oo][Cc][Aa][Tt][Ee];
DECLARE				: [Dd][Ee][Cc][Ll][Aa][Rr][Ee];
DEFAULTS			: [Dd][Ee][Ff][Aa][Uu][Ll][Tt][Ss];
DEFERRED			: [Dd][Ee][Ff][Ee][Rr][Rr][Ee][Dd];
DEFINER				: [Dd][Ee][Ff][Ii][Nn][Ee][Rr];
DELETE				: [Dd][Ee][Ll][Ee][Tt][Ee];
DELIMITER			: [Dd][Ee][Ll][Ii][Mm][Ii][Tt][Ee][Rr];
DELIMITERS			: [Dd][Ee][Ll][Ii][Mm][Ii][Tt][Ee][Rr][Ss];
DICTIONARY			: [Dd][Ii][Cc][Tt][Ii][Oo][Nn][Aa][Rr][Yy];
DISABLE				: [Dd][Ii][Ss][Aa][Bb][Ll][Ee];
DISCARD				: [Dd][Ii][Ss][Cc][Aa][Rr][Dd];
DOCUMENT			: [Dd][Oo][Cc][Uu][Mm][Ee][Nn][Tt];
DOMAIN				: [Dd][Oo][Mm][Aa][Ii][Nn];
DOUBLE				: [Dd][Oo][Uu][Bb][Ll][Ee];
DROP				: [Dd][Rr][Oo][Pp];
EACH				: [Ee][Aa][Cc][Hh];
ENABLE				: [Ee][Nn][Aa][Bb][Ll][Ee];
ENCODING			: [Ee][Nn][Cc][Oo][Dd][Ii][Nn][Gg];
ENCRYPTED			: [Ee][Nn][Cc][Rr][Yy][Pp][Tt][Ee][Dd];
ENUM				: [Ee][Nn][Uu][Mm];
ESCAPE				: [Ee][Ss][Cc][Aa][Pp][Ee];
EVENT				: [Ee][Vv][Ee][Nn][Tt];
EXCLUDE				: [Ee][Xx][Cc][Ll][Uu][Dd][Ee];
EXCLUDING			: [Ee][Xx][Cc][Ll][Uu][Dd][Ii][Nn][Gg];
EXCLUSIVE			: [Ee][Xx][Cc][Ll][Uu][Ss][Ii][Vv][Ee];
EXECUTE				: [Ee][Xx][Ee][Cc][Uu][Tt][Ee];
EXPLAIN				: [Ee][Xx][Pp][Ll][Aa][Ii][Nn];
EXTENSION			: [Ee][Xx][Tt][Ee][Nn][Ss][Ii][Oo][Nn];
EXTERNAL			: [Ee][Xx][Tt][Ee][Rr][Nn][Aa][Ll];
FAMILY				: [Ff][Aa][Mm][Ii][Ll][Yy];
FIRST				: [Ff][Ii][Rr][Ss][Tt];
FOLLOWING			: [Ff][Oo][Ll][Ll][Oo][Ww][Ii][Nn][Gg];
FORCE				: [Ff][Oo][Rr][Cc][Ee];
FORWARD				: [Ff][Oo][Rr][Ww][Aa][Rr][Dd];
FUNCTION			: [Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn];
FUNCTIONS			: [Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn][Ss];
GLOBAL				: [Gg][Ll][Oo][Bb][Aa][Ll];
GRANTED				: [Gg][Rr][Aa][Nn][Tt][Ee][Dd];
HANDLER				: [Hh][Aa][Nn][Dd][Ll][Ee][Rr];
HEADER				: [Hh][Ee][Aa][Dd][Ee][Rr];
HOLD				: [Hh][Oo][Ll][Dd];
HOUR				: [Hh][Oo][Uu][Rr];
IDENTITY			: [Ii][Dd][Ee][Nn][Tt][Ii][Tt][Yy];
IF					: [Ii][Ff];
IMMEDIATE			: [Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee];
IMMUTABLE			: [Ii][Mm][Mm][Uu][Tt][Aa][Bb][Ll][Ee];
IMPLICIT			: [Ii][Mm][Pp][Ll][Ii][Cc][Ii][Tt];
INCLUDING			: [Ii][Nn][Cc][Ll][Uu][Dd][Ii][Nn][Gg];
INCREMENT			: [Ii][Nn][Cc][Rr][Ee][Mm][Ee][Nn][Tt];
INDEX				: [Ii][Nn][Dd][Ee][Xx];
INDEXES				: [Ii][Nn][Dd][Ee][Xx][Ee][Ss];
INHERIT				: [Ii][Nn][Hh][Ee][Rr][Ii][Tt];
INHERITS			: [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss];
INLINE				: [Ii][Nn][Ll][Ii][Nn][Ee];
INPUT				: [Ii][Nn][Pp][Uu][Tt];
INSENSITIVE			: [Ii][Nn][Ss][Ee][Nn][Ss][Ii][Tt][Ii][Vv][Ee];
INSERT				: [Ii][Nn][Ss][Ee][Rr][Tt];
INSTEAD				: [Ii][Nn][Ss][Tt][Ee][Aa][Dd];
INVOKER				: [Ii][Nn][Vv][Oo][Kk][Ee][Rr];
ISOLATION			: [Ii][Ss][Oo][Ll][Aa][Tt][Ii][Oo][Nn];
KEY					: [Kk][Ee][Yy];
LABEL				: [Ll][Aa][Bb][Ee][Ll];
LANGUAGE			: [Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee];
LARGE				: [Ll][Aa][Rr][Gg][Ee];
LAST				: [Ll][Aa][Ss][Tt];
LC_COLLATE			: [Ll][Cc][_][Cc][Oo][Ll][Ll][Aa][Tt][Ee];
LC_CTYPE			: [Ll][Cc][_][Cc][Tt][Yy][Pp][Ee];
LEAKPROOF			: [Ll][Ee][Aa][Kk][Pp][Rr][Oo][Oo][Ff];
LEVEL				: [Ll][Ee][Vv][Ee][Ll];
LISTEN				: [Ll][Ii][Ss][Tt][Ee][Nn];
LOAD				: [Ll][Oo][Aa][Dd];
LOCAL				: [Ll][Oo][Cc][Aa][Ll];
LOCATION			: [Ll][Oo][Cc][Aa][Tt][Ii][Oo][Nn];
LOCK				: [Ll][Oo][Cc][Kk];
MAPPING				: [Mm][Aa][Pp][Pp][Ii][Nn][Gg];
MATCH				: [Mm][Aa][Tt][Cc][Hh];
MATERIALIZED		: [Mm][Aa][Tt][Ee][Rr][Ii][Aa][Ll][Ii][Zz][Ee][Dd];
MAXVALUE			: [Mm][Aa][Xx][Vv][Aa][Ll][Uu][Ee];
MINUTE				: [Mm][Ii][Nn][Uu][Tt][Ee];
MINVALUE			: [Mm][Ii][Nn][Vv][Aa][Ll][Uu][Ee];
MODE				: [Mm][Oo][Dd][Ee];
MONTH				: [Mm][Oo][Nn][Tt][Hh];
MOVE				: [Mm][Oo][Vv][Ee];
NAME				: [Nn][Aa][Mm][Ee];
NAMES				: [Nn][Aa][Mm][Ee][Ss];
NEXT				: [Nn][Ee][Xx][Tt];
NO					: [Nn][Oo];
NOTHING				: [Nn][Oo][Tt][Hh][Ii][Nn][Gg];
NOTIFY				: [Nn][Oo][Tt][Ii][Ff][Yy];
NOWAIT				: [Nn][Oo][Ww][Aa][Ii][Tt];
NULLS				: [Nn][Uu][Ll][Ll][Ss];
OBJECT				: [Oo][Bb][Jj][Ee][Cc][Tt];
OF					: [Oo][Ff];
OFF					: [Oo][Ff][Ff];
OIDS				: [Oo][Ii][Dd][Ss];
OPERATOR			: [Oo][Pp][Ee][Rr][Aa][Tt][Oo][Rr];
OPTION				: [Oo][Pp][Tt][Ii][Oo][Nn];
OPTIONS				: [Oo][Pp][Tt][Ii][Oo][Nn][Ss];
OWNED				: [Oo][Ww][Nn][Ee][Dd];
OWNER				: [Oo][Ww][Nn][Ee][Rr];
PARSER				: [Pp][Aa][Rr][Ss][Ee][Rr];
PARTIAL				: [Pp][Aa][Rr][Tt][Ii][Aa][Ll];
PARTITION			: [Pp][Aa][Rr][Tt][Ii][Tt][Ii][Oo][Nn];
PASSING				: [Pp][Aa][Ss][Ss][Ii][Nn][Gg];
PASSWORD			: [Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd];
PLANS				: [Pp][Ll][Aa][Nn][Ss];
PRECEDING			: [Pp][Rr][Ee][Cc][Ee][Dd][Ii][Nn][Gg];
PREPARE				: [Pp][Rr][Ee][Pp][Aa][Rr][Ee];
PREPARED			: [Pp][Rr][Ee][Pp][Aa][Rr][Ee][Dd];
PRESERVE			: [Pp][Rr][Ee][Ss][Ee][Rr][Vv][Ee];
PRIOR				: [Pp][Rr][Ii][Oo][Rr];
PRIVILEGES			: [Pp][Rr][Ii][Vv][Ii][Ll][Ee][Gg][Ee][Ss];
PROCEDURAL			: [Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Aa][Ll];
PROCEDURE			: [Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee];
PROGRAM				: [Pp][Rr][Oo][Gg][Rr][Aa][Mm];
QUOTE				: [Qq][Uu][Oo][Tt][Ee];
RANGE				: [Rr][Aa][Nn][Gg][Ee];
READ				: [Rr][Ee][Aa][Dd];
REASSIGN			: [Rr][Ee][Aa][Ss][Ss][Ii][Gg][Nn];
RECHECK				: [Rr][Ee][Cc][Hh][Ee][Cc][Kk];
RECURSIVE			: [Rr][Ee][Cc][Uu][Rr][Ss][Ii][Vv][Ee];
REF					: [Rr][Ee][Ff];
REFRESH				: [Rr][Ee][Ff][Rr][Ee][Ss][Hh];
REINDEX				: [Rr][Ee][Ii][Nn][Dd][Ee][Xx];
RELATIVE			: [Rr][Ee][Ll][Aa][Tt][Ii][Vv][Ee];
RELEASE				: [Rr][Ee][Ll][Ee][Aa][Ss][Ee];
RENAME				: [Rr][Ee][Nn][Aa][Mm][Ee];
REPEATABLE			: [Rr][Ee][Pp][Ee][Aa][Tt][Aa][Bb][Ll][Ee];
REPLACE				: [Rr][Ee][Pp][Ll][Aa][Cc][Ee];
REPLICA				: [Rr][Ee][Pp][Ll][Ii][Cc][Aa];
RESET				: [Rr][Ee][Ss][Ee][Tt];
RESTART				: [Rr][Ee][Ss][Tt][Aa][Rr][Tt];
RESTRICT			: [Rr][Ee][Ss][Tt][Rr][Ii][Cc][Tt];
RETURNS				: [Rr][Ee][Tt][Uu][Rr][Nn][Ss];
REVOKE				: [Rr][Ee][Vv][Oo][Kk][Ee];
ROLE				: [Rr][Oo][Ll][Ee];
ROLLBACK			: [Rr][Oo][Ll][Ll][Bb][Aa][Cc][Kk];
ROWS				: [Rr][Oo][Ww][Ss];
RULE				: [Rr][Uu][Ll][Ee];
SAVEPOINT			: [Ss][Aa][Vv][Ee][Pp][Oo][Ii][Nn][Tt];
SCHEMA				: [Ss][Cc][Hh][Ee][Mm][Aa];
SCROLL				: [Ss][Cc][Rr][Oo][Ll][Ll];
SEARCH				: [Ss][Ee][Aa][Rr][Cc][Hh];
SECOND				: [Ss][Ee][Cc][Oo][Nn][Dd];
SECURITY			: [Ss][Ee][Cc][Uu][Rr][Ii][Tt][Yy];
SEQUENCE			: [Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee];
SEQUENCES			: [Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee][Ss];
SERIALIZABLE		: [Ss][Ee][Rr][Ii][Aa][Ll][Ii][Zz][Aa][Bb][Ll][Ee];
SERVER				: [Ss][Ee][Rr][Vv][Ee][Rr];
SESSION				: [Ss][Ee][Ss][Ss][Ii][Oo][Nn];
SET					: [Ss][Ee][Tt];
SHARE				: [Ss][Hh][Aa][Rr][Ee];
SHOW				: [Ss][Hh][Oo][Ww];
SIMPLE				: [Ss][Ii][Mm][Pp][Ll][Ee];
SNAPSHOT			: [Ss][Nn][Aa][Pp][Ss][Hh][Oo][Tt];
STABLE				: [Ss][Tt][Aa][Bb][Ll][Ee];
STANDALONE			: [Ss][Tt][Aa][Nn][Dd][Aa][Ll][Oo][Nn][Ee];
START				: [Ss][Tt][Aa][Rr][Tt];
STATEMENT			: [Ss][Tt][Aa][Tt][Ee][Mm][Ee][Nn][Tt];
STATISTICS			: [Ss][Tt][Aa][Tt][Ii][Ss][Tt][Ii][Cc][Ss];
STDIN				: [Ss][Tt][Dd][Ii][Nn];
STDOUT				: [Ss][Tt][Dd][Oo][Uu][Tt];
STORAGE				: [Ss][Tt][Oo][Rr][Aa][Gg][Ee];
STRICT				: [Ss][Tt][Rr][Ii][Cc][Tt];
STRIP				: [Ss][Tt][Rr][Ii][Pp];
SYSID				: [Ss][Yy][Ss][Ii][Dd];
SYSTEM				: [Ss][Yy][Ss][Tt][Ee][Mm];
TABLES				: [Tt][Aa][Bb][Ll][Ee][Ss];
TABLESPACE			: [Tt][Aa][Bb][Ll][Ee][Ss][Pp][Aa][Cc][Ee];
TEMP				: [Tt][Ee][Mm][Pp];
TEMPLATE			: [Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee];
TEMPORARY			: [Tt][Ee][Mm][Pp][Oo][Rr][Aa][Rr][Yy];
TEXT				: [Tt][Ee][Xx][Tt];
TRANSACTION			: [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn];
TRIGGER				: [Tt][Rr][Ii][Gg][Gg][Ee][Rr];
TRUNCATE			: [Tt][Rr][Uu][Nn][Cc][Aa][Tt][Ee];
TRUSTED				: [Tt][Rr][Uu][Ss][Tt][Ee][Dd];
TYPE				: [Tt][Yy][Pp][Ee];
TYPES				: [Tt][Yy][Pp][Ee][Ss];
UNBOUNDED			: [Uu][Nn][Bb][Oo][Uu][Nn][Dd][Ee][Dd];
UNCOMMITTED			: [Uu][Nn][Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd];
UNENCRYPTED			: [Uu][Nn][Ee][Nn][Cc][Rr][Yy][Pp][Tt][Ee][Dd];
UNKNOWN				: [Uu][Nn][Kk][Nn][Oo][Ww][Nn];
UNLISTEN			: [Uu][Nn][Ll][Ii][Ss][Tt][Ee][Nn];
UNLOGGED			: [Uu][Nn][Ll][Oo][Gg][Gg][Ee][Dd];
UNTIL				: [Uu][Nn][Tt][Ii][Ll];
UPDATE				: [Uu][Pp][Dd][Aa][Tt][Ee];
VACUUM				: [Vv][Aa][Cc][Uu][Uu][Mm];
VALID				: [Vv][Aa][Ll][Ii][Dd];
VALIDATE			: [Vv][Aa][Ll][Ii][Dd][Aa][Tt][Ee];
VALIDATOR			: [Vv][Aa][Ll][Ii][Dd][Aa][Tt][Oo][Rr];
VALUE				: [Vv][Aa][Ll][Uu][Ee];
VARYING				: [Vv][Aa][Rr][Yy][Ii][Nn][Gg];
VERSION				: [Vv][Ee][Rr][Ss][Ii][Oo][Nn];
VIEW				: [Vv][Ii][Ee][Ww];
VOLATILE			: [Vv][Oo][Ll][Aa][Tt][Ii][Ll][Ee];
WHITESPACE			: [Ww][Hh][Ii][Tt][Ee][Ss][Pp][Aa][Cc][Ee];
WITHOUT				: [Ww][Ii][Tt][Hh][Oo][Uu][Tt];
WORK				: [Ww][Oo][Rr][Kk];
WRAPPER				: [Ww][Rr][Aa][Pp][Pp][Ee][Rr];
WRITE				: [Ww][Rr][Ii][Tt][Ee];
XML					: [Xx][Mm][Ll];
YEAR				: [Yy][Ee][Aa][Rr];
YES					: [Yy][Ee][Ss];
ZONE				: [Zz][Oo][Nn][Ee];

//
// non-reserved keywords (cannot be function or type)
//
BETWEEN				: [Bb][Ee][Tt][Ww][Ee][Ee][Nn];
BIGINT				: [Bb][Ii][Gg][Ii][Nn][Tt];
BIT					: [Bb][Ii][Tt];
BOOLEAN				: [Bb][Oo][Oo][Ll][Ee][Aa][Nn];
CHAR				: [Cc][Hh][Aa][Rr];
CHARACTER			: [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr];
COALESCE			: [Cc][Oo][Aa][Ll][Ee][Ss][Cc][Ee];
DEC					: [Dd][Ee][Cc];
DECIMAL				: [Dd][Ee][Cc][Ii][Mm][Aa][Ll];
EXISTS				: [Ee][Xx][Ii][Ss][Tt][Ss];
EXTRACT				: [Ee][Xx][Tt][Rr][Aa][Cc][Tt];
FLOAT				: [Ff][Ll][Oo][Aa][Tt];
GREATEST			: [Gg][Rr][Ee][Aa][Tt][Ee][Ss][Tt];
INOUT				: [Ii][Nn][Oo][Uu][Tt];
INT					: [Ii][Nn][Tt];
INTEGER				: [Ii][Nn][Tt][Ee][Gg][Ee][Rr];
INTERVAL			: [Ii][Nn][Tt][Ee][Rr][Vv][Aa][Ll];
LEAST				: [Ll][Ee][Aa][Ss][Tt];
NATIONAL			: [Nn][Aa][Tt][Ii][Oo][Nn][Aa][Ll];
NCHAR				: [Nn][Cc][Hh][Aa][Rr];
NONE				: [Nn][Oo][Nn][Ee];
NULLIF				: [Nn][Uu][Ll][Ll][Ii][Ff];
NUMERIC				: [Nn][Uu][Mm][Ee][Rr][Ii][Cc];
OUT					: [Oo][Uu][Tt];
OVERLAY				: [Oo][Vv][Ee][Rr][Ll][Aa][Yy];
POSITION			: [Pp][Oo][Ss][Ii][Tt][Ii][Oo][Nn];
PRECISION			: [Pp][Rr][Ee][Cc][Ii][Ss][Ii][Oo][Nn];
REAL				: [Rr][Ee][Aa][Ll];
ROW					: [Rr][Oo][Ww];
SETOF				: [Ss][Ee][Tt][Oo][Ff];
SMALLINT			: [Ss][Mm][Aa][Ll][Ll][Ii][Nn][Tt];
SUBSTRING			: [Ss][Uu][Bb][Ss][Tt][Rr][Ii][Nn][Gg];
TIME				: [Tt][Ii][Mm][Ee];
TIMESTAMP			: [Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp];
TREAT				: [Tt][Rr][Ee][Aa][Tt];
TRIM				: [Tt][Rr][Ii][Mm];
VALUES				: [Vv][Aa][Ll][Uu][Ee][Ss];
VARCHAR				: [Vv][Aa][Rr][Cc][Hh][Aa][Rr];
XMLATTRIBUTES		: [Xx][Mm][Ll][Aa][Tt][Tt][Rr][Ii][Bb][Uu][Tt][Ee][Ss];
XMLCONCAT			: [Xx][Mm][Ll][Cc][Oo][Nn][Cc][Aa][Tt];
XMLELEMENT			: [Xx][Mm][Ll][Ee][Ll][Ee][Mm][Ee][Nn][Tt];
XMLEXISTS			: [Xx][Mm][Ll][Ee][Xx][Ii][Ss][Tt][Ss];
XMLFOREST			: [Xx][Mm][Ll][Ff][Oo][Rr][Ee][Ss][Tt];
XMLPARSE			: [Xx][Mm][Ll][Pp][Aa][Rr][Ss][Ee];
XMLPI				: [Xx][Mm][Ll][Pp][Ii];
XMLROOT				: [Xx][Mm][Ll][Rr][Oo][Oo][Tt];
XMLSERIALIZE		: [Xx][Mm][Ll][Ss][Ee][Rr][Ii][Aa][Ll][Ii][Zz][Ee];

//
// IDENTIFIERS (§4.1.1)
//

Identifier
	:	IdentifierStartChar IdentifierChar*
	;

fragment
IdentifierStartChar
	:	// these are the valid identifier start characters below 0x7F
		[a-zA-Z_]
	|	// these are the valid characters from 0x80 to 0xFF
		[\u00AA\u00B5\u00BA\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF]
	|	// these are the letters above 0xFF which only need a single UTF-16 code unit
		[\u0100-\uD7FF\uE000-\uFFFF] {Character.isLetter((char)_input.LA(-1))}?
	|	// letters which require multiple UTF-16 code units
		[\uD800-\uDBFF] [\uDC00-\uDFFF] {Character.isLetter(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
	;

fragment
IdentifierChar
	:	StrictIdentifierChar
	|	'$'
	;

fragment
StrictIdentifierChar
	:	IdentifierStartChar
	|	[0-9]
	;

/* Quoted Identifiers
 *
 *   These are divided into four separate tokens, allowing distinction of valid quoted identifiers from invalid quoted
 *   identifiers without sacrificing the ability of the lexer to reliably recover from lexical errors in the input.
 */

QuotedIdentifier
	:	UnterminatedQuotedIdentifier '"'
	;

// This is a quoted identifier which only contains valid characters but is not terminated
UnterminatedQuotedIdentifier
	:	'"'
		(	'""'
		|	~[\u0000"]
		)*
	;

// This is a quoted identifier which is terminated but contains a \u0000 character
InvalidQuotedIdentifier
	:	InvalidUnterminatedQuotedIdentifier '"'
	;

// This is a quoted identifier which is unterminated and contains a \u0000 character
InvalidUnterminatedQuotedIdentifier
	:	'"'
		(	'""'
		|	~'"'
		)*
	;

/* Unicode Quoted Identifiers
 *
 *   These are divided into four separate tokens, allowing distinction of valid Unicode quoted identifiers from invalid
 *   Unicode quoted identifiers without sacrificing the ability of the lexer to reliably recover from lexical errors in
 *   the input. Note that escape sequences are never checked as part of this determination due to the ability of users
 *   to change the escape character with a UESCAPE clause following the Unicode quoted identifier.
 *
 * TODO: these rules assume "" is still a valid escape sequence within a Unicode quoted identifier.
 */

UnicodeQuotedIdentifier
	:	[Uu] '&'  QuotedIdentifier
	;

// This is a Unicode quoted identifier which only contains valid characters but is not terminated
UnterminatedUnicodeQuotedIdentifier
	:	[Uu] '&'  UnterminatedQuotedIdentifier
	;

// This is a Unicode quoted identifier which is terminated but contains a \u0000 character
InvalidUnicodeQuotedIdentifier
	:	[Uu] '&'  InvalidQuotedIdentifier
	;

// This is a Unicode quoted identifier which is unterminated and contains a \u0000 character
InvalidUnterminatedUnicodeQuotedIdentifier
	:	[Uu] '&'  InvalidUnterminatedQuotedIdentifier
	;

//
// CONSTANTS (§4.1.2)
//

// String Constants (§4.1.2.1)
StringConstant
	:	UnterminatedStringConstant '\''
	;

UnterminatedStringConstant
	:	'\''
		(	'\'\''
		|	~'\''
		)*
	;

// String Constants with C-style Escapes (§4.1.2.2)
BeginEscapeStringConstant
	:	[Ee] '\'' -> more, pushMode(EscapeStringConstantMode)
	;

// String Constants with Unicode Escapes (§4.1.2.3)
//
//   Note that escape sequences are never checked as part of this token due to the ability of users to change the escape
//   character with a UESCAPE clause following the Unicode string constant.
//
// TODO: these rules assume '' is still a valid escape sequence within a Unicode string constant.
UnicodeEscapeStringConstant
	:	UnterminatedUnicodeEscapeStringConstant '\''
	;

UnterminatedUnicodeEscapeStringConstant
	:	[Uu] '&' UnterminatedStringConstant
	;

// Dollar-quoted String Constants (§4.1.2.4)
BeginDollarStringConstant
	:	'$' Tag? '$' {_tags.push(getText());}
		-> pushMode(DollarQuotedStringMode)
	;

/* "The tag, if any, of a dollar-quoted string follows the same rules as an
 * unquoted identifier, except that it cannot contain a dollar sign."
 */
fragment
Tag
	:	IdentifierStartChar StrictIdentifierChar*
	;

// Bit-strings Constants (§4.1.2.5)
BinaryStringConstant
	:	UnterminatedBinaryStringConstant '\''
	;

UnterminatedBinaryStringConstant
	:	[Bb] '\'' [01]*
	;

InvalidBinaryStringConstant
	:	InvalidUnterminatedBinaryStringConstant '\''
	;

InvalidUnterminatedBinaryStringConstant
	:	[Bb] UnterminatedStringConstant
	;

HexadecimalStringConstant
	:	UnterminatedHexadecimalStringConstant '\''
	;

UnterminatedHexadecimalStringConstant
	:	[Xx] '\'' [0-9a-fA-F]*
	;

InvalidHexadecimalStringConstant
	:	InvalidUnterminatedHexadecimalStringConstant '\''
	;

InvalidUnterminatedHexadecimalStringConstant
	:	[Xx] UnterminatedStringConstant
	;

// Numeric Constants (§4.1.2.6)
Integral
	:	Digits
	;

Numeric
	:	Digits '.' Digits? ([Ee] [+-]? Digits)?
	|	'.' Digits ([Ee] [+-]? Digits)?
	|	Digits [Ee] [+-]? Digits
	;

fragment
Digits
	:	[0-9]+
	;

//
// WHITESPACE (§4.1?)
//

Whitespace
	:	[ \t]+ -> channel(HIDDEN)
	;

Newline
	:	(	'\r' '\n'?
		|	'\n'
		) -> channel(HIDDEN)
	;

//
// COMMENTS (§4.1.5)
//

LineComment
	:	'--' ~[\r\n]* -> channel(HIDDEN)
	;

BlockComment
	:	(	'/*'
			(	'/'* BlockComment
			|	~[/*]
			|	'/'+ ~[/*]
			|	'*'+ ~[/*]
			)*
			'*'*
			'*/'
		) -> channel(HIDDEN)
	;

UnterminatedBlockComment
	:	'/*'
		(	'/'* BlockComment
		|	// these characters are not part of special sequences in a block comment
			~[/*]
		|	// handle / or * characters which are not part of /* or */ and do not appear at the end of the file
			(	'/'+ ~[/*]
			|	'*'+ ~[/*]
			)
		)*
		// Handle the case of / or * characters at the end of the file, or a nested unterminated block comment
		(	'/'+
		|	'*'+
		|	'/'* UnterminatedBlockComment
		)?
		// Optional assertion to make sure this rule is working as intended
		{assert _input.LA(1) == EOF;}
	;

//
// META-COMMANDS
//

// http://www.postgresql.org/docs/9.3/static/app-psql.html
MetaCommand
	:	'\\'
		(	~[\r\n\\"]
		|	'"' ~[\r\n"]* '"'
		)*
		(	'"' ~[\r\n"]*
		)?
	;

EndMetaCommand
	:	'\\\\'
	;

//
// ERROR
//

// Any character which does not match one of the above rules will appear in the token stream as an ErrorCharacter token.
// This ensures the lexer itself will never encounter a syntax error, so all error handling may be performed by the
// parser.
ErrorCharacter
	:	.
	;

mode EscapeStringConstantMode;

	EscapeStringConstant
		:	EscapeStringText '\'' -> mode(AfterEscapeStringConstantMode)
		;

	UnterminatedEscapeStringConstant
		:	EscapeStringText
			// Handle a final unmatched \ character appearing at the end of the file
			'\\'?
			EOF
		;

	fragment
	EscapeStringText
		:	(	'\'\''
			|	'\\'
				(	// two-digit hex escapes are still valid when treated as single-digit escapes
					'x' [0-9a-fA-F]
				|	'u' [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F]
				|	'U' [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F]
				|	// Any character other than the Unicode escapes can follow a backslash. Some have special meaning,
					// but that doesn't affect the syntax.
					~[xuU]
				)
			|	~['\\]
			)*
		;

	InvalidEscapeStringConstant
		:	InvalidEscapeStringText '\'' -> mode(AfterEscapeStringConstantMode)
		;

	InvalidUnterminatedEscapeStringConstant
		:	InvalidEscapeStringText
			// Handle a final unmatched \ character appearing at the end of the file
			'\\'?
			EOF
		;

	fragment
	InvalidEscapeStringText
		:	(	'\'\''
			|	'\\' .
			|	~['\\]
			)*
		;

mode AfterEscapeStringConstantMode;

	AfterEscapeStringConstantMode_Whitespace
		:	Whitespace -> type(Whitespace), channel(HIDDEN)
		;

	AfterEscapeStringConstantMode_Newline
		:	Newline -> type(Newline), channel(HIDDEN), mode(AfterEscapeStringConstantWithNewlineMode)
		;

	AfterEscapeStringConstantMode_NotContinued
		:	{} // intentionally empty
			-> skip, popMode
		;

mode AfterEscapeStringConstantWithNewlineMode;

	AfterEscapeStringConstantWithNewlineMode_Whitespace
		:	Whitespace -> type(Whitespace), channel(HIDDEN)
		;

	AfterEscapeStringConstantWithNewlineMode_Newline
		:	Newline -> type(Newline), channel(HIDDEN)
		;

	AfterEscapeStringConstantWithNewlineMode_Continued
		:	'\'' -> more, mode(EscapeStringConstantMode)
		;

	AfterEscapeStringConstantWithNewlineMode_NotContinued
		:	{} // intentionally empty
			-> skip, popMode
		;

mode DollarQuotedStringMode;

	Text
		:	~'$'+
		|	// this alternative improves the efficiency of handling $ characters within a dollar-quoted string which are
			// not part of the ending tag.
			'$' ~'$'*
		;

	EndDollarStringConstant
		:	'$' Tag? '$' {getText().equals(_tags.peek())}?
			{_tags.pop();}
			-> popMode
		;
