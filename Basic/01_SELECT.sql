-- 01 select sth ------------------------------------------
SELECT 
	year, 
	montth,
    west
FROM tut.us_housing_units
  
-- 02 select all ------------------------------------------
SELECT * FROM tut.us_housing_units

-- 03 change column names ---------------------------------
SELECT 
	west AS "West Region"
FROM tut.us_housing_units
-----------------------------------------------------------
SELECT 
	west AS "West Region"
	south AS "South Region"
FROM tut.us_housing_units
-----------------------------------------------------------
SELECT 
	year AS "Year",
    month AS "Month",
    month_name AS "Month Name",
    west AS "West",
    midwest AS "Midwest",
    south AS "South",
    northeast AS "Northeast"
FROM tutorial.us_housing_units




