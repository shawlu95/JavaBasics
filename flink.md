* event time: decouples processing speed from results, deterministic
* watermark: no more delayed event will arrive
  - trade off: confidence and latency
  - monotonic increasing
  - all subsequent events have time > watermark
#### Watermark
* a task can receive input streams from multiple partitions
* each partition sends a watermark
* when receiving a watermark, max(received watermark, partition watermark) is updated for each partition
* the minimum of all partitions is the event-time clock
* when event-time clock advances, it is broadcasted to downstream tasks
* if one partition stops advancing, event-time clock stops
* if two streams significantly diverge, the slower stream dominates the event-time clock

* at most once: no guarantee, drop records when task fails. lowest latency
* at least once: when completeness matters
* exactly once: strictest, use transactional updates of internal state
  - might incur significant overhead

* logical data flow: nodes are operator
* physical data flow: nodes are task

* operator has >= 1 subtask
  - subtasks are independent, executed in different threads
  - numbero f subtask is the parallelism of the operator
* subtasks are chained together into task
  - minimize thread-to-thread handover, buffering, network communication

#### Data Exchange Strategy
1. forward: simplest, avoid network communication if on same machine
2. broadcast: expensive, let all parallel tasks of an operator know
3. key-by: aka shuffle
4. random

#### Apache Integration
* storage: HDFS, S3
* leader election: Zookeeper
* Resource manager: Yarn, Mesos, Kubernetes

* job manager: convert Job Graph to Execution Graph, coordinate, checkpoint
* resource manager: communicate between job & task manager
* task manager: has certain number of slots (one slot per task), a task manager can execute tasks:
  - of same operator (subtasks) **data parallelism**
  - of different operators **task parallelism**
  - of different job **job parallelism**
  - one task manager has a JVM
  - tasks run on different thread, but do not strictly isolate
    - set one slot per task manager if need to isolate
* dispatcher: for submitting job and monitoring, might not be needed

#### Credit-based Flow Control
Improve both bandwidth and throughput
* receiver send a credit to sender: number of buffers ready to process
* sender send as many buffers as granted and backlog size
* based on backlog size, receiver adjust the amount of credit allocated to each sender  

Task chaining
* avoid serialization, net work communication
* two or more operators are connected by local forward channel
* executed on a single thread

#### State
* operator state: for a single task
* keyed state: for user defined key 
