
### Partition
* unit of parallelism
* The records in the partitions are each assigned a sequential id number called the offset that uniquely identifies each record within the partition
*  ordered, immutable sequence of records that is continually appended
* durably persists all published records
* Each individual partition must fit on the servers that host it
* Each partition is replicated across a configurable number of servers for fault tolerance
  - each partition has one leader server
  - and >= 0 followers that replicate leader
* Order is maintained per partition, **not** across partitions
  - Use key to assign record to partition consistently

### Producer
* a record consists of: topic, key/partition, value
* compressing the record improves bandwidth and latency
  - snappy is good compromise between CPU processing and size
  - gzip is more CPU intensive, but smaller size

### Consumer
* **one consumer per thread**
* Consumer is bound to a "fair share of partitions"
  - a consumer group is a cluster of machines that form a single subscriber
* there cannot be more consumer instances in a consumer group than partitions
  - or some consumer will be idle
* heartbeat: sent by consumer to broker
  - when consumes record, and when commits record
  - group coordinator: broker receiving heartbeat
* group leader: first consumer to join a group
  - receive list of live consumers from coordinator
  - assign partitions, return assignment to coordinator
* `poll()`: return a list of records
  - must poll regularly or consumer is considered dead
* `close()`: immediate rebalance

### Commit
* Update current position in the partition
* consumer produces a message to special topic `__consumer_offset`
* after rebalance, consumer gets assigned partition and read offset from `__consumer_offset`
* `commitAsync`: does not retry
* `commitSync`: for the last record in `finally {}`
* exactly once semantic: store offset and record in a single transaction
  - use `seek` to get offset from external DB

### Hardware consideration
* disk throughput
* disk capacity
* memory
* networking
* CPU
