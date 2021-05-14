/*
quarterly view of orders from Gsearch nonbrand, Bsearch nonbrand, brand search overall, organic search, and direct type-in
*/

SELECT
    YEAR(o.created_at) AS year,
    QUARTER(o.created_at) AS quarter,
    COUNT(CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS 'gsearch_nonbrand',
    COUNT(CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS 'bsearch_nonbrand',
    COUNT(CASE WHEN utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS 'brand_search',
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN o.order_id ELSE NULL END) AS 'organic_search',
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN o.order_id ELSE NULL END) AS 'direct_typein'
FROM website_sessions AS ws
INNER JOIN orders AS o
ON ws.website_session_id = o.website_session_id
GROUP BY year, quarter;

/*----------------- Conclusion -----------------
In the 2nd quarter of 2012, the ratio of nonbrand session volume to that of brand search was about 6:1.
At the end, this ratio is about 2:1. This means we are much less dependent on paid marketing campaigns.
------------------------------------------------*/