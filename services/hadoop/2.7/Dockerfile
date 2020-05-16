FROM openjdk:8-jre

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

RUN groupadd -r apache && useradd -m -r -g apache hadoop

ENV GOSU_VERSION=1.10

RUN set -ex; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    chmod +x /usr/local/bin/gosu

ENV HADOOP_VERSION=2.7.6 \
    HADOOP_HOME=/usr/local/hadoop

ENV HADOOP_DOWNLOAD_URL="http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    HADOOP_ASC_URL="http://apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" \
    HADOOP_KEYS_URL="http://apache.org/dist/hadoop/common/KEYS" \
    PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
        rsync \
        openssh-server; \
    \
    ssh-keygen -A; \
    gosu hadoop ssh-keygen -t rsa -f /home/hadoop/.ssh/id_rsa; \
    gosu hadoop cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys; \
    gosu hadoop echo "StrictHostKeyChecking no" >> /home/hadoop/.ssh/config; \
    \
    wget -O "hadoop-${HADOOP_VERSION}.tar.gz" "${HADOOP_DOWNLOAD_URL}"; \
    wget -O "hadoop-${HADOOP_VERSION}.tar.gz.asc" "${HADOOP_ASC_URL}"; \
    wget -O "KEYS" "${HADOOP_KEYS_URL}"; \
    \
    apt-get install -y --no-install-recommends gnupg; \
    gpg --import KEYS; \
    gpg --verify hadoop-${HADOOP_VERSION}.tar.gz.asc hadoop-${HADOOP_VERSION}.tar.gz; \
    \
    mkdir -p "${HADOOP_HOME}"; \
    tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" -C "${HADOOP_HOME}" --strip-components=1; \
    \
    ln -s ${HADOOP_HOME}/etc/hadoop /etc/hadoop; \
    \
    mkdir /hadoop && chown -R hadoop:apache /hadoop; \
    \
    rm -rf \
        KEYS \
        hadoop-${HADOOP_VERSION}.tar.gz \
        hadoop-${HADOOP_VERSION}.tar.gz.asc \
        ${HADOOP_HOME}/share/doc \
        /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove gnupg

COPY etc/hadoop/ ${HADOOP_HOME}/etc/hadoop/

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8020 8030 8031 8032 8033 8040 50010 50020 50090

CMD ["start-all.sh"]