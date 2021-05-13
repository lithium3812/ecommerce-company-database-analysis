/*
Monthly trends of all channels
*/

-- See all unique sources
SELECT DISTINCT 
    utm_source,
    utm_campaign,
    http_referer
FROM website_sessions 
WHERE created_at < '2012-11-27';

-- Count sessions according to 
-- gsearch, bsearch, organic (no tracking, coming from search engine), direct (no tracking, direct coming from direct type-in)
SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(CASE WHEN ws.utm_source = 'gsearch' THEN ws.website_session_id ELSE NULL END) AS gsearch_paid_sessions,
    COUNT(CASE WHEN ws.utm_source = 'bsearch' THEN ws.website_session_id ELSE NULL END) AS bsearch_paid_sessions,
    COUNT(CASE WHEN ws.utm_source IS NULL AND http_referer IS NOT NULL THEN ws.website_session_id ELSE NULL END) AS organic_search_sessions,
    COUNT(CASE WHEN ws.utm_source IS NULL AND http_referer IS NULL THEN ws.website_session_id ELSE NULL END) AS direct_sessions
FROM website_sessions AS ws
LEFT JOIN orders AS o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-11-27'
GROUP BY 
    year, 
    month;