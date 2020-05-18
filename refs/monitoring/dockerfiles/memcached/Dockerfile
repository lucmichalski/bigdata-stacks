FROM alpine:3.8

LABEL maintainer="pereira.jeferson@outlook.com" \
      version="1.0"

ENV memcached_version 0.4.1

WORKDIR /memcached

RUN apk --update --no-cache --virtual add curl \
    && curl -LO https://github.com/prometheus/memcached_exporter/releases/download/v${memcached_version}/memcached_exporter-${memcached_version}.linux-amd64.tar.gz \
    && tar -xvzf memcached_exporter-${memcached_version}.linux-amd64.tar.gz \
    && cp memcached_exporter-${memcached_version}.linux-amd64/memcached_exporter /bin \
    && rm -rf memcached-${memcached_version}.linux-amd64* \
    && apk del curl \
    && rm -rf /var/cache/apk/*

CMD memcached_exporter --memcached.address=$MEMCACHED_HOST:$MEMCACHED_PORT
EXPOSE "9150"
