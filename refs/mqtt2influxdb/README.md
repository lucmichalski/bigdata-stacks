Quick and Dirty build of a Telegraf-based Docker Image to store raw data from MQTT into InfluxDB.  
This repository will become much simpler when [this](https://github.com/influxdata/telegraf/pull/7177) pull request is merged into Telegraf, until then:

## Build

    docker build -t dersimn/mqtt2influxdb .

(or use the pre-build image on [Docker Hub](https://hub.docker.com/repository/docker/dersimn/mqtt2influxdb))

## Run

Configure environment variables according to your needs:

    MQTT_HOST="mqtt"
    MQTT_PORT="1883"
    INFLUXDB_URL="http://influxdb:8086"
    INFLUXDB_DB_NAME="raw_mqtt"
    INFLUXDB_MEASUREMENT_NAME="string_data"

Example:

    docker run -d --restart=always --name=mqtt2influxdb -e "MQTT_HOST=10.1.1.50" -e "INFLUXDB_URL=http://10.1.1.50:8086" dersimn/mqtt2influxdb

See [this file](https://github.com/dersimn/mqtt2influxdb/blob/master/etc/telegraf_mqtt.conf) for more detailes about how this tool works.