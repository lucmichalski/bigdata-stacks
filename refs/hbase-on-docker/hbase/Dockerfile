FROM mathstana/hadoop:2.7.3
MAINTAINER mathstana <stana@is-land.com.tw>

#Default version. It would be recover by docker-compose
ARG HBASE_VERSION=2.0.0-alpha4

#Download hbase, and tar gz file to /opt/hbase
#RUN wget http://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz -P /opt
RUN wget https://dist.apache.org/repos/dist/dev/hbase/hbase-2.0.0-alpha4RC0/hbase-2.0.0-alpha4-bin.tar.gz -P /opt
RUN cd /opt && mkdir hbase && tar --strip-component=1 -zxvf hbase-${HBASE_VERSION}-bin.tar.gz -C hbase

#Copy configuration file to cluster
COPY config /opt/hbase/conf
#Remove tar file
RUN rm /opt/hbase-${HBASE_VERSION}-bin.tar.gz

#Set env variable
ENV HBASE_HOME /opt/hbase
ENV PATH $PATH:$HBASE_HOME/bin
