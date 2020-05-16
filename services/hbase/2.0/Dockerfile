FROM yinfuyuan/hadoop:2.7.6

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

RUN useradd -m -r -g apache hbase

ENV HBASE_VERSION=2.0.0 \
    HBASE_HOME=/usr/local/hbase

ENV HBASE_DOWNLOAD_URL="http://mirror.bit.edu.cn/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz" \
    HBASE_ASC_URL="http://apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz.asc" \
    HBASE_KEYS_URL="http://apache.org/dist/hbase/KEYS" \
    PATH=${PATH}:${HBASE_HOME}/bin

RUN set -ex; \
    \
    gosu hbase ssh-keygen -t rsa -f /home/hbase/.ssh/id_rsa; \
    gosu hbase cat /home/hbase/.ssh/id_rsa.pub >> /home/hbase/.ssh/authorized_keys; \
    gosu hbase echo "StrictHostKeyChecking no" >> /home/hbase/.ssh/config; \
    \
    wget -O "hbase-${HBASE_VERSION}-bin.tar.gz" "${HBASE_DOWNLOAD_URL}"; \
    wget -O "hbase-${HBASE_VERSION}-bin.tar.gz.asc" "${HBASE_ASC_URL}"; \
    wget -O "KEYS" "${HBASE_KEYS_URL}"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends gnupg; \
    gpg --import KEYS; \
    gpg --verify "hbase-${HBASE_VERSION}-bin.tar.gz.asc" "hbase-${HBASE_VERSION}-bin.tar.gz"; \
    \
    mkdir -p "${HBASE_HOME}"; \
    tar -xzf "hbase-${HBASE_VERSION}-bin.tar.gz" -C "${HBASE_HOME}" --strip-components=1; \
    \
    ln -s ${HBASE_HOME}/conf /etc/hbase; \
    \
    mkdir /hbase && chown -R hbase:apache /hbase; \
    \
    rm -rf \
        KEYS \
        hbase-${HBASE_VERSION}-bin.tar.gz \
        hbase-${HBASE_VERSION}-bin.tar.gz.asc \
        ${HBASE_HOME}/docs \
        /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove gnupg

COPY conf/ ${HBASE_HOME}/conf/

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["start-hbase.sh"]