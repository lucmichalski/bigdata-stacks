#!/bin/bash
set -e;

cd ${WARP10_HOME}/etc/
python ${WARP10_HOME}/etc/config.py

#
# Classpath
#
LOG4J_CONF=${WARP10_HOME}/etc/log4j.properties
JAVA_HEAP_DUMP=${WARP10_HOME}/logs/java.heapdump
# you can specialize your metrics for this instance of Warp10
#SENSISION_DEFAULT_LABELS=-Dsensision.default.labels=instance=warp10-test,env=dev
JAVA_OPTS="-Djava.awt.headless=true -Dlog4j.configuration=file:${LOG4J_CONF} -Dsensision.server.host=0.0.0.0 -Dsensision.server.port=7090 ${SENSISION_DEFAULT_LABELS} -XX:+UseG1GC"
WARP10_USER=warp10
WARP10_GROUP=warp10
WARP10_CONFIG=${WARP10_HOME}/etc/warp.conf
WARP10_JAR=${WARP10_HOME}/bin/warp10-${WARP10_VERSION}.jar
WARP10_CLASS=io.warp10.WarpDist
echo "${JAVA_HOME}/bin/java ${JAVA_OPTS} -cp ${WARP10_JAR} ${WARP10_CLASS} ${WARP10_CONFIG}"
${JAVA_HOME}/bin/java ${JAVA_OPTS} -cp ${WARP10_JAR} ${WARP10_CLASS} ${WARP10_CONFIG}