/*
Weekely trends of traffic volume from each channel: paid brand search, direct type-in, organic search
Percentage fo them to paid search nonbrand
Request: on December 23th
*/

SELECT
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
    COUNT(CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS brand,
    COUNT(CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END)/
        COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS brand_pct_to_nonbrand,
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) AS direct,
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END)/
        COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS direct_pct_to_nonbrand,
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END) AS organic,
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END)/
        COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS organic_pct_to_nonbrand
FROM website_sessions
WHERE created_at < '2012-12-23'
GROUP BY 
    year,
    month;