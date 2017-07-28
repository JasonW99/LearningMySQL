-- LIKE is a logical operator in SQL that allows you to match on similar values rather than exact ones.

SELECT *
FROM testDB
WHERE "group" LIKE 'Snoop%'
/*
Note: 
"group" appears in quotations above because GROUP is actually the name of a function in SQL.
The double quotes (as opposed to single: ') are a way of indicating that you are referring to the column name "group", not the SQL function. 
In general, putting double quotes around a word or phrase will indicate that you are referring to that column name.


The % used above represents any character or set of characters. 

In the type of SQL that Mode uses, LIKE is case-sensitive. 
for example, the above query will only capture matches that start with a capital “S” and lower-case “noop.” 
snoop and Snoop will be differnt.
However if we want to ignore case when matching values, then we can use ILIKE command as following:
*/

SELECT *
FROM testDB
WHERE "group" ILIKE 'snoop%'

-- also we can use _ (a single underscore) to substitute for an individual character
SELECT *
FROM testDB
WHERE "group" ILIKE 'dr_ke'

----------------------------------------------------------------------
SELECT *
FROM testDB
WHERE "group" ILIKE '%kevin%'