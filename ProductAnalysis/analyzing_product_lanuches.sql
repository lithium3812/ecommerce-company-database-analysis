/*
Monthly trends of order volume, overall conversion rates, revenue per session, sales by product
Period: April 1, 2012 - April 4, 2013
Note: New product is launched on January 6th
*/

SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(o.order_id) AS orders,
    COUNT(o.order_id)/COUNT(ws.website_session_id) AS cvr,
    ROUND(SUM(o.price_usd)/COUNT(ws.website_session_id), 2) AS revenue_per_session,
    COUNT(CASE WHEN o.primary_product_id = 1 THEN o.order_id ELSE NULL END) AS orders_product1,
    COUNT(CASE WHEN o.primary_product_id = 2 THEN o.order_id ELSE NULL END) AS orders_product2
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at BETWEEN '2012-04-01' AND '2013-04-05'
GROUP BY
    year,
    month;