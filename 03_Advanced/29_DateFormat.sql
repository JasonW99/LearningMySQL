/*
When you perform arithmetic on dates (such as subtracting one date from another), 
the results are often stored as the interval data type—a series of integers that represent a period of time. 
*/

-- "::timestamp" converting poorly formatted dates into proper date-formatted fields

SELECT 
	user.state,
	COUNT(CASE WHEN history.last_visit_time <= history.first_visit_time::timestamp + INTERVAL '3 weeks'
			   THEN 1 ELSE NULL END) AS 3WeeksOLdCustomer,
	COUNT(CASE WHEN history.last_visit_time <= history.first_visit_time::timestamp + INTERVAL '5 months'
			   THEN 1 ELSE NULL END) AS 5MonthsOldCustomer,
	COUNT(CASE WHEN history.last_visit_time <= history.first_visit_time::timestamp + INTERVAL '7 years'
			   THEN 1 ELSE NULL END) AS 7YearsOldCustomer,
	COUNT(1)
FROM testDB_user user 
JOIN testDB_history history
ON user.id = history.user_id
AND history.restaurant_name = 'PizzaHut'
GROUP BY 1
ORDER BY 5 DESC, 4 DESC, 3 DESC, 2 DESC



----------------------------------------------------------------------------
SELECT 
	user.id AS User_ID,
	user.name AS Name,
	history.restaurant_name AS Restaurant
	NOW() - history.first_visit_time::timestamp AS Time_From_First_Visit
FROM testDB_user user
JOIN testDB_history history