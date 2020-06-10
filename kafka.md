
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


### Consumer
* Consumer is bound to a "fair share of partitions"
  - a consumer group is a cluster of machines that form a single subscriber
* there cannot be more consumer instances in a consumer group than partitions

### Hardware consideration
* disk throughput
* disk capacity
* memory
* networking
* CPU
