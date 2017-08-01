/*
Note that UNION only appends distinct values. 
More specifically, when you use UNION, the dataset is appended.
And any rows in the appended table that are exactly identical to rows in the first table are dropped. 
If you’d like to append all the values from the second table, use UNION ALL. 
You’ll likely use UNION ALL far more often than UNION.


SQL has strict rules for appending data:
1. Both tables must have the same number of columns
2. The columns must have the same data types in the same order as the first table
*/

SELECT *
FROM testDB_part1
WHERE name LIKE 'Tom%'
UNION 
SELECT *
FROM testDB_part2
WHERE name LIKE 'Sam%'


------------------------------------------
SELECT 
	'from part 1' AS group_part,
	user1.name AS name,
	COUNT (DISTINCT history.restaurant) AS num_of_visited_restaurant
FROM testDB_user_part1 user1
LEFT JOIN testDB_history history
ON history.user_id = user1.id

UNION

SELECT 
	'from part 2' AS group_part,
	user1.name AS name,
	COUNT (DISTINCT history.restaurant) AS num_of_visited_restaurant
FROM testDB_user_part2 user2
LEFT JOIN testDB_history history
ON history.user_id = user2.id

------------------------------------------
SELECT 
	1 AS group_part,
	user1.name AS name,
	COUNT (DISTINCT history.restaurant) AS num_of_visited_restaurant
FROM testDB_user_part1 user1
LEFT JOIN testDB_history history
ON history.user_id = user1.id

UNION

SELECT 
	2 AS group_part,
	user1.name AS name,
	COUNT (DISTINCT history.restaurant) AS num_of_visited_restaurant
FROM testDB_user_part2 user2
LEFT JOIN testDB_history history
ON history.user_id = user2.id