SELECT DISTINCT month
FROM testDB

---------------------------------------------
SELECT DISTINCT year, month
FROM testDB
ORDER BY year, month

---------------------------------------------
SELECT COUNT(DISTINCT month) AS unique_moth
FROM testDB

---------------------------------------------
SELECT 
	month,
    AVG(volume) AS avg_trade_volume
FROM testDB
GROUP BY month
ORDER BY avg_trade_volume DESC

---------------------------------------------
SELECT 
	year, 
	COUNT(DISTINCT month) AS month_count
FROM testDB 
GROUP BY year
ORDER BY year

----------------------------------------------
SELECT 
	COUNT(DISTINCT month) AS month_count,
	COUNT(DISTINCT year) AS year_count
FROM testDB


