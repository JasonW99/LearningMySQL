SELECT 
	user.name,
	history.restaurant,
	history.visit_time
FROM testDB_user user
LEFT JOIN testDB_history history
ON user.id = history.user_id
AND history.visit_time >= 5
ORDER BY visit_time DESC