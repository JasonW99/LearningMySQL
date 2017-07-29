SELECT *
FROM testDB
WHERE year = 1892
AND rank NOT BETWEEN 2 AND 5 

-- equivalent to --------------------------------------
SELECT *
FROM testDB
WHERE year = 1892
AND (rank < 2 OR rank > 5)

-------------------------------------------------------
SELECT *
FROM testDB
WHERE year = 1892
AND name NOT ILIKE '%magicJohnson%'

-------------------------------------------------------
SELECT *
FROM testDB
WHERE year = 1892
AND name IS NOT NULL



