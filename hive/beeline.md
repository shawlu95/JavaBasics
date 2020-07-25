```
$HIVE_HOME/bin/beeline
!connect jdbc:hive2://localhost:10000
beeline> !connect jdbc:hive2://localhost:10000/default;principal=hive/ hiveserver_hostname@YOUR-REALM.COM org.apache.hive.jdbc.HiveDriver
```
