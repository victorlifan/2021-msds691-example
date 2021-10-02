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


------------------------------------------------------------
-- Ex 1. Return site_id, site_name, county, state (either Southern California or Northern California), site_latitude and site_longitude.
--     If site_latitude is smaller than 37, it is “Southern California”. 
------------------------------------------------------------


------------------------------------------------------------
-- Ex 2.
-- 2A. Return rows  from epa_site_location where it is in 'Butte', 
-- 'Lassen', 'Yuba' or 'Kern' county ordered by site_id.
------------------------------------------------------------


------------------------------------------------------------
-- 2B. Return rows where its daily_mean_pm10_concentration is higher than 
-- any values between '2020-08-01' and '2020-11-15' ordered by date.
------------------------------------------------------------



------------------------------------------------------------
-- Ex 3. Return rows in epa_site_location 
-- which site_id does not appear in epa_air_quality ordered by site_id.
------------------------------------------------------------
select *
from epa_site_location
where site_id not in (select distinct site_id from epa_air_quality)
order by site_id;


------------------------------------------------------------
-- Ex 4. Return site_id, minimum, average and maximum daily_mean_pm10_concentration 
-- per site_id which has more than 30 records ordered by site_id
------------------------------------------------------------

select site_id, min(daily_mean_pm10_concentration), avg(daily_mean_pm10_concentration), max(daily_mean_pm10_concentration)
from epa_air_quality
group by 1
having count(*) >30
order by 1;

------------------------------------------------------------
-- Ex 5. Return date, site_name, daily_mean_pm10_concentration and daily_aqi_value ordered by site_id and date.
------------------------------------------------------------



------------------------------------------------------------
-- Ex 6. Assuming that data was supposed to be collected from every station on all the dates in epa_air_quality.
--      Return date, site_id and daily_mean_pm10_concentration and daily_aqi_value for all possible date and site_id pairs ordered by date and site_id.
------------------------------------------------------------
select sub.date, sub.site_id, daily_mean_pm10_concentration,daily_aqi_value
from
	(select distinct a.date, b.site_id
	from epa_air_quality a, epa_site_location b) sub
left join epa_air_quality ea
on sub.date = ea.date and sub.site_id = ea.site_id
order by 1,2;


------------------------------------------------------------
-- Ex 7 . We are interested in how many readings were collected per site quarterly every year.
-- The output should have cohort(year), site_id,  the number of readings between Jan-Mar, Apr-Jun, Jul-Sep and Oct-Dec ordered by cohort and site_id.
------------------------------------------------------------
select extract(year from date), site_id ,
	sum(case when extract(month from date) between 1 and 3 then 1 else 0 end) as jan_mar,
	sum(case when extract(month from date) between 4 and 6 then 1 else 0 end) as apr_jun,
	sum(case when extract(month from date) between 7 and 9 then 1 else 0 end) as jul_sep,
	sum(case when extract(month from date) between 10 and 12 then 1 else 0 end) as oct_dec
from epa_air_quality
group by 1,2
order by 1,2;

