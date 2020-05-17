FROM golang as builder
WORKDIR /go/src/github.com/influxdata/telegraf
COPY . /go/src/github.com/influxdata/telegraf
RUN make
RUN make go-install

FROM buildpack-deps:stretch-curl

COPY --from=builder /go/bin/* /usr/bin/

COPY etc/telegraf_mqtt.conf /etc/telegraf/telegraf.conf
ENV MQTT_HOST="mqtt"
ENV MQTT_PORT="1883"
ENV INFLUXDB_URL="http://influxdb:8086"
ENV INFLUXDB_DB_NAME="raw_mqtt"
ENV INFLUXDB_MEASUREMENT_NAME="string_data"

COPY scripts/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
