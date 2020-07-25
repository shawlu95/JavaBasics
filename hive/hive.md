## Hive

#### HiveServer2
* solved concurrency, authentication issues
* sypport JDBC(java database connection), ODBC
* high availability mode: need zookeeper quorum running on multiple nodes

#### Metastore
* store table info, database, schema
* can be any RDBMS
* three mode: embedded, remote, local
* client communicate with metastore via thrift protocol
* single point of communication
  - need high availability mode
  - concurrently start metastore on multiple machines

##### How to connect to HiveServer2
1. beeline: commandline client
2. JDBC: java client
```bash
hive --service hiveserver2
!connect jdbc:hive2://localhost:10000
```
### HUE
Hadoop User Experience: use hadoop without CLI
* HiveServer2 is required
* configure hive server host in `hue.ini`

### Data Model
* primitive: int, smallint, tinyint,
  - decimal: used for financial app (precision, scale)
  - binary: to include arbitrary type, not interpreted
* complex: array, map, struct, union
  - array[0]
  - map['id']
  - struct.id
  - union: store different types in the same memory location

```sql
CREATE TABLE person ( id INT,
  phones ARRAY<INT>,
  otherDetails MAP<STRING, STRING>,
  address STRUCT<street:STRING, city:STRING, state:STRING>
);

SELECT phones[1] FROM person;
SELECT otherDetails[' hometown'] FROM person;
SELECT address.city FROM person;
```

### Partition
* property `hive.mapred.mode` prevents risky query
* static partitioning: specify value of partition columns
* dynamic partitioning: specify partition columns, but not value

```sql
SHOW PARTITIONS customer;
SHOW PARTITIONS customer PARTITION(country = 'US')

-- given an existing directory, add as a/multiple partition
ALTER TABLE table_name ADD [IF NOT EXISTS] PARTITION partition_spec [LOCATION 'loc1'] partition_spec [LOCATION 'loc2'] ...;

-- rename partition
ALTER TABLE table_name PARTITION partition_spec RENAME TO PARTITION partition_spec;

-- move partition from table 2 to table 1
ALTER TABLE table_name_1 EXCHANGE PARTITION (partition_spec) WITH TABLE table_name_2;

-- drop partition
ALTER TABLE table_name DROP [IF EXISTS] PARTITION partition_spec[, PARTITION partition_spec, ...] [IGNORE PROTECTION] [PURGE];

-- required for dynamic partition
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
```

### Bucket
* When too many partitions exists, it's better to use bucketing
* defined at table creation time
* upon lookup, hash the where clause value to fetch the right bucket
* different from partition:
  1. column is still declared in the schema
  2. use insert statement, instead of load
* insert: number of reducer should be equal to number of buckets

```sql
set hive.enforce.bucketing=true;

create table ...
CLUSTERED BY (col_name data_type [COMMENT col_comment], ...)
INTO N BUCKETS;
```

### Data Type


| Hive column type	| UDF types |
| :------------- | :------------- |
| string	| java.lang.String, org.apache.hadoop.io.Text |
| int	    | int, java.lang.Integer, org.apache.hadoop.io.IntWritable |
| boolean	| bool, java.lang.Boolean, org.apache.hadoop.io.BooleanWritable |
| array<type>	| java.util.List<Java type> |
| map<ktype, vtype>	| java.util.Map<Java type for K, Java type for V> |
| struct	| Don't use Simple UDF, use GenericUDF |


### Common DDL

```sql
TRUNCATE TABLE table_name [PARTITION partition_spec];
Alter Table Hive_Test_table1 RENAME TO Hive_Test_table;
Alter Table Hive_Test_table SET TBLPROPERTIES ('comment' = 'This is a new comment');

alter view hive_view as select id, firstname from sales;
Show tables in Hive_learning;
Show tables 'Hive*';

Show partitions Sales partition(dop='2015-01-01');
Show partitions Hive_learning.Sales partition(dop='2015-01-01');
SHOW TBLPROPERTIES tblname;
```

### Common DML
*  Cum_dist(r) = Num of rows with value lower than or equals to r / total rows in resultset or partition
* There is no support for Nulls first or last specification. In Hive, Nulls are returned first.
```sql
LOAD DATA LOCAL INPATH '/tmp/sales.txt' INTO TABLE sales; -- if not in HDFS
LOAD DATA INPATH '/sales.txt' INTO TABLE sales;
LOAD DATA INPATH ' /sales.txt' OVERWRITE INTO TABLE sales;

FROM sales_region slr
INSERT OVERWRITE TABLE sales PARTITION(dop='2015-10-20', city) SELECT slr.id, slr.firstname, slr.lastname, slr.city;

INSERT INTO department PARTITION (datestamp = '2015-10-23') VALUES
('Jason', 20, 10), ('Nelson', 30, 20);

-- export query result to file
Standard syntax:
INSERT OVERWRITE [LOCAL] DIRECTORY directory1 [ROW FORMAT row_format] [STORED AS file_format]SELECT select_statment FROM from_statment.
Hive extension (multiple inserts):
FROM from_statement
INSERT OVERWRITE [LOCAL] DIRECTORY directory1 select_statement1 [INSERT OVERWRITE [LOCAL] DIRECTORY directory2 select_statement2] ...
```

### ACID Mode
* Require **bucketing**
* Insertion, update not possible with **sort by** clause specified
* partition, bucketing column cannot be updated

### Index
```sql
CREATE INDEX index_ip ON TABLE sales(ip) AS 'org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'
WITH DEFERRED REBUILD;
```

### Meta Table
```
TBLS
IDXS
PARTITIONS
PARTITION_KEYS
PARTITION_KEY_VALS
BUCKETING_COLS
TAB_COL_STATS
PART_COL_STATS
```

### File Format
* TEXTFILE: default
* SEQUENCEFILE: save disk storage
* RCFILE: record columnar file
* ORC: optimized row columnar

### Join
#### Semi Join
* use one table to filter another
* the semi table cannot be used in where clause or be selected
#### Map-side Join
* when small table joins large table, small one is cached in memory
```sql
-- auto convert (only when sorted or bucketed)
set hive.auto.convert.join=true;
SELECT a.* FROM Sales a JOIN Sales_orc b ON a.id = b.id and a.fname = b.fname;

-- or use MAPJOIN hint
SELECT /*+ MAPJOIN(Sales_orc)*/ a.fname, b.lname FROM Sales a JOIN Sales_orc b ON a.id = b.id;
```
#### Bucket-map JOIN
* both tables are bucketed on the join columns
* only buckets matching to smaller tables are fetched from big table into mapper
```sql
set hive.optimize.bucketmapjoin = true
set hive.enforce.bucketing = true

-- table1: big table
-- table2: small table
SELECT /*+ MAPJOIN(table2) */ column1, column2, column3 FROM table1 [alias_name1] JOIN table2 [alias_name2]
ON table1 [alias_name1].key = table2 [alias_name2].key
```
#### bucket sort merge map join
* both table are bucketed and sorted
* contain **equal** number of buckets
* each mapper fetch one bucket from each table and perform the join
```sql
Set hive.enforce.sorting = true;

set hive.input.format = org.apache.hadoop.hive.ql.io.BucketizedHiveInputFormat;
set hive.optimize.bucketmapjoin = true;
set hive.optimize.bucketmapjoin.sortedmerge = true;


```

### Table Stats
* Automatically computed if property `hive.stats.autogather=true`
```sql
ANALYZE TABLE sales COMPUTE STATISTICS;
desc formatted sales;

-- analyze one partition
ANALYZE TABLE sales_part PARTITION(pid= 'PI_09') COMPUTE STATISTICS;
DESCRIBE FORMATTED sales_part PARTITION(pid='PI_09');
-- all partition
ANALYZE TABLE sales_part PARTITION(pid) COMPUTE STATISTICS;
```
* column statistics
```sql
-- for non-partition table
ANALYZE TABLE sales COMPUTE STATISTICS FOR COLUMNS ip, pid;

-- for partition table
ANALYZE TABLE sales_part PARTITION(pid='PI_09') COMPUTE STATISTICS FOR COLUMNS fname, ip;
```

### User Defined Table Function
```sql
-- array
SELECT explode(pins) AS pin_code FROM table_with_array_datatype;
SELECT posexplode(pins) AS position, pin_code FROM table_with_array_datatype;

-- map
SELECT explode(map_field) AS (mapKey, mapValue) FROM sampleTable;
```

### Optimization
* predicate push down: `hive.optimize.ppd=true;`
* control number of mapper
```sql
-- new hive
mapreduce.input.fileinputformat.split.maxsize mapreduce.input.fileinputformat.split.minsize

-- old hive
mapred.max.split.size
mapred.min.split.size

-- merge small files once map job completes
set hive.merge.mapfiles=true;

-- manually set nummber of mapper
set mapreduce.job.maps = 10;
```

### Sampling
* sample on row: `SELECT count(*) FROM Sales_orc TABLESAMPLE(BUCKET 4 OUT OF 10 ON rand());`
* sample on column: `SELECT * FROM Sales_orc TABLESAMPLE(BUCKET 3 OUT OF 5 ON id);`
* block sample: `SELECT * FROM Sales_orc TABLESAMPLE(10 PERCENT);`
* literal sample : `SELECT * FROM Sales_orc TABLESAMPLE(10M);`
* nrow sample: `SELECT * FROM Sales_orc TABLESAMPLE(100 ROWS);`

___
## Security
### Authentication
* HDFS permission model: POSIX
  - file: no execute,
  - directory: execution is required to access child objects
1. owner: r(4) + w(2) + x(1)
2. group: r(4) + x(1)
3. other: r(4) + x(1)
* ACL: access control list
  - configure permission for specific user, groups at file/directory level
  - priority: owner? named user? group? else -> others
```bash
# finer access control list
hdfs dfs -getfacl [-R] <path>
hadoop fs -getfacl [-R] <path>

hdfs dfs -setfacl [-R] [-b |-k -m |-x <acl_specification> <path>] |[--set <acl_specification> <path>]
hadoop fs -setfacl [-R] [-b |-k -m |-x <acl_specification> <path>] |[--set
<acl_specification> <path>]
```

### Authorization
* database, table: storage-based authorization (work on file and directory)
* column: SQL Standards-based authorization
  - two roles: user, role (a user can have many roles)
  - all query must be routed thorugh hiveserver2 (set config in hiveserver2-site.xml)
