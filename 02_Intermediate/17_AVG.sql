SELECT AVG(high)
FROM testDB
WHERE high IS NOT NULL

----- is eauivalent to ---------------------
SELECT AVG(high)
FROM testDB

/*
AVG is a SQL aggregate function that calculates the average of a selected group of values. 
It’s very useful, but has some limitations. 
First, it can only be used on numerical columns. 
Second, it ignores nulls completely. 

There are some cases in which you’ll want to treat null values as 0. 
For these cases, you’ll want to write a statement that changes the nulls to 0 first.
*/
SELECT AVG(volume) AS avg_volume
FROM testDB






