-- WHERE is the syntax for filtering --------
SELECT *
FROM testDB
WHERE month = 1

---------------------------------------------
/*
Equal to	               : =
Not equal to	           : <> or !=
Greater than	           : >
Less than	               : <
Greater than or equal to   : >=
Less than or equal to	   : <=
*/

---------------------------------------------
SELECT *
FROM testDB
WHERE west > (midwest + northeast)

---------------------------------------------
SELECT
	year,
	month,
	west / (west + south + midwest + northeast) * 100 as West_pct,
	south / (west + south + midwest + northeast) * 100 as West_pct,
	midwest / (west + south + midwest + northeast) * 100 as West_pct,
	northeast / (west + south + midwest + northeast) * 100 as West_pct
FROM testDB
WHERE year >= 2000 AND month_name != 'January'


