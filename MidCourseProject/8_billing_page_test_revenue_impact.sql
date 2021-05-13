/*
Estimate the impact of billing page change in terms of revenue per billing page session
First analyze the revenue lift generated in the test (Sep 10 - Nov 10)
Then pull he number of billing page sessions of the past month till the  request (Nov 27)
And combine and estimate the impact
*/

-- Conversion from billing page to order for each of the 2 test billing pages
SELECT
    wp.pageview_url,
    COUNT(wp.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders,
    COUNT(o.order_id)/COUNT(wp.website_session_id) AS billing_to_order_rt,
    SUM(o.price_usd) AS total_revenue,
    SUM(o.price_usd)/COUNT(wp.website_session_id) AS revenue_per_billing_session
FROM website_pageviews AS wp
LEFT JOIN orders AS o
ON wp.website_session_id = o.website_session_id
WHERE wp.created_at > '2012-09-10'
    AND wp.created_at < '2012-11-11'
    AND wp.pageview_url IN ('/billing', '/billing-2')
GROUP BY wp.pageview_url
ORDER BY wp.pageview_url;
/* ------------------     result      ------------------- 
 Revenue ($): 22.88 for /billing, vs 31.21 for /billing-2 
 => 8.33$ additional revenue per session
---------------------------------------------------------*/

-- Sessions through /billing-2 in the past month
SELECT COUNT(website_session_id)
FROM website_pageviews
WHERE pageview_url IN ('/billing', '/billing-2')
    AND created_at BETWEEN '2012-10-27' AND '2012-11-27';
/* ------------------     result      ------------------- 
 1,193 total billing sessions in the past month
 => 8.33*1193 = 9937.69$ additional revenue if all billing pages had been /billing-2
---------------------------------------------------------*/ 


