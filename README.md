# hbase-on-docker
Docker file about HBase.
Start all services via docker-compose.


## Env:
* JDK 1.8.0_162
* CentOS 6.6
* Hadoop 2.7.3
* HBase 2.0-alpha4

## How To Build Docker Images
`docker-compose -f build-images.yml build`

## How To Start Container
`docker-compose up -d`

And you would get the list of containers:
* master
* slave1
* slave2

## How To Operating HBase In Container After All Containers
1. Get into container of hbase master via below command:
    * `docker exec -it master bash`

2. Using HBase shell:
    * `hbase shell`

## How To Starting All Containers After Stop
`docker-compose start`

## Service Web UI
HBase:`http://{hostip}:16010`

Hadoop:`http://{hostip}:50070`

Yarn Application:`http://{hostip}:8088`

*Note: _{hostip}_ is the ip of your host node. If your host ip is 192.168.1.78, you could access the HBase web ui via _http://192.168.1.78:16010_*

## Test HBase Bulkload

To see [HBase Book about import data](http://hbase.apache.org/book.html#import) to know more information.

The below example would import data to HBase via `hbase org.apache.hadoop.hbase.mapreduce.ImportTsv` command.
To see [HBase ImportTsv](http://hbase.apache.org/book.html#importtsv) understand more details.

If you have a data file stored on HDFS path:`/tmp/importsv` which you want to bulk load to hbase table, and below is the data format:

`
rowkey000000000,Test1,Test2,Test3,Test4,Test5,Test6,Test7,Test8,Test9,Test10
`

When ImportTsv MR job finished, executing the `LoadIncrementalHFiles command to move generated StoreFiles into an HBase table.

* Step 1. Create HBase table:
    - `create 'bktable', {NAME => 'cf'},   {SPLITS => ['rowkey033333333', 'rowkey066666666']}`
* Step 2. Execute HBase ImportTsv command:
    - `hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.columns=HBASE_ROW_KEY,cf:c1,cf:c2,cf:c3,cf:c4,cf:c5,cf:c6,cf:c7,cf:c8,cf:c9,cf:c10 -Dimporttsv.skip.bad.lines=false '-Dimporttsv.separator=,' -Dimporttsv.bulk.output=hdfs://master:9000/tmp/bktableoutput bktable hdfs://master:9000/tmp/importsv`
* Step 3. CompleteBulkLoad:
    - `hbase org.apache.hadoop.hbase.tool.LoadIncrementalHFiles hdfs://master:9000/tmp/bktableoutput bktable`
