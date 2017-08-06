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

Let's call this table Result_1
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

/*
let's call the above table Result_2
if we want to transform Result_2 into Result_1, then we can perform the following
*/

-- STEP 1. create a column containing the age group
SELECT age_group
FROM (VALUES ('under 18'), ('18 - 30'), ('31 - 45'), ('46+')) v(age_group)
/*
under 18     
18 - 30
31 - 45 
46+ 
*/

-- STEP 2. CROSS JOIN the above column with Result_2
-- a M rows table 'CROSS JOIN' a N rows table will return a MxN rows table
SELELT 
	age.*,
	visit.*
FROM 
	(
	SELECT age_group FROM (VALUES ('under 18'), ('18 - 30'), ('31 - 45'), ('46+')) v(age_group) age
    CROSS JOIN Result_2 visit

/*
age_group      restaurant         under_18_visit          18_30_visit         31_45_visit     46_above_visit      total_visit_times
under 18       Pizza Hut          103                     200                 90              148                 541
18 - 30        Pizza Hut          103                     200                 90              148                 541
31 - 45        Pizza Hut          103                     200                 90              148                 541
46+            Pizza Hut          103                     200                 90              148                 541
under 18       Panda Express      47                      164                 79              225                 515
18 - 30        Panda Express      47                      164                 79              225                 515
31 - 45        Panda Express      47                      164                 79              225                 515
46+            Panda Express      47                      164                 79              225                 515
... ...
... ...
*/

-- STEP 3. filtering the result
SELECT 
	age_group,
	restaurant,
	CASE age_group
		WHEN 'under 18' THEN under_18_visit
		WHEN '18 - 30' THEN 18_30_visit
		WHEN '31 - 45' THEN 31_45_visit
		WHEN '46+' THEN 46_above_visit
		ELSE NULL END
		AS visit_times
FROM 
	Result_2 visit
	CROSS JOIN 
	(SELECT * FROM (VALUES ('under 18'), ('18 - 30'), ('31 - 45'), ('46+')) v(age_group)) age
/*
age_group      restaurant         visit_times      
under 18       Pizza Hut          103                                  
18 - 30        Pizza Hut          200                          
31 - 45        Pizza Hut          90             
46+            Pizza Hut          148            
under 18       Panda Express      47                                  
18 - 30        Panda Express      164                                
31 - 45        Panda Express      79                         
46+            Panda Express      225             
... ...
... ...

*/
