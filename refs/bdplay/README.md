# bigdata playground - bdplay
Bdplay aims to provide a simple deployment of bigdata platform for beginners and for testing purpose.
It packages bigdata softwares in one docker image and provide some necessary configure, which makes it easy to deploy
in cluster with docker-compose or kubernetes.

Bdplay integrates kafka, hadoop, flink, spark. And planing to include more.

You can easily submit batch and streaming jobs to cluster and take advantage the co-functioning of big-data software.

flink and spark can take the advantage of the locality with hdfs and kafka in the same node, witch makes the data
processing low overhead.

## build
cd to docker directory
run `sudo bash build.sh`
a docker image named bdplay will be ready

## deployment
every bigdata software is installed under /opt directory.

Each container has role of either master or worker. Currently, only single master is supported. you can scale up as many workers
as you want to scale up the computation capability.

start master simply with CMD: `master`.

start worker simply with CMD: `worker`.

All configurations are done by docker environment variables or directly by config map.

### deploy by docker-compose
cd to empty directory and create a new file [docker-compose.yml](./docker-compose.yml) and put following content:

```yaml
version: "3"
services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    ports:
      - 2181:2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181
  master:
    image: bdplay
    expose:
      - "6123"
    ports:
      - 6123:6123
      - 8081:8081
      - 9000:9000
      - 9870:9870
      - 8088:8088
      - 19888:19888
      - 10020:10020
      - 7077:7077
      - 8082:8082
      - 9092:9092
    command: master tail -f /dev/null
    links:
      - "zoo1:zoo1"
    environment:
      - HOSTNAME_MASTER=master
      - KAFKA_ZOOKEEPER_CONNECT=zoo1:2181
  worker:
    image: bdplay
    expose:
      - "6121"
      - "6122"
    depends_on:
      - master
    command: worker tail -f /dev/null
    links:
      - "master:master"
      - "zoo1:zoo1"
    environment:
      - HOSTNAME_MASTER=master
      - KAFKA_ZOOKEEPER_CONNECT=zoo1:2181
```

run `docker-compose up --scale worker=2`

flink web ui will be available at: [http://localhost:8081](http://localhost:8081)

spark web ui at: [http://localhost:8082](http://localhost:8082)

hadoop resource manager web ui at [http://localhost:8088](http://localhost:8088)

hadoop hdfs webui at [http://localhost:9870](http://localhost:9870)

### deploy by kubernetes

create a yaml file [bdplay.yaml](./bdplay.yaml) and put such content:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: zk
  labels:
    app: zk
spec:
  ports:
  - port: 2181
    name: client
  selector:
    app: zk
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: zk
spec:
  selector:
    matchLabels:
      app: zk
  template:
    metadata:
      labels:
        app: zk
    spec:
      containers:
      - name: zk
        image: zookeeper
        imagePullPolicy: IfNotPresent
        env:
        - name: ZOO_MY_ID
          value: "1"
        - name: ZOO_SERVERS
          value: server.1=0.0.0.0:2888:3888;2181
---
apiVersion: v1
kind: Service
metadata:
  name: bdplay-master
  labels:
    app: bdplay
spec:
  ports:
  - port: 6123
    name: flink-rpc
  - port: 8081
    name: flink-web
  - port: 9000
    name: hdfs-server
  - port: 9870
    name: hdfs-web
  - port: 8088
    name: res-man-web
  - port: 19888
    name: job-his-web
  - port: 10020
    name: job-rpc
  - port: 7077
    name: spark-serv
  - port: 8082
    name: spark-web
  - port: 9092
    name: kafka
  selector:
    app: bdplay
    role: master
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bdplay-master
  labels:
    app: bdplay
spec:
  selector:
    matchLabels:
      app: bdplay
      role: master
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: bdplay
        role: master
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - bdplay
            topologyKey: "kubernetes.io/hostname"
      containers:
      - image: bdplay
        imagePullPolicy: IfNotPresent
        name: bdplay-master
        command:
        - /opt/start.sh
        - master
        - tail 
        - "-f"
        - /dev/null
        env:
        - name: HOSTNAME_MASTER
          value: bdplay-master
        - name: KAFKA_ZOOKEEPER_CONNECT
          value: zk:2181
        - name: SPARK_MASTER_HOST
          value: 0.0.0.0
        - name: KAFKA_ADV_HOSTNAME
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bdplay-worker
  labels:
    app: bdplay
spec:
  replicas: 2
  selector:
    matchLabels:
      app: bdplay
      role: worker
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: bdplay
        role: worker
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - bdplay
            topologyKey: "kubernetes.io/hostname"
      containers:
      - image: bdplay
        imagePullPolicy: IfNotPresent
        name: bdplay-worker
        command:
        - /opt/start.sh
        - worker
        - tail 
        - "-f" 
        - /dev/null
        env:
        - name: HOSTNAME_MASTER
          value: bdplay-master
        - name: KAFKA_ZOOKEEPER_CONNECT
          value: zk:2181
        - name: KAFKA_ADV_HOSTNAME
          valueFrom:
            fieldRef:
              fieldPath: status.podIP

```

run `kubectl apply -f bdplay.yaml` to start the cluster.

the master and worker containers will be run on different nodes.
```bash
> kubectl get pods
NAME                             READY   STATUS    RESTARTS   AGE   IP            NODE           NOMINATED NODE   READINESS GATES
bdplay-master-59b599fd79-5z4lx   1/1     Running   0          37m   10.244.1.12   kind-worker3   <none>           <none>
bdplay-worker-6b8dfc8897-8nhtc   1/1     Running   0          37m   10.244.2.10   kind-worker    <none>           <none>
bdplay-worker-6b8dfc8897-wdlsn   1/1     Running   0          37m   10.244.3.12   kind-worker2   <none>           <none>
zk-7449fd49cb-98vkn              1/1     Running   0          37m   10.244.2.9    kind-worker    <none>           <none>
```

start a bash inside pod: `kubectl exec -it bdplay-worker-6b8dfc8897-8nhtc gosu bdplay bash`

start port forwarding: `kubectl port-forward service/bdplay-master 8081:8081 9870:9870 8088:8088 19888:19888 8082:8082`

Now web ui can be accessed from localhost just as docker-compose deployment.

## start to play

### paly the hdfs

you need to start a shell inside container to run following command.

put files to hdfs: `hadoop fs -put /opt/spark/README.md hdfs://bdplay-master:9000/`

list files: 
```bash
> hadoop fs -ls  hdfs://bdplay-master:9000/
Found 2 items
-rw-r--r--   1 bdplay supergroup       3756 2020-02-15 12:25 hdfs://bdplay-master:9000/README.md
drwxrwx---   - bdplay supergroup          0 2020-02-15 11:42 hdfs://bdplay-master:9000/tmp
```

### test kafka functionality

1. create topic:
```bash
kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test
```

2. list topic
```bash
 bin/kafka-topics.sh --list --bootstrap-server localhost:9092
 # or
 bin/kafka-topics.sh --list --zookeeper zk:2181
```

3. send message
```bash
> bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
> hello
> world
> ^C
```

4. show all message
```bash
> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
hello
world
^C
```

### flink example

start a new flink application [wordcount](./examples/flink-wordcount) use maven:
```bash
mvn archetype:generate -DarchetypeGroupId=org.apache.flink -DarchetypeArtifactId=flink-quickstart-scala -DarchetypeVersion=1.9.2 \
 -DgroupId=flink.start -DartifactId=flink-start
```

the project structure looks like as following:
```
tree quickstart
quickstart/
├── pom.xml
└── src
    └── main
        ├── resources
        │   └── log4j.properties
        └── scala
            └── org
                └── myorg
                    └── quickstart
                        ├── BatchJob.scala
                        └── StreamingJob.scala
```

edit source file as in the example:
```scala
object StreamingJob {
    def main(args: Array[String]) {
        // set up the streaming execution environment
        val env = StreamExecutionEnvironment.getExecutionEnvironment
        val params = ParameterTool.fromArgs(args)
        env.getConfig.setGlobalJobParameters(params)

        val text = env.readTextFile(params.get("input"))

        val counts = text.flatMap(_.toLowerCase.split("\\W+")).filter(_.nonEmpty).map((_, 1)).keyBy(0).sum(1)

        if (params.has("output")) {
            counts.writeAsText(params.get("output"))
        } else {
            counts.print()
        }

        // execute program
        env.execute("Flink Streaming Scala API Skeleton")
    }
}
```

build it by `mvn clean package`

now that you can submit the job by:

```bash
flink run ./target/flink-start-1.0-SNAPSHOT --input /path/to/some/text/data --output /path/to/result
```

you can watch the job execution detail from web ui.

### spark example

you can use flink maven quick start template, and change the dependencies accordingly
```bash
mvn archetype:generate -DarchetypeGroupId=org.apache.flink -DarchetypeArtifactId=flink-quickstart-scala -DarchetypeVersion=1.9.0 \
 -DgroupId=spark.wordcount -DartifactId=spark-wordcount
```

spark wordcount example with hdfs source and kafka sink is available under [examples/spark-wordcount](./examples/spark-wordcount/src/main/scala/spark/wordcount/BatchJob.scala)

submit spark job by:
```bash
spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0 --master spark://bdplay-master:7077 target/spark-wordcount-1.0-SNAPSHOT.jar hdfs://localhost:9000/README.md
```

now check out the job execution from web ui http://localhost:8082.

the result will be published to kafka topic: wordcount.

## flink

Currently, flink deployment support only single jobmanager. considering multi jobmanager support in the future.

### configuration
file: /opt/flink/conf/flink-conf.yaml

template: /opt/conf/flink/flink-conf.yaml.template

environment variables:
```
FLINK_JOBMANAGER_HEAP_SIZE: flink jobmanager heap size, default 1024m
FLINK_TASKMANAGER_HEAP_SIZE: flink taskmanager heap size, default 1024m
FLINK_TASKMANAGER_NUM_SLOT: flink number of task slots,  default number of cpu cores
FLINK_CONF_BY_FILE: default empty, if set to true, environment variables substitution will not take effect
ENABLE_BUILT_IN_PLUGINS: semi-colon separated plugin names
```

### port map
|port  |description    |
|------|------------------------------------|
|6123  |jobmanager.rpc.port, used to submit jobs. |
|8081  |web front end  |


## hadoop

### configuration
refer to [hadoop deploy doc](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/ClusterSetup.html)

- etc/hadoop/core-site.xml
- etc/hadoop/hdfs-site.xml
- etc/hadoop/yarn-site.xml
- etc/hadoop/mapred-site.xml

### env:
|key |   default      | description |
|------|------------------------------------|---|
|HDFS_NAME_DIR| /data/hadoop/hdfs/name/ | namenode dir, need not to change |
|HDFS_DATA_DIR| /data/hadoop/hdfs/data/ | datanode dir, need not to change |
|HDFS_REPLICATION| 1 | hdfs data replication |
|YARN_NODE_RES_MEM_MB| 8192 | Defines total available resources on the NodeManager to be made available to running containers |
|HADOOP_CONFIG_BY_FILE| - | set to true if you want to use config map |



### port map

|port|description|
|------|:------------------------------------|
|9000  | hdfs server port |
|9870  | hdfs web front end  |
|8088  | resource manager webui |
|19888 | job history server webui|
|10020 | job history rpc port |

## spark

### env
for detailed env config, check out [spark documentation](https://spark.apache.org/docs/latest/)

useful docker env variables

|key   |   default    |    description   |
|------|------------------------------------|:---|
|SPARK_MASTER_HOST| localhost | spark master host |

### port map
|port  |  description  |
|------|------------------------------------|
|7077  | spark server port |
|8082  | spark web ui port |

## kafka
### env
|key   |   default      |   description |
|------|----------------|---------------| 
|KAFKA_ENABLED| true | enable kafka on each worker |
|KAFKA_ZOOKEEPER_CONNECT | - | comma separated zookeeper host:port, if kafak enabled this variable is required |
|KAFKA_CONF_BY_FILE | - | set to true if use direct file config |

### port map
|port  |description                 |
|------|------------------------------------|
|9092  | kafka listen port |

## Problems

Currently submission of job outside the cluster will fail. One possible solution is to create a
service for each worker.

## Todos
1. config and data volume map.
2. add more big-data software into docker image.
3. make cluster service available outside the container.
4. add more batch job and stream job examples.