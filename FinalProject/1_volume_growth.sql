/*
Session and order volume trends in quarter
*/

-- Check the first and last date recorded
SELECT 
    MIN(created_at),
    MAX(created_at)
FROM website_sessions;
-- 2012-03-19 to 2015-03-19
-- the first and last quarter is incomplete

SELECT
    YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
GROUP BY year, quarter;

/*			Conclusion			*/
-- Session and order volumes are almost constantly growing. Only at the 4th quarter of 2012 a strange boom can be seen.