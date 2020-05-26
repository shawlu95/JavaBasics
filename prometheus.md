```bash
# download the reporter corresponding to the correct flink version (1.9.1)
./prometheus --config.file=prometheus.yml
cp /opt/flink-metrics-prometheus-1.9.1.jar /lib
```

```yaml
# conf/flink-conf.yaml
metrics.reporter.prom.class: org.apache.flink.metrics.prometheus.PrometheusReporter
metrics.reporter.prom.host: 192.168.1.226 # my home IP
metrics.reporter.prom.port: 9250-9260 # multiple port numbers needed
```

No need to add anything to pom.xml

[Useful blog](http://felipeogutierrez.blogspot.com/2019/04/monitoring-apache-flink-with-prometheus.html)

```bash
# start flink
./bin/start-cluster.sh

# submit job
./bin/flink run -c wikiedits.WikipediaAnalysis ../proj/wiki-edits/target/wiki-edits-0.1.jar

# shutdown flink
./bin/stop-cluster.sh

# start prometheus
./prometheus --config.file=prometheus.yml

# kill prometheus
lsof -i :9090
sudo kill -9 <pid>
```
