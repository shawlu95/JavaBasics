
Add user defined functions
```sql
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
