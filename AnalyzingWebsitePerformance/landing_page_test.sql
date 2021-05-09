/*
50/50 test of 2 landing pages /home and /lander-1 for 'gsearch-nonbrand' traffics
Compare bounce rate of 2 landing pages
Sessions only after /lander-1 introduced have to be compared
*/

DROP TEMPORARY TABLE IF EXISTS first_lander1;
DROP TEMPORARY TABLE IF EXISTS landing_pages;
DROP TEMPORARY TABLE IF EXISTS landing_page_urls;

-- The date when /lander-1 is introduced and the test began
CREATE TEMPORARY TABLE first_lander1
SELECT
    created_at AS first_created_at,
    website_pageview_id AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
ORDER BY created_at
LIMIT 1;

-- Sessions and their landing page ID in the proper period
CREATE TEMPORARY TABLE landing_pages
SELECT
	wp.website_session_id,
	MIN(wp.website_pageview_id) AS landing_page_id
FROM website_pageviews AS wp
INNER JOIN website_sessions AS ws
ON wp.website_session_id = ws.website_session_id
WHERE wp.created_at BETWEEN (SELECT first_created_at FROM first_lander1) AND '2012-07-28'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY wp.website_session_id;

-- Select out only sessions starting at /home or /lander-1 from the previous table
CREATE TEMPORARY TABLE landing_page_urls
SELECT
    lp.website_session_id,
    lp.landing_page_id,
    wp.pageview_url AS landing_page_url
FROM website_pageviews AS wp
INNER JOIN landing_pages AS lp
ON lp.landing_page_id = wp.website_pageview_id
WHERE wp.pageview_url IN ('/home', '/lander-1');

-- Count and compare all sessions and bounced sessions
SELECT
    landing_page_url,
    COUNT(website_session_id) AS sessions,
    COUNT(CASE WHEN viewed_pages = 1 THEN website_session_id ELSE NULL END) AS bounced_sessions,
    COUNT(CASE WHEN viewed_pages = 1 THEN website_session_id ELSE NULL END)/COUNT(website_session_id) AS bounce_rate
FROM (
    -- Count viewed pages of each session
	SELECT
		lpu.website_session_id,
		lpu.landing_page_url,
		COUNT(wp.website_pageview_id) AS viewed_pages
	FROM landing_page_urls AS lpu
	INNER JOIN website_pageviews AS wp
	ON lpu.website_session_id = wp.website_session_id
	GROUP BY 
		lpu.website_session_id,
		lpu.landing_page_url
	) AS pages_per_session
GROUP BY landing_page_url;