/*
Average website traffic volume by hour of day for each day of week
During Sep 15 - Nov 15, 2012
*/

-- Take average of session volume pulled in the subquery
SELECT
    hr,
    ROUND(AVG(CASE WHEN weekday = 0 THEN sessions ELSE NULL END), 1) AS 'mon',
    ROUND(AVG(CASE WHEN weekday = 1 THEN sessions ELSE NULL END), 1) AS 'tue',
    ROUND(AVG(CASE WHEN weekday = 2 THEN sessions ELSE NULL END), 1) AS 'wed',
    ROUND(AVG(CASE WHEN weekday = 3 THEN sessions ELSE NULL END), 1) AS 'thu',
    ROUND(AVG(CASE WHEN weekday = 4 THEN sessions ELSE NULL END), 1) AS 'fri',
    ROUND(AVG(CASE WHEN weekday = 5 THEN sessions ELSE NULL END), 1) AS 'sat',
    ROUND(AVG(CASE WHEN weekday = 6 THEN sessions ELSE NULL END), 1) AS 'sun'
FROM (
		-- Count sessions for each date and hour
		SELECT
			DATE(created_at) AS date,
			WEEKDAY(created_at) AS weekday,
			HOUR(created_at) AS hr,
			COUNT(website_session_id) AS sessions
		FROM website_sessions
		WHERE created_at BETWEEN '2012-09-15' AND '2012-11-16'
		GROUP BY
			date,
			weekday,
			hr
	) AS daily_hourly_sessions
GROUP BY hr
ORDER BY hr;