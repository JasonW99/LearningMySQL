--the limit restricts how many rows the SQL query returns
SELECT *
FROM testDB
LIMIT 100

----------------------------------------------------------
SELECT 
	west
	south
FROM testDB
LIMIT 15

----------------------------------------------------------
SELECT AVG(close - open) AS avg_daily_change
GROUP BY year
ORDER BY year

----------------------------------------------------------
SELECT 
	year
	month
	MAX(price) AS monthly_high
	MIN(price) AS monthly_low
FROM testDB
GROUP BY year, month
ORDER BY year, month