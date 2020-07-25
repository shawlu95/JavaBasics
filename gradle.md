
Goal
* remove manual intervention
* a push-button fail-safe software release process

Types of automation
* on-demand
* triggered
* scheduled

Build automation can be expressed as DAG.
* build script
  - project: top-level container; one per script
  - multiple targets: a target has multiple tasks
  - used tasks: a piece of executable codes
* build input, output
* build engine: build internal model, execute step by step
* dependency manager: retrieve external dependency (jar)

Build tool
* Ant: oldest
  - build script written in XML
  - integrates with Ivy dependency manager
  - pros: flexible, versatile
  - cons: lack standardization, lots of boilerplate, no built in dependency manager
    * XML not good with conditional statement
* Maven
  - plugin: custom logic
  - lifecycle:
    * validate
    * compile
    * test
    * package
    * integration test
    * verify
    * install
    * deploy
  - provide good convention: default layout
  - Maven Central: most popular binary artifact repository
  - dependency:
    - scope determines phase of lifecycle the dependency applies
  - pros: easy, standardized, dependency manager
  - cons: difficult for custom logic

___
### Gradle
* support groovy and java
* plugin: share reusable code across builds and projects
* Ant target maps to gradle tasks

```bash
-- examine avaiable tasks
gradle -q tasks --all

-- log info
gradle groupTherapy -x yayGradle0 -i

gradle groupTherapy -x yayGradle0 -i -s
```

Gradle Daemon
* run as background process
* gradle command will reuse the daemon process for subsequent build, avoiding the startup cost
* expire after 3 hour idle time
```bash
-- run as daemon
gradle --daemon
ps | grep gradle
gradle groupTherapy --daemon

-- stop daemon
gradle --stop
```

Web App
* `war` plubin
* `jetty` -> replaced by `gretty`

```java
// customize jetty config
jettyRun {
  httpPort = 9090
  contextPath = 'todo'
}
```

Gradle Wrapper
* enables a machine to run a Gradle build script without having to install the runtime.
* ensure build is run with correct gradle version
* The ultimate goal is to create reliable and reproducible builds independent of the operating system, system setup, or installed Gradle version

* step 1: add a wrapper tasks
  - can be any name, but the convention is `wrapper`
  - specify gradle version
* step 2: execute wrapper task **once**: `gradle wrapper`
* step 3+: use the wrapper’s script to execute your build
* check in wrapper script to version control

Generated file
* gradle-wrapper.jar: Gradle wrapper microlibrary contains logic to download and unpack distribution
* gradle-wrapper.properties: Wrapper metadata like storage location for downloaded distribution and originating URL
* gradlew, gradlew.bat: Wrapper scripts for executing Gradle commands

### Mastering Gradle Fundamentals
Components of a build script
* project: a script can have multiple interdependent projects
* task
* properties: required to use `ext` namespace
  - can also define a property file `gradle.properties`
  - pass in properties in CLI via `-P` or `-D` flags
  - access properties: `$version` or `ext.version`

```java
// declare action dependencies
task first << { println "first" }
task second << { println "second" }

task printVersion(dependsOn: [second, first]) << {
  logger.quiet "Version: $version"
}

task third << { println "third" }
third.dependsOn('printVersion')
```

* finalizer tasks: for example, integration test against a deployment env

```java
task first << { println "first" }
task second << { println "second" }
first.finalizedBy second
```

Build phases
1. initialization
2. configuration
3. execution

### Scope
* compile: not provided at runtime
* providedCompile: need to compile, but provided at runtime
* runtime: no need to compile & provided at runtime


### Resources
* Asgard, a web-based cloud management and deploy- ment tool built and used by Netflix
* search maven repository: http://search.maven.org/
* Jetty: allow changing static files without restarting container
* JRebel: perform hot deployment for class file changes.
