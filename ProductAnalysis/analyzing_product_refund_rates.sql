/*
Monthly product refund rates by product
Note: There was a quality issue in products and it was supposedly fixed on September 16, 2014
*/

-- See the list of products
SELECT DISTINCT product_id
FROM order_items
WHERE created_at < '2014-10-15';
-- 1, 2, 3, 4

-- Orders and refund rates
SELECT
    YEAR(oi.created_at) AS year,
    MONTH(oi.created_at) AS month,
    COUNT(CASE WHEN oi.product_id = 1 THEN oi.order_item_id ELSE NULL END) AS p1_orders,
    COUNT(CASE WHEN oi.product_id = 1 THEN r.order_item_refund_id ELSE NULL END)/
        COUNT(CASE WHEN oi.product_id = 1 THEN oi.order_item_id ELSE NULL END) AS p1_refund_rt,
	COUNT(CASE WHEN oi.product_id = 2 THEN oi.order_item_id ELSE NULL END) AS p2_orders,
    COUNT(CASE WHEN oi.product_id = 2 THEN r.order_item_refund_id ELSE NULL END)/
        COUNT(CASE WHEN oi.product_id = 2 THEN oi.order_item_id ELSE NULL END) AS p2_refund_rt,
	COUNT(CASE WHEN oi.product_id = 3 THEN oi.order_item_id ELSE NULL END) AS p3_orders,
    COUNT(CASE WHEN oi.product_id = 3 THEN r.order_item_refund_id ELSE NULL END)/
        COUNT(CASE WHEN oi.product_id = 3 THEN oi.order_item_id ELSE NULL END) AS p3_refund_rt,
	COUNT(CASE WHEN oi.product_id = 4 THEN oi.order_item_id ELSE NULL END) AS p4_orders,
    COUNT(CASE WHEN oi.product_id = 4 THEN r.order_item_refund_id ELSE NULL END)/
        COUNT(CASE WHEN oi.product_id = 4 THEN oi.order_item_id ELSE NULL END) AS p4_refund_rt
FROM order_items AS oi
LEFT JOIN order_item_refunds AS r
ON oi.order_item_id = r.order_item_id
WHERE oi.created_at < '2014-10-15'
GROUP BY year, month;
    