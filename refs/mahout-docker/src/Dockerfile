ARG HADOOP_VERSION=""
ARG JAVA_VERSION=""

FROM mpolatcan/hadoop:${HADOOP_VERSION}-java${JAVA_VERSION}

ARG MAHOUT_VERSION=""
ARG MAHOUT_ZIP_FOLDER_NAME="apache-mahout-distribution-${MAHOUT_VERSION}"
ARG MAHOUT_DOWNLOAD_LINK="http://www-eu.apache.org/dist/mahout/${MAHOUT_VERSION}/${MAHOUT_ZIP_FOLDER_NAME}.tar.gz"

ENV MAHOUT_HOME "${HDUSER_HOME}/mahout"
ENV PATH $PATH:$MAHOUT_HOME/bin

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

USER root
RUN mkdir -p ${MAHOUT_HOME} && \
    wget ${MAHOUT_DOWNLOAD_LINK} && \
    tar -xvzf ${MAHOUT_ZIP_FOLDER_NAME}.tar.gz -C ${HDUSER_HOME} && \
    mv ${MAHOUT_ZIP_FOLDER_NAME}/* ${MAHOUT_HOME} && \
    rm -r ${MAHOUT_ZIP_FOLDER_NAME} && \
    rm ${MAHOUT_ZIP_FOLDER_NAME}.tar.gz && \
    chown -R hduser:hadoop ${MAHOUT_HOME}

USER hduser
ENTRYPOINT ["./hadoop_entrypoint.sh", "hadoop"]