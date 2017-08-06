/*
let's say if we want to improve the searching functionality. 
before we really doing so, we should consider if it is worthy to do so.
is there a problem with the current searching fuctionality? where should we improve?

Framing problems simply and correctly can often save time later on. 
Thinking about the ultimate purpose of search right off the bat can make it 
easier to evaluate other parts of them problem. Search, at the most basic level, 
is about helping people find what they’re looking for easily. 
A great search product achieves this quickly and with minimal work on behalf of the user.

To understand whether search is fulfilling that purpose, consider some possibilities:

Search use:                 The first thing to understand is whether anyone even uses search at all
Search frequency:           If users search a lot, it’s likely that they’re getting value out of the 
                            feature ‐ with a major exception. If users search repeatedly within a short 
                            timeframe, it’s likely that they’re refining their terms because they were 
                            unable to find what they wanted initially.
Repeated terms:             A better way to understand the above would be to actually compare similarity 
                            of search terms. That’s much slower and more difficult to actually do than counting 
                            the number of searches a user performs in a short timeframe, so best to ignore this option.
Clickthroughs:              If a user clicks many links in the search results, it’s likely that she isn’t having a great 
                            experience. However, the inverse is not necessarily true—clicking only one result does not imply 
                            a success. If the user clicks through one result, then refines her search, that’s certainly not 
                            a great experience, so search frequency is probably a better way to understand that piece of the 
                            puzzle. Clickthroughs are, however, very useful in determining whether search rankings are good. 
                            If users frequently click low results or scroll to additional pages, then the ranking algorithm 
                            should probably be adjusted.



Autocomplete Clickthroughs: The autocomplete feature is certainly part of the equation, though its success should be measured separately to understand its role.

*/
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
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The criteria above suggest that understanding search on a session by session basis is going to be important for this problem. 
So before seeking to understand whether search is good or bad, it would be wise to define a session for the purposes of this problem, 
both practically and in terms of the data. For the following solution, a session is defined as a string of events logged by a user without 
a 10-minute break between any two events. 
So if a user goes 10 minutes without logging an event, the session is ended and her next engagement will be considered a new session.
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
1. First, take a look at how often people search and whether that changes over time. 
Users take advantage of the autocomplete function more frequently than they actually run searches that take them to the search results page:

*/



SELECT      -- step7. count each kind of actions within the sessions
	DATE.TRUNC('week', z.session_start) as week,
	COUNT(*) AS sessions,
	-- COUNT(CASE z.autocompletes != 0 THEN z.session ELSE NULL END) / COUNT(*)::FLOAT AS with_autocompletes_percentage,
	COUNT(CASE z.autocompletes != 0 THEN z.session ELSE NULL END) AS with_autocompletes,
	-- COUNT(CASE z.runs != 0 THEN z.session ELSE NULL END) / COUNT(*)::FLOAT AS with_runs_percentage,
	COUNT(CASE z.runs != 0 THEN z.session ELSE NULL END) AS with_runs
FROM (
	SELECT      -- step6. count each kind of actions within the sessions
		x.session,
		x.session_start,
		x.user_id,
		COUNT(CASE x.event_name = 'search_autocomplete' THEN x.user_id ELSE NULL END) AS autocompletes,
		COUNT(CASE x.event_name = 'search_run' THEN x.user_id ELSE NULL END) AS runs,
		COUNT(CASE x.event_name LIKE 'search_click_%' THEN x.user_id ELSE NULL END) AS clicks
	FROM (
		SELECT      -- step5. clean the engagement & session information table
			e.*,
			session.session,
			session.session_start
		test_events e      -- step4. connect the engagement information to session information
		LEFT JOIN (
			SELECT      -- step3. select the session related information
				user_id,
				session,
				MIN(occurred_at) AS session_start,
				MAX(occurred_at) AS session_end
			FROM (
				SELECT      -- step2. create the session column
					bounds.*,
					CASE WHEN last_event IS NULL THEN id
				         WHEN last_event > INTERVAL '10 MINUTE'
				         ELSE LAG(id, 1) OVER(PARTITION user_id ORDER BY occurred_at) END AS session 
				FROM (
					SELECT     -- step1. select information and compute the difference between each engagement
						user_id,
						event_type,
						event_name,
						occurred_at,
						occurred_at - LAG(occurred_at, 1) OVER(PARTITION BY user_id ORDER BY occurred_at) AS last_event,
						LEAD(occurred_at, 1) - occurred_at OVER(PARTITION BY user_id ORDER BY occurred_at) AS next_event,
						ROW_NUMBER() OVER() AS id
					FROM test_events e
					WHERE event_type = 'engagement'
					ORDER BY user_id, occurred_at      -- step1 end
				) bounds
				WHERE last_event >= INTERVAL '10 MINUTE' OR last_event IS NULL       -- select the rows of a Session start
				   OR next_event >= INTERVAL '10 MINUTE' OR next_event IS NULL       -- select the rows of a Session end
				-- step2 end, WHERE clause excute before SELECT clause
			) final
			GROUP BY 1, 2      -- step3 end
		) session
		ON e.user_id = session.user_id 
		AND e.occurred_at >= session.session_start
		AND e.occurred_at <= session.session_end
		WHERE e.event_type = 'engagement'      -- WHERE clause excute after JOIN clause and before SELECT clause
		-- step4 end
	) x
	GROUP 1, 2, 3      -- step6 end
) z
GROUP BY 1
ORDER BY 1      -- step7 end

/*
autocomplete gets used in approximately 25% of sessions, while search is only used in 8% or so.
Autocomplete’s 25% use indicates that there is a need for users to find information on their Yammer networks. 
In other words, it’s a feature that people use and is worth some attention.

*/



