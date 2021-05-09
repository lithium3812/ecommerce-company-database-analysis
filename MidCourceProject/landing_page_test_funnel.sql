/*
Funnel analysis of conversion from each of the 2 test landng pages /home and /lander-1 to orders.
Test period is Jun 19 - Jul 28
*/

-- Check all steps from landing to order
SELECT DISTINCT wp.pageview_url 
FROM website_pageviews AS wp
INNER JOIN website_sessions AS ws
ON wp.website_session_id = ws.website_session_id
WHERE wp.created_at > '2012-06-19'
    AND wp.created_at < '2012-07-29'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand';

-- Result 1
-- Sessions at each stage of conversion for each of the 2 test landing pages
-- Use marking created in the subquery to count sessions at each stage
SELECT
    wp.pageview_url,
    COUNT(pages_reached.website_session_id) AS sessions,
    COUNT(CASE WHEN products_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS to_products,
    COUNT(CASE WHEN mrfuzzy_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(CASE WHEN cart_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS to_cart,
    COUNT(CASE WHEN shipping_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS to_shipping,
    COUNT(CASE WHEN billing_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS to_billing,
    COUNT(CASE WHEN thankyou_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS to_thankyou
FROM (
		-- Marking pages reached in each session
		SELECT
			wp.website_session_id,
			MIN(wp.website_pageview_id) AS landing_pageview_id,
			MAX(CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END) AS products_page,
			MAX(CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS mrfuzzy_page,
			MAX(CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END) AS cart_page,
			MAX(CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END) AS shipping_page,
			MAX(CASE WHEN wp.pageview_url = '/billing' THEN 1 ELSE 0 END) AS billing_page,
			MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thankyou_page
		FROM website_pageviews AS wp
		INNER JOIN website_sessions AS ws
		ON wp.website_session_id = ws.website_session_id
		WHERE wp.created_at > '2012-06-19'
			AND wp.created_at < '2012-07-29'
			AND ws.utm_source = 'gsearch'
			AND ws.utm_campaign = 'nonbrand'
		GROUP BY wp.website_session_id
	) AS pages_reached
INNER JOIN website_pageviews AS wp
ON pages_reached.landing_pageview_id = wp.website_pageview_id
GROUP BY wp.pageview_url;

-- Result 2
-- Click rate at each stage
SELECT
    wp.pageview_url,
    COUNT(CASE WHEN products_page = 1 THEN pages_reached.website_session_id ELSE NULL END)/COUNT(pages_reached.website_session_id) AS lander_click_rt,
    COUNT(CASE WHEN mrfuzzy_page = 1 THEN pages_reached.website_session_id ELSE NULL END)/COUNT(CASE WHEN products_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS products_click_rt,
    COUNT(CASE WHEN cart_page = 1 THEN pages_reached.website_session_id ELSE NULL END)/COUNT(CASE WHEN mrfuzzy_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    COUNT(CASE WHEN shipping_page = 1 THEN pages_reached.website_session_id ELSE NULL END)/COUNT(CASE WHEN cart_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS cart_click_rt,
    COUNT(CASE WHEN billing_page = 1 THEN pages_reached.website_session_id ELSE NULL END)/COUNT(CASE WHEN shipping_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS shipping_click_rt,
    COUNT(CASE WHEN thankyou_page = 1 THEN pages_reached.website_session_id ELSE NULL END)/COUNT(CASE WHEN billing_page = 1 THEN pages_reached.website_session_id ELSE NULL END) AS billing_click_rt
FROM (
		-- Marking pages reached in each session
		SELECT
			wp.website_session_id,
			MIN(wp.website_pageview_id) AS landing_pageview_id,
			MAX(CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END) AS products_page,
			MAX(CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS mrfuzzy_page,
			MAX(CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END) AS cart_page,
			MAX(CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END) AS shipping_page,
			MAX(CASE WHEN wp.pageview_url = '/billing' THEN 1 ELSE 0 END) AS billing_page,
			MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thankyou_page
		FROM website_pageviews AS wp
		INNER JOIN website_sessions AS ws
		ON wp.website_session_id = ws.website_session_id
		WHERE wp.created_at > '2012-06-19'
			AND wp.created_at < '2012-07-29'
			AND ws.utm_source = 'gsearch'
			AND ws.utm_campaign = 'nonbrand'
		GROUP BY wp.website_session_id
	) AS pages_reached
INNER JOIN website_pageviews AS wp
ON pages_reached.landing_pageview_id = wp.website_pageview_id
GROUP BY wp.pageview_url;