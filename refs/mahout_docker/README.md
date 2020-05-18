# Apache Mahout for Docker

Running [Apache Mahout](https://mahout.apache.org/) in [Docker](https://www.docker.com/).

The following will run Mahout in a Spark shell:
```bash
git clone https://github.com/t0xic-m/mahout_docker.git
cd mahout_docker
docker-compose run mahout
```

Try an example:
- [Playing with Mahout's Spark Shell](https://mahout.apache.org/docs/latest/tutorials/samsara/play-with-shell.html)

## Info

The Docker image runs the following Apache services:
- [Apache Mahout 0.14.2](https://mahout.apache.org/)
- [Apache Maven 3.6.3](https://maven.apache.org/)
- [Apache Hadoop 3.2.1](https://hadoop.apache.org/)
- [Apache Spark 3.0.0-preview2](https://spark.apache.org/)
