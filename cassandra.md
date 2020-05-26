
### Apache Cassandra
* column-oriented data store
* top level Apache project
* from Facebook
* built on DynamoDB, BigTable

#### Architecture
* Masterless, ring constructions
  - When a new nodes joins a cluster, it will automatically contact the other nodes in the cluster and copy the right data to itself. See Adding, replacing, moving and removing nodes.
* Query-first design: Data model are designed for query
* Optimized for fast read:
  - no join allowed
  - no referential integrity, foreign key
  - cascading deletes are not available.
  - denormalization of data (duplicate data across table)
    * `materialized views` allows you to create multiple denormalized views of data based on a base table design
* partitioning:
  - primary key (may have multiple columns) determines partition
  - by default, first primary col determines partition, the rest sort data in partition
    * sort order available on queries is fixed
    * sort order is a design decision
  - use `()` to group more than one primary cols for partition
  - each partition should have < 100,000 values and < 100 MB
  - minimize the number of partitions that must be searched in order to satisfy a given query
  - partition is a unit of storage that does not get divided across nodes
  - a query that searches a single partition will typically yield the best performance

#### wide partition pattern
* group multiple related rows in a partition in order to support fast access to multiple rows within the partition in a single query.
* sometimes called the wide row pattern
* The time series pattern is an extension of the wide partition pattern. In this pattern, a series of measurements at specific time intervals are stored in a wide partition

> The design of the primary key is extremely important, as it will determine how much data will be stored in each partition and how that data is organized on disk, which in turn will affect how quickly Cassandra processes reads.

* tombstone: any design that relies on the deletion of data is potentially a poorly performing design

#### Physical Storage
Number of values
```
N_v = N_r (N_c - N_{pk} - N_s) + N_s
```
* `N_v`: number of values(cells) in partition
* `N_r`: number of rows
* `N_c`: number of columns
* `N_{pk}`: number of primary columns used to determine partition
* `N_s`: static column (same for every row)

Storage space
* primary key columns: `N_{pk} * avg(sizeof(c_{pk}))`
* static key column: `N_s * avg(sizeof(c_s))`
* regular column: `N_r * (N_c - N_{pk} - N_s) * avg((sizeof(c_r)))`
* metadata per value: `N_v * 8`

Two ways to repartition
1. add an additional column to the partition key
2. use bucketing

Deletion
* Data are written to `SSTable` which is immutable
* Deleted rows are marked with tombstone
* Physically removed during compaction

```sql
-- configure replication at the keyspace level,
CREATE KEYSPACE reservation WITH replication = {‘class’:
  ‘SimpleStrategy’, ‘replication_factor’ : 3};

-- register custom type
CREATE TYPE reservation.address (
  street text,
  city text,
  state_or_province text,
  postal_code text,
  country text );

CREATE TABLE reservation.guests (
  guest_id uuid PRIMARY KEY,
  first_name text,
  last_name text,
  title text,
  emails set,
  phone_numbers list,
  addresses map<text,
  frozen<address>,
  confirm_number text )
  WITH comment = ‘Q9. Find guest by ID’;
```

 Chebotko diagrams
 ![alt-text](assets/data_modeling_chebotko_physical.png)

#### Gossip
* Gossip is how Cassandra propagates basic cluster bootstrapping information such as endpoint membership and internode network protocol versions.
* nodes exchange state information not only about themselves but also about other nodes they know about
* Every second, every node in the cluster:
```
1. Updates the local node’s heartbeat state (the version) and constructs the node’s local view of the cluster gossip endpoint state.
2. Picks a random other node in the cluster to exchange gossip endpoint state with.
3. Probabilistically attempts to gossip with any unreachable nodes (if one exists)
4. Gossips with a seed node if that didn’t happen in step 2.
```

#### Seed
* seed nodes are allowed to bootstrap into the ring without seeing any other seed nodes
* Non-seed nodes must be able to contact at least one seed node in order to bootstrap into the cluster
* Seeds are used during startup to discover the cluster.
* nodes in your ring tend to send Gossip message to seeds more often
* pick two (or more) nodes per data center as seed nodes.
* sync the seed list to all your nodes
