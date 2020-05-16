FROM pkeropen3/alpine-base
MAINTAINER pkeropen3<pkeropen3@163.com>

LABEL description="Build docker flume 1.6.0"

ENV FLUME_VERSION 1.6.0

# Download and Install Flume

RUN wget -q http://archive.apache.org/dist/flume/$FLUME_VERSION/apache-flume-$FLUME_VERSION-bin.tar.gz && \
   tar xzf apache-flume-$FLUME_VERSION-bin.tar.gz -C /opt/ && \
   mv /opt/apache-flume-$FLUME_VERSION-bin /opt/flume && \
   mv /opt/flume/conf/flume-env.sh.template /opt/flume/conf/flume-env.sh && \ 
   rm apache-flume-$FLUME_VERSION-bin.tar.gz

RUN sed -i "/^# export JAVA_HOME/ s:.*:export JAVA_HOME=$JAVA_HOME\n:" /opt/flume/conf/flume-env.sh

RUN mkdir /opt/flume-config

ADD start-flume.sh /opt/flume/bin/start-flume.sh
RUN chmod a+x /opt/flume/bin/start-flume.sh

ADD sink.conf /opt/flume-config/sink.conf
RUN chmod a+x /opt/flume-config/sink.conf

ADD source.conf /opt/flume-config/source.conf
RUN chmod a+x /opt/flume-config/source.conf

VOLUME /opt/flume
VOLUME /opt/flume-config

ENV PATH=$PATH:/opt/flume/bin

# source port
EXPOSE 44444

WORKDIR /opt/flume/bin

ENTRYPOINT ["start-flume.sh"]