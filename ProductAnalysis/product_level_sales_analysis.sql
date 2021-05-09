/*
Monthly trends of sales, revenue, and margin
Request date: Jan 4, 2013
*/

SELECT
    YEAR(created_at) AS year,
    MONTH(created_at) As month,
    COUNT(order_id) AS number_of_sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
FROM orders
WHERE created_at < '2013-01-04'
GROUP BY
    year,
    month;