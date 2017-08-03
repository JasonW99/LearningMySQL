SELECT * FROM testDB
ORDER BY start_time

/*
duration        duration_seconds    start_time             ...

0h 7m 55sec.	475	                2012-01-01 00:04:00	   ...
0h 19m 22sec.	1162	            2012-01-01 00:10:00	   ...	
0h 19m 5sec.	1145	            2012-01-01 00:10:00	   ...	
0h 8m 5sec.	    485	                2012-01-01 00:15:00	   ...	
0h 7m 51sec.	471	                2012-01-01 00:15:00	   ...	
0h 5m 58sec.	358	                2012-01-01 00:17:00	   ...	
0h 29m 14sec.	1754	            2012-01-01 00:18:00	   ...	
0h 4m 19sec.	259	                2012-01-01 00:22:00	   ...	
0h 8m 36sec.	516	                2012-01-01 00:24:00	   ...
... ...
... ...
*/


SELECT 
	start_time,
	duration_seconds,
	SUM(duration_seconds) OVER(ORDER BY start_time) AS accumulated_duration
FROM testDB
/*
start_time                duration_seconds          accumulated_duration
2012-01-01 00:04:00	      475	                    475
2012-01-01 00:10:00	      1162	                    2782
2012-01-01 00:10:00	      1145	                    2782
2012-01-01 00:15:00	      485	                    3738
2012-01-01 00:15:00	      471	                    3738
2012-01-01 00:17:00	      358	                    4096
2012-01-01 00:18:00	      1754	                    5850
2012-01-01 00:22:00	      259	                    6109
2012-01-01 00:24:00	      516	                    6625
... ...
... ...
*/

SELECT 
	start_time,
	start_terminal,
	duration_seconds,	
	SUM(duration_seconds) OVER
		(PARTITION BY start_terminal ORDER BY start_time)
FROM testDB
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, start_time
/*
start_time                  start_terminal   duration_seconds        accumulated_duration
2012-01-01 15:32:00	        31000	         74	                     74
2012-01-02 12:40:00	        31000	         291	                 365
2012-01-02 19:15:00	        31000	         520	                 885
2012-01-03 07:22:00	        31000	         424	                 1756
2012-01-03 07:22:00	        31000	         447	                 1756
... ...
2012-01-01 02:20:00	        31001	         162	                 162
2012-01-01 13:35:00	        31001	         2876	                 3038
2012-01-01 13:36:00	        31001	         2804	                 5842
2012-01-01 13:38:00	        31001	         2686	                 8528
2012-01-01 14:29:00	        31001	         5	                     8533
... ...
... ...

*/
/*
The above query groups and orders the query by start_terminal. 
Within each value of start_terminal, it is ordered by start_time, 
and the running total sums across the current row and all previous 
rows of duration_seconds. Scroll down until the start_terminal value changes 
and you will notice that running_total starts over. 
That’s what happens when you group using PARTITION BY. 
In case you’re still stumped by ORDER BY, it simply orders by the designated column(s) 
the same way the ORDER BY clause would, except that it treats every partition as separate. 
It also creates the running total—without ORDER BY, 
each value will simply be a sum of all the duration_seconds values in its respective start_terminal. 
Try running the above query without ORDER BY to get an idea:
*/

SELECT 
	start_time,
	start_terminal,
	duration_seconds,	
	SUM(duration_seconds) OVER
		(PARTITION BY start_terminal)
FROM testDB
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, start_time
/*
start_time                  start_terminal   duration_seconds        accumulated_duration
2012-01-01 15:32:00	        31000	         74	                     12207
2012-01-02 12:40:00	        31000	         291	                 12207
2012-01-02 19:15:00	        31000	         520	                 12207
2012-01-03 07:22:00	        31000	         424	                 12207
2012-01-03 07:22:00	        31000	         447	                 12207
... ...
2012-01-01 02:20:00	        31001	         162	                 39557
2012-01-01 13:35:00	        31001	         2876	                 39557
2012-01-01 13:36:00	        31001	         2804	                 39557
2012-01-01 13:38:00	        31001	         2686	                 39557
2012-01-01 14:29:00	        31001	         5	                     39557
... ...
... ...

*/

/*
The ORDER and PARTITION define what is referred to as the “window”—the ordered subset of data over which calculations are made.

Note: You can’t use window functions and standard aggregations in the same query. 
More specifically, you can’t include window functions in a GROUP BY clause.
*/
SELECT 
	start_time,
	start_terminal,
	duration_seconds,
	SUM(duration_seconds) OVER (PARTITION BY start_terminal),
	(duration_seconds / SUM(duration_seconds)) OVER (PARTITION BY start_terminal) AS time_propotion
FROM testDB
ORDER BY 2, 5 DESC 
/*
start_time             start_terminal   duration_seconds        accumulated_duration    time_propotion
2012-01-05 17:25:00	   31000	        3340	                12207	                27.361350045056117
2012-01-06 17:29:00	   31000	        2661	                12207	                21.798967805357584
2012-01-03 12:32:00	   31000	        1422	                12207	                11.649053821577784
2012-01-02 19:15:00	   31000	        520	                    12207	                4.259850905218317
2012-01-03 07:22:00	   31000	        447	                    12207	                3.6618333742934386
... ...
... ...
*/
SELECT 
	start_time
	start_terminal,
    duration_seconds,
    SUM(duration_seconds) OVER
    	(PARTITION BY start_terminal) AS running_total,
    COUNT(duration_seconds) OVER
        (PARTITION BY start_terminal) AS running_count,
    AVG(duration_seconds) OVER
        (PARTITION BY start_terminal) AS running_avg
FROM testDB
WHERE start_time < '2012-01-08'
ORDER BY 2, 1
/*
start_time	           start_terminal   duration_seconds running_total      running_count       running_avg
2012-01-01 15:32:00	   31000	        74	             12207	            16	                762.9375
2012-01-02 12:40:00	   31000	        291	             12207	            16	                762.9375
2012-01-02 19:15:00	   31000	        520	             12207	            16	                762.9375
2012-01-03 07:22:00	   31000	        447	             12207	            16	                762.9375
2012-01-03 07:22:00	   31000	        424	             12207	            16	                762.9375
... ...
... ...
*/

SELECT 
	start_time,
	start_terminal,
    duration_seconds,
    SUM(duration_seconds) OVER
        (PARTITION BY start_terminal ORDER BY start_time) AS running_total,
    COUNT(duration_seconds) OVER
        (PARTITION BY start_terminal ORDER BY start_time) AS running_count,
    AVG(duration_seconds) OVER
        (PARTITION BY start_terminal ORDER BY start_time) AS running_avg
FROM testDB
WHERE start_time < '2012-01-08'
ORDER BY 2, 1
/*
start_time	           start_terminal   duration_seconds running_total      running_count       running_avg
2012-01-01 15:32:00	   31000	        74	             74	                1	                74
2012-01-02 12:40:00	   31000	        291	             365	            2	                182.5
2012-01-02 19:15:00	   31000	        520	             885	            3	                295
2012-01-03 07:22:00	   31000	        424	             1756            	5	                351.2
2012-01-03 07:22:00	   31000	        447	             1756	            5	                351.2
2012-01-03 12:32:00	   31000	        1422	         3178	            6	                529.6666666666666
2012-01-04 17:36:00	   31000	        348	             3526	            7	                503.7142857142857
2012-01-05 15:13:00	   31000	        277	             3803	            8	                475.375
2012-01-05 17:25:00	   31000	        3340	         7143	            9	                793.6666666666666
2012-01-06 07:28:00	   31000	        414	             7955	            11	                723.1818181818181
2012-01-06 07:28:00	   31000	        398	             7955	            11	                723.1818181818181
2012-01-06 11:36:00	   31000	        399	             8766	            13	                674.3076923076923
... ...
... ...

*/
/*
ROW_NUMBER() does just what it sounds like—displays the number of a given row. 
It starts are 1 and numbers the rows according to the ORDER BY part of the window statement.
*/
SELECT 
	start_terminal,
	start_time,	
	duration_seconds,
	ROW_NUMBER() OVER(PARTITION BY start_terminal ORDER BY start_time) AS row_number
FROM testDB
ORDER BY 1, 2
/*
start_terminal   start_time             duration_seconds  row_number
31000	         2012-01-01 15:32:00	74	              1
31000	         2012-01-02 12:40:00	291	              2
31000	         2012-01-02 19:15:00	520	              3
31000	         2012-01-03 07:22:00	424	              4
31000	         2012-01-03 07:22:00	447	              5
31000	         2012-01-03 12:32:00	1422	          6
31000	         2012-01-04 17:36:00	348	              7
... ...
31001	         2012-01-01 02:20:00	162	              1
31001	         2012-01-01 13:35:00	2876	          2
31001	         2012-01-01 13:36:00	2804	          3
31001	         2012-01-01 13:38:00	2686	          4
31001	         2012-01-01 14:29:00	5	              5
31001	         2012-01-01 15:09:00	3598	          6
31001	         2012-01-01 15:09:00	3624	          7
31001	         2012-01-01 16:49:00	1426	          8
... ...
... ...
*/
/*
RANK() is slightly different from ROW_NUMBER(). 
If you order by start_time, for example, 
it might be the case that some terminals have rides with two identical start times. 
In this case, they are given the same rank, whereas ROW_NUMBER() gives them different numbers. 
In the following query, you notice the 4th and 5th observations for start_terminal 31000—they 
are both given a rank of 4, and the following result receives a rank of 6:
*/
SELECT 
	start_terminal,
	start_time,	
	duration_seconds,
	RANK() OVER(PARTITION BY start_terminal ORDER BY start_time) AS rank
FROM testDB
ORDER BY 1, 2
/*
start_terminal   start_time             duration_seconds  rank
31000	         2012-01-01 15:32:00	74	              1
31000	         2012-01-02 12:40:00	291	              2
31000	         2012-01-02 19:15:00	520	              3
31000	         2012-01-03 07:22:00	424	              4
31000	         2012-01-03 07:22:00	447	              4
31000	         2012-01-03 12:32:00	1422	          6
31000	         2012-01-04 17:36:00	348	              7
... ...
31001	         2012-01-01 02:20:00	162	              1
31001	         2012-01-01 13:35:00	2876	          2
31001	         2012-01-01 13:36:00	2804	          3
31001	         2012-01-01 13:38:00	2686	          4
31001	         2012-01-01 14:29:00	5	              5
31001	         2012-01-01 15:09:00	3598	          6
31001	         2012-01-01 15:09:00	3624	          6
31001	         2012-01-01 16:49:00	1426	          8
... ...
... ...
*/
/*
You can also use DENSE_RANK() instead of RANK() depending on your application. 
Imagine a situation in which three entries have the same value. Using either command, 
they will all get the same rank. For the sake of this example, let’s say it’s “2.” 
Here’s how the two commands would evaluate the next results differently:

### RANK()       : would give the identical rows a rank of 2, then skip ranks 3 and 4, 
                   so the next result would be 5.
### DENSE_RANK() : would still give all the identical rows a rank of 2, 
                   but the following row would be 3. (no ranks would be skipped.)
*/

SELECT sub.*
FROM (
	SELECT 
		start_terminal,
		start_time,
		duration_seconds,
		RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
	FROM testDB
	ORDER BY 1, 4
	WHERE start_time < '2012-01-08'
) sub
WHERE sub.rank <= 5

----------------------------------------------------------------------------------------



/*
NTILE
You can use window functions to identify what percentile (or quartile, or any other subdivision) 
a given row falls into. The syntax is NTILE(*# of buckets*). In this case, ORDER BY determines 
which column to use to determine the quartiles (or whatever number of ‘tiles you specify). 
For example:
*/
SELECT 
	start_terminal,
    duration_seconds,
    NTILE(4) OVER
        (PARTITION BY start_terminal ORDER BY duration_seconds)
        AS quartile,
    NTILE(5) OVER
        (PARTITION BY start_terminal ORDER BY duration_seconds)
        AS quintile,
    NTILE(100) OVER
        (PARTITION BY start_terminal ORDER BY duration_seconds)
        AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds


/*
start_terminal       duration_second      quartile     quintile    percentile
31000	             74	                  1	           1	       1
31000	             277	              1	           1	       2
31000	             291	              1	           1	       3
31000	             348	              1	           1	       4
31000	             387	              2	           2	       5
31000	             393	              2	           2	       6
31000	             398	              2	           2	       7
31000	             399	              2	           3	       8
31000	             412	              3	           3	       9
31000	             414	              3	           3	       10
31000	             424	              3	           4	       11
31000	             447	              3	           4	       12
31000	             520	              4	           4	       13
31000	             1422	              4	           5	       14
31000	             2661	              4	           5	       15
31000	             3340	              4	           5	       16	
... ...
... ...


note that
Suppse :
### n / k = m;
### n % k = j;
Then for the first j buckets, they will contain (m + 1) elements.
And for the last (k - j) buckets, thay will contain (m) elements.
*/

/*
LAG and LEAD

It can often be useful to compare rows to preceding or following rows, 
especially if you’ve got the data in an order that makes sense. 
You can use LAG or LEAD to create columns that pull values from other 
rows—all you need to do is enter which column to pull from and how many 
rows away you’d like to do the pull. 
LAG pulls from previous rows and LEAD pulls from following rows:
*/
SELECT 
	start_terminal,
    duration_seconds,
    LAG(duration_seconds, 1) OVER
    (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
    LEAD(duration_seconds, 1) OVER
    (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
FROM testDB
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds
/*
start_terminal    duration_seconds   lag      lead
31000	          74		                  277
31000	          277	             74	      291
31000	          291	             277	  348
31000	          348	             291	  387
31000	          387	             348	  393
... ...
31000	          2661	             1422	  3340
31000	          3340	             2661	
31001	          5		                      47
31001	          47	             5	      120
31001	          120	             47	      138
31001	          138	             120	  138
... ...
31001	          3598	             2876	  3624
31001	          3624	             3598	
31002	          70		                  71
31002	          71	             70	      86
... ...
... ...
*/
SELECT 
	start_terminal,
    duration_seconds,
    duration_seconds - LAG(duration_seconds, 1) OVER
    (PARTITION BY start_terminal ORDER BY duration_seconds) AS difference
FROM testDB
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds

/*
start_terminal    duration_seconds   difference      
31000	          74		                  
31000	          277	             203	      
31000	          291	             14	  
31000	          348	             57
... ...
31000	          2661	             1293	  
31000	          3340	             679	
31001	          5		                      
31001	          47	             42	     
... ...
... ...	


The first row of the difference column is null because there is no previous row from which to pull. 
Similarly, using LEAD will create nulls at the end of the dataset. 
If you’d like to make the results a bit cleaner, 
you can wrap it in an outer query to remove nulls: 
*/
SELECT sub.*
FROM (
	SELECT 
		start_terminal,
	    duration_seconds,
	    duration_seconds - LAG(duration_seconds, 1) OVER
	    (PARTITION BY start_terminal ORDER BY duration_seconds) AS difference
	FROM testDB
	WHERE start_time < '2012-01-08'
	ORDER BY start_terminal, duration_seconds
) sub
WHERE sub.difference IS NOT NULL



-----------------------------------------------------------------------------------------
/*
Defining a window alias

If you’re planning to write several window functions in to the same query, 
using the same window, you can create an alias. Take the NTILE example above:
*/

SELECT 
	start_terminal,
	duration_seconds,
	NTILE(4) OVER ntile_window AS quartile,
	NTILE(5) OVER ntile_window AS quintile,
	NTILE(100) OVER ntile_window AS percentile
FROM testDB
WHERE start_time < '2012-01-08'
WINDOW ntile_window AS
	(PARTITION BY start_terminal ORDER BY duration_seconds)
ORDER BY 1, 2

/*
The WINDOW clause, if included, should always come after the WHERE clause.

*/