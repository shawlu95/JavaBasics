## YARN
* YARN is designed to allow individual applications (via the ApplicationMaster) to utilize cluster resources in a shared, secure, and multitenant manner.
* support virtually any distributed applications

#### Components
1. ResourceManager: a pure scheduler, can configure schedule algorithm (FIFO, capacity, fair)
2. Application master: negotiate resources with ResourceManager, communicate with NodeManager
  - user code, not trustworthy
  - any user code in any programming language
  - follow application life-cycle
  - usually named "container 0"
3. NodeManager: per-node

* container: the right to use a specified amount of resources on a specific machine (NodeManager) in the cluster (RAM, CPU, core)
* RPC: remote procedure call
