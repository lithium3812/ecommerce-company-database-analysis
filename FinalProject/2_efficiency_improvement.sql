/*
Quarterly trends of session-to-order CVR, revenue per order, revenue per session
*/

SELECT
    YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
    COUNT(o.order_id)/COUNT(ws.website_session_id) AS cvr,
    SUM(o.price_usd)/COUNT(o.order_id) AS revenue_per_order,
    SUM(o.price_usd)/COUNT(ws.website_session_id) AS revenue_per_session
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
GROUP BY year, quarter;