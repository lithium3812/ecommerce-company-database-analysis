/*
Top landing pages
*/

-- First page of each website session
CREATE TEMPORARY TABLE entry_pages
SELECT
    website_session_id,
    MIN(website_pageview_id) AS entry_page_id
FROM website_pageviews
GROUP BY website_session_id;

SELECT
    wp.pageview_url,
    COUNT(ep.website_session_id) AS sessions
FROM entry_pages AS ep
INNER JOIN website_pageviews AS wp
ON ep.entry_page_id = wp.website_pageview_id
WHERE created_at < '2012-06-12'
GROUP BY wp.pageview_url
ORDER BY sessions DESC;