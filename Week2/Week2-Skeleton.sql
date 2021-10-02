-----------------------------
-- Drop, create and load data
------------------------------
DROP TABLE IF EXISTS epa_air_quality;
DROP TABLE IF EXISTS epa_site_location;

CREATE TABLE epa_site_location
(
	site_id INTEGER CHECK (site_id > 0),
	site_name VARCHAR NOT NULL,
	site_latitude REAL NOT NULL,
	site_longitude REAL NOT NULL,
	county VARCHAR NOT NULL,
	state VARCHAR NOT NULL,
	PRIMARY KEY (site_id)
);

CREATE TABLE epa_air_quality
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,	
	daily_aqi_value REAL NOT NULL,
	PRIMARY KEY (date, site_id),
	FOREIGN KEY (site_id) REFERENCES epa_site_location (site_id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO epa_site_location VALUES (60070008,	'Chico-East Avenue', 39.76168, -121.84047, 'Butte', 'California');


COPY epa_site_location 
FROM '/Users/fanli/Desktop/classes/fall_1/691_01_relational_database/2021-msds691-example/Data/epa_site_location.csv'
DELIMITER ','
CSV HEADER;

COPY epa_air_quality 
FROM '/Users/fanli/Desktop/classes/fall_1/691_01_relational_database/2021-msds691-example/Data/epa_air_quality.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO epa_site_location VALUES (60070001,	'Central Marin', 38.0834, -122.7633, 'Marin', 'California');


-----------------
-- Ex. 1
--------------------------------------------------------
-- 1.A From epa_air_quality, return all the records where site_id is 60070008.
--------------------------------------------------------
select *
from epa_air_quality
where site_id = 60070008;

--------------------------------------------------------
-- 1.B From epa_air_quality, return date and daily_aqi_value where site_id is 60070008.
--------------------------------------------------------
select date, daily_aqi_value
from epa_air_quality
where site_id = 60070008;

--------------------------------------------------------
-- 1.C From epa_air_quality, return unique dates where site_id is 60070008.
--------------------------------------------------------
select distinct date
from epa_air_quality
where site_id = 60070008;

--------------------------------------------------------
-- 1.D From epa_air_quality, return unique dates where site_id is 60070008 ordered by date (ascending).
--------------------------------------------------------
select distinct date
from epa_air_quality
where site_id = 60070008
order by date;

--------------------------------------------------------
--  1.E From epa_air_quality, return first 5 dates where site_id is 60070008 between 2020-05-01 and 2020-10-01 ordered by date.
--------------------------------------------------------
select date
from epa_air_quality
where site_id = 60070008 and date between '2020-05-01' and '2020-10-01'
order by date;

--------------------------------------------------------
-- 1.F From epa_air_quality, return last 5 dates where site_id is 60070008 between 2020-05-01 and 2020-10-01 ordered by date.
--------------------------------------------------------
select date
from epa_air_quality
where date between '2020-05-01' and '2020-10-01'
order by date desc
limit 5;

------------------------------------------------------------
-- Type Conversion (p.19)
------------------------------------------------------------
SELECT TO_CHAR(TIMESTAMP '2021-04-20 17:31:12.66', 'HH12:MI:SS');
SELECT TO_DATE('05 Dec 2000', 'DD Mon YYYY');
SELECT TO_TIMESTAMP('05 Dec 2000', 'DD Mon YYYY');
SELECT TO_CHAR(-125.8, '999D999');
SELECT TO_NUMBER('12,454.8-', 'S99G999D9');


--------------------------------------------------------
-- Ex 2. 
--------------------------------------------------------
-- 2.A Find the unique integer values of site_latitude and site_longitude in epa_site_location ordered by  latitude in ascending order, and then site longitude in descending order.
--------------------------------------------------------
SELECT DISTINCT site_latitude::INT, site_longitude::INT
FROM epa_site_location
ORDER BY site_latitude, site_longitude DESC;

--------------------------------------------------------
-- 2.B Find the unique YEAR-MONTH string pairs in epa_air_quality.
select distinct to_char(date, 'YYYY-MM')
from epa_air_quality;
--------------------------------------------------------
-- SELECT DISTINCT TO_CHAR(DATE, 'YYYY-MM')
-- FROM epa_air_quality;

------------------------------------------------------------
-- NULL
------------------------------------------------------------
SELECT NULL > 1;
SELECT NULL < 1;
SELECT NULL = 1;
SELECT NULL = NULL;

SELECT NULL AND True;
SELECT NULL OR True;
SELECT NULL AND False;
SELECT NULL OR False;

--------------------------------------------------------
-- Ex 3. Return site_id, year, month, day, pm10,  and aqi ordered by site_id, year, month and day in ascending order.
-- 		The returned output should have column names and types.
-- 		site_id : integer
-- 		year, month, day : numeric
-- 		pm10, aqi : real
--------------------------------------------------------
select site_id, extract(year from date):: NUMERIC as year, extract(month from date)::NUMERIC as month, extract(day from date)::NUMERIC as day, 
daily_mean_pm10_concentration pm10, daily_aqi_value aqi
from epa_air_quality
order by site_id, year, month, day;

--------------------------------------------------------
-- String Operators p.27
--------------------------------------------------------
SELECT LENGTH('xyz'),
	   'Diane' || '_' || 'Woodbridge',
	   LOWER('Diane'),
	   UPPER('Diane'),
	   TRIM(BOTH 'xyz' FROM 'yxTomxx'),
	   REPLACE('abcdefabcdef', 'cd', 'XX'),
	   LEFT('MSDS691', 4),
	   RIGHT('MSDS691', 3);
	   
-- String Operators p.28	   
SELECT 'MSDS691' LIKE 'MSDS%', 
	   'MSDS691' SIMILAR TO 'MSDS%',
	   'MSDS691' LIKE 'MSDS[0-9]+', --WRONG Syntax
	   'MSDS691' SIMILAR TO 'MSDS[0-9]+',
	   'MSDS691' SIMILAR TO '[a-z,0-9]+',
	   'MSDS691' SIMILAR TO '[A-Z,0-9]+',
	   'MSDS691' SIMILAR TO '[A-Z,a-z,0-9]+';
	   
	   
--------------------------------------------------------
-- Ex 4.
--------------------------------------------------------
-- 4.A Return all the site name that includes “Fresno” in its name (case insensitive).
--------------------------------------------------------
select site_name
from epa_site_location
where lower(site_name) like '%fresno%';
--------------------------------------------------------
-- 4.B Return all the site name starting with ‘a’ (case insensitive) in ascending order.
--------------------------------------------------------
select site_name
from epa_site_location
where lower(site_name) like 'a%'
order by site_name;
------------------------------------------------------------
-- Mathematical Functions - p.31
------------------------------------------------------------
SELECT ROUND(42.4382, 2), 
	   CEIL(-42.8), 
	   FLOOR(-42.8), 
	   POWER(9.0, 3.0),
	   LOG(2.0, 64.0), 
	   GREATEST(1, 2, 3, 4, 5, NULL), 
	   LEAST(1, 2, 3, 4, 5, NULL);
	   
--------------------------------------------------------
-- Ex 5. Return  site_id and longitude/latitude rounded to the nearest two decimal places.
--------------------------------------------------------
select site_id, (site_longitude/site_latitude)::NUMERIC(100,2)
from epa_site_location;


--------------------------------------------------------
-- Ex 6. Return uniqe date, its year/month and timestamp truncated to "month" in epa_air_quality ordered by date.
select distinct date, extract(year from date), extract (month from date), date_trunc('month', date)
from epa_air_quality
order by 1;
--------------------------------------------------------
SELECT DISTINCT date, extract(year from date) as year, extract(month from date) as month, date_trunc('month', date)
from epa_air_quality
order by date;

--------------------------------------------------------
-- Date Time Functions p.36
--------------------------------------------------------
SELECT CURRENT_DATE,
	   CURRENT_TIME,
	   CURRENT_TIMESTAMP,
	   EXTRACT(HOUR FROM CAST('2021-09-03 10:15:12' AS TIMESTAMP)),
	   DATE_TRUNC('min', CAST('2021-09-03 10:15:12' AS TIMESTAMP)) ;

--------------------------------------------------------
-- Ex 7. Return site_id that does not have any air quality records
--------------------------------------------------------
select site_id from epa_site_location
except
select site_id from epa_air_quality
order by site_id;

select distinct site_id
from epa_site_location
where site_id not in (select site_id from epa_air_quality)
order by 1;