Create directory to store table data
* `google.csv` is saved at `/Users/shawlu/Documents/proj/hive_demo/src/main/resources`

```bash
# stock data
hdfs dfs -mkdir -p /data
hdfs dfs -mkdir -p /data/stocks
hadoop fs -put google.csv /data/stocks

# address data (for testing UDF)
hdfs dfs -mkdir -p /data/address_sample
hadoop fs -put address_sample.csv /data/address_sample
```

In Hive, create table schema
```sql
DROP TABLE IF EXISTS google;
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
```
