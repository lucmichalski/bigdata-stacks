###############################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

ARG BASE_IMAGE
FROM $BASE_IMAGE

# install flink
COPY flink /opt/flink
ARG SCALA_VERSION_ARG
ENV SCALA_VERSION=${SCALA_VERSION_ARG}
ARG FLINK_VERSION_ARG
ENV FLINK_VERSION=$FLINK_VERSION_ARG
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
# jobmanger.rpc.port
EXPOSE 6123
# webui
EXPOSE 8081

# install hadoop
COPY hadoop /opt/hadoop
ARG HADOOP_VERSION_ARG
ENV HADOOP_VERSION=$HADOOP_VERSION_ARG
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$HADOOP_HOME/bin:$PATH
# hdfs server port
EXPOSE 9000
# hdfs web front end
EXPOSE 9870
# resource manager webui
EXPOSE 8088
# job history server webui
EXPOSE 19888
# job history rpc port
EXPOSE 10020

# install spark
COPY spark /opt/spark
ARG SPARK_VERSION_ARG
ENV SPARK_VERSION=$SPARK_VERSION_ARG
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_WEBUI_PORT=8082
EXPOSE 7077
EXPOSE 8082

# install kafka
COPY kafka /opt/kafka
ARG KAFKA_VERSION_ARG
ENV KAFKA_VERSION=$KAFKA_VERSION_ARG
ENV KAFKA_HOME=/opt/kafka
ENV PATH=$KAFKA_HOME/bin:$PATH
EXPOSE 9092


# Install dependencies
RUN set -ex; \
    cp -a /etc/apt/sources.list /etc/apt/sources.list.bak; \
    sed -i "s@http://.*debian.org@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list; \
    apt-get update; \
    apt-get -y install libsnappy1v5 gettext-base; \
    apt -y install gosu;\
    apt -y install procps gdb net-tools; \
    apt -y install vim; \
    rm -rf /var/lib/apt/lists/*

# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11
RUN set -ex; \
    gosu nobody true

RUN groupadd --system --gid=9999 bdplay && \
    useradd --system --home-dir /opt --uid=9999 --gid=bdplay bdplay

# install startup script
COPY common /opt/common
COPY master /opt/master
COPY worker /opt/worker
COPY conf /opt/conf
COPY start.sh /opt/

RUN set -ex; \
    chmod a+x /opt/*.sh; \
    chmod a+x /opt/common/*.sh; \
    chmod a+x /opt/master/*.sh; \
    chmod a+x /opt/worker/*.sh; \
    chown -R bdplay:bdplay /opt; \
    mkdir -p /data; \
    chown -R bdplay:bdplay /data

WORKDIR /opt/
ENTRYPOINT ["/opt/start.sh"]
CMD ["help"]
