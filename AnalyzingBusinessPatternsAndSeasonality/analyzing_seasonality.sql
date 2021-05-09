/*
2012's monthly and weekely session and order volume
*/

-- Monthly trends
SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE YEAR(ws.created_at) = 2012
GROUP BY
    year,
    month;
    
-- Weekly trends
SELECT
    MIN(DATE(ws.created_at)) AS week_start_date,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE YEAR(ws.created_at) = 2012
GROUP BY WEEK(ws.created_at);