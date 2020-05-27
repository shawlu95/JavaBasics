
### What is Kubernetes?
Kubernetes is an open-source container management platform for deploying and managing containerized workloads. These containerized workloads are the backbone of many modern web apps, acting as packages of applications and dependencies all delivered and stored together. The advantage of containerization is *consistency*; the user never has to consider or construct the dependencies that an application would need and therefore will always behave the same at run time.

While container implementation is doable without a management platform like Kubernetes, the behavior of these containers when working together can be erratic. For example, when executed, one container may pull too many resources of the machine, starving out others. These starved containers may then fail, and because no other program is managing them and no backups, it will remain that way until the program is run from the start again.

In short, containers require a great deal of micromanaging, from the amount of resources devoted to each, to self-healing of failed containers. Thankfully, Kubernetes is equipped for customizing and handling all of those behind the scenes tasks!

### Docker and Kubernetes
If Kubernetes is the *scheduler*, managing each container as they work together, then Docker would be the *recruiter*, your source of all the containers you could need. In the simplest form, the two main tools provided are Docker Desktop, used by developers for easily creating and sharing containerized applications, and Docker Hub, an online library of ready to use, community-made container templates, called *images*. Docker can also run a container, but does not have many tools to maintain desired states, form connections between containers, and many other functions essential for running multiple containers.

The true power of Docker and Kubernetes come into view when they are combined. Starting with Docker, we can create and package our app into containers, pulling previously made container images to solve some common problems. Then we can run these containers in Kubernetes, which will manage the execution of the underlying containers and maintain the apps ideal condition environment. In each step of the process, the user’s ease of use is prioritized through these apps, turning the task of running containers which at one time required near-constant interference to be one largely streamlined and automated.

### Kubernetes Basic Concepts
Now we know broadly what Kubernetes is and a little bit about its most important partner, Docker, but what does Kubernetes look like once you jump into it? Below we’ll break down the basic components present in any Kubernetes app and show how they build on each other. We’ll also look at some of the additional tools sure to help you along the way.

#### Pods
These are the smallest unit of application in Kubernetes. Pods represent a single, isolated instance of an application and the resources needed to execute it, *each having its own IP address*. Pods are made up of *one or more containers* that work together and share a life cycle on the same node; each pod could be composed of a single container or multiple containers, depending on its complexity. This can be advantageous as all containers within the same pod can communicate without the need for additional setup from the user.

These pods, however, are highly isolated and alone cannot communicate with other pods. This is where our next component, services, comes into the picture.

#### Services
Services are an abstraction which sits one level above pods, acting as a director between individual pods and the outside world. As pods are isolated instances, they normally would not have access to one another. Services fix this problem by defining a *policy to access*, an entry condition of sorts, for a select set of pods decided by a selector. Once this is done, pods in this service's set can communicate freely until the policy to access is changed.

Services are also convenient when creating complex, interdependent programs as they set a *single Domain Name Service* (DNS) record for all pods within their service. Another part of the program, a deployment (see below), can then use this DNS name to access information from these pods without needing to know the IP addresses for each. In other words, another part of the program can connect to this pod group through the shared DNS record without needing to track the status or information of each pod. This allows a greater flexibility to the program through isolation, as pods can be added or removed from the service group without revision needed to the deployment.

#### Deployments
Our final component of Kubernetes, Deployments, takes the hassle out of upgrading pods. Normally, when upgrading a system, one would have to shut off all old instances then reboot the system using the upgraded instances, resulting in a period of downtime. Kubernetes’ deployments allow us to sidestep this problem by allowing for *rolling updates* during which pods are taken down one-by-one, upgraded to the new version, and verified as functional before moving onto the next. In doing so, Kubernetes ensures that not only is there no downtime but also that each pod is upgraded as it should. This process can also be repeated in the opposite order should the new program contain an error, resulting in an automated rollback to the previous version.
For a closer look at pods, services, deployments, and replication controllers check out our previous article on Kubernetes.

#### Minikube
The first of our additional tools, Minikube creates a *virtual testing ground* for all your containerized programs. When run, Minikube creates a Virtual Machine (VM) on your computer which will simulate the behavior of a physical system without the risk of making unwanted changes to your machine. This VM is a simple single-node cluster, meaning that it behaves as a group of computers with only one machine hooked up. This simplified cluster form and simulated behavior makes Minikube the perfect development and testing environment for unfinished programs or for simply learning container-based programming.

While this is ideal for Linux and Mac users, Windows users may have a hard time getting it started. For Windows, instead try Docker Desktop; it has the same test environment functionality with a simpler fit into Windows’ infrastructure.

#### kubectl
For our next tool, we have kubectl, a command-line application to manage Kubernetes clusters. In many ways, the kubectl command is its own coding language with exclusive syntax and complexity. While difficult to pick up due to its extensiveness, kubectl offers unmatched control to developers, making it the most popular cluster manipulation tool for Kubernetes out there right now. Combined with Minikube, these two tools are essential for those seeking to dive into Kubernetes.

#### Kubernetes Cluster
Clusters are groups of servers all working together as a system toward the same goal. These servers are commonly referred to as nodes and can each work on independent tasks which culminate in accomplishing the system’s goal. Each cluster has a *list of conditions* defined in its config files which the cluster expects in order to run correctly, known as a *desired state*. This state could feature specifications such as which workloads should be running, container images the cluster will need access to, or hardware resources that should be available on a given machine.

#### Master and worker nodes
Nodes in a cluster have different functions; some are masters and others are workers. In each cluster, there is a master node and at least one worker node.

The master node is charged with maintaining the cluster’s desired state, freeing up resources, checking the status of each condition, and so on. It also manages the scheduling of pods across nodes in a cluster, distributing jobs to ensure all nodes are working while not becoming overloaded. The master node has various components like API Server, Controller Manager, Scheduler, and ETCD.

Worker nodes are responsible for everything else involved in running a program and do most of the lifting. These nodes can have multiple pods running on them, working on each as assigned by the master nodes. As worker nodes are mostly isolated, clusters can be scaled with more worker nodes without issue.
Keep the learning going.

### Powerful Features of Kubernetes
By now we’ve explored only the bare minimum that Kubernetes has to offer, with a range of capabilities and features you can explore as you continue to learn. Many of these capabilities and features will become increasingly important as your organization’s usage of containers grows to larger scales and more complex problems. Here are just some of the features that you can make use of to maximize the benefits of Kubernetes:
* Self-healing capabilities to maintain “desired state” conditions
* Autoscaling so you can automatically change the number of running containers, based on CPU utilization or other application-provided metrics.
* Extendable to additional functionalities with loadable modules
* Management of storage available to applications within the cluster
* Allows the storage of confidential information via secret labeling
* Easy access to logs and background information
* Automated load balancing across nodes
* Optimization of component placement for more efficient hardware optimization
* Node capability management, so that components with specialized node requirements (such as apps requiring GPU hardware) are run on nodes with the required capabilities
* Scalability via replica controllers and placement policies
* Customization of automated rollouts and rollback policies
