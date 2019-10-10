# Docker Swarm

As a platform, Docker has revolutionized the manner software was packaged. Docker Swarm or simply Swarm is an open-source container orchestration platform and is the native clustering engine for and by Docker. Any software, services, or tools that run with Docker containers run equally well in Swarm. Also, Swarm utilizes the same command line from Docker.

## Initialize a Swarm
```
$ docker swarm init --advertise-addr eth0
Swarm initialized: current node (pggnprqb96mkl4zto5dpdf73a) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-201uhsgrcavr8mdotwd6hu2ukfxaaqmyw9u72gybmfkjq75zn8-1h00y2t7c7zyq1rv0svj9btq9 10.5.10.222:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Get Manager join token
```
$ docker swarm join-token manager
To add a manager to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-201uhsgrcavr8mdotwd6hu2ukfxaaqmyw9u72gybmfkjq75zn8-8m1p4ff7d9079pihjjg3fce76 10.5.10.222:2377
```

Get worker join token
```
$ docker swarm join-token worker
To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-201uhsgrcavr8mdotwd6hu2ukfxaaqmyw9u72gybmfkjq75zn8-1h00y2t7c7zyq1rv0svj9btq9 10.5.10.222:2377
```

Leave Swarm
```
$ docker swarm leave
Node left the swarm.
```

## Example stack
#### hello-world.yml
```
version: '3'

services:
  hello-world:
    image: kerwood/hello-world
    container_name: hello-world
    ports:
      - 9001:80
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
      placement:
        constraints:
          - node.role == worker
```

## Commands
Deploy new stack
```
docker stack deploy -c hello-world-stack.yml hello-world
```

List stacks
```
$ docker stack list
NAME                SERVICES            ORCHESTRATOR
hello-world         1                   Swarm

```

List services
```
[paced@fbbprobemgmt ~]$ docker service ls
ID                  NAME                              MODE                REPLICAS            IMAGE                        PORTS
myjn218t2juz        hello-world_hello-world           replicated          2/2                 kerwood/hello-world:latest   
```