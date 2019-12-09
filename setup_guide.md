### Install Java 8 & JRE 8
Flink requires **Java 8.x** installations. Later version is not encouraged (prone to compatibility issues).

Click to download [Java 8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and [JRE 8](https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html). Follow the installation guide below:

* JDK Installation Instructions [[Link](https://docs.oracle.com/javase/8/docs/technotes/guides/install/mac_jdk.html#CHDBADCG)]
* JRE 8 Installation for OS X [[Link](https://docs.oracle.com/javase/8/docs/technotes/guides/install/mac_jre.html#CHDGECEB)]
* To run the specific version of java, rather than the system's higher version, specify java full path: `/usr/libexec/java_home -v 1.8.0_0231 --exec javac -version`

```bash
$ /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java -version

java version "1.8.0_231"
Java(TM) SE Runtime Environment (build 1.8.0_231-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.231-b11, mixed mode)
```

___
### Change Java
Flink requires Maven 3.0.4 (or higher)

Before installing Maven, make sure `$JAVA_HOME` environment variable has been set [[help](https://stackoverflow.com/questions/14702702/how-to-set-java-home-in-mac-permanently/14702771)]

Get the path for `$JAVA_HOME`
```bash
$ /usr/libexec/java_home -v 1.8.0_0231

/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home
```

To set the environment variable, open `~/.bash_profile`

```bash
$ vim ~/.bash_profile
```

and add the following line:

```
export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_0231`
```

Double check `$JAVA_HOME` has been set:

```bash
$ source ~/.bash_profile
$ echo $JAVA_HOME
/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home
```

Java default version should have been chagned (restart Terminal if necessary):
```bash
$ java -version

java version "1.8.0_231"
Java(TM) SE Runtime Environment (build 1.8.0_231-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.231-b11, mixed mode)
```

### Install Maven
Download maven [here](https://maven.apache.org/download.cgi). Follow the [guide](https://maven.apache.org/install.html)
* Move the unzipped folder to a convenient/permanent location (for example `Documents`)

```bash
sudo vim /etc/paths
```

Add the path (for example mine is `/Users/shaw.lu/Documents/apache-maven-3.6.3/bin`)

Double check path has been added.
```bash
$ echo $PATH

/Users/shaw.lu/Documents/anaconda3/bin:/Users/shaw.lu/Documents/anaconda3/condabin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Quit Terminal. Restart, and check `mvn` is correct installed:
```bash
$ mvn -v

Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
Maven home: /Users/shaw.lu/Documents/apache-maven-3.6.3
Java version: 1.8.0_231, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "mac os x", version: "10.14.6", arch: "x86_64", family: "mac"
```

___
### Start Flink
Project template [[Link](https://ci.apache.org/projects/flink/flink-docs-release-1.9/dev/projectsetup/java_api_quickstart.html)]. Need to enter the following for each new projects:
* Define value for property 'groupId': typically same as 'artifactId'
* Define value for property 'artifactId': name of newly created directory
* Define value for property 'version' 1.0-SNAPSHOT: : 0

```bash
# two ways to start a flink project
$ mvn archetype:generate                               \
      -DarchetypeGroupId=org.apache.flink              \
      -DarchetypeArtifactId=flink-quickstart-java      \
      -DarchetypeVersion=1.9.0

# use quick start script
curl https://flink.apache.org/q/quickstart.sh | bash -s 1.9.0
```


#### Sample Project [[wiki-edits](https://ci.apache.org/projects/flink/flink-docs-release-1.9/getting-started/tutorials/datastream_api.html#writing-a-flink-program)]
* The command should be executed in the directory which contains the relevant pom file.

```bash
$ mvn archetype:generate \
    -DarchetypeGroupId=org.apache.flink \
    -DarchetypeArtifactId=flink-quickstart-java \
    -DarchetypeVersion=1.9.0 \
    -DgroupId=wiki-edits \
    -DartifactId=wiki-edits \
    -Dversion=0.1 \
    -Dpackage=wikiedits \
    -DinteractiveMode=false

$ rm wiki-edits/src/main/java/wikiedits/*.java

# checklist
# 1. update dependencies (add wikiedits_2.11)
# 2. start 
$ mvn clean package
$ mvn exec:java -Dexec.mainClass=wikiedits.WikipediaAnalysis
```

#### Sample Project [WordCount](https://ci.apache.org/projects/flink/flink-docs-release-1.9/getting-started/tutorials/local_setup.html)
```bash
# Start Flink
./bin/start-cluster.sh  

# start netcat
nc -l 9000

# submit flink job
./bin/flink run examples/streaming/SocketWindowWordCount.jar --port 9000

# check log (continuously updated
tail -f log/flink-*-taskexecutor-*.out

# stop server
./bin/stop-cluster.sh
```

### Kafka
Install [[Kafka](https://kafka.apache.org/0110/documentation.html#quickstart) Official Doc].
```bash
# start zookeeper
bin/zookeeper-server-start.sh config/zookeeper.properties

# start server
bin/kafka-server-start.sh config/server.properties

# create a topic called test
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

# list all topics
bin/kafka-topics.sh --list --zookeeper localhost:2181

# start publisher and keep termimal opem to send message
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test

# start consumer in another terminal
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
