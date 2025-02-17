DROP TABLE IF EXISTS epa_air_quality_no_index;
DROP TABLE IF EXISTS epa_air_quality_btree_index;
DROP TABLE IF EXISTS epa_air_quality_hash_index;

CREATE EXTENSION aws_s3 CASCADE;

SHOW data_directory;

-- Ex1.  Create without index and load data from data.csv.
CREATE TABLE epa_air_quality_no_index
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,	
	daily_aqi_value REAL NOT NULL
);

EXPLAIN ANALYZE VERBOSE
SELECT aws_s3.table_import_from_s3(
   'epa_air_quality_no_index', 'date,site_id,daily_mean_pm10_concentration, daily_aqi_value', '(FORMAT csv, HEADER true)',
   aws_commons.create_s3_uri('usfca-msds691', 'data.csv','us-west-1'),
   aws_commons.create_aws_credentials('USER_ACCESS_KEY','USER_SECRET_KEY','')
);

--Ex2. Create with index using btree and cluster. Load data from data.csv.
CREATE TABLE epa_air_quality_btree_index
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,	
	daily_aqi_value REAL NOT NULL
);

--TO DO : CREATE INDEX

create index index_name 
on tabl_name
using btree (col_name);

EXPLAIN ANALYZE VERBOSE
SELECT aws_s3.table_import_from_s3(
   'epa_air_quality_btree_index', 'date,site_id,daily_mean_pm10_concentration, daily_aqi_value', '(FORMAT csv, HEADER true)',
   aws_commons.create_s3_uri('usfca-msds691', 'data.csv','us-west-1'),
   aws_commons.create_aws_credentials('USER_ACCESS_KEY','USER_SECRET_KEY','')
);
 
--TO DO :  CLUSTER

cluster table_name using index_name; 
-- Ex3.
-- Analyze the following in the epa_air_quality_no_index table.
-- Scan
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_no_index; -- Execution Time: 
-- Equality Selection - site_id is 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_no_index WHERE site_id = 60650500; -- Execution Time: 
-- Range Selection - plaza_id is great than 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_no_index WHERE site_id > 60650500; -- Execution Time: 
-- Insert  - ('2021-09-22', 60431001, 23, 120)
EXPLAIN ANALYZE VERBOSE INSERT INTO epa_air_quality_no_index VALUES ('2021-09-22', 60431001, 23, 120); -- Execution Time: 
-- Delete - the inserted row
EXPLAIN ANALYZE VERBOSE DELETE FROM epa_air_quality_no_index WHERE site_id = 60431001 AND date = '2021-09-22'; -- Execution Time:

-- Ex4. Analyze the following in the epa_air_quality_btree_index table.
-- Scan
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_btree_index; -- Execution Time: 
-- Equality Selection - site_id is 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_btree_index WHERE site_id = 60650500; -- Execution Time:
-- Range Selection - plaza_id is great than 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_btree_index WHERE site_id > 60650500; -- Execution Time: 
-- Insert  - ('2021-09-22', 60431001, 23, 120)
EXPLAIN ANALYZE VERBOSE INSERT INTO epa_air_quality_btree_index VALUES ('2021-09-22', 60431001, 23, 120); -- Execution Time:
-- Delete - the inserted row
EXPLAIN ANALYZE VERBOSE DELETE FROM epa_air_quality_btree_index WHERE site_id = 60431001 AND date = '2021-09-22'; -- Execution Time: 
						
-- Ex5. Create epa_air_quality_hash_index with hash index on site_id.
CREATE TABLE epa_air_quality_hash_index
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,	
	daily_aqi_value REAL NOT NULL
);


-- TODO : CREATE INDEX

create index index_name
on table_name
using btree (col_name);

EXPLAIN ANALYZE VERBOSE
SELECT aws_s3.table_import_from_s3(
   'epa_air_quality_hash_index', 'date,site_id,daily_mean_pm10_concentration, daily_aqi_value', '(FORMAT csv, HEADER true)',
   aws_commons.create_s3_uri('usfca-msds691', 'data.csv','us-west-1'),
   aws_commons.create_aws_credentials('USER_ACCESS_KEY','USER_SECRET_KEY','')
);


-- Ex6. Analyze the following in the epa_air_quality_hash_index table.
-- Scan
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_hash_index; -- Execution Time: 
-- Equality Selection - site_id is 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_hash_index WHERE site_id = 60650500; -- Execution Time:
-- Range Selection - plaza_id is great than 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_hash_index WHERE site_id > 60650500; -- Execution Time:
-- Insert  - ('2021-09-22', 60431001, 23, 120)
EXPLAIN ANALYZE VERBOSE INSERT INTO epa_air_quality_hash_index VALUES ('2021-09-22', 60431001, 23, 120); -- Execution Time:
-- Delete - the inserted row
EXPLAIN ANALYZE VERBOSE DELETE FROM epa_air_quality_hash_index WHERE site_id = 60431001 AND date = '2021-09-22'; -- Execution Time: 
