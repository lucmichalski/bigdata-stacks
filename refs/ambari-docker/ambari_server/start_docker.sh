docker stop ambari_server
docker rm ambari_server
docker run -d --privileged -h master --name ambari_server smzx/ambari_server:v1 
