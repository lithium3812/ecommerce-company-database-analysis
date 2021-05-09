/*
Time between the first and the second sessions, minimum, maximum, average
Data: 2014 - November 3, 2014
*/

-- Days between the first and second website sessions
CREATE TEMPORARY TABLE days_till_second_session
SELECT
    first_sessions.user_id,
    first_sessions.created_at AS first_session_at,
    MIN(ws.created_at) AS second_session_at,
    DATEDIFF(MIN(ws.created_at), first_sessions.created_at) AS days_between
FROM (
		-- Users' first website sessions in the target time period
		SELECT 
			user_id,
			website_session_id,
            created_at
		FROM website_sessions
		WHERE YEAR(created_at) = 2014
			AND created_at < '2014-11-03'
			AND is_repeat_session = 0
	) AS first_sessions
INNER JOIN website_sessions AS ws
ON first_sessions.user_id = ws.user_id
	AND ws.is_repeat_session = 1
	AND YEAR(ws.created_at) = 2014
    AND ws.created_at < '2014-11-03'
GROUP BY first_sessions.user_id, first_sessions.created_at;

SELECT
	AVG(days_between) AS avg_days_till_second_session,
    MIN(days_between) AS min_days_till_second_session,
    MAX(days_between) AS max_days_till_second_session
FROM days_till_second_session;