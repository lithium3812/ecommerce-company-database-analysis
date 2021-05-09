/*
Monthly trends of gsearch sessions for nonbrand and brand campaign
*/

SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(CASE WHEN ws.utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END) AS nonbrand_sessions,
    COUNT(CASE WHEN ws.utm_campaign = 'brand' THEN ws.website_session_id ELSE NULL END) AS brand_sessions,
    COUNT(CASE WHEN ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS nonbrand_orders,
    COUNT(CASE WHEN ws.utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand_orders
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-11-27'
    AND ws.utm_source = 'gsearch'
GROUP BY 
    year, 
    month;