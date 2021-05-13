/*
Monthly trends of gsearch sessions and orders until November 26, 2012
*/

SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-11-27'
    AND ws.utm_source = 'gsearch'
GROUP BY 
    year, 
    month;