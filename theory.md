#### File system
* NTFS: windows
* ext: Linux

#### Sharding
* Horizontal partitioning
* Each shard follows same schema
* All shard combined == original database
* Each shard independently services read/write
* commonly accessed data should be co-located on the same shard

#### Replication
* Master slave: master node services insert update, delete. slaves service read
  - suitable for read-intensive system
  - write performance degrades as more slaves are added, and read inconsistency increases
* peer-2-peer: each peer services read/write
  - prone to write inconsistency, two strategies:
    * pessimistic concurrency: use locking (ACID)
    * optimistic concurrency: BASE
* sharding can follow master-slave or peer-2-peer fashion


### CAP Theorem for Distributed Storage
Can only ensure two of the three:
* Consistency
* Availability
* Partition

#### ACID
* Atomocity, Consistency, isolation, durability
* Favor consistency over availability (locking)

#### BASE
* Basically available
* Soft state
* Eventually consistent
* Sacrifice consistency for availability

#### Map-Reduce
* Map:
  1. map
  2. combine
  3. partition
* reduce:
  1. shuffle
  2. sort
  3. reduce

### SVC Theorem for Distributed Processing
* Speed
* Consistency: accuracy, precision
  - high consistency: use more data, slow
* Volume

* Hard real time: require speed, compromise consistency, use sampling technique
* Near real time: compromise speed to get more consistent result

##### Distributed File System
* For few, large files
* Sequential access

##### RDBMS
* Vertical scaling
* Small file, single node, ACID
* distributed server have shared storage that risks single point of failure
* Normalized
* Schema-on-write

##### NoSQL
* Horizontal scaling, cheap
* BASE, not ACID
* Eventual consistency
* Denormalized
* Schema-on-read (low write latency)
* major types:
  - key-value: often blob, partial update impossible
    * Riak, Redis, DynamoDB
  - column family: family stored in separate devices; sparse
    * HBase, Cassandra, AWS SimpleDB
  - document: JSON, XML; can reference field in value; partial update
    * MongoDB, CouchStore, Terrastore
  - graph: Neo4J, InfiniteGraph, OrientDB, TitanDB

___
### In-Memory Store
#### In-memory data grid
##### read through
* at read time, if record is not in IMDG, read from disk sync
* record is saved in IMDG to serve subsequent request for same data
* add to read latency

#### Write Through
* at write time, record is sync updated with backend DB
* sacrifice write latency
* achieve immediate consistency

#### Write Behind
* schedule periodic, async update to backend
* improve both read and write performance
* sacrifice consistency

#### Refresh Ahead
* frequently accessed values are refreshed and cached in IMDG
* evicted from IMDG
* if evicted record is read from backend, it is retrieved in read-through manner (sync)

#### In-memory Database (IMDB)
* more similar to SQL
* NoSQL IMDB provide API
* support continuous query
* used heavily in realtime analytics
