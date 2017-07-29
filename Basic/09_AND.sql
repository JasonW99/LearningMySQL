SELECT *
FROM testDB
WHERE year = 2012 AND rank <= 10

-----------------------------------------
SELECT *
FROM testDB
WHERE year = 2013
AND rank <= 10
AND "group" ILIKE '%feat%'

-----------------------------------------
SELECT *
FROM testDB
WHERE rank <= 10 AND "Group" ILIKE '%Ludacris%'


-----------------------------------------
SELECT *
FROM testDB
WHERE year IN (1990, 2001, 1980)
AND rank <= 10

-----------------------------------------
SELECT *
FROM testDB
WHERE year BETWEEN 1950 AND 1959
AND title ILIKE 'god'

