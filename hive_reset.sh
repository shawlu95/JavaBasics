# first need to delete zookeeper folder
cd ~/Documents/apache-zookeeper-3.5.5-bin
bin/zkServer.sh start

hdfs namenode -format

cd ~/Documents/hadoop-2.7.3
sbin/start-dfs.sh

hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse

Create tmp folder in root and provide permission
hdfs dfs -mkdir -p /tmp
hdfs dfs -chmod g+w /tmp

hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -chmod 777 /tmp/hive

hdfs dfs -mkdir -p /data
hdfs dfs -mkdir -p /data/stocks

dl
hadoop fs -put google.csv /data/stocks

hive
