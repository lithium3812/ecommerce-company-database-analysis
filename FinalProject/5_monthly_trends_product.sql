/*
Monthly trends of revenue and margin by product and total revenue and total margin
*/

-- See all products
SELECT DISTINCT product_id
FROM order_items;
-- 1, 2, 3, 4

-- See what each ID corresponds to
SELECT * FROM products;
-- 1: The Original Mr. Fuzzy
-- 2: The Forever Love Bear
-- 3: The Birthday Sugar Panda
-- 4: The Hudson River Mini bear

SELECT
    YEAR(created_at) AS yr,
    MONTH(created_at) AS mt,
    SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) AS mrfuzzy_revenue,
    SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END) AS lovebear_revenue,
    SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END) AS birthdaypanda_revenue,
    SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END) AS minibear_revenue,
    SUM(CASE WHEN product_id = 1 THEN price_usd - cogs_usd ELSE NULL END) AS mrfuzzy_margin,
    SUM(CASE WHEN product_id = 2 THEN price_usd - cogs_usd ELSE NULL END) AS lovebear_margin,
    SUM(CASE WHEN product_id = 3 THEN price_usd - cogs_usd ELSE NULL END) AS birthdaypanda_margin,
    SUM(CASE WHEN product_id = 4 THEN price_usd - cogs_usd ELSE NULL END) AS minibear_margin,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
FROM order_items
GROUP BY yr, mt;

/*---------------------------	Conclusion	-----------------------------
Revenue by our main product "The original Mr. Fuzzy" pops up in Nov - Dec every year. 
This is a typical seasonality seen in US online retails.
Revenue of "the forever love bear" has peeks in February, and this is because this product is designed for couples
and therefore sells good in Vallentine's day season.
------------------------------------------------------------------------*/
