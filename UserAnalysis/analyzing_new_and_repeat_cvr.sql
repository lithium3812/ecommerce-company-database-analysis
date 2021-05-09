/*
Comaparison of the new and repeat sessions by CVR and revenue per session
Data: 2014 - November 8, 2014
*/

SELECT
    ws.is_repeat_session,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id)/COUNT(ws.website_session_id) AS cvr,
    SUM(o.price_usd)/COUNT(ws.website_session_id) AS rev_per_session
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at BETWEEN '2014-01-01' AND '2014-11-08'
GROUP BY ws.is_repeat_session;