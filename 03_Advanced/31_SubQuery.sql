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

-----------------------------------------------------------------------------------------
SELECT *
FROM testDB
WHERE date = (SELECT MIN(date) 
			  FROM testDB
			 )

-----------------------------------------------------------------------------------------
SELECT *
FROM testDB
WHERE date IN (SELECT date
			   FROM testDB 
			   ORDER BY date
			   LIMIT 5
			  )

---------------- equivalently, we can write ----------------------------------------------
SELECT *
FROM testDB test 
JOIN (
	SELECT date 
 	FROM testDB 
 	ORDER BY date
 	LIMIT 5
 	) sub
ON sub.date = test.date

------------------------------------------------------------------------------------------
SELECT test.*
	sub.tot_case as total_num_case
FROM testDB test 
JOIN (
	SELECT 
		date,
		COUNT(case_id) as tot_case
	FROM testDB
	GROUP BY date
) sub
ON test.date = sub.date
ORDER BY total_num_case DESC, time

------------------------------------------------------------------------------------------
SELECT test.*
	sub.tot_num_case_in_category
FROM testDB test 
JOIN (
	SELECT 
		category,
		COUNT(case_id) AS tot_num_case_in_category
	FROM testDB
	GROUP BY 1
	ORDER BY 2
	LIMIT 3
) sub
ON test.category = sub.category

-----------------------------------------------------------------------------------------
/*
Imagine you’d like to aggregate all of the 
product sold by seller bought by buyer each month. 
*/
SELECT 
	COALESCE(seller.date, buyer.date) AS deal_date
	seller.amount,
	buyer.amount
FROM (
	SELECT 
		date,
		COUNT(*) AS amount
	FROM testDB_seller
	GROUP BY 1
	) seller
FULL JOIN (
	SELECT 
		date,
		COUNT(*) AS amount
	FROM testDB_buyer
	GROUP BY 1
	) buyer
ON seller.date = buyer.date
ORDER BY 1 DESC
/*
Note: We used a FULL JOIN above just in case one table had observations in a month 
that the other table didn’t. 
We also used COALESCE to display months when the seller subquery didn’t have month entries 
(presumably no seller occurred in those months). 
*/

SELECT 
	user.user_id,
	COUNT(event.*) AS num_of_event
FROM testDB_user user
JOIN 
	(SELECT * FROM testDB_event_part1
		
		UNION ALL 

	SELECT * FROM testDB_event_part2
	) event
ON event.user_id = user.user_id
AND user.status = 'activate' 
GROUP BY 1
ORDER BY 2 DESC

-------------------------------------------------------------------------------------------






