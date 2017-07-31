SELECT 
	user.id AS user_id,
	user.name AS name,
	history.restaurant AS restaurant
	history.date AS visit_date
FROM testDB_user user 
LEFT JOIN testDB_history history
ON history.user_id = user.id
ORDER BY 1
/*
whithout any filtering the merge result will be sth like following

user_id      name       restaurant       visit_date
001          jack       Dim Sam King     01-01-1989
001          jack       Panda EXP        01-06-1989
002          sam        Pizza Hut        01-17-1989
002          sam        Starbucks        02-03-1989
002          sam        DQ icecream      02-14-1989
002          sam        Pizza Hut        03-07-1989
003          mike       KFC              02-05-1989
003          mike       Starbucks        02-12-1989
003          mike       Burger King      03-15-1989
004          jill
005          john
006          bill       Crab Town        04-01-1989
006          bill       Fun Sushi        04-05-1989
... ...
... ...
*/



/*
Normally, filtering is processed in the WHERE clause once the two tables have already been joined. (use WHERE) 
It’s possible, though that you might want to filter one or both of the tables before joining them. (use AND)
*/


SELECT 
	user.id AS user_id,
	user.name AS name,
	history.restaurant AS restaurant
	history.date AS visit_date
FROM testDB_user user 
LEFT JOIN testDB_history history
ON history.user_id = user.id
AND history.user_id != '002'
ORDER BY 1
/*
AND statement is like a filter before the merge.
it will ignore the information about user_id 002 carried by history table, or say, treated it as NULL. 

user_id      name       restaurant       visit_date
001          jack       Dim Sam King     01-01-1989
001          jack       Panda EXP        01-06-1989
002          sam      
003          mike       KFC              02-05-1989
003          mike       Starbucks        02-12-1989
003          mike       Burger King      03-15-1989
004          jill
005          john
006          bill       Crab Town        04-01-1989
006          bill       Fun Sushi        04-05-1989
... ...
... ...
*/

SELECT 
	user.id AS user_id,
	user.name AS name,
	history.restaurant AS restaurant
	history.date AS visit_date
FROM testDB_user user 
LEFT JOIN testDB_history history
ON history.user_id = user.id
WHERE history.user_id != '002' 
OR history.user_id IS NULL
ORDER BY 1
/*
WHERE statement is like a filter after the merge.
it only hide the user_id 002's merge result from the final output  

user_id      name       restaurant       visit_date
001          jack       Dim Sam King     01-01-1989
001          jack       Panda EXP        01-06-1989
003          mike       KFC              02-05-1989
003          mike       Starbucks        02-12-1989
003          mike       Burger King      03-15-1989
004          jill
005          john
006          bill       Crab Town        04-01-1989
006          bill       Fun Sushi        04-05-1989
... ...
... ...
*/

-- note that the WHERE statement also filter out the null entries. without the OR statement, the output will be like following
SELECT 
	user.id AS user_id,
	user.name AS name,
	history.restaurant AS restaurant
	history.date AS visit_date
FROM testDB_user user 
LEFT JOIN testDB_history history
ON history.user_id = user.id
WHERE history.user_id != '002' 
ORDER BY 1

/*
user_id      name       restaurant       visit_date
001          jack       Dim Sam King     01-01-1989
001          jack       Panda EXP        01-06-1989
003          mike       KFC              02-05-1989
003          mike       Starbucks        02-12-1989
003          mike       Burger King      03-15-1989
006          bill       Crab Town        04-01-1989
006          bill       Fun Sushi        04-05-1989
... ...
... ...
*/

SELECT 
	user.name AS name,
	COUNT(DISTINCT restaurant) AS Num_Of_visited_restaurants
FROM testDB_user as user
LEFT JOIN testDB_history as history
ON history.user_id = user.id
AND user.state = 'CA'
GROUP BY 1
ORDER BY 2 DESC


----------------------------------------------------------------
SELECT 
	CASE restaurant.name IS NULL THEN 'No Record'
	ELSE restaurant.name END as restaurant,
	COUNT(DISTINCT user.id)
FROM testDB_user user
LEFT JOIN testDB_history history
ON history.user_id = user.id
GROUP BY 1
ORDER BY 2 DESC