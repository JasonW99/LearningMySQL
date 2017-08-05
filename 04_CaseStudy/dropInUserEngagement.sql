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

Table3 : Email Events (test_email_events)
this table contains events specific to the sending of email. it is similar in structure to the events table above
user_id     : the ID of the user to whom the envet relates. can be joined to user_id in either of the other tables.
occurred_at : the time the event occurred
action      : the name of the event that occurred
              1. "sent_weekly_digest" means that the user was delivered a digest email showing relevant conversations from the previous day
              2. "email_open" means that the user opened the email
              3. "email_clickthrough" means that the user clicked a link in the email

Table4 : Rollup Periods (test_rollup_periods)             
the final table is a lookup table that is ised to create rolling time periods. though you could use the INTERVAL() function,
creating rolling time periods is often easiest with a table like this.
period_id : this identifies the tyoe of rollup period. the above dashboard uses period 1007, which is rolling 7-day periods.
time_id   : this is the identifier for any given data point - it's what you would put on a chart axis. if time_id is 2014-08-01,
			that means that is represents the rolling 7-day period leading up to 2014-08-01
pst_start : the start time of the period in PST. for 2014-08-01, you'll notice that this is 2014-07-25 (one week prior). 
            use this to join enents to the table		
pst_end   : the end time of the period in PST. for 2014-08-01, the end time is 2014-08-01. 
utc_start : the same as pst_start, but in UTC time.
utc_end   : the same as pst_end, but in UTC time.

period_id    time_id                pst_start           pst_end             uts_start           utc_end
1	         2013-01-01 00:00:00	2013-01-01 00:00:00	2013-01-02 00:00:00	2013-01-01 08:00:00	2013-01-02 08:00:00
1	         2013-01-02 00:00:00	2013-01-02 00:00:00	2013-01-03 00:00:00	2013-01-02 08:00:00	2013-01-03 08:00:00
1	         2013-01-03 00:00:00	2013-01-03 00:00:00	2013-01-04 00:00:00	2013-01-03 08:00:00	2013-01-04 08:00:00
1	         2013-01-04 00:00:00	2013-01-04 00:00:00	2013-01-05 00:00:00	2013-01-04 08:00:00	2013-01-05 08:00:00
1	         2013-01-05 00:00:00	2013-01-05 00:00:00	2013-01-06 00:00:00	2013-01-05 08:00:00	2013-01-06 08:00:00
... ...
1007	     2013-12-20 00:00:00	2013-12-13 00:00:00	2013-12-20 00:00:00	2013-12-13 08:00:00	2013-12-20 08:00:00
1007	     2013-12-21 00:00:00	2013-12-14 00:00:00	2013-12-21 00:00:00	2013-12-14 08:00:00	2013-12-21 08:00:00
1007	     2013-12-22 00:00:00	2013-12-15 00:00:00	2013-12-22 00:00:00	2013-12-15 08:00:00	2013-12-22 08:00:00
1007	     2013-12-23 00:00:00	2013-12-16 00:00:00	2013-12-23 00:00:00	2013-12-16 08:00:00	2013-12-23 08:00:00
1007	     2013-12-24 00:00:00	2013-12-17 00:00:00	2013-12-24 00:00:00	2013-12-17 08:00:00	2013-12-24 08:00:00
... ...
... ...
*/

-- the index we cared about is the number of the active users per week, so let's firstly examine the varies of the figure.
SELECT 
	DATE_TRUNC('week', e.occurred_at),
	COUNT(DISTINCT e.user_id) AS weekly_active_user
FROM test_events e
WHERE e.event_type = 'engagement' AND e.event_name = 'login'
GROUP BY 1
ORDER BY 1

-- by visualisubing the above data, we can see a dramatic drop in user engagement after 2014-07-28. 
-- in the following, we would like to do some analysis try to find a reason behind this drop.

/*
for designind a series of test try to consider following factors
Experience:    This isn’t particularly relevant for those of you who have not worked in industry before, 
               but once you have seen these problems a couple time, you will get a sense for the most frequent problems.
Communication: It’s really easy to ask someone about marketing events, so there’s very little reason not to do that. 
               Unfortunately, this is also irrelevant for this example, but it’s certainly worth mentioning.
Speed:         Certain scenarios are easier to test than others, sometimes because the data is cleaner or easier to understand or query, 
               sometimes because you’ve done something similar in the past. If two possibilities seem equally likely, test the faster one first.
Dependency:    If a particular scenario will be easy to understand after testing a different scenario, 
               then test them in the order that makes sense.

*/

/*
possible reasons which caused the drop 
Holiday:                       It’s likely that people using a work application like Yammer might engage at a lower rate on holidays. 
                               If one country has much lower engagement than others, it’s possible that this is the cause.
Broken feature:                It is possible that something in the application is broken, and therefore impossible for people to use. 
                               This is a little harder to pinpoint because different parts of the application would show differently in the metrics. 
                               For example, if something in the signup flow broke, preventing new users from joining Yammer, growth would also be down. 
                               If a mobile app was unstable and crashed, engagement would be down for only that device type.
Broken tracking code:          It’s possible that the code that logs events is, itself, broken. If you see a drop to absolutely subero events of a certain 
                               type and you rule out a broken feature, then this is a possibility.
Traffic anomalies from bots:   Most major website see a lot of activity from bots. A change in the product or infrastructure that might make it harder for 
                               bots to interact with the site could decrease engagement (assuming bots look like real users). This is tricky to determine 
                               because you have to identify bot-like behavior through patterns or specific events.
Traffic shutdown to your site: It is possible for internet service providers to block your site. This is pretty rare for professional applications, but 
                               nevertheless possible.
Marketing event:               A Super Bowl ad, for example, might cause a massive spike in sign-ups for the product. But users who enter through one-time 
                               marketing blitsubes often retain at lower rates than users who are referred by friends, for example. Because the chart uses a 
                               rolling 7-day period, this will register as high engagement for one week, then almost certainly look like a big drop in engagement 
                               the following week. Most often, the best way to determine this is to simply ask someone in the Marketing department if anything big 
                               happened recently.
Bad data:                      There are lots of ways to log bad data. For example, most large web apps separate their QA data from production data. One way or 
                               another, QA data can make its way into the production database. This is not likely to be the problem in this particular case, as it 
                               would likely show up as additional data logged from very few users.
Search crawler changes:        For a website that receives a lot of traffic, changes in the way search engines index them could cause big swings in traffic.


*/

/* 1. let's firstly check if it was because the drop in new user registration and activation(low growth) has caused the drop in total user engagement. 
One of the easiest things to check is growth, both because it’s easy to measure and because most companies (Yammer included) track this closely already. 
In this case, you have to make it yourself, though. You’ll notice that nothing has really changed about the growth rate—it continues to be high during the week, low on weekends:
*/
SELECT
	DATE_TRUNC('day', created_at),
	COUNT(1) AS all_new_user,
	COUNT(CASE actived_at IS NOT NULL THEN u.user_id ELSE NULL END) AS actived_new_user
FROM test_user u
WHERE created_at >= '2014-06-01' AND created_at < '2014-09-01'
GROUP BY 1
ORDER BY 1

/*
2. from the above table(chart), we can see the pattern of new users engagement didn't change. 
so secondly, we would like to check if it was the old users caused the drop in total user engagement.  
Since growth is normal, it’s possible that the dip in engagement is coming from existing users as opposed to new ones. 
One of the most effective ways to look at this is to cohort users based on when they signed up for the product. 
This chart shows a decrease in engagement among users who signed up more than 10 weeks prior:
*/
SELECT 
	DATE_TRUNC('week', sub.occurred_at) AS week,
	AVG(sub.age_at_event) AS "Average age during week",
	COUNT(CASE WHEN sub.user_age > 70 THEN sub.user_id ELSE NULL END) AS "10+ weeks",
	COUNT(DISTINCT CASE WHEN sub.user_age < 70 AND sub.user_age >= 63 THEN sub.user_id ELSE NULL END) AS "9 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 63 AND sub.user_age >= 56 THEN sub.user_id ELSE NULL END) AS "8 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 56 AND sub.user_age >= 49 THEN sub.user_id ELSE NULL END) AS "7 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 49 AND sub.user_age >= 42 THEN sub.user_id ELSE NULL END) AS "6 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 42 AND sub.user_age >= 35 THEN sub.user_id ELSE NULL END) AS "5 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 35 AND sub.user_age >= 28 THEN sub.user_id ELSE NULL END) AS "4 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 28 AND sub.user_age >= 21 THEN sub.user_id ELSE NULL END) AS "3 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 21 AND sub.user_age >= 14 THEN sub.user_id ELSE NULL END) AS "2 weeks",
    COUNT(DISTINCT CASE WHEN sub.user_age < 14 AND sub.user_age >= 7 THEN sub.user_id ELSE NULL END) AS "1 week",
    COUNT(DISTINCT CASE WHEN sub.user_age < 7 THEN sub.user_id ELSE NULL END) AS "Less than a week"
FROM (
	SELECT 
		u.user_id,
		e.occurred_at,
		-- DATE_TRUNC('week', e.occurred_at) AS activation_week,
		EXTRACT('day' FROM e.occurred_at - u.actived_at) AS age_at_event,
		EXTRACT('day' FROM '2014-09-01'::TIMESTAMP - u.actived_at) AS user_age
	FROM test_user u
	JOIN test_events e
	ON u.user_id = e.user_id
	AND e.event_type = 'engagement' 
	AND e.event_name = 'login'
	AND e.occurred_at >= '2014-05-01'
	AND e.occurred_at <= '2014-09-01'
	WHERE u.actived_at IS NOT NULL
) sub
GROUP BY 1
ORDER BY 1
/*
week                  Average age during week        10+ weeks      9 weeks      8 weeks      7 weeks      6 weeks      5 weeks      4 weeks      3 weeks      2 weeks      1 weeks        Less than a week
2014-04-28 00:00:00	  124.007238883144	             701	        0	         0	          0	           0         	0            0	          0	           0	        0	           0
2014-05-05 00:00:00	  124.381690845423	             1054	        0	         0	          0	           0         	0            0	          0	           0	        0	           0	
2014-05-12 00:00:00	  131.938644235527	             1094	        0	         0	          0	           0         	0            0	          0	           0	        0	           0
2014-05-19 00:00:00	  132.32662835249	             1147	        0	         0	          0	           0         	0            0	          0	           0	        0	           0	
2014-05-26 00:00:00	  132.345363408521	             1113	        0	         0	          0	           0         	0            0	          0	           0	        0	           0	
2014-06-02 00:00:00	  131.831109065808	             1173	        0	         0	          0	           0         	0            0	          0	           0	        0	           0	
2014-06-09 00:00:00	  131.042582417582	             1219	        0	         0	          0	           0         	0            0	          0	           0	        0	           0	
2014-06-16 00:00:00	  136.480565371025	             1255	        0	         0	          0	           0         	0            0	          0	           0	        0	           0	
2014-06-23 00:00:00	  136.278905560459	             1034	        210		     0	          0	           0	        0         	 0            0	           0	        0	           0
2014-06-30 00:00:00	  136.41929746554	             917	        151	         199		  0	           0	        0         	 0            0	           0	        0	           0
2014-07-07 00:00:00	  135.888750518887	             899	        100	         130	      223	       0	        0	         0         	  0            0	        0	           0	         
2014-07-14 00:00:00	  143.448815736652	             832	        62	         82	          152	       215          0	         0	          0            0            0	           0	    
2014-07-21 00:00:00	  141.70278004906	             791	        44	         60	          95	       144      	228	         0	          0	           0            0              0	         
2014-07-28 00:00:00	  144.078660436137	             805	        30	         43	          83	       91	        155	         234	      0	           0	        0	           0
2014-08-04 00:00:00   140.732238010657	             678	        24	         34	          52	       52	        82	         154	      189	       0	        0	           0
2014-08-11 00:00:00	  125.994310099573	             562	        19	         33	          39	       33	        59	         94	          126	       250	        0	           0
2014-08-18 00:00:00	  128.021718146718	             522	        15	         26	          26	       19	        40	         64	          69	       163	        259 	       0
2014-08-25 00:00:00	  128.2698104035	             474	        15	         14	          23	       20	        31	         47	          48	       82	        173	           266
*/


/*
3. The understanding that the problem is localized to older users leads us to believe that the problem probably isn’t 
related to a one-time spike from marketing traffic or something that is affecting new traffic to the site like being blocked or changing rank on search engines. 
Now let’s take a look at various device types to see if the problem is localized to any particular product:

*/
SELECT 
	DATE_TRUNC('week', e.occurred_at) AS week,
	COUNT(e.user_id) AS weekly_active_user,
	COUNT(DISTINCT CASE WHEN e.device IN ('macbook pro','lenovo thinkpad','macbook air','dell inspiron notebook', 'asus chromebook','dell inspiron desktop','acer aspire notebook','hp pavilion desktop','acer aspire desktop','mac mini')
        THEN e.user_id ELSE NULL END) AS computer,
    COUNT(DISTINCT CASE WHEN e.device IN ('iphone 5','samsung galaxy s4','nexus 5','iphone 5s','iphone 4s','nokia lumia 635', 'htc one','samsung galaxy note','amazon fire phone') 
    	THEN e.user_id ELSE NULL END) AS phone,
    COUNT(DISTINCT CASE WHEN e.device IN ('ipad air','nexus 7','ipad mini','nexus 10','kindle fire','windows surface', 'samsumg galaxy tablet') 
    	THEN e.user_id ELSE NULL END) AS tablet
FROM test_events e
WHERE e.event_type = 'engagement' AND e.event_name = 'login'
GROUP BY 1
ORDER BY 1

/*
4. If you filter the above chart down to phones (double-click the dot next to “phone” in the legend), you will see that there’s a pretty steep drop in phone engagement rates. 
So it’s likely that there’s a problem with the mobile app related to long-time user retention. At this point, you’re in a good position to ask around and see if anything changed 
recently with the mobile app to try to figure out the problem. You might also think about what causes people to engage with the product. The purpose of the digest email mentioned 
above is to bring users back into the product. 
Since we know this problem relates to the retention of long-time users, it’s worth checking out whether the email has something to do with it:

*/
SELECT
	DATE_TRUNC('week', e.occurred_at) AS week,
    COUNT(CASE WHEN e.action = 'sent_weekly_digest' THEN e.user_id ELSE NULL END) AS weekly_emails,
    COUNT(CASE WHEN e.action = 'sent_reengagement_email' THEN e.user_id ELSE NULL END) AS reengagement_emails,
    COUNT(CASE WHEN e.action = 'email_open' THEN e.user_id ELSE NULL END) AS email_opens,
    COUNT(CASE WHEN e.action = 'email_clickthrough' THEN e.user_id ELSE NULL END) AS email_clickthroughs
FROM test_email_events e
GROUP BY 1
ORDER BY 1	

/*
5. If you filter to clickthroughs (again, by clicking the dot in the legend), you’ll see that clickthroughs are way down. 
This next chart shows in greater detail clickthrough and open rates of emails, indicating clearly that the problem has to do with digest emails in addition to mobile apps.

a. user recieve the weekly digest email
b. user click through the link in the email
c. user recieve the reengagement email
d. user click through the link in the reengagement email

*/
SELECT
	week,
    weekly_opens/CASE WHEN weekly_emails = 0 THEN 1 ELSE weekly_emails END::FLOAT AS weekly_open_rate,
    weekly_click_through/CASE WHEN weekly_opens = 0 THEN 1 ELSE weekly_opens END::FLOAT AS weekly_ctr,
    weekly_retain_opens/CASE WHEN weekly_retain_email = 0 THEN 1 ELSE weekly_retain_email END::FLOAT AS retain_open_rate,
    weekly_retain_click_through/CASE WHEN weekly_retain_opens = 0 THEN 1 ELSE weekly_retain_opens END::FLOAT AS retain_ctr
FROM (
	SELECT 
		DATE_TRUNC('week', e1.occurred_at) AS week,
		COUNT(CASE e1.action = 'sent_weekly_digest' THEN e1.user_id ELSE NULL END) AS weekly_emails,
		COUNT(CASE e1.action = 'sent_weekly_digest' THEN e2.user_id ELSE NULL END) AS weekly_opens,
		COUNT(CASE e1.action = 'sent_weekly_digest' THEN e3.user_id ELSE NULL END) AS weekly_click_through,
		COUNT(CASE e1.action = 'sent_reengagement_email' THEN e1.user_id ELSE NULL END) AS weekly_retain_email,
		COUNT(CASE e1.action = 'sent_reengagement_email' THEN e2.user_id ELSE NULL END) AS weekly_retain_opens,
		COUNT(CASE e1.action = 'sent_reengagement_email' THEN e3.user_id ELSE NULL END) AS weekly_retain_click_through
	FROM (
		test_email_events e1 
		LEFT JOIN test_email_events e2
		ON e2.user_id = e1.user_id AND e2.occurred_at > e1.occurred_at AND e2.occurred_at <= e1.occurred_at + INTERVAL '5 MINUTE' AND e2.action = 'email_open'
		LEFT JOIN test_email_events e3
		ON e3.user_id = e2.user_id AND e3.occurred_at > e2.occurred_at AND e3.occurred_at <= e2.occurred_at + INTERVAL '5 MINUTE' AND e3.action = 'email_clickthrough'
	    )
	WHERE e1.occurred_at >= '2014-06-01' AND e1.occurred_at <= '2014-09-01' AND e1.action IN ('sent_weekly_digest', 'sent_reengagement_email')
	GROUP BY 1
	) sub
ORDER BY 1

/*
After investigation, it appears that the problem has to do with mobile use and digest emails. The intended action here should be clear: notify the head of 
product (who approached you in the first place) that the problem is localized in these areas and that it’s worth checking to make sure something isn’t broken or poorly implemented. 
It’s not clear from the data exactly what the problem is or how it should be solved, but the above work can save other teams a lot of time in figuring out where to look.

the weekly_digest email seems less and less attractive to the non-fan users. however, the reengagement email seems very attractive to those target users.
*/











