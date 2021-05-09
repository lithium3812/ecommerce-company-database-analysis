/*
CTR from /cart page, average products per order, AOV, and revenue per /cart page 
of the month before and the month after cross-selling was introduced (September 25, 2013)
Request: November 22
*/

SELECT
    CASE
        WHEN cart_sessions.created_at < '2013-09-25' THEN 'pre_cross_sell' 
        ELSE 'post_cross_sell' 
	END AS time_period,
    COUNT(cart_sessions.website_session_id) AS sessions,
    COUNT(CASE WHEN cart_sessions.next_pageview_id IS NOT NULL THEN cart_sessions.website_session_id ELSE NULL END) AS clickthroughs,
    COUNT(CASE WHEN cart_sessions.next_pageview_id IS NOT NULL THEN cart_sessions.website_session_id ELSE NULL END)/
        COUNT(cart_sessions.website_session_id) AS cart_ctr,
    AVG(o.items_purchased) AS products_per_order,
    AVG(o.price_usd) AS aov,
    SUM(o.price_usd)/COUNT(cart_sessions.website_session_id) AS rev_per_cart_sessions
FROM (
		-- Relevant session that reached /cart in the target period, and the next page's website_pageview_id
		SELECT
			wp1.website_session_id,
			wp1.created_at,
			MIN(wp2.website_pageview_id) AS next_pageview_id
		FROM website_pageviews AS wp1
		LEFT JOIN website_pageviews AS wp2
		ON wp1.website_session_id = wp2.website_session_id
			AND wp1.website_pageview_id < wp2.website_pageview_id
		WHERE wp1.created_at BETWEEN '2013-08-25' AND '2013-10-25'
			AND wp1.pageview_url = '/cart'
		GROUP BY wp1.website_session_id, wp1.created_at
	) AS cart_sessions
LEFT JOIN orders AS o
ON cart_sessions.website_session_id = o.website_session_id
GROUP BY time_period;