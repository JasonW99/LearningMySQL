-- IN is a logical operator in SQL that allows you to specify a list of values that you’d like to include in the results.
SELECT *
FROM testDB
WHERE rank IN (1, 2, 3)

-------------------------------------------------------------------
SELECT *
FROM testDB
WHERE name IN ('kevin', 'John', 'smart')

-------------------------------------------------------------------
SELECT *
FROM testDB
WHERE "group" IN ('Red', 'Blue', 'Green')