/*
Monthly trends of the click through rate from /products page and CVR from /products page to order
*/

-- Sessions that reached /products page and their next page view
CREATE TEMPORARY TABLE product_pageviews
SELECT
    products_sessions.website_session_id,
    products_sessions.created_at,
    MIN(wp.website_pageview_id) AS next_pageview_id
FROM (
		-- Sessions that reached /products page
		SELECT *
		FROM website_pageviews
		WHERE pageview_url = '/products'
	) AS products_sessions
LEFT JOIN website_pageviews AS wp
ON products_sessions.website_session_id = wp.website_session_id
    AND products_sessions.website_pageview_id < wp.website_pageview_id
GROUP BY products_sessions.website_session_id, products_sessions.created_at;

SELECT
	YEAR(pp.created_at) AS yr,
    MONTH(pp.created_at) AS mt,
    COUNT(pp.next_pageview_id)/COUNT(pp.website_session_id) AS clickthrough_rt,
    COUNT(o.order_id)/COUNT(pp.website_session_id) AS cvr
FROM product_pageviews AS pp
LEFT JOIN orders AS o
ON pp.website_session_id = o.website_session_id
GROUP BY yr, mt;

-- When each product was introduced
SELECT * FROM products;
-- 2: 2013-01-06
-- 3: 2013-12-12
-- 4: 2014-02-05

/*				Conclusion				*/
-- Introduction of new products clearly correlates with the improvement of CTR and CVR.