FROM alpine:3.7

LABEL maintainer="pereira.jeferson@outlook.com"
LABEL version="1.0"

ENV alertmanager_version 0.14.0

WORKDIR /alertmanager

RUN apk update && apk --no-cache --virtual add curl \
    && curl -LO https://github.com/prometheus/alertmanager/releases/download/v${alertmanager_version}/alertmanager-${alertmanager_version}.linux-amd64.tar.gz \
    && tar -xvzf alertmanager-${alertmanager_version}.linux-amd64.tar.gz \
    && cp alertmanager-${alertmanager_version}.linux-amd64/alertmanager /bin \
    && rm -rf alertmanager-${alertmanager_version}.linux-amd64* \
    && apk del curl \
    && rm -rf /var/cache/apk/*

VOLUME /alertmanager
VOLUME /etc/alertmanager
ADD conf/config.yml /etc/alertmanager/

EXPOSE "9093"
CMD ["--config.file=/etc/alertmanager/config.yml", "--storage.path=/alertmanager"]
ENTRYPOINT ["alertmanager"]
