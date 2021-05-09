/*
Funnel analysis of traffic from /lander-1 via gsearch-nonbrand
Data from August 5th to September 5th
*/

DROP TEMPORARY TABLE IF EXISTS relevant_sessions;
DROP TEMPORARY TABLE IF EXISTS stages;

-- All sessions landing at /lander-1
CREATE TEMPORARY TABLE lander1_sessions
SELECT website_session_id
FROM website_pageviews
WHERE website_pageview_id IN (
							  SELECT MIN(website_pageview_id) FROM website_pageviews
							  GROUP BY website_session_id
							 )
    AND pageview_url = '/lander-1';

-- All sessions and their URLs of relevant period and source
CREATE TEMPORARY TABLE relevant_sessions
SELECT
    wp.website_pageview_id,
    wp.website_session_id,
    wp.pageview_url
FROM website_pageviews AS wp
INNER JOIN website_sessions AS ws
ON wp.website_session_id = ws.website_session_id
WHERE ws.created_at BETWEEN '2012-08-05' AND '2012-09-05'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
    AND wp.website_session_id IN (SELECT website_session_id FROM lander1_sessions);

-- See what is each page   
SELECT DISTINCT pageview_url FROM relevant_sessions;

-- Sessions and which stage they reached
CREATE TEMPORARY TABLE stages
SELECT
    website_session_id,
    MAX(products) AS to_products,
    MAX(mrfuzzy) AS to_mrfuzzy,
    MAX(cart) AS to_cart,
    MAX(shipping) AS to_shipping,
    MAX(billing) AS to_billing,
    MAX(thankyou) AS to_thankyou
FROM (
		-- Flag steps
		SELECT
			*,
			CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products,
			CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy,
			CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart,
			CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping,
			CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing,
            CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou
		FROM relevant_sessions
	) AS page_flags
GROUP BY website_session_id;


-- Count sessions remained at each stage
SELECT
    COUNT(website_session_id) AS sessions,
    SUM(to_products) AS to_products,
    SUM(to_mrfuzzy) AS to_mrfuzzy,
    SUM(to_cart) AS to_cart,
    SUM(to_shipping) AS to_shipping,
    SUM(to_billing) AS to_billing,
    SUM(to_thankyou) AS to_thankyou
FROM stages;

-- Rates to go through each stage
SELECT
    SUM(to_products)/COUNT(website_session_id) AS lander_click_rt,
    SUM(to_mrfuzzy)/SUM(to_products) AS products_click_rt,
    SUM(to_cart)/SUM(to_mrfuzzy) AS mrfuzzy_click_rt,
    SUM(to_shipping)/SUM(to_cart) AS cart_click_rt,
    SUM(to_billing)/SUM(to_shipping) AS billing_click_rt,
    SUM(to_thankyou)/SUM(to_billing) AS shipping_click_rt
FROM stages;