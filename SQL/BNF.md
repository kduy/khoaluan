
Siddhi: A Second Look at Complex Event Processing Architectures
```sql
QUERY :=STM_NAME( select OUT from STM { [where COND] [ [having COND] [groupby STM_NAME.NAME]]|[PATTERN]
| [sequence(SEQ)]
})
STM :=STM join STM|QUERY|
NAME(IN_NAMES, IN_TYPES [, (STM_PROP)]) STM_PROP:=[time_window|batch_window
|window_length|unique|firstUnique]* PATTERN :=every(COND)|any(COND)|
COND|nonOccurrence (COND)
SEQ :=COND SEQ|star(COND) COND
COND := COND N_OP COND | COND L_OP COND
| STM_NAME.NAME N_OP [VAL|STM_NAME.NAME]
| STM_NAME.NAME L_OP STM_NAME.NAME
OUT :=’*’|NAME=EXP, OUT| NAME=EXP
EXP :=[avg|sum|max|min|count]+(EXP)|NAME| STM_NAME.NAME STM_NAME:=NAME
VAL :=[0_9.]*|true|false
NAME :=[ A_z0_9 ]*
N_OP:=eq|noeq|lt|gt|lteq|gteq
L_OP:=and|or
IN_NAMES:=NAME [,NAME]*, IN_TYPES:=list of types
```