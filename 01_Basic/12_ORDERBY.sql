SELECT *
FROM testDB
ORDER BY year

-----------------------------------
SELECT *
FROM testDB
ORDER BY rank DESC

-----------------------------------
SELECT *
FROM testDB
WHERE rank <= 10
ORDER BY year, rank

-----------------------------------
SELECT *
FROM testDB
WHERE rank <= 10
ORDER BY year DESC, rank

-----------------------------------
SELECT *
FROM testDB
WHERE rank BETWEEN 10 AND 20 -- limit the rank to 10 - 20
AND year IN (2013, 2023, 4089) -- select the relevant years
ORDER BY year DESC, rank