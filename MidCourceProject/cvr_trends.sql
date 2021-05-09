/*
Monthly trends of session to order conversion rate
*/

SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders,
    COUNT(o.order_id)/COUNT(ws.website_session_id) AS conv_rt
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-11-27'
GROUP BY
    year, 
    month;