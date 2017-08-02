/*
Subqueries (also known as inner queries or nested queries) are a tool for performing operations in multiple steps. 
For example, if you wanted to take the sums of several columns, 
then average all of those values, you’d need to do each aggregation in a distinct step.
*/

SELECT sub.*
FROM (
	SELECT *
	FROM testDB 
	WHERE name = 'Bob'
	) sub
WHER day = 'Friday'

------------------------------------------------------------------------------------------
SELECT 
	sub.category,
	AVG(sub.incidents) AS incidents_per_month
FROM (
	SELECT 
		category,
		EXTRACT('month' FROM cleaned_date) AS month,
		COUNT(*) as incidents
	FROM testDB
	GROUP BY 1, 2
	) sub
GROUP BY 1
ORDER BY 2 DESC

