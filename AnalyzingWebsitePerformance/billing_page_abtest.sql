/*
Billing page AB Test
Compare 2 different billing pages /billing and /billing-2 
by which % of sessions on both pages actually placing an order
There is solution 2 (better one) at the bottom
*/

-- First time /billing-2 is introduced
CREATE TEMPORARY TABLE test_started_date
SELECT
    MIN(website_session_id) AS test_session_id,
    MIN(created_at) AS test_started_at
FROM website_pageviews
WHERE pageview_url = '/billing-2';

-- Figure out session_id that reached billing page, in the proper time period
CREATE TEMPORARY TABLE billing_pageview
SELECT *
FROM website_pageviews
WHERE created_at > (
					SELECT DATE(test_started_at) FROM test_started_date
				   )
    AND created_at < '2012-11-10'
    AND pageview_url IN ('/billing', '/billing-2');


SELECT
    billing_page,
    COUNT(website_session_id) AS sessions,
    SUM(ordered) AS orders,
    SUM(ordered)/COUNT(website_session_id) AS billing_to_order_rt
FROM (
		-- Sessions that reached billing pages and whether customers actually ordered, with which billing page indicated
		SELECT
			wp.website_session_id,
			bp.pageview_url AS billing_page,
			MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS ordered
		FROM website_pageviews AS wp
		INNER JOIN billing_pageview AS bp
		ON wp.website_session_id = bp.website_session_id -- filter out sessions that didn't reach billing pages by inner join
		GROUP BY 
			wp.website_session_id, 
			bp.pageview_url
	) AS order_or_not
GROUP BY billing_page
ORDER BY billing_page;


/*######################################
          Solution 2 (Better)
######################################*/

SELECT
    billing_page_version, 
    COUNT(website_session_id) AS sessions,
    COUNT(order_id) AS orders,
    COUNT(order_id)/COUNT(website_session_id) AS billing_to_order_rt
FROM (
		-- Sessions that reached billing pages in the proper time period, and order_id if exists
		SELECT
			wp.website_session_id,
			wp.pageview_url AS billing_page_version,
			o.order_id -- gives NULL when session doesn't exist in orders table
		FROM website_pageviews AS wp
		LEFT JOIN orders AS o
		ON wp.website_session_id = o.website_session_id
		WHERE wp.created_at > (
							SELECT DATE(test_started_at) FROM test_started_date
						   )
			AND wp.created_at < '2012-11-10'
			AND wp.pageview_url IN ('/billing', '/billing-2')
	) AS sessions_orders
GROUP BY billing_page_version
ORDER BY billing_page_version;