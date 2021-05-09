/*
Conversion funnels from each product page to order for all website traffic
Period: January 6th - April 9th, 2013
*/

-- Pageviews after /products
DROP TEMPORARY TABLE product_to_order_pageviews;
CREATE TEMPORARY TABLE product_to_order_pageviews
SELECT
    product_pages.website_session_id,
    wp.website_pageview_id,
    product_pages.created_at,
    wp.pageview_url
FROM (
        -- Relevant sessions; in the target time period and hit /products page
		SELECT
			website_session_id,
			website_pageview_id,
            created_at,
			pageview_url
		FROM website_pageviews
		WHERE created_at BETWEEN '2013-01-06' AND '2013-04-10'
			AND pageview_url = '/products'
	) AS product_pages
INNER JOIN website_pageviews AS wp -- By INNER JOIN omit all sessions which left at /products page
ON product_pages.website_session_id = wp.website_session_id
    AND product_pages.website_pageview_id < wp.website_pageview_id;

-- Check what are steps after /products
SELECT DISTINCT pageview_url FROM product_to_order_pageviews;

-- Sessions at each stage of conversion
SELECT
    wp.pageview_url,
    COUNT(stages.website_session_id) AS sessions,
    COUNT(CASE WHEN cart = 1 THEN stages.website_session_id ELSE NULL END) AS to_cart,
    COUNT(CASE WHEN shipping = 1 THEN stages.website_session_id ELSE NULL END) AS to_shipping,
    COUNT(CASE WHEN billing = 1 THEN stages.website_session_id ELSE NULL END) AS to_billing,
    COUNT(CASE WHEN thankyou = 1 THEN stages.website_session_id ELSE NULL END) AS to_thankyou
FROM (
		-- pageview_id of page after /products and marking each stage by boolean
		SELECT
			website_session_id,
			MIN(website_pageview_id) AS product_pageview_id,
			MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END) AS cart,
			MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END) AS shipping,
			MAX(CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END) AS billing,
			MAX(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thankyou
		FROM product_to_order_pageviews
		GROUP BY website_session_id
	) AS stages
INNER JOIN website_pageviews AS wp
ON stages.product_pageview_id = wp.website_pageview_id
WHERE wp.pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear')
GROUP BY wp.pageview_url;

-- Click rate at each stage
SELECT
    wp.pageview_url,
    COUNT(CASE WHEN cart = 1 THEN stages.website_session_id ELSE NULL END)/COUNT(stages.website_session_id) AS product_page_click_rt,
    COUNT(CASE WHEN shipping = 1 THEN stages.website_session_id ELSE NULL END)/
        COUNT(CASE WHEN cart = 1 THEN stages.website_session_id ELSE NULL END) AS cart_click_rt,
    COUNT(CASE WHEN billing = 1 THEN stages.website_session_id ELSE NULL END)/
        COUNT(CASE WHEN shipping = 1 THEN stages.website_session_id ELSE NULL END) AS shipping_click_rt,
    COUNT(CASE WHEN thankyou = 1 THEN stages.website_session_id ELSE NULL END)/
        COUNT(CASE WHEN billing = 1 THEN stages.website_session_id ELSE NULL END) AS billing_click_rt
FROM (
		-- pageview_id of page after /products and marking each stage by boolean
		SELECT
			website_session_id,
			MIN(website_pageview_id) AS product_pageview_id,
			MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END) AS cart,
			MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END) AS shipping,
			MAX(CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END) AS billing,
			MAX(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thankyou
		FROM product_to_order_pageviews
		GROUP BY website_session_id
	) AS stages
INNER JOIN website_pageviews AS wp
ON stages.product_pageview_id = wp.website_pageview_id
WHERE wp.pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear')
GROUP BY wp.pageview_url;