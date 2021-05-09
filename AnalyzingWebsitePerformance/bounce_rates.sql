/*
Bounce rate of sessions landing on homepage
*/

DROP TEMPORARY TABLE IF EXISTS landing_pages;
DROP TEMPORARY TABLE IF EXISTS landing_pages_home;
DROP TEMPORARY TABLE IF EXISTS bounced_sessions;

-- Sessions and their landing pages
CREATE TEMPORARY TABLE landing_pages
SELECT
    website_session_id,
    MIN(website_pageview_id) AS landing_page_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

-- Attach landing page URLs to the above table
CREATE TEMPORARY TABLE landing_pages_home
SELECT
    lp.website_session_id,
    lp.landing_page_id,
    wp.pageview_url
FROM landing_pages AS lp
INNER JOIN website_pageviews AS wp
ON lp.landing_page_id = wp.website_pageview_id
where wp.pageview_url = '/home';

-- Sessions with only one viewed page
CREATE TEMPORARY TABLE bounced_sessions
SELECT
    lph.website_session_id,
    lph.pageview_url,
    COUNT(wp.website_pageview_id) AS pages_viewed
FROM landing_pages_home AS lph
INNER JOIN website_pageviews AS wp
ON lph.website_session_id = wp.website_session_id
GROUP BY 
    lph.website_session_id,
    lph.pageview_url
HAVING COUNT(wp.website_pageview_id) = 1;

-- Count all sessions and bounced sessions
SELECT
    COUNT(wp.website_session_id) AS sessions,
    COUNT(bs.website_session_id) AS bounced_sessions,
    COUNT(wp.website_session_id)/COUNT(wp.website_session_id) AS bounce_rate
FROM website_pageviews AS wp
LEFT JOIN bounced_sessions AS bs
ON wp.website_session_id = bs.website_session_id;

/*
CREATE TEMPORARY TABLE pages_sessions
SELECT
    wp1.website_session_id,
    wp1.pageview_url,
    COUNT(wp2.website_pageview_id) AS pages_viewed
FROM website_pageviews AS wp1
INNER JOIN website_pageviews AS wp2
ON wp1.website_session_id = wp2.website_session_id
WHERE wp1.created_at < '2012-06-14'
    AND wp1.pageview_url = '/home'
GROUP BY wp1.website_session_id;

SELECT
    COUNT(website_session_id) AS sessions,
    COUNT(CASE WHEN pages_viewed = 1 THEN website_session_id ELSE NULL END) AS bounced_sessions,
    COUNT(CASE WHEN pages_viewed = 1 THEN website_session_id ELSE NULL END)/COUNT(website_session_id) AS bounce_rate
FROM pages_sessions;
*/