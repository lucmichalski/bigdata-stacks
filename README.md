# Grafana and InfluxDB

An optimized docker version of Grafana with InfluxDB as data source.  
All persistent volumes are already set and they are mounted at container run.  
You could edit configuration file of all services, a Nginx reverse proxy extend web server functionalities like TLS connections in production environments.  

## Quickstart 

**1 - Environment File**  
Create a new environment variables `.env` file in project root folder and set respective value as shown below:

```
GF_SERVER_ROOT_URL=http://your.domain.com
GF_SECURITY_ADMIN_PASSWORD=mypassword

INFLUXDB_DB=db_name
INFLUXDB_HTTP_AUTH_ENABLED=true
INFLUXDB_ADMIN_USER=db_user
INFLUXDB_ADMIN_PASSWORD=db_passwd

NGINX_HTTP_PORT=80
```

**2 - Create configuration files**  
Clone following files w/o `-sample` suffix in file name:  

- `grafana/defaults-sample.ini`
- `influxdb/influxdb-sample.conf`
- `nginx/default-sample.conf`

CLI Commands

```
cp grafana/defaults-sample.ini grafana/defaults.ini
cp influxdb/influxdb-sample.conf influxdb/influxdb.conf
cp nginx/default-sample.conf nginx/default.conf 
```

Feel free to change configuration files with your custom values.


**3 - Build Docker images**    
Build new images stack in order to configure them with custom parameters.

```
# Load environment variable
source .env

# Build required Docker images
docker-compose build
```

**4 - Run Docker containers stack**  
Run Docker containers by Docker Compose

```
# Load environment variable
source .env

# Run containers
docker-compose up -d
```

Stop containers
```
docker-compose down
```

**5 - Connect to Grafana UI**  
Run in your browser Grafana URL and login into the UI

```
# Local environment
http://localhost

# Online instance
http://your.domain.com
```

## Containers Stack
The service is composed by three containers:

- **Grafana**: Charts and metrics UI
- **InfluxDB**: Time series database to store all metrics
- **Nginx**: Reverse proxy to manage HTTP/S requests and proxy to Grafana
 

### Grafana

Current version: `latest` on [Docker Hub](https://hub.docker.com/r/grafana/grafana)

You can log in to Grafana UI as `admin` user and password set in `.env` file.

**TODO**  
- [ ] Restric access to default Grafana UI port (3000)


### InfluxDB

Current version: **1.5.4**

Test connection to InfluxDB

```
# Run a container as InfluxDB client and send requests to InfluxDB container by curl
GRAFANA_INFLUXDB_NET=`docker network ls | grep grafana-influxdb | tr -s ' ' | cut -d ' ' -f 2`
docker run --rm -t \
    --network=$GRAFANA_INFLUXDB_NET \
    influxdb:1.5.4 \
    curl -G http://influxdb:8086/query -u db_user:db_passwd --data-urlencode "q=SHOW DATABASES"
```

### Nginx

Default configuration allows Nginx to send request to Grafana container to default exposed port (3000).

## Persistent Storage

I've mapped all folders inside containers to keep all important data stored in host folders.  
In case you will destroy and re-run containers stack you won't lose any important information.

Mounted Docker volumes:

- `grafana/etc/grafana/provisioning`
- `grafana/var/lib/grafana`
- `grafana/var/log/grafana`
- `influxdb/var/lib/influxdb`

For more information about mounted volumes and related path check `docker-compose.yml`.

