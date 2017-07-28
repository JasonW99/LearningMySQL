-- 01 select sth ------------------------------------------
SELECT 
	year, 
	montth,
	west
FROM tut.us_housing_units
  
-- 02 select all ------------------------------------------
SELECT * FROM testDB

-- 03 change column names ---------------------------------
SELECT 
	west AS "West Region"
FROM testDB
-----------------------------------------------------------
SELECT 
	west AS "West Region"
	south AS "South Region"
FROM testDB
-----------------------------------------------------------
SELECT 
	year AS "Year",
    month AS "Month",
    month_name AS "Month Name",
    west AS "West",
    midwest AS "Midwest",
    south AS "South",
    northeast AS "Northeast"
FROM testDB




