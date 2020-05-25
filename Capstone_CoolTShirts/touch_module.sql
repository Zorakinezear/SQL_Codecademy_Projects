/*
The following query will count the first touches associtated with the
following campains
*/
--Q1
SELECT COUNT(DISTINCT utm_campaign) AS number_campaign
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS number_sources
FROM page_visits;

SELECT COUNT(DISTINCT utm_campaign) AS number_campaign
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS number_sources
FROM page_visits;

--Q2
SELECT DISTINCT page_name
FROM page_visits;

--Q3

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
f_total_touch AS (
  SELECT ft.user_id AS id,
    ft.first_touch_at AS fta,
    pv.utm_source AS us,
		pv.utm_campaign AS uc
  FROM first_touch AS ft
  JOIN page_visits AS pv
    ON id = pv.user_id
    AND fta = pv.timestamp)

    SELECT f_total_touch.us,
         f_total_touch.uc,
         COUNT(*)
    FROM f_total_touch
    GROUP BY 1,2
    ORDER BY 3;

/*
counts the total last touches made from the following campaings
*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
l_total_touch AS (
  SELECT lt.user_id AS id,
    lt.last_touch_at AS lta,
    pv.utm_source AS us,
		pv.utm_campaign AS uc
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON id = pv.user_id
    AND lta = pv.timestamp)

SELECT l_total_touch.us,
       l_total_touch.uc,
       COUNT(*)
FROM l_total_touch
GROUP BY 1,2
ORDER BY 3;

/*
Groups the Counts of distinct users who visited the purchase page from the
various campains.
*/

SELECT page_name, COUNT(DISTINCT user_id) AS #users
FROM page_visits
GROUP BY page_name;


WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
    l_total_touch AS (
    SELECT lt.user_id AS id,
      lt.last_touch_at AS lta,
      pv.utm_source AS us,
		  pv.utm_campaign AS uc
    FROM last_touch AS lt
    JOIN page_visits AS pv
    ON id = pv.user_id
    AND lta = pv.timestamp)
SELECT
        us, uc,
       COUNT(DISTINCT id)
FROM l_total_touch
GROUP BY 1,2;
