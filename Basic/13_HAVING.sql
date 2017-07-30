/*
In the previous lesson, you learned how to use the GROUP BY clause to aggregate stats from the Apple
stock prices dataset by month and year.

However, you’ll often encounter datasets where GROUP BY isn’t enough to get what you’re looking for. 
Let’s say that it’s not enough just to know aggregated stats by month. After all, there are a lot of 
months in this dataset. Instead, you might want to find every month during which AAPL stock worked 
its way over $400/share. The WHERE clause won’t work for this because it doesn’t allow you to filter 
on aggregate columns—that’s where the HAVING clause comes in:
*/

SELECT 
	year,
	month,
	MAX(price) AS monthly_high
FROM testDB
GROUP BY year, month
HAVING MAX(price) >= 400
ORDER BY year, month