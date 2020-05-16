FROM zookeeper:3.4.12

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

WORKDIR /

RUN adduser -D kafka

ENV KAFKA_HOME=/usr/local/kafka \
    SCALA_VERSION=2.11 \
    KAFKA_VERSION=1.1.0

ENV KAFKA_DOWNLOAD_URL="http://mirror.bit.edu.cn/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    KAFKA_ASC_URL="http://www.us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc" \
    KAFKA_KEYS_URL="http://www.us.apache.org/dist/kafka/KEYS" \
    PATH=${PATH}:${KAFKA_HOME}/bin

RUN set -ex; \
    \
    wget -O kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz "${KAFKA_DOWNLOAD_URL}"; \
    wget -O kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc "${KAFKA_ASC_URL}"; \
    wget -O KEYS "${KAFKA_KEYS_URL}"; \
    \
    apk add --no-cache --virtual .build-deps gnupg; \
    gpg --import KEYS; \
    gpg --verify kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz; \
    \
    mkdir -p "$KAFKA_HOME"; \
    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C "$KAFKA_HOME" --strip-components=1; \
    \
    ln -s ${KAFKA_HOME}/config /etc/kafka; \
    \
    mkdir /kafka && chown -R kafka:kafka /kafka; \
    \
    rm -rf \
        KEYS \
        kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
        kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc; \
    apk del .build-deps

COPY config/ /etc/kafka/

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 9092

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["kafka-server-start.sh"]