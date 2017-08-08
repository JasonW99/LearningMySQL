/*
Table1 : Users (test_user)
this table includes one row per user, with despriptive information about that user's account
user_id    : A unique ID per user. can be joined to user_id in either of the tables
created_at : the time the user was created (first signed up)   
state      : the state of the user
actived_at : the time the user was actived, if they are active
company_id : the ID of the user's company
language   : the chosen language of the user

Table2 : Events (test_events)
this table includes one row per event, where an event is ansction that a user has taken on Yammer. these events include login events, 
messaging events, search events, events logged as users progress through a signup funnel, events around received emails
user_id     : the ID of the user logging the event. can be joined to user_id in either of the other tables
occurred_at : the time the event occurred
event_type : the gerneral event type. there are two values in this dataset
              1. "signup_flow", which refers to anything occuring during the process of a user's authentication
              2. "engagement", which refers to general prodect usage after the user has signed up for the first time
event_name  : the specific action the user took. possible valuse include
			  1. create_user            : user is added to Yammer's database during signup process
			  2. enter_email            : user begind the signup process by entering her email address
			  3. inter_info             : user enters her name ang personal information during signup process
			  4. complete_signup        : user completes the intire signup/arthentication process
			  5. home_page              : user loads the home page
			  6. like_message           : user likes another user's message
			  7. login                  : user logs into Yammer
			  8. search_autocomplete    : user selects a search result from the autocomplete list
			  9. search_run             : user runs a search query and is taken to the search results page
			  10. search_click_result_X : user clicks seaedh result X on the results page, where X is a number from 1 through 10
			  11. send_message          : user posts a message
			  12. view_inbox            : user views messages in her inbox              
location    : the country from ehich the event was logged (collected throgh IP address)
device      : the type of device used to log the event

Table3 : Experiments
this table shows which groups users are sorted into for ecperiments. there should be one row per user, per experiment(a user should not be in both
test and control groups in a given experiment)
user_id          : the ID of the logging the event. cam be joined to user_id in either of the other tables.
occured_at       : the time the user was treated in that particular group.
experiment       : the name of the experiment. this indicated what actually changed in the product during the experiment.
experiment_group : the group into which the user was sorted. "test_group" is the new version of the feature; "control_group" is the old version.
location         : the country in which the user was located when sorted into a group(collectd through IP address).
device           : the type of device used to log the event.

user_id occured_at          experiment          experiment_group   location          device
4	    2014-06-05 15:20:16	publisher_update	control_group	   India	         lenovo thinkpad	
8198	2014-06-11 09:31:32	publisher_update	control_group	   Japan	         nokia lumia 635	
11	    2014-06-17 09:31:22	publisher_update	control_group	   United States	 iphone 4s	
8209	2014-06-04 09:31:21	publisher_update	test_group	       Turkey	         nokia lumia 635	
19	    2014-06-04 09:31:33	publisher_update	test_group	       Nigeria	         iphone 5	

Table4 : Normal Distribution
this table is purely lookup table, similar to what you might find in the back of a statistics textbook. it is equivalent to using the leftmost
column in this table, though it omits negative Z-Scores.
score      : Z-Score. NOte that this table only contains values >= 0, so you will need to join the absolute value of the Z-Score against it.
value      : the area on a normal distribution below Z-Score.

*/

/*
On July 1, you check the results of the A/B test. 
You notice that message posting is 50% higher in the treatment group—a huge increase in posting. The table below summarizes the results:

    experiment          experiment_group    users      total_treated_users       treatment_percent     total      average    rate_difference     rate_lift    stdev       t_stat    p_value
1	publisher_update	control_group	    1746	   2595	                     0.6728	               4660	      2.669	     0.0000	             0.0000	      3.5586	  0.0000	1
2	publisher_update	test_group	        849	       2595	                     0.3272	               3460	      4.0754	 1.4064	             0.5270	      4.7676	  7.6245	0

The chart shows the average number of messages posted per user by treatment group. The table below provides additional test result details:

users:               The total number of users shown that version of the publisher.
total_treated_users: The number of users who were treated in either group.
treatment_percent:   The number of users in that group as a percentage of the total number of treated users.
total:               The total number of messages posted by that treatment group.
average:             The average number of messages per user in that treatment group (total/users).
rate_difference:     The difference in posting rates between treatment groups (group average - control group average).
rate_lift:           The percent difference in posting rates between treatment groups ((group average / control group average) - 1).
stdev:               The standard deviation of messages posted per user for users in the treatment group. 
				     For example, if there were three people in the control group and they posted 1, 4, and 8 messages, 
				     this value would be the standard deviation of 1, 4, and 8 (which is 2.9).
t_stat:              A test statistic for calculating if average of the treatment group is statistically different from the average 
                     of the control group. It is calculated using the averages and standard deviations of the treatment and control groups.
p_value:             Used to determine the test’s statistical significance.
*/

/*
Before doing anything with the data, develop some hypotheses about why the result might look the way it does, 
as well as methods for testing those hypotheses. As a point of reference, such dramatic changes in user behavior—like 
the 50% increase in posting—are extremely uncommon.

Work through your list of hypotheses to determine whether the test results are valid. We suggest following the steps (and answer the questions) below:

1. Check to make sure that this test was run correctly. Is the query that calculates lift and p-value correct? It may be helpful to start with the code 
   that produces the above query, which you can find by clicking the link in the footer of the chart and navigating to the “query” tab.
2. Check other metrics to make sure that this outsized result is not isolated to this one metric. What other metrics are important? 
   Do they show similar improvements? This will require writing additional SQL queries to test other metrics.
3. Check that the data is correct. Are there problems with the way the test results were recorded or the way users were treated into test 
   and control groups? If something is incorrect, determine the steps necessary to correct the problem.
4. Make a final recommendation based on your conclusions. Should the new publisher be rolled out to everyone? Should it be re-tested? 
   If so, what should be different? Should it be abandoned entirely?
*/
SELECT     -- Step5. join the normal table find the statisics
	c.experiment, 
	c.experiment_group,
	c.user,
	c.total_treated_users,
	ROUND(c.user / c.total_treated_users, 4) AS treatment_percent,
	c.total,
	ROUND(c.average, 4)::FLOAT AS average, 
	ROUND(c.average - c.control_average, 4) AS rate_difference,
	ROUND(c.average / c.control_average - 1, 4) AS rate_lift,
	ROUND(c.stdev, 4) AS stdev,
	ROUND((c.average - c.control_average) / SQRT(c.variance / c.users + c.control_variance / c.control_users), 4) AS t_stat,
	(1 - COALESCE(nd.value, 1)) * 2 AS p_value
FROM (
	SELECT      -- Step4. move the useful information to single columns which can be used for further calculation
		b.*,
		MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.user ELSE NULL END) OVER() AS control_users,
		MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.average ELSE NULL END) OVER() AS control_average,    -- pick up one specific value and copy it to entire column
		MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.total ELSE NULL END) OVER() AS control_total, 
		MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.variance ELSE NULL END) OVER() AS control_variance,
		MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.stdev ELSE NULL END) OVER() AS control_stdev,
		SUM(b.user) OVER() AS total_treated_users
	FROM (
		SELECT      -- Step3. sumarize the counts, avg, sum, stdev, variance by group
			a.experiment,
			a.experiment_group,
			COUNT(a.user_id) AS user,
			AVG(a.metric) AS average,
			SUM(a.metric) AS total,
			STDDEV(a.metric) AS stdev,
			VARIANCE(a.metric) AS variance 
		FROM (
			SELECT      -- Step2. summarize the counts of posting by user id, by exp group.
				exp.experiment,
				exp.experiment_group,
				exp.occurred_at AS treatment_start,
				u.user_id,
				u.actived_at,
				COUNT(CASE WHEN e.event_name = 'send_message' THEN e.user_id ELSE NULL END) AS metric
			FROM 
				(      -- Step1. constuct the source table containing information from user, event, and experiment.
					SELECT 
						user_id,
						experiment,
						experiment_group -- wo you yi ge xiao guai guai, ta de ming zi jiao xiao bu guai...
						occurred_at
					FROM test_experiment
					WHERE experiment = 'publisher_update'
				) exp
				JOIN test_user u
				ON exp.user_id = u.user_id
				JOIN test_event e 
				ON exp.user_id = e.user_id 
				AND e.occurred_at >= exp.occurred_at 
				AND e.occurred_at < '2014-07-01'
				AND e.event_type = 'engagement' 
				-- Step1 end
			GROUP BY 1, 2, 3, 4, 5      -- Step2 end
		) a
		GROUP BY 1, 2      -- Step3 end
	) b
	-- Step4 end
) c
LEFT JOIN test_normal_distribution nd
ON nd.score = ABS(ROUND((c.average - c.control_average) / SQRT(c.variance / c.user + c.control_varince / c.control_users), 3))
-- Step5 end


--------------------------------------------------------------------------------------------------------------------------------------
/*
A/B tests can alter user behavior in a lot of ways, and sometimes these changes are unexpected. 
Before digging around test data, it’s important to hypothesize how a feature might change user behavior, and why. 
If you identify changes in the data first, it can be very easy to rationalize why these changes should be obvious, 
even if you never would have have thought of them before the experiment.

It’s similarly important to develop hypotheses for explaining test results before looking further into the data. 
These hypotheses focus your thinking, provide specific conclusions to validate, and keep you from always concluding that the 
first potential answer you find is the right one.

For this problem, a number of factors could explain the anomalous test. Here are a few examples:


1. This metric is incorrect or irrelevant: Posting rates may not be the correct metric for measuring overall success. 
   It describes how Yammer’s customers use the tool, but not necessarily if they’re getting value out of it. For example, while a giant “Post New Message” 
   button would probably increase posting rates, it’s likely not a great feature for Yammer. You may want to make sure the test results hold up for other metrics as well.
2. The test was calculated incorrectly: A/B tests are statistical tests. People calculate results using different methods—sometimes that method is incorrect, 
   and sometimes the arithmetic is done poorly.
3. The users were treated incorrectly: Users are supposed to be assigned to test treatments randomly, but sometimes bugs interfere with this process. 
   If users are treated incorrectly, the experiment may not actually be random.
4. There is a confounding factor or interaction effect: These are the trickiest to identify. Experiment treatments could be affecting the product in some other 
   way—for example, it could make some other feature harder to find or create incongruous mobile and desktop experiences. These changes might affect user behavior 
   in unexpected ways, or amplify changes beyond what you would typically expect.
*/


/*
in the following, let's vlidate the results

*/

/*
1. the number of message set shouldn't be the only determinant of this test's success, so dig into a few other metrics to make sure that their outcomes
   were also positive. in particula, we're interested in metrics that determine id a user is getting value out of Yammer. (Yammer typically user login frequency
   as a core metric.)
*/
/*
   first, the average number of logins per user is up. this suggests that not only are users sending more messages, but they're also signing in to Yammer more.
*/

-- in above the query, change the [e.event_name = 'send_message'] to [e.event_name = 'login'] in the step2
COUNT(CASE WHEN e.event_name = 'send_message' THEN e.user_id ELSE NULL END) AS metric
==> COUNT(CASE WHEN e.event_name = 'login' THEN e.user_id ELSE NULL END) AS metric
/*
   experiment          experiment_group    users      total_treated_users       treatment_percent     total      average    rate_difference     rate_lift    stdev       t_stat    p_value
1. publisher_update	   control_group	   1746	      2595	                    0.6728	              5789	     3.3156	    0.0000	            0.0000	     2.5777	     0.0000	   1
2. publisher_update	   test_group	       849	      2595	                    0.3272	              3481	     4.1001	    0.7845	            0.2366	     3.3110	     6.0676	   0
*/
/*
second, users are logging in on more days as well(days engaged the distinct number of days customers use Yammer). if this metric were up, it might imply
that people were logging in and logging out in quick succession, which could mean the new feature introduce a login bug. but both metrics are up, so it
appears that the problem with this tests isn't cherry-picking metrics-things look good across the board.
*/
-- change the COUNT clause in the step2 
COUNT(CASE WHEN e.event_name = 'send_message' THEN e.user_id ELSE NULL END) AS metric
==> COUNT(DISTINCT DATE_TRUNC('day', e.occurred_at)) AS metric

/*
   experiment          experiment_group    users      total_treated_users       treatment_percent     total      average    rate_difference     rate_lift    stdev       t_stat    p_value
1. publisher_update	   control_group	   1746	      2595	                    0.6728	              5297	     3.0338	    0.0000	            0.0000	     2.1520	     0.0000	   1
2. publisher_update	   test_group	       849	      2595	                    0.3272	              3059	     3.6031	    0.5693	            0.1876	     2.6994	     5.3707	   0
*/

-------------------------------------------------------------------------------------------------------------------------------------------
/*
2. Reasonable people can debate which mathematical methods are best for an A/B test, and arguments can be made for some changes 
   (1-tailed vs. 2-tailed tests, required sample sizes, assumptions about sample distributions, etc.). Nontheless, these other 
   methods don’t materially affect the test results here.

   the test, however, does suffer from a methodological error. the test lumps new users and existing users into the same group, and measures the number
   of messages they post during the testing window. this means that a user who signed up in January would be considered the same way as a user who signed
   up a day before the test ended, even though the second user has much less time to post messages. it would make more sense to consider new and existing
   users separately. not only does this make comparing magnitudes more appropriate, be it also lets you test for novelty effects. 

   users familier with Yammer might try out a new feature just because it's new, temporarily boosting their overall engagement. for new users, he feature
   isn't "new", so they're much less likely to use it just because it's different.


*/

-------------------------------------------------------------------------------------------------------------------------------------------
/*
3. investigating user treatments(or splitting users out into new and existing cohorts) reveals the heart of the problem
   -----all new users were treated in the control group.

*/

SELECT
	DATE_TRUNC('week', u.actived_at) AS week,
	COUNT(CASE WHEN exp.experiment_group = 'control_group' THEN u.user_id ELSE NULL END) AS control_users,
	COUNT(CASE WHEN exp.experiment_group = 'test_group' THEN u.user_id ELSE NULL END) AS test_users
FROM test_user u
JOIN test_experiment exp 
ON u.user_id = exp.user_id

/*
This creates a number of problems for the test. Because these users have less time to post than existing users, 
all else equal, they would be expected to post less than existing users given their shorter exposure to Yammer. 
Including all of them in the control group lowers that group’s overall posting rate. Because of this error, 
you may want to analyze the test in a way that ignores new users. 
As you can see from below, when only looking at posts from old users, the test results narrow considerably.

we can add one line into the original Step1
*/

(-- Step1. constuct the source table containing information from user, event, and experiment.
	SELECT 
		user_id,
		experiment,
		experiment_group -- wo you yi ge xiao guai guai, ta de ming zi jiao xiao bu guai...
		occurred_at
	FROM test_experiment
	WHERE experiment = 'publisher_update'
) exp
JOIN test_user u
ON exp.user_id = u.user_id
AND u.actived_at < '2014-06-01'
JOIN test_event e 
ON exp.user_id = e.user_id 
AND e.occurred_at >= exp.occurred_at 
AND e.occurred_at < '2014-07-01'
AND e.event_type = 'engagement' 
-- Step1 end

-------------------------------------------------------------------------------------------------------------------------------------------
/*
4. Though we’ve identified one problem, it’s usually a good idea to explore other possibilities as well. 
   There can be multiple problems, and frequently, these problems are related. When recommending what to next 
   to product teams, it’s important to have a complete understanding of what happened during a test—both the 
   expected results and unexpected ones. 

   Interaction effects can appear in many ways, so it’s not possible to list all of the possibilities here. 
   However, a few cohorts—new vs. existing users, usage by device, usage by user type (i.e., content producers 
   vs. readers)—are usually good to check. 

   The graph below show that the test results for just messages sent on phones. If you click through the embed 
   link, you can update the report to see results by tablet and desktop devices as well.
*/	

/*
Follow through

Overall, the test results are still strong. But given the above result, we should validate that change across 
different cohorts and fix the logging error that treated all new users in one group.

*/
