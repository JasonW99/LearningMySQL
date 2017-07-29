/*
COUNT is a SQL aggregate function for counting the number of rows in a particular column. 
*/

SELECT COUNT(*) 
FROM testDB

---------------------------------------------------------------------------------------------
/*
Things start to get a little bit tricky when you want to count individual columns.
The following code will provide a count of all of rows in which the high column is not null.
*/

SELECT COUNT(high) 
FROM testDB

---------------------------------------------------------------------------------------------
SELECT COUNT(low) AS low 
FROM testDB

---------------------------------------------------------------------------------------------
SELECT COUNT(date) AS count_of_date
FROM testDB

---------------------------------------------------------------------------------------------
SELECT COUNT(date) AS "Count Of Date"
FROM testDB

---------------------------------------------------------------------------------------------
SELECT 
	COUNT(year) AS year,
	COUNT(month) AS month,
	COUNT(price) AS price,
	COUNT(high) AS high,
	COUNT(low) AS low
FROM testDB








