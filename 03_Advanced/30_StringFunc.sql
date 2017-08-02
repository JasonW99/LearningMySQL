SElECT 
	id,
	event_date,
	LEFT(event_date, 10) AS clean_event_date
FROM testDB

/*
id          event_date                      clean_event_date
140099416	01/31/2014 08:00:00 AM +0000	01/31/2014
140092426	01/31/2014 08:00:00 AM +0000	01/31/2014
140092410	01/31/2014 08:00:00 AM +0000	01/31/2014
140092341	01/31/2014 08:00:00 AM +0000	01/31/2014
140092573	01/31/2014 08:00:00 AM +0000	01/31/2014
146027306	01/31/2014 08:00:00 AM +0000	01/31/2014
140092288	01/31/2014 08:00:00 AM +0000	01/31/2014
*/

SElECT 
	id,
	event_date,
	LEFT (event_date, 10) AS clean_event_date,
	RIGHT (event_date, 17) AS clean_event_time
FROM testDB

/*
id          event_date                      clean_event_date      clean_event_time
140099416   01/31/2014 08:00:00 AM +0000	01/31/2014	          08:00:00 AM +0000
140092426	01/31/2014 08:00:00 AM +0000	01/31/2014	          08:00:00 AM +0000
140092410	01/31/2014 08:00:00 AM +0000	01/31/2014	          08:00:00 AM +0000
140092341	01/31/2014 08:00:00 AM +0000	01/31/2014	          08:00:00 AM +0000
140092573	01/31/2014 08:00:00 AM +0000	01/31/2014	          08:00:00 AM +0000
*/

--------- equivalently, we can write --------------------------------------------------
SELECT 
	id,
	event_date,
	LEFT (event_date, 10) AS clean_event_date,
	RIGHT (event_date, LENGTH(event_date) - 11) AS clean_event_time -- 11 = 10 + 1, 1 position for the space
FROM testDB


---------------------------------------------------------------------------------------
/*
The TRIM function is used to remove characters from the beginning and end of a string. Here’s an example:
*/

SELECT location,
    TRIM(both '3()6' FROM location)
FROM testDB

/*
(37.709725805163, -122.413623946206)	7.709725805163, -122.41362394620
(37.7154876086057, -122.47370623066)	7.7154876086057, -122.473706230
(37.7686887134351, -122.435718550322)	7.7686887134351, -122.435718550322
(37.8086250595467, -122.412527239682)	7.8086250595467, -122.412527239682
... ...
... ...

The TRIM function takes 3 arguments. 
First, you have to specify whether you want to remove characters from the beginning (‘leading’), 
the end (‘trailing’), or both (‘both’, as used above). 
Next you must specify all characters to be trimmed. 
Any characters included in the single quotes will be removed from both beginning, end, or both sides of the string. 
The remaining character will stop at the first non-target character.
Finally, you must specify the text you want to trim using FROM.
*/


/*
POSITION allows you to specify a substring, 
then returns a numerical value equal to the character number (counting from left) where that substring first appears in the target string. 
For example, the following query will return the position of the character ‘A’ (case-sensitive) where it first appears in the descript field:
*/

SELECT 
	name,
	POSITION('AN' IN name) AS position
FROM testDB
/*
name                                    position
STOLEN AND RECOVERED VEHICLE	        8
BATTERY	                                0
SUSPICIOUS OCCURRENCE	                0
GRAND THEFT FROM LOCKED AUTO	        3
DRIVERS LICENSE, SUSPENDED OR REVOKED	0
POSSESSION OF NARCOTICS PARAPHERNALIA	0
... ...
... ...
*/

-----------equivalently, we can write ------------------------------------------------------
SELECT
	name,
	STRPOS(name, 'AN') AS position
FROM testDB

/*
LEFT and RIGHT both create substrings of a specified length, 
but they only do so starting from the sides of an existing string. 
If you want to start in the middle of a string, you can use SUBSTR. 
The syntax is SUBSTR(*string*, *starting character position*, *# of characters*):
*/

SELECT 
	event_date,
	SUBSTR(event_date, 4, 2) AS day
FROM testDB
/*
event_data                      day
01/31/2014 08:00:00 AM +0000	31
01/31/2014 08:00:00 AM +0000	31
01/31/2014 08:00:00 AM +0000	31
*/

-------------------------------------------------------------------------------------
SELECT
	TRIM(leading '(' FROM LEFT(location, POSITION(',' IN location) - 1)) AS lattitude,
	TRIM(trailing ')' FROM RIGHT(location, LENGTH(location) - POSITION(',' IN location))) AS longtitude
	location
FROM testDB

/*
location                                lattitude           longtitude
(37.709725805163, -122.413623946206)	37.709725805163	    -122.413623946206
(37.7154876086057, -122.47370623066)	37.7154876086057	-122.47370623066
(37.7686887134351, -122.435718550322)	37.7686887134351	-122.435718550322
(37.8086250595467, -122.412527239682)	37.8086250595467	-122.412527239682
... ...
... ...

*/

/*
You can combine strings from several columns together (and with hard-coded values) using CONCAT. 
Simply order the values you want to concatenate and separate them with commas. 
If you want to hard-code values, enclose them in single quotes. Here’s an example:
*/

SELECT 
	day_of_week,
	LEFT(data, 10) AS clean_date,
	CONCAT(day_of_week, ', ', LEFT(data, 10)) AS day_and_date
FROM testDB
/*
day_of_week    clean_date      day_and_date
Friday	       01/31/2014	   Friday, 01/31/2014
Friday	       01/31/2014	   Friday, 01/31/2014
Friday	       01/31/2014	   Friday, 01/31/2014
*/
-----------equivalently, we can write-------------------------------------------
SELECT 
	day_of_week,
	LEFT(data, 10) AS clean_date,
	day_of_week || ', ' || LEFT(data, 10)) AS day_and_date
FROM testDB
---------------------------------------------------------------------------------
SELECT
	CONCAT('(', lattitude, ', ', 'longtitude', ')') AS location,
	lattitude,
	longtitude
FROM testDB
/*
location                                lattitude           longtitude
(37.709725805163, -122.413623946206)	37.709725805163	    -122.413623946206
(37.7154876086057, -122.47370623066)	37.7154876086057	-122.47370623066
(37.7686887134351, -122.435718550322)	37.7686887134351	-122.435718550322
(37.8086250595467, -122.412527239682)	37.8086250595467	-122.412527239682
... ...
... ...

*/

SELECT
	event_date,
	SUBSTR(event_date, 7, 4) || '-' || SUBSTR(event_date, 1, 2) || '-' || SUBSTR(event_date, 4, 2) AS cleaned_date
FROM testDB
/*
event_date                      cleaned_date
01/31/2014 08:00:00 AM +0000	2014-01-31
01/31/2014 08:00:00 AM +0000	2014-01-31
01/31/2014 08:00:00 AM +0000	2014-01-31
01/31/2014 08:00:00 AM +0000	2014-01-31
... ...
... ...
*/

SELECT
	event_date,
	SUBSTR(event_date, 7, 4) || '-' || SUBSTR(event_date, 1, 2) || '-' || SUBSTR(event_date, 4, 2)::date AS cleaned_date
	-- date is in the form of in the form of '2014-01-31'
FROM testDB
/*
event_date                      cleaned_date
01/31/2014 08:00:00 AM +0000	2014-01-31
01/31/2014 08:00:00 AM +0000	2014-01-31
01/31/2014 08:00:00 AM +0000	2014-01-31
01/31/2014 08:00:00 AM +0000	2014-01-31
... ...
... ...
This example is a little different from the answer above in that we’ve wrapped the entire set of concatenated substrings
in parentheses and cast the result in the date format.
We could also cast it as timestamp, which includes additional precision (hours, minutes, seconds). 
In this case, we’re not pulling the hours out of the original field, so we’ll just stick to date.
*/

SELECT
	date,
    time,
    (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) || ' ' || time ||':00')::timestamp AS cleaned_date
    -- timestamp is in the form of '2014-01-31 15:30:00'
FROM testDB
/*
date                            time    cleaned_date
01/31/2014 08:00:00 AM +0000	15:30	2014-01-31 15:30:00
01/31/2014 08:00:00 AM +0000	17:50	2014-01-31 17:50:00
01/31/2014 08:00:00 AM +0000	19:20	2014-01-31 19:20:00
... ...
... ...
*/

-----------------------------------------------------------------------
SELECT 
	name,
	UPPER(LEFT(name, 1)) || LOWER(RIGHT(name, LENGTH(name) - 1)) as cleaned_name
FROM testDB

/*
name            cleaned_name
VEHICLE THEFT	Vehicle theft
ASSAULT	        Assault
SUSPICIOUS OCC	Suspicious occ
OTHER OFFENSES	Other offenses
DRUG/NARCOTIC	Drug/narcotic
LARCENY/THEFT	Larceny/theft
... ...
... ...

*/









----------------Once you’ve got a well-formatted date field, you can manipulate in all sorts of interesting ways. 
SELECT 
	cleaned_date,
    EXTRACT('year'   FROM cleaned_date) AS year,
    EXTRACT('month'  FROM cleaned_date) AS month,
    EXTRACT('day'    FROM cleaned_date) AS day,
    EXTRACT('hour'   FROM cleaned_date) AS hour,
    EXTRACT('minute' FROM cleaned_date) AS minute,
    EXTRACT('second' FROM cleaned_date) AS second,
    EXTRACT('decade' FROM cleaned_date) AS decade,
    EXTRACT('dow'    FROM cleaned_date) AS day_of_week   -- sun=0, mon=1, tue=2, ..., sat=6
FROM testDB

/*
cleaned_date            year      month     day    hour   minute   second    decade   day_of_week
2014-01-31 17:45:00	    2014	  1	        31	   17	  45	   0	     201	  5
2014-01-31 15:30:00	    2014	  1	        31	   15	  30	   0	     201      5
2014-01-31 17:50:00	    2014	  1	        31	   17	  50	   0	     201	  5
2014-01-31 19:20:00	    2014	  1	        31	   19	  20	   0	     201	  5

*/

/*
You can also round dates to the nearest unit of measurement. 
This is particularly useful if you don’t care about an individual date, 
but do care about the week (or month, or quarter) that it occurred in. 
The DATE_TRUNC function rounds a date to whatever precision you specify. 
The value displayed is the first value in that period. 
So when you DATE_TRUNC by year, any value in that year will be listed as January 1st of that year:

*/
SELECT 
	cleaned_date,
	DATE_TRUNC('year'   , cleaned_date) AS year,
	DATE_TRUNC('month'  , cleaned_date) AS month,
	DATE_TRUNC('week'   , cleaned_date) AS week,
	DATE_TRUNC('day'    , cleaned_date) AS day,
	DATE_TRUNC('hour'   , cleaned_date) AS hour,
	DATE_TRUNC('minute' , cleaned_date) AS minute,
	DATE_TRUNC('second' , cleaned_date) AS second,
	DATE_TRUNC('decade' , cleaned_date) AS decade
FROM testDB

/*
cleaned_date           year                    month                   week                    day                     hour                    minute                  second                   decade
2014-01-31 17:00:00	   2014-01-01 00:00:00	   2014-01-01 00:00:00	   2014-01-27 00:00:00	   2014-01-31 00:00:00	   2014-01-31 17:00:00	   2014-01-31 17:00:00	   2014-01-31 17:00:00   	2010-01-01 00:00:00
2014-01-31 17:45:00	   2014-01-01 00:00:00	   2014-01-01 00:00:00	   2014-01-27 00:00:00	   2014-01-31 00:00:00	   2014-01-31 17:00:00	   2014-01-31 17:45:00	   2014-01-31 17:45:00   	2010-01-01 00:00:00
2014-01-31 15:30:00	   2014-01-01 00:00:00	   2014-01-01 00:00:00	   2014-01-27 00:00:00	   2014-01-31 00:00:00	   2014-01-31 15:00:00	   2014-01-31 15:30:00	   2014-01-31 15:30:00	    2010-01-01 00:00:00
2014-01-31 17:50:00	   2014-01-01 00:00:00	   2014-01-01 00:00:00	   2014-01-27 00:00:00	   2014-01-31 00:00:00	   2014-01-31 17:00:00	   2014-01-31 17:50:00	   2014-01-31 17:50:00   	2010-01-01 00:00:00

*/



/*
Write a query that counts the number of incidents reported by week. Cast the week as a date to get rid of the hours/minutes/seconds.
*/
SELECT 
	DATE_TRUNC('week', cleaned_date)::date AS week_beginning,
	COUNT(*) AS incidents
FROM tutorial.sf_crime_incidents_cleandate
GROUP BY 1
ORDER BY 1
/*
week_beginning         incidents
2013-10-28 00:00:00	   1139
2013-11-04 00:00:00	   2419
2013-11-11 00:00:00	   2543
2013-11-18 00:00:00	   2460
2013-11-25 00:00:00	   2244
2013-12-02 00:00:00	   2249
2013-12-09 00:00:00	   2267
... ...
... ...

*/

