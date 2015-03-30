https://msdn.microsoft.com/en-us/library/azure/dn834998.aspx

## Data Type

- bigint
Integers in the range -2^63 (-9,223,372,036,854,775,808) to 2^63-1 (9,223,372,036,854,775,807).
- float
Floating point numbers in the range - 1.79E+308 to -2.23E-308, 0, and 2.23E-308 to 1.79E+308.
- nvarchar(max)
Text values, comprised of Unicode characters. Note: A value other than max is not supported.
- datetime
Defines a date that is combined with a time of day with fractional seconds that is based on a 24-hour clock and relative to UTC (time zone offset 0).
- record
Set of name/value pairs. Values must be of supported data type.

## Data Definition Language Statement
CREATE TABLE 

## Data Manipulation Language
SELECT  - FROM - WHERE - GROUP BY - HAVING - CASE - JOIN - UNION - WITH

## Windowing
### Tumbling Window
Tumbling windows are a series of fixed-sized, non-overlapping and contiguous time intervals. The following diagram illustrates a stream with a series of events and how they are mapped into 5-second tumbling windows.

tubling
### Hopping Window
Unlike tumbling windows, hopping windows model scheduled overlapping windows. A hopping window specification consist of two parameters: the window size (how long each window lasts), and the window hop (by how much each window moves forward relative to the previous one). Note that a tumbling window is simply a hopping window whose ‘hop’ is equal to its ‘size’.


```sql

SELECT System.TimeStamp AS OutTime, TollId, COUNT(*) 
FROM Input TIMESTAMP BY EntryTime
GROUP BY TollId, HoppingWindow(minute,10 , 5)

```

### Sliding Window
When using a sliding window, the system is asked to logically consider all possible windows of a given length. As the number of such windows would be infinite, Azure Stream Analytics instead outputs events only for those points in time when the content of the window actually changes, in other words when an event entered or exists the window.

```sql
SELECT DateAdd(minute,-5,System.TimeStamp) AS WinStartTime, System.TimeStamp AS WinEndTime, TollId, COUNT(*) 
FROM Input TIMESTAMP BY EntryTime
GROUP BY TollId, SlidingWindow(minute, 5)
HAVING COUNT(*) > 3
```
## Build-in Functions
### Aggregate Functions
AVG - COUNT - MAX - MIN - STDEVP - STDEV - SUM - VAR- VARP
### Conversion Functions
CAST
### Date and Time Functions
DATEADD - DATEDIFF - DATENAME - DATEPART - DATETIMEFROMPARTS - DAY- MONTH - YEAR
### String Functions
CHARINDEX - CONCAT - LEN - PATINDEX - SUBSTRING

