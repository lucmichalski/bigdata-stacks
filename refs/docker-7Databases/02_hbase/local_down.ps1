docker-compose -f docker-images\docker-compose-standalone.yml down

docker volume rm docker-hbase_hadoop_namenode
docker volume rm docker-hbase_hadoop_datanode
docker volume rm docker-hbase_hadoop_historyserver
docker volume rm docker-hbase_hbase_data
docker volume rm docker-hbase_hbase_zookeeper_data
