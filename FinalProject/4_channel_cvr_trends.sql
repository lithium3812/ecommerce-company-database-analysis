/*
Quarterly session-to-order CVR by channel
*/

SELECT
    YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
    COUNT(CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END)/
        COUNT(CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END)AS 'gsearch_nonbrand',
    COUNT(CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END)/
        COUNT(CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END) AS 'bsearch_nonbrand',
    COUNT(CASE WHEN utm_campaign = 'brand' THEN o.order_id ELSE NULL END)/
        COUNT(CASE WHEN utm_campaign = 'brand' THEN ws.website_session_id ELSE NULL END) AS 'brand_search',
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN o.order_id ELSE NULL END)/
        COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN ws.website_session_id ELSE NULL END) AS 'organic_search',
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN o.order_id ELSE NULL END)/
        COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN ws.website_session_id ELSE NULL END) AS 'direct_typein'
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
GROUP BY year, quarter;

/*			Conclusion			*/
-- It can be seen there was a major improvement of CVR in all channels in the 1st quarter of 2013.