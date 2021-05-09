/*
Compare gsearch and bsearch nonbrand by conversion rate from session to order for each device type
Data from August 22 to September 18
*/

SELECT
    ws.device_type,
    ws.utm_source,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders,
    COUNT(o.order_id)/COUNT(ws.website_session_id) AS cvr
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.utm_campaign = 'nonbrand'
    AND ws.created_at > '2012-08-22'
    AND ws.created_at < '2012-09-19'
GROUP BY
    ws.device_type,
    ws.utm_source
ORDER BY ws.device_type;