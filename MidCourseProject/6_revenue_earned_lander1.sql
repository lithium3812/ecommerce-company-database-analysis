/*
Revenues earned by gsearch landing page test (Jun 19 - Jul 28)
*/

-- Find when the first session with /lander-1
SELECT
    MIN(website_session_id) AS first_session_w_lander1,
    MIN(created_at) AS first_lander1_observed_at
FROM website_pageviews
WHERE pageview_url = '/lander-1';
-- session_id = 11683

-- Session to order conversion rate of /home and /lander-1 during the test
SELECT
    test_sessions.landing_page,
    COUNT(test_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders,
    COUNT(orders.order_id)/COUNT(test_sessions.website_session_id) AS conv_rt
FROM (
		-- Figure out relevant gsearch-nonbrand sessions during the test
		SELECT
			wp.website_session_id,
			wp.created_at,
			wp.pageview_url AS landing_page
		FROM website_pageviews AS wp
		INNER JOIN website_sessions AS ws
		ON wp.website_session_id = ws.website_session_id
		WHERE wp.website_session_id >= 11683
			AND wp.created_at < '2012-07-29'
			AND ws.utm_source = 'gsearch'
			AND ws.utm_campaign = 'nonbrand'
			AND wp.pageview_url IN ('/home', '/lander-1')
	) AS test_sessions
LEFT JOIN orders
ON test_sessions.website_session_id = orders.website_session_id
GROUP BY test_sessions.landing_page;
/* ----------     result      ----------- 
   CVR .0322 for /home, vs .0400 for /lander-1 
   => .0078 additional orders per session
-----------------------------------------*/

-- Find when complete transition from /home to /lander-1 is made
SELECT
    MAX(wp.website_session_id) AS last_session_w_home,
    MAX(wp.created_at) AS last_home_observed_at
FROM website_pageviews AS wp
INNER JOIN website_sessions AS ws
ON wp.website_session_id = ws.website_session_id
WHERE wp.pageview_url = '/home'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand';
-- Last time /home appeared for gsearch-nonbrand was 2012-07-29 23:48:16, session_id = 17145

-- Count all sessions after the test till the request (Nov 27)
SELECT COUNT(website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id > 17145
    AND created_at < '2012-11-27'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand';
/* ----------     result      ----------- 
 sessions in about 4 months: 22972
 22972*0.0078 = 180 incremental orders
 180/4 = 45 extra orders/month
-----------------------------------------*/