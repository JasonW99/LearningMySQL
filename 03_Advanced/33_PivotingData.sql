SELECT 
	history.restanrant AS restaurant,
	user.age_group AS age_group,
	COUNT(1) AS visit_times
FROM testDB_user user
JOIN testDB_history history
ON user.id = history.user_id
GROUP BY 1, 2
-- ORDER BY 1, 2
/*
restaurant       age_group    visit_times
Pizza Hut        under 18     103
Pizza Hut        18 - 30      200
Pizza Hut        31 - 45      90
Pizza Hut        46+          148
Panda Express    under 18     47
Panda Express    18 - 30      164
Panda Express    31 - 45      79
Panda Express    46+          225
... ...
... ...
*/

SELECT 
	restaurant,
	COUNT(CASE WHEN age_group = 'under 18' THEN visit_times ELSE NULL END) AS under_18_visit,
	COUNT(CASE WHEN age_group = '18 - 30' THEN visit_times ELSE NULL END) AS 18_30_visit,
	COUNT(CASE WHEN age_group = '31 - 45' THEN visit_times ELSE NULL END) AS 31_45_visit,
	COUNT(CASE WHEN age_group = '46+' THEN visit_times ELSE NULL END) AS 46_above_visit,
	COUNT(visit_times) AS total_visit_times
FROM (
	SELECT 
		history.restaurant AS restaurant,
		user.age_group AS age_group,
		COUNT(1) AS visit_times
	FROM testDB_user user
	JOIN testDB_history history
	ON history.user_id = user.id
	GROUP BY 1,2
) sub
GROUP BY 1
-- ORDER BY 1
/*
restaurant         under_18_visit          18_30_visit         31_45_visit     46_above_visit      total_visit_times
Pizza Hut          103                     200                 90              148                 541
Panda Express      47                      164                 79              225                 515
... ...
... ...

*/

