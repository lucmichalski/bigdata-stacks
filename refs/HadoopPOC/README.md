# Hadoop POC

## Prerequisites

Docker     
Docker Compose 

## Setup

Windows Host File ```C:\Windows\System32\drivers\etc\hosts```    
Mac/Linux ```/etc/hosts```

```
127.0.0.1 namenode
127.0.0.1 datanode
127.0.0.1 resourcemanager
127.0.0.1 nodemanager1
127.0.0.1 historyserver
```

## Run

```
cd Hadoop
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up
```

## Shutdown

```
cd Hadoop
docker-compose -f docker-compose.yml down

docker system prune
```

### Dashboard

```
http://<dockerhadoop_IP_address>:9870/dfshealth.html#tab-overview
```

![](assets/hadoop.png)
