/*
CVR of 'gsearch nonbrand' according to device type
*/
SELECT
    ws.device_type,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders,
    COUNT(o.order_id)/COUNT(ws.website_session_id) AS session_to_order_cvr
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-05-11'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY ws.device_type;