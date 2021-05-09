/*
Weekly bounce rate transition and traffic from /home and /lander-1
*/

DROP TEMPORARY TABLE IF EXISTS home_lander1_sessions;
DROP TEMPORARY TABLE IF EXISTS session_pages;

-- Sessions starting at /home or /lander1
CREATE TEMPORARY TABLE home_lander1_sessions
SELECT
    fp.website_session_id,
    wp.pageview_url AS landing_page_url
FROM website_pageviews AS wp
INNER JOIN (
			SELECT 
				website_session_id,
				MIN(website_pageview_id) AS landing_page_id
			FROM website_pageviews
			GROUP BY website_session_id
		   ) AS fp
ON wp.website_pageview_id = fp.landing_page_id
WHERE wp.pageview_url IN ('/home', '/lander-1');

-- Pages per session since June 1 to August 31, with landing page
CREATE TEMPORARY TABLE session_pages
SELECT
    hls.website_session_id,
    MIN(wp.created_at) AS first_created_at,
    hls.landing_page_url,
    COUNT(wp.website_pageview_id) AS pages_viewed
FROM home_lander1_sessions AS hls
INNER JOIN website_pageviews AS wp
ON hls.website_session_id = wp.website_session_id
WHERE wp.created_at BETWEEN '2012-06-01' AND '2012-08-30'
GROUP BY 
    hls.website_session_id,
    hls.landing_page_url;

-- Pivoting the above table for 'gsearch-nonbrand'
SELECT
    MIN(sp.first_created_at) AS week_start_date,
    COUNT(CASE WHEN sp.pages_viewed = 1 THEN sp.website_session_id ELSE NULL END)/COUNT(sp.website_session_id) AS bounce_rate,
    COUNT(CASE WHEN sp.landing_page_url = '/home' THEN sp.website_session_id ELSE NULL END) AS home_sessions,
    COUNT(CASE WHEN sp.landing_page_url = '/lander-1' THEN sp.website_session_id ELSE NULL END) AS lander_sessions
FROM session_pages AS sp
INNER JOIN website_sessions AS ws
ON sp.website_session_id = ws.website_session_id
WHERE ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY WEEK(first_created_at);