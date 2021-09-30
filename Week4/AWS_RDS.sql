--https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Procedural.Importing.html#USER_PostgreSQL.S3Import
CREATE EXTENSION aws_s3 CASCADE;

DROP TABLE IF EXISTS epa_air_quality;

CREATE TABLE epa_air_quality
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,
	daily_aqi_value REAL NOT NULL,
	PRIMARY KEY (date, site_id)
);

--https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Procedural.Importing.html
SELECT aws_commons.create_s3_uri(
   'usfca-msds691', --s3_bucket_name
   'epa_air_quality.csv', --zip_info_file_name
   'us-west-1' --region
) AS s3_uri 


--https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Procedural.Importing.html#USER_PostgreSQL.S3Import.FileFormats
-- provid table name (epa_air_quality), columns (date,site_id,daily_mean_pm10_concent...)
SELECT aws_s3.table_import_from_s3(
   'epa_air_quality', 'date,site_id,daily_mean_pm10_concentration, daily_aqi_value', '(FORMAT csv, HEADER true)',
	--s3_bucket_name, zip_info_file_name, region
   aws_commons.create_s3_uri('usfca-msds691', 'epa_air_quality.csv','us-west-1'),
   aws_commons.create_aws_credentials('USE_YOUR_OWN_ACCESS_KEY','USE_YOUR_OWN_SECERT_KEY','')

);

SELECT *
FROM epa_air_quality;
