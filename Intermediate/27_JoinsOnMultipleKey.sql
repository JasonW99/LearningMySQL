/*
There are couple reasons you might want to join tables on multiple foreign keys. 
The first has to do with accuracy.

The second reason has to do with performance. 
SQL uses “indexes” (essentially pre-defined joins) to speed up queries. 
This will be covered in greater detail the lesson on making queries run faster, 
but for all you need to know is that it can occasionally make your query run faster to join on multiple fields, 
even when it does not add to the accuracy of the query. 
For example, the results of the following query will be the same with or without the last line. 
However, it is possible to optimize the database such that the query runs more quickly with the last line included:
*/

SELECT 
	user.name,
	history.restaurant,
	history.visit_time
FROM testDB_user user
LEFT JOIN testDB_history history
ON user.id = history.user_id
AND user.name = history.user_name
