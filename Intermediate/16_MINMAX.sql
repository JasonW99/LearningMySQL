/*
MIN and MAX are SQL aggregation functions that return the lowest and highest values in a particular column.

They’re similar to COUNT in that they can be used on non-numerical columns.
Depending on the column type, MIN will return the lowest number, earliest date, 
or non-numerical value as close alphabetically to “A” as possible. 
MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”
*/

---------------------------------------------
SELECT MIN(volume) AS min_volume
	MAX(volume) AS max_volume
FROM testDB

---------------------------------------------
SELECT MAX(high - low) 
FROM testDB




