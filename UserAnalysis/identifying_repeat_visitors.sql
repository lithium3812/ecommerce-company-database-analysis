/*
How many website visitors come back for another session
Data: 2014 - November 1, 2014
*/

-- Users and number of separate sessions they made in the target time period
DROP TEMPORARY TABLE user_repeat;
CREATE TEMPORARY TABLE user_repeat
SELECT
    first_sessions.user_id,
    COUNT(ws.website_session_id) AS repeat_sessions
FROM (
		-- Users' first website sessions in the target time period
		SELECT 
			user_id,
			website_session_id
		FROM website_sessions
		WHERE YEAR(created_at) = 2014
			AND created_at < '2014-11-01'
			AND is_repeat_session = 0
	) AS first_sessions
LEFT JOIN website_sessions AS ws
ON first_sessions.user_id = ws.user_id
	AND ws.is_repeat_session = 1
	AND YEAR(ws.created_at) = 2014
    AND ws.created_at < '2014-11-01'
GROUP BY first_sessions.user_id;

-- Number of repeated visit and the corresponding number of users
SELECT
    repeat_sessions,
    COUNT(user_id) AS users
FROM user_repeat
GROUP BY repeat_sessions
ORDER BY repeat_sessions;


/*  				Failed Solution					*/

-- This one failed since it also counts repeated sessions which users made their first session before the target period
/*
SELECT
    repeat_sessions,
    COUNT(user_id) AS users
FROM (
		-- Users and number of separate sessions they made
		SELECT
			user_id,
			SUM(is_repeat_session) AS repeat_sessions
		FROM website_sessions
		WHERE YEAR(created_at) = 2014
			AND created_at < '2014-11-01'
		GROUP BY user_id
	) AS user_repeat
GROUP BY repeat_sessions
ORDER BY repeat_sessions;
*/