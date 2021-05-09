/*
Compare gsearch and bsearch (nonbrand) in terms of the percentage of mobile traffic
Since August 22nd to November 30th
*/

SELECT
    utm_source,
    COUNT(website_session_id) AS sessions,
    COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END)/COUNT(website_session_id)*100 AS mobile_percentage
FROM website_sessions
WHERE created_at > '2012-08-22'
    AND created_at < '2012-11-30'
    AND utm_campaign = 'nonbrand'
GROUP BY utm_source;