/*
Compare session-to-order CVR, AOV, products per order, and revenue per session
of the month before and after he 3rd product Birthday Bear was introduced (December 12, 2013)
*/

SELECT
    CASE
        WHEN ws.created_at < '2013-12-12' THEN 'pre_birthday_bear'
        ELSE 'post_birthday_bear'
	END AS time_period,
    COUNT(CASE WHEN o.order_id IS NOT NULL THEN ws.website_session_id ELSE NULL END)/COUNT(ws.website_session_id) AS cvr,
    AVG(o.price_usd) AS aov,
    AVG(o.items_purchased) AS products_per_order,
    SUM(o.price_usd)/COUNT(ws.website_session_id) AS revenue_per_session
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY time_period;