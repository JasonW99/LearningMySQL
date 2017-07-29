SELECT *
FROM testDB
WHERE rank BETWEEN 5 AND 10

-- equivalent to
SELECT *
FROM testDB
WHERE rank >= 5 AND rank <= 10


-------------------------------
SELECT * 
FROM testDB
WHERE year BETWEEN 1987 AND 1993
