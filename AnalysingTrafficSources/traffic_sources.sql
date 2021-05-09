/*
Break down website sessions until April 12th, 2012 by UTM source, campaign, and referring domain.
*/
SELECT
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id) AS sessions
  FROM website_sessions
 WHERE created_at < '2012-04-12'
 GROUP BY 
     utm_source, 
     utm_campaign, 
     http_referer
 ORDER BY sessions DESC;