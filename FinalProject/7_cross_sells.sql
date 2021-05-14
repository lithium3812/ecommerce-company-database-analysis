/*
Cross-sells data since the 4th item became available as a primary product (Dec 5, 2014)
*/

SELECT
    o.primary_product_id,
    COUNT(o.order_id) AS orders,
    COUNT(CASE WHEN i.product_id = 1 THEN o.order_id ELSE NULL END) AS x_sell_pd1,
    COUNT(CASE WHEN i.product_id = 2 THEN o.order_id ELSE NULL END) AS x_sell_pd2,
    COUNT(CASE WHEN i.product_id = 3 THEN o.order_id ELSE NULL END) AS x_sell_pd3,
    COUNT(CASE WHEN i.product_id = 4 THEN o.order_id ELSE NULL END) AS x_sell_pd4,
    COUNT(CASE WHEN i.product_id = 1 THEN o.order_id ELSE NULL END)/COUNT(o.order_id) AS x_sell_pd1_rt,
    COUNT(CASE WHEN i.product_id = 2 THEN o.order_id ELSE NULL END)/COUNT(o.order_id) AS x_sell_pd2_rt,
    COUNT(CASE WHEN i.product_id = 3 THEN o.order_id ELSE NULL END)/COUNT(o.order_id) AS x_sell_pd3_rt,
    COUNT(CASE WHEN i.product_id = 4 THEN o.order_id ELSE NULL END)/COUNT(o.order_id) AS x_sell_pd4_rt
FROM orders AS o
LEFT JOIN order_items AS i
ON o.order_id = i.order_id
    AND i.is_primary_item = 0
WHERE o.created_at > '2014-12-05'
GROUP BY o.primary_product_id
ORDER BY o.primary_product_id;

/*------------------------- 	Conclusion	   ----------------------------
The 4th product "The Hudson River Mini bear" cross-sells pretty well for all other products with rate 20%.
This is because it's designed as lower priced small additional item, and probably this is a major contributor of increased revenue per order.
---------------------------------------------------------------------------