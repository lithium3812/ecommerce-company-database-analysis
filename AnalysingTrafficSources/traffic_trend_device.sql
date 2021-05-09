/*
Device level monthly trend of sessions via 'gsearch nonbrand'
*/ 
SELECT
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-04-15' AND '2012-06-09'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);