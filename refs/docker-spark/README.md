# Personal Dockerfile for Machine Learning and BigData processing

If you reached out here for exploring Jupyter Docker images, I recommend you to check the following repository.<br>
[https://github.com/jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)<br>

2 Dockerfiles
- spark-cluster
- dev-env

## spark-cluster
This Dockerfile is currently based on jupyter/pyspark-notebook.<br>
The following packages are installed here.
- Scala 2.11
- Apache Mahout 0.13.0
- Keras
- Tensorflow
- Opencv
- Elephas
- python API for retrieving data from Poloniex

This Docker image is mainly used to bring up a Spark cluster.

## dev-env
This Dockerfile is based on spark-cluster.<br>
The following packages are installed here.
- Emacs
- Angular
- SBT
- Maven
- openjdk8-jdk

This is my development environment.

## Building

```
docker image build -t [docker image name] .
```

## How to use
After building the Dockerfiles as Docker images, run the following command to start a new docker container.<br>

```
docker container run --name=[docker container name] -it -v [host folder]:/home/jupyter/workspace -p [host port]:8888 [docker image name]
```

* --name&nbsp;&nbsp;[docker container name]<br>
* -it&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;run container in iteractive mode using tty connection.<br>
* -v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mount a [host folder] as /home/jupyter/workspace in the container. workspace folder is the root directory of jupyter notebook.<br>
* -p&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bind container port 8888 to the [host port].<br>

or you can use dev-env/spark-notebook-start.sh to run a container instance.<br>
Please note that spark-notebook-start.sh will start a jupyter notebook server without any authentification.

## PYTHONPATH
As I use personal libraries in my daily work, I mount the my libraries onto a PYTHONPATH volume in the docker container.

```
-v [host PYTHONPATH folder]:/opt/pythonlibs
```

## Bring up a Spark Cluster
Copy spark-cluster/docker-compose.yml to anywhere you like.
Bring up a spark cluster by the following command

```
docker-compose up
```
