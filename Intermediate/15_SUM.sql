/*
SUM is a SQL aggregate function that totals the values in a given column.
Unlike COUNT, you can only use SUM on columns containing numerical values.

You don’t need to worry as much about the presence of nulls with SUM as you would with COUNT, as SUM treats nulls as 0.
*/


SELECT SUM(volumn)
FROM testDB
----------------------------------------------------------------
SELECT SUM(price) / COUNT(price) AS averge_price
FROM testDB