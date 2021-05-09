/*
Clickthrough rate from /products page also by product
Comapre results during 3 month before and after the new product launch on January 6th, 2013
Request: April 6th, 2013
*/

/*----------------- Solution 1 --------------------*/

-- Relevant sessions; in the target time period and hit /products page
CREATE TEMPORARY TABLE sessions_reached_product_pg
SELECT
    website_session_id,
    pageview_url
FROM website_pageviews
WHERE created_at > '2012-10-06'
    AND created_at < '2013-04-06'
    AND pageview_url = '/products';

-- See what are pages after /products
SELECT DISTINCT pageview_url
FROM website_pageviews
WHERE website_session_id IN (
							 SELECT website_session_id FROM sessions_reached_product_pg
							);
-- Page of each product: /the-original-mr-fuzzy /the-forever-love-bear

-- Simply count each and combined cases 
SELECT
    CASE
        WHEN created_at < '2013-01-06' THEN 'before_product2'
        ELSE 'after_product2'
	END AS time_period,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(CASE WHEN pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear') THEN website_session_id ELSE NULL END) AS w_next_pg,
    COUNT(CASE WHEN pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear') THEN website_session_id ELSE NULL END)/
        COUNT(DISTINCT website_session_id) AS pct_w_next_pg,
    COUNT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/
        COUNT(DISTINCT website_session_id) AS pct_to_mrfuzzy,
    COUNT(CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_love_bear,
    COUNT(CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/
        COUNT(DISTINCT website_session_id) AS pct_to_love_bear
FROM website_pageviews
WHERE website_session_id IN (
							 SELECT website_session_id FROM sessions_reached_product_pg
							)
GROUP BY time_period
ORDER BY time_period DESC;


/*------------------ Solution 2 --------------------*/

-- Sessions and which product's page it visited. NULL if it left at /products page
DROP TEMPORARY TABLE IF EXISTS next_pageviews;
CREATE TEMPORARY TABLE next_pageviews
SELECT
    product_pages.website_session_id,
    product_pages.time_period,
    MIN(wp.website_pageview_id) AS next_pageview_id
FROM (
		-- ID of /product pages in the relevant time period
		SELECT
			website_pageview_id,
			website_session_id,
			CASE
				WHEN created_at < '2013-01-06' THEN 'before_product2'
				ELSE 'after_product2'
			END AS time_period
		FROM website_pageviews
		WHERE created_at BETWEEN '2012-10-06' AND '2013-04-06'
			AND pageview_url = '/products'
	 ) AS product_pages
LEFT JOIN website_pageviews AS wp
ON product_pages.website_session_id = wp.website_session_id
    AND product_pages.website_pageview_id < wp.website_pageview_id
GROUP BY
    product_pages.website_session_id,
    product_pages.time_period;

-- Case by next page's URL and group by time period    
SELECT
    time_period,
    COUNT(website_session_id) AS sessions,
    COUNT(CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) AS click_to_next,
    COUNT(CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END)/COUNT(website_session_id) AS click_through_rate,
    COUNT(CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/COUNT(website_session_id) AS pct_to_mrfuzzy,
    COUNT(CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_love_bear,
    COUNT(CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/COUNT(website_session_id) AS pct_to_love_bear
FROM(
     -- Attach pageview_url to next_pageview temporary table
	 SELECT
		 next_pageviews.website_session_id,
		 next_pageviews.time_period,
		 wp.pageview_url AS next_pageview_url
	 FROM next_pageviews
	 LEFT JOIN website_pageviews AS wp
		 ON next_pageviews.next_pageview_id = wp.website_pageview_id
	) AS product_page_behaviour
GROUP BY time_period;


/*    Failed solution - failed since sometimes website_pageview_id is not incremental

-- Sessions and which product's page it visited. NULL if it left at /products page
SELECT
    product_pages.website_session_id,
    product_pages.time_period,
    wp.pageview_url AS which_product_page
FROM (
		-- ID of /product pages in the relevant time period
		SELECT
			website_pageview_id,
			website_session_id,
			CASE
				WHEN created_at < '2013-01-06' THEN 'before_product2'
				ELSE 'after_product2'
			END AS time_period
		FROM website_pageviews
		WHERE created_at BETWEEN '2012-10-06' AND '2013-04-06'
			AND pageview_url = '/products'
	 ) AS product_pages
LEFT JOIN website_pageviews AS wp
    ON product_pages.website_session_id = wp.website_session_id
    AND wp.website_pageview_id = product_pages.website_pageview_id + 1; -- Pull the page ID of the next page after /products
*/