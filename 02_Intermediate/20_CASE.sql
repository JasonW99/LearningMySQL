/*
The CASE statement is SQL’s way of handling if/then logic. 
The CASE statement is followed by at least one pair of WHEN and THEN statements—SQL’s equivalent of IF/THEN in Excel. 
It must end with the END statement. 
The ELSE statement is optional, and provides a way to capture values not specified in the WHEN/THEN statements. 
CASE is easiest to understand in the context of an example:
*/

SELECT 
	player,
	year,
	CASE WHEN year = 1998 THEN 'nineteen - ninetyeight'
		 ELSE NULL END AS is_1998
FROM testDB

----------------------------------------------------------------
/*
In plain english, here’s what’s happening:

1. The CASE statement checks each row to see if the conditional statement — year = 1998 is true.
2. For any given row, if that conditional statement is true, the word "nineteen - ninetyeight" gets printed in the column that we have named is_1998.
3. In any row for which the conditional statement is false, nothing happens in that row, leaving a null value in the is_1998 column.
4. At the same time all this is happening, SQL is retrieving and displaying all the values in the player and year columns.
*/

SELECT 
	player,
	age,
	homwtown,
	CASE WHEN hometown = 'California' THEN 'yes'
		 ELSE 'no' END AS is_California
FROM testDB
ORDER BY is_California DESC, age


------------------------------------------------------------------
SELECT 
	player,
	age,
	CASE WHEN age < 18 THEN 'under 18'
	     WHEN age < 25 THEN '18 - 24'
	     WHEN age < 35 THEN '25 - 34'
	     ELSE '35 or over' END AS age_group
FROM testDB	     
------------------------------------------------------------------
SELECT 
	player,
	age,
	CASE WHEN age < 18 THEN 'under 18'
	     WHEN age < 25 AND age < 25 THEN '18 - 24'
	     WHEN age < 35 AND age < 35 THEN '25 - 34'
	     ELSE '35 or over' END AS age_group
FROM testDB	

-----------------------------------------------------------------
SELECT *,
	CASE WHEN year = 'junior' OR year = 'senior' THEN name
		 ELSE null END AND new_student
FROM testDB

-----------------------------------------------------------------
SELECT *,
	CASE WHEN year IN ('junior', 'senior') THEN name
		 ELSE null END AND new_student
FROM testDB

----------------------------------------------------------------
/*
CASE’s slightly more complicated and substantially more useful functionality comes from pairing it with aggregate functions. 
For example, let’s say you want to only count rows that fulfill a certain condition. 
Since COUNT ignores nulls, you could use a CASE statement to evaluate the condition and produce null or non-null values depending on the outcome:

*/
SELECT 
	CASE WHEN year = 'FR' THEN 'FR'
         ELSE 'Not FR' END AS year_group,
     COUNT(1) AS count
FROM testDB
GROUP BY 
	CASE WHEN year_group = 'FR' THEN 'FR' 
		 ELSE 'Not FR' END


--------------------------------------------------------------
SELECT CASE WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS arbitrary_regional_designation,
            COUNT(*) AS players
FROM testDB
WHERE weight >= 300
GROUP BY arbitrary_regional_designation

--------------------------------------------------------------
SELECT 
	CASE WHEN class IN ('FR', 'SO') THEN 'underclass'
		 WHEN class IN ('JR', 'SR') THEN 'upperclass'
		 ELSE NULL END as class,
	COUNT(*) AS count
FROM testDB
WHERE state = 'California' AND class IN ('underclass', 'upperclass')
GROUP BY class

---------------------------------------------------------------
SELECT 
	COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
    COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
    COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
    COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
FROM testDB

-----------------------------------------------------------------
SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(1) AS total_players
  FROM testDB
 GROUP BY state
 ORDER BY total_players DESC

------------------------------------------------------------------
SELECT 
	CASE WHEN school_name < 'n' THEN 'A-M'
         WHEN school_name >= 'n' THEN 'N-Z'
         ELSE NULL END AS school_name_group,
    COUNT(1) AS players
FROM benn.college_football_players
GROUP BY 1
