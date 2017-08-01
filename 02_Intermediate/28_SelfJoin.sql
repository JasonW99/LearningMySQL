/*
say we want to find a user has visted restaurant PandaExpress after his visit to PizzaHut.
*/

SELECT 
	pandaE.user_id,
	pandaE.user_name
FROM testDB_history pandaE
LEFT JOIN testDB_history pizzaH
ON pandaE.user_id = pizzaH.user_id
AND pizzaH.restaurant_name = 'PizzaHut'
AND pandaE.visit_date > pizzaH.visit_date
WHERE pandaE.restaurant_name = 'PandaExpress'
ORDER BY 1