# Data Analytics on E-commerce Company Database
This is a repository for MySQL query scripts that I wrote for advanced SQL for data analytics and business intelligence course by Maven Analytics. This is an entirely project-based course and it proceeded as if I was a data analyst in a virtual E-commerce company and I worked for possible requests from managers one by one.

## Database
MySQL database of a virtual E-commerce company. It is created by Maven Analytics and can be obtained only by purchasing their advanced SQL for data analyst course.

## Chapters
### Analyzing Traffic Sources
Analyzed volume and its trends of website traffic sources. I also compared conversion rate of different sources. Each source has different cost and I worked on bid optimization.

### Analyzing Website Performance
Analysis on the company's website performance. Tested alternatives for landing page by comparing traffic volume and bounce rates. Built conversion funnels and compared different conversion paths.

### Analysis for Channel Portfolio Management
Analyzed performance of different paid marketing campaign to bid effectively.

### Analyzing Business Patterns and Seasonality
Analyzed seasonal patterns of business.

### Product Analysis
Product level sales analysis. Analysis of the impact of new product launches. Product-level website performance analysis with such as conversion funnels. Analysis of cross-sell. Analysis with metrics such as Average Order Value (AOV), revenue per session. Analysis of product refund rates.

### User Analysis
Customer analysis with customers behaviours such as purchase and repeat.

### Mid-course Project
Analysis of growth in the first 8 months of the company.
1. Traffic source "gsearch" has the highest volume. I pulled monthly trends of gsearch sessions and orders. 
2. Monthly trends of Gsearch broken down by marketing campaigns "brand" and "nonbrand".
3. Monthly sessions and orders volume by device type "mobile" and "desktop".
4. By the combination of source, campaign, and whether or not there is the previous page's URL recoreded, our traffic channels are categorized into 4 types: Gsearch, Bsearch, organic search, and direct search. Since Gsearch costs marketing bid, it would be not great if we rely only on it. I analyzed monthly trends of all channels.
5. Conversion rate from session to order by month.
6. In July, we had a test of a new landing page /lander-1 and made a complete transition from the old landing page /home. Here I estimated the impact of this change on revenue from the increase of CVR.
7. Full conversion funnels from each of the 2 landing pages to order during the test mentioned above.
8. Simliar analysis for the billing page test from Sep 10 to Nov 10.

### Final Project
Analysis of company growth in the entire period since it was launched (May 2012 - May 2015).
1. Quarterly analysis of overall session and order volume.
2. Quarterly figures of session-to-order CVR, revenue per order, revenue per session.
3. Quarterly analysis of orders from each channel.
4. Session-to-order CVR for each channel.
5. Monthly trends of revenue and margin by product.
6. Analysis of the impact of introducing new products by click-through rate and CVR to order.
7. On 5th December 2014, the company made our 4th product available as a primary purchase item (top in the cart), which was previously only a cross-sell option. I analyzed how cross-sell performance changed since then. 

## Key Results
- Not only "nonbrand" but also "brand" campaign is growing in sessions and orders. This is a good sign since this means people are actually searching for our business.
- By the end of the first year 2012, it becomes more distinct that sessions and orders from desktop has much higher volume than those of mobile. This means it might be more efficient to focus on improving our desktop website.
- Sessions from customers' organic search and direct type-in are growing alongside those from paid marketing campaigns. This is great since these are customer acquisition with no cost and also it means our brand is getting more recognision.
- During the new landing page test in July 2012, the original landing page "/home" had CVR 3.2% and the new page "/lander-1" had CVR 4.0%, and in the following 4 months after moving entirely to the new landing page there were 22972 sessions. From this we can estimate that this change brought us approximately 45 extra orders per month.
- Conversion funnels show that the click-through rate of /lander-1 page is significantly higher than that of /home and it certainly is the reason of the improved overall CVR.
- During the new billing page test from Sep 10 - Nov 10, there was on average 22.88$ of revenue per billing session via the original billing page "/billing" and 31.21$ via the test billing page "/billing-2". In the following month there were 1193 total billing sessions and therefore the benefit from the billing page change can be estimated to be 9937.69$.
- After 3 years since its launch, CVR increased from 3% to 8%, revenue per order increased by 20%, and revenue per session is over 3 times bigger.
- In the 2nd quarter of 2012, the ratio of nonbrand session volume to that of brand search was about 6:1. At the end, this ratio is about 2:1. This means we are much less dependent on paid marketing campaigns.
- Revenue by our main product "The original Mr. Fuzzy" pops up in Nov - Dec every year. This is a typical seasonality seen in US online retails. Also revenue of "the forever love bear" has peeks in February, and this is because this product is designed for couples and therefore sells good in Vallentine's day season.
- After 3 years since its lauch, the click-through rate of the products list page increased from 71.2% to 85.6%, and CVR from the products list page to order increased from 8.0% to 13.9%. And monthly trends analysis shows that it's clearly correlated to introductions of new products.
- The 4th product "The Hudson River Mini bear" cross-sells pretty well for all other products with rate 20%. This is because it's designed as lower priced small additional item, and probably this is a major contributor of increased revenue per order.
