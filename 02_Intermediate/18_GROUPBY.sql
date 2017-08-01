SELECT COUNT(*) as count
FROM testDB
GROUP BY year

-------------------------------
SELECT year
	month
	COUNT(*) AS count
GROUP BY year, month

--------------------------------
SELECT year
	month
	COUNT(*) AS count
GROUP BY year, month
ORDER BY year, month