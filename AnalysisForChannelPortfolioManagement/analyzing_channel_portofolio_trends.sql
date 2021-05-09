/*
Weekely trends of session volume for gsearch and bsearch nonbrand for each device type
Show also the percentage of bsearch to gsearch
Data since November 4th to December 21th
*/

SELECT
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS dtop_g_sessions,
    COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS dtop_b_sessions,
    COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END)/
        COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS b_pct_g_dtop,
    COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS mobile_g_sessions,
    COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS mobile_b_sessions,
    COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END)/
        COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS b_pct_g_mobile
FROM website_sessions
WHERE utm_campaign = 'nonbrand'
    AND created_at > '2012-11-04'
    AND created_at < '2012-12-22'
GROUP BY YEARWEEK(created_at);