/*
Table1 : Users (test_user)
this table includes one row per user, with despriptive information about that user's account
user_id    : A unique ID per user. can be joined to user_id in either of the tables
created_at : the time the sser was created (first signed up)   
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

-- by visualizing the above data, we can see a dramatic drop in user engagement after 2014-07-28. 
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
Broken tracking code:          It’s possible that the code that logs events is, itself, broken. If you see a drop to absolutely zero events of a certain 
                               type and you rule out a broken feature, then this is a possibility.
Traffic anomalies from bots:   Most major website see a lot of activity from bots. A change in the product or infrastructure that might make it harder for 
                               bots to interact with the site could decrease engagement (assuming bots look like real users). This is tricky to determine 
                               because you have to identify bot-like behavior through patterns or specific events.
Traffic shutdown to your site: It is possible for internet service providers to block your site. This is pretty rare for professional applications, but 
                               nevertheless possible.
Marketing event:               A Super Bowl ad, for example, might cause a massive spike in sign-ups for the product. But users who enter through one-time 
                               marketing blitzes often retain at lower rates than users who are referred by friends, for example. Because the chart uses a 
                               rolling 7-day period, this will register as high engagement for one week, then almost certainly look like a big drop in engagement 
                               the following week. Most often, the best way to determine this is to simply ask someone in the Marketing department if anything big 
                               happened recently.
Bad data:                      There are lots of ways to log bad data. For example, most large web apps separate their QA data from production data. One way or 
                               another, QA data can make its way into the production database. This is not likely to be the problem in this particular case, as it 
                               would likely show up as additional data logged from very few users.
Search crawler changes:        For a website that receives a lot of traffic, changes in the way search engines index them could cause big swings in traffic.


*/







