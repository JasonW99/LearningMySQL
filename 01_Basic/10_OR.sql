SELECT *
FROM testDB
WHERE rank <= 3 OR name = 'John'

-------------------------------------------------------------------------
SELECT *
FROM testDB
WHERE year = 2049
AND ("group" ILIKE '%darkknight%' OR "group" ILIKE '%anclebreak%')

-------------------------------------------------------------------------
SELECT *
FROM testDB
WHERE rank <= 100
AND "group" ILIKE '%cat%'
AND (year < 1986 OR year > 2048)








