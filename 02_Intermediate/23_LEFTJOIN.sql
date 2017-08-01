SELECT 
	user.id as user_id,
	user.name as name,
	history.restaurant as  restaurant
FROM testDB_user user 
LEFT JOIN testDB_history history
ON history.user_id = user.id

--------------------------------------------------------------
SELECT 
	COUNT(user.id) as user_count,
	COUNT(history.restaurant) as restaurant_count
FROM testDB_user user
LEFT JOIN testDB_history history
ON user.id = history.user_id

--------------------------------------------------------------
SELECT 
	user.state as state
	COUNT(DISTINCT user.id) AS user_count,
	COUNT(DISTINCT history.restaurant) AS restaurant_count,
FROM testDB_user user
LEFT JOIN testDB_history history
ON user.id = history.user_id
WHERE user.state IS NOT NULL
GROUP BY state
ORDER BY restaurant_count










