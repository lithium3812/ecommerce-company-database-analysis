/*
Compare new vs. repeat sessions by channel
Data: 2014 - November 5, 2014
*/

-- Just check all possible channels
SELECT
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id)
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-5'
GROUP BY utm_source, utm_campaign, http_referer;

-- 5 channels and number of the first and repeat sessions
SELECT
	CASE
		WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN 'organic_search'
		WHEN utm_campaign = 'brand' THEN 'paid_brand'
		WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_typein'
		WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
		WHEN utm_source = 'socialbook' THEN 'paid_social'	-- ads on SNS
		ELSE 'Check logic!'
	END AS channel_group,
	COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS first_sessions,
	COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions AS ws
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-5'
GROUP BY channel_group;
