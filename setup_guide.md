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
### Change Default Java Version
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
Download Flink [here](https://ci.apache.org/projects/flink/flink-docs-release-1.9/getting-started/tutorials/local_setup.html). Project template [[Link](https://ci.apache.org/projects/flink/flink-docs-release-1.9/dev/projectsetup/java_api_quickstart.html)]. Need to enter the following for each new projects:
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
```

### Gradle
* Create new build [[Link](https://guides.gradle.org/creating-new-gradle-builds/)]
* plugin must be added at the top
* `group` and `description` of a task can be anything
* `gradlew`: gradle wrapper script
* `./gradlew build`: best practice
  - compiles the classes, runs the tests, and generates a test report.
  - first run will download libraries to `~/.gradle`
* generate new project

```bash
# the command runs the wrapper script
# and generates the gradlew and gradlew.bat wrapper scripts.
gradle init
```

* Change java version: `File->Project Structure`

```bash
gradle build --scan

# run copy task
./gradlew copy

# run gradle zip task
./gradlew zip

# discover available task
./gradlew tasks

# scan a single task
./gradlew zip --scan

# Find properties of project
./gradlew properties

# run jar file
java -cp ./demo2-all.jar demo2.App
```


```
❯ ./gradlew tasks

> Task :tasks

------------------------------------------------------------
All tasks runnable from root project
------------------------------------------------------------

Archive tasks
-------------
zip - Archives sources in a zip file

Build tasks
-----------
assemble - Assembles the outputs of this project.
build - Assembles and tests this project.
clean - Deletes the build directory.

Build Setup tasks
-----------------
init - Initializes a new Gradle build.
wrapper - Generates Gradle wrapper files.

Custom tasks
------------
copy - Simply copies sources to a the build directory

Help tasks
----------
buildEnvironment - Displays all buildscript dependencies declared in root project 'basic-demo'.
components - Displays the components produced by root project 'basic-demo'. [incubating]
dependencies - Displays all dependencies declared in root project 'basic-demo'.
dependencyInsight - Displays the insight into a specific dependency in root project 'basic-demo'.
dependentComponents - Displays the dependent components of components in root project 'basic-demo'. [incubating]
help - Displays a help message.
model - Displays the configuration model of root project 'basic-demo'. [incubating]
projects - Displays the sub-projects of root project 'basic-demo'.
properties - Displays the properties of root project 'basic-demo'.
tasks - Displays the tasks runnable from root project 'basic-demo'.

Verification tasks
------------------
check - Runs all checks.

Rules
-----
Pattern: clean<TaskName>: Cleans the output files of a task.
Pattern: build<ConfigurationName>: Assembles the artifacts of a configuration.
Pattern: upload<ConfigurationName>: Assembles and uploads the artifacts belonging to a configuration.

To see all tasks and more detail, run gradlew tasks --all

To see more detail about a task, run gradlew help --task <task>

BUILD SUCCESSFUL in 0s
1 actionable task: 1 executed
```

Rebuild gradle exampple

```
(base) 04L0219100014DD:gradle_tutorial shaw.lu$ cd demo2
(base) 04L0219100014DD:demo2 shaw.lu$ ls
build		gradle		gradlew.bat	src
build.gradle	gradlew		settings.gradle
(base) 04L0219100014DD:demo2 shaw.lu$ ls -al
total 56
drwxr-xr-x  13 shaw.lu  admin   416 Dec 10 17:17 .
drwxr-xr-x   8 shaw.lu  admin   256 Dec 10 14:12 ..
-rw-r--r--   1 shaw.lu  admin   154 Dec 10 14:13 .gitattributes
-rw-r--r--   1 shaw.lu  admin   103 Dec 10 14:13 .gitignore
drwxr-xr-x   5 shaw.lu  admin   160 Dec 10 14:14 .gradle
drwxr-xr-x   8 shaw.lu  admin   256 Dec 10 17:20 .idea
drwxr-xr-x  11 shaw.lu  admin   352 Dec 10 17:17 build
-rw-r--r--   1 shaw.lu  admin  1033 Dec 10 17:17 build.gradle
drwxr-xr-x   3 shaw.lu  admin    96 Dec 10 14:13 gradle
-rwxr-xr-x   1 shaw.lu  admin  5764 Dec 10 14:13 gradlew
-rw-r--r--   1 shaw.lu  admin  2942 Dec 10 14:13 gradlew.bat
-rw-r--r--   1 shaw.lu  admin   354 Dec 10 14:13 settings.gradle
drwxr-xr-x   4 shaw.lu  admin   128 Dec 10 14:13 src
(base) 04L0219100014DD:demo2 shaw.lu$ rm -rf .gradle
(base) 04L0219100014DD:demo2 shaw.lu$ RM -RF .idea
RM: illegal option -- F
usage: rm [-f | -i] [-dPRrvW] file ...
       unlink file
(base) 04L0219100014DD:demo2 shaw.lu$ rm -rf .idea/
(base) 04L0219100014DD:demo2 shaw.lu$ ls -al
total 56
drwxr-xr-x  11 shaw.lu  admin   352 Dec 10 17:21 .
drwxr-xr-x   8 shaw.lu  admin   256 Dec 10 14:12 ..
-rw-r--r--   1 shaw.lu  admin   154 Dec 10 14:13 .gitattributes
-rw-r--r--   1 shaw.lu  admin   103 Dec 10 14:13 .gitignore
drwxr-xr-x  11 shaw.lu  admin   352 Dec 10 17:17 build
-rw-r--r--   1 shaw.lu  admin  1033 Dec 10 17:17 build.gradle
drwxr-xr-x   3 shaw.lu  admin    96 Dec 10 14:13 gradle
-rwxr-xr-x   1 shaw.lu  admin  5764 Dec 10 14:13 gradlew
-rw-r--r--   1 shaw.lu  admin  2942 Dec 10 14:13 gradlew.bat
-rw-r--r--   1 shaw.lu  admin   354 Dec 10 14:13 settings.gradle
drwxr-xr-x   4 shaw.lu  admin   128 Dec 10 14:13 src
(base) 04L0219100014DD:demo2 shaw.lu$ rm -rf ./build/*
(base) 04L0219100014DD:demo2 shaw.lu$ rm -rf gradle
(base) 04L0219100014DD:demo2 shaw.lu$ rm -rf gradlew
(base) 04L0219100014DD:demo2 shaw.lu$ rm -rf gradlew.bat
(base) 04L0219100014DD:demo2 shaw.lu$ ls -al
total 32
drwxr-xr-x  8 shaw.lu  admin   256 Dec 10 17:22 .
drwxr-xr-x  8 shaw.lu  admin   256 Dec 10 14:12 ..
-rw-r--r--  1 shaw.lu  admin   154 Dec 10 14:13 .gitattributes
-rw-r--r--  1 shaw.lu  admin   103 Dec 10 14:13 .gitignore
drwxr-xr-x  2 shaw.lu  admin    64 Dec 10 17:21 build
-rw-r--r--  1 shaw.lu  admin  1033 Dec 10 17:17 build.gradle
-rw-r--r--  1 shaw.lu  admin   354 Dec 10 14:13 settings.gradle
drwxr-xr-x  4 shaw.lu  admin   128 Dec 10 14:13 src
(base) 04L0219100014DD:demo2 shaw.lu$ less settings.gradle
(base) 04L0219100014DD:demo2 shaw.lu$ ls -al
total 56
drwxr-xr-x  13 shaw.lu  admin   416 Dec 10 17:23 .
drwxr-xr-x   8 shaw.lu  admin   256 Dec 10 14:12 ..
-rw-r--r--   1 shaw.lu  admin   154 Dec 10 14:13 .gitattributes
-rw-r--r--   1 shaw.lu  admin   103 Dec 10 14:13 .gitignore
drwxr-xr-x   5 shaw.lu  admin   160 Dec 10 17:23 .gradle
drwxr-xr-x   7 shaw.lu  admin   224 Dec 10 17:22 .idea
drwxr-xr-x   2 shaw.lu  admin    64 Dec 10 17:21 build
-rw-r--r--   1 shaw.lu  admin  1033 Dec 10 17:17 build.gradle
drwxr-xr-x   3 shaw.lu  admin    96 Dec 10 17:23 gradle
-rwxr-xr-x   1 shaw.lu  admin  5305 Dec 10 17:23 gradlew
-rw-r--r--   1 shaw.lu  admin  2269 Dec 10 17:23 gradlew.bat
-rw-r--r--   1 shaw.lu  admin   354 Dec 10 14:13 settings.gradle
drwxr-xr-x   4 shaw.lu  admin   128 Dec 10 14:13 src
(base) 04L0219100014DD:demo2 shaw.lu$

```
