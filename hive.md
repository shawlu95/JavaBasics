https://dbmstutorials.com/hive/hive-setup-on-mac.html

```sql
CREATE DATABASE metastore;
USE metastore;
source /usr/local/Cellar/hive/3.1.2/libexec/scripts/metastore/upgrade/mysql/hive-schema-3.1.0.mysql.sql
CREATE USER 'hiveuser'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT,INSERT,UPDATE,DELETE,ALTER,CREATE ON metastore.* TO 'hiveuser'@'localhost';

GRANT all on metastore.* to hiveuser;
FLUSH PRIVILEGES;
```

Create warehouse folder under hive and provide permission
```bash
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse

Create tmp folder in root and provide permission
hdfs dfs -mkdir -p /tmp
hdfs dfs -chmod g+w /tmp

hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -chmod 777 /tmp/hive

hdfs dfs -mkdir -p /data
hdfs dfs -mkdir -p /data/stocks
hadoop fs -put google.csv /data/stocks

hdfs dfs -mkdir -p /data/address_sample
hadoop fs -put address_sample.csv /data/address_sample
```

```sql
CREATE TABLE IF NOT EXISTS google(
tradeDate STRING,
price STRING,
open STRING,
high STRING,
low STRING,
vol STRING,
change STRING
)
COMMENT 'google stocks'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
load data inpath '/data/stocks/google.csv' into table google;

DROP TABLE address_sample;
CREATE TABLE IF NOT EXISTS address_sample (
src STRING,
src_address STRING,
src_dt timestamp,
dst STRING,
dst_dt timestamp,
dst_address STRING,
commid int,
attr string,
score int,
change STRING
)
COMMENT '1000 address pair'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
load data inpath '/data/address_sample/address_sample.csv' into table address_sample;

-- hadoop fs -put /Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar /user/hive
add jar /Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar;
create temporary function udf_abs as 'com.coupang.fds.udf.AbsValue';
create temporary function udf_sum as 'com.coupang.fds.udf.SimpleUDFExample';
create temporary function noQuotes as 'com.coupang.fds.udf.Quotes';

-- add from local jar file directly, without uploading to HDFS

create temporary function cosine as 'com.coupang.fds.udf.Cosine' using jar '/Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar';
create temporary function hamming as 'com.coupang.fds.udf.Hamming' using jar '/Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar';
create temporary function jaccard as 'com.coupang.fds.udf.Jaccard' using jar '/Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar';
create temporary function jaro as 'com.coupang.fds.udf.Jaro' using jar '/Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar';
create temporary function levenshtein as 'com.coupang.fds.udf.Levenshtein' using jar '/Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar';
create temporary function subsequence as 'com.coupang.fds.udf.Subsequence' using jar '/Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar';

create temporary function square as 'Square' using jar '/Users/shawlu/Downloads/hive_udf-1.0-SNAPSHOT.jar';

create temporary function udf_abs3 as 'com.coupang.fds.udf.AbsValue' using jar 'hdfs:///user/hive/hive_udf-1.0-SNAPSHOT.jar';

show functions like '*ja*';

select udf_sum(collect_list(cast(price as double))) from google;
select cast(high as double) from google limit 10;
select src_address, dst_address, jaccard(src_address, dst_address) as sim from address_sample limit 100;
```


Hive column type	UDF types
string	java.lang.String, org.apache.hadoop.io.Text
int	int, java.lang.Integer, org.apache.hadoop.io.IntWritable
boolean	bool, java.lang.Boolean, org.apache.hadoop.io.BooleanWritable
array<type>	java.util.List<Java type>
map<ktype, vtype>	java.util.Map<Java type for K, Java type for V>
struct	Don't use Simple UDF, use GenericUDF

hive --service hiveserver2
!connect jdbc:hive2://localhost:10000
