/*
Monthly trends of gsearch-nonbrand sessions for each device type
*/

SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(CASE WHEN ws.device_type = 'mobile' THEN ws.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(CASE WHEN ws.device_type = 'desktop' THEN ws.website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(CASE WHEN ws.device_type = 'mobile' THEN o.order_id ELSE NULL END) AS mobile_orders,
    COUNT(CASE WHEN ws.device_type = 'desktop' THEN o.order_id ELSE NULL END) AS desktop_orders
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-11-27'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY 
    year, 
    month;