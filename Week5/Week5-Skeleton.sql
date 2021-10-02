select * from tweets;
-------------------------------------------------------
-- Ex1. Create a table tweets and insert tweets.csv
-------------------------------------------------------


-- What is the column type of tweet?


-------------------------------------------------------
-- Ex2. In tweets table,
-- return id, time, hashtag, text and retweet_count 
-- when retweet_count is over 100 ordered by retweet_count in descending order.
-------------------------------------------------------
SELECT id, time, hashtag, tweet->> 'text' as text, tweet ->> 'public_metrics'::
from tweets;

-------------------------------------------------------
-- Ex3. Use the epa_air_quality table from Week3.
-- Create rows of JSON include all the columns for daily_aqi_value > 200 ordered by daily_aqi_value (ASC)
-------------------------------------------------------


-------------------------------------------------------
-- Ex4. For January of 2020, return site_id, date, daily_mean_pm10_concentration, 
-- and it average between the first day  and the current date per site_id.
-------------------------------------------------------
select site_id, date, daily_mean_pm10_concentration,
		avg(daily_mean_pm10_concentration)over(partition by site_id rows between unbounded preceding and current row)
from epa_air_quality
where extract(month from date) = 01 and extract(year from date) = 2020;


--p.20
SELECT site_id, 
	   date, 
	   daily_mean_pm10_concentration, 
	   AVG(daily_mean_pm10_concentration) OVER(), 
	   AVG(daily_mean_pm10_concentration) OVER (PARTITION BY site_id), 
	   AVG(daily_mean_pm10_concentration) OVER (PARTITION BY site_id ORDER BY date),
	   AVG(daily_mean_pm10_concentration) OVER (PARTITION BY site_id ORDER BY date ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING),
	   AVG(daily_mean_pm10_concentration) OVER (PARTITION BY site_id ORDER BY date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING),
	   AVG(daily_mean_pm10_concentration) OVER (PARTITION BY site_id ORDER BY date ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM epa_air_quality
WHERE EXTRACT(YEAR FROM date) = 2020  AND  EXTRACT(MONTH FROM date) = 1
ORDER BY site_id, date;

-------------------------------------------------------
-- Ex5.  Calculate the pm10 changes from a day before for each site.
-------------------------------------------------------


-- p.24
CREATE OR REPLACE FUNCTION increment(input int) 
RETURNS int AS 
$$ SELECT input + 1 $$ 
LANGUAGE SQL;

SELECT * FROM increment(42);

DROP FUNCTION IF EXISTS increment;

-------------------------------------------------------
-- Ex6. Create a function called site_id_for_name which takes site_name and returns its corresponding site_id.
-- Using this function return all the rows for 'Westmorland' ordered by date.
-------------------------------------------------------
CREATE OR REPLACE FUNCTION site_id_for_name(name varchar)
RETURNs TABLE (site_id INT) AS
$$
SELECT site_id
FROM epa_site_location
WHERE site_name = name
$$
LANGUAGE SQL;

select * from  site_id_for_name('Westmorland');
-------------------------------------------------------
-- Ex7. Create a view called epa_site_info_aqi which returns all the site_id, site_name, site_longitude, site_latitude and corresponding daily_mean_pm10_concentration and daily_aqi_value if exist.
-- Return rows from epa_site_info_aqi where site_name is 'Westmorland'
-------------------------------------------------------
create or replace view epa_site_info_aqi as
SELECT ea.site_id, site_name, site_longitude, site_latitude,
	 daily_mean_pm10_concentration, daily_aqi_value
FROM epa_air_quality ea
JOIN epa_site_location es
on ea.site_id = es.site_id

-------------------------------------------------------
-- Ex8. Create a view called epa_aqi_2020_01 which only stores January of 2020 data from epa_air_quality.
-- Make sure it only stores/updates data from January, 2020.
-------------------------------------------------------

-- Compare with/without "WITH CHECK OPTION"



