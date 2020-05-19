#!/usr/bin/env bash

BASE_IMAGE=openjdk:8-jre
THIS_DIR=`dirname $0`
BUILD_DIR=${THIS_DIR}/build
DOWNLOAD_DIR=${THIS_DIR}/download

source ${THIS_DIR}/util.sh

#base config
SCALA_VERSION=2.11

APACHE_MIRROR_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/

# create dirs
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR
[ -d $DOWNLOAD_DIR ] || mkdir -p $DOWNLOAD_DIR

# install hadoop keys
[ ! -f $DOWNLOAD_DIR/HADOOP_KEYS ] && wget -nv -O $DOWNLOAD_DIR/HADOOP_KEYS https://dist.apache.org/repos/dist/release/hadoop/common/KEYS
gpg --import $DOWNLOAD_DIR/HADOOP_KEYS || exit 1

# install spark keys
[ ! -f $DOWNLOAD_DIR/SPARK_KEYS ] && wget -nv -O $DOWNLOAD_DIR/SPARK_KEYS https://dist.apache.org/repos/dist/release/spark/KEYS
gpg --import $DOWNLOAD_DIR/SPARK_KEYS || exit 1

# install kafka keys
[ ! -f $DOWNLOAD_DIR/KAFKA_KEYS ] && wget -nv -O $DOWNLOAD_DIR/KAFKA_KEYS https://dist.apache.org/repos/dist/release/kafka/KEYS
gpg --import $DOWNLOAD_DIR/KAFKA_KEYS || exit 1

# install flink keys
[ ! -f $DOWNLOAD_DIR/FLINK_KEYS ] && wget -nv -O $DOWNLOAD_DIR/FLINK_KEYS https://dist.apache.org/repos/dist/release/flink/KEYS
gpg --import $DOWNLOAD_DIR/FLINK_KEYS || exit 1


#flink configuration
FLINK_VERSION=1.9.2

FLINK_URL_FILE_PATH=flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_${SCALA_VERSION}.tgz
FLINK_TGZ_SAVE_NAME=`basename ${FLINK_URL_FILE_PATH}`
FLINK_ASC_SAVE_NAME=${FLINK_TGZ_SAVE_NAME}.asc
FLINK_TGZ_URL=${APACHE_MIRROR_URL}${FLINK_URL_FILE_PATH} 
FLINK_ASC_URL=https://www.apache.org/dist/${FLINK_URL_FILE_PATH}.asc
FLINK_GPG_KEY=EF88474C564C7A608A822EEC3FF96A2057B6476C

# download and unpack flink
download_and_verify_asc $FLINK_TGZ_URL $FLINK_ASC_URL $FLINK_TGZ_SAVE_NAME $FLINK_ASC_SAVE_NAME
mkdir -p $BUILD_DIR/flink && tar -xvzf ${DOWNLOAD_DIR}/${FLINK_TGZ_SAVE_NAME} --strip-components 1 -C $BUILD_DIR/flink/

# download and unpack hadoop
HADOOP_VERSION=3.2.1
HADOOP_URL_PATH=hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
HADOOP_TGZ_URL=${APACHE_MIRROR_URL}${HADOOP_URL_PATH}
HADOOP_ASC_URL=https://www.apache.org/dist/${HADOOP_URL_PATH}.asc
download_and_verify_asc $HADOOP_TGZ_URL $HADOOP_ASC_URL `basename $HADOOP_URL_PATH` `basename $HADOOP_URL_PATH`.asc
mkdir -p $BUILD_DIR/hadoop && tar -xvzf ${DOWNLOAD_DIR}/`basename $HADOOP_URL_PATH` --strip-components 1 -C $BUILD_DIR/hadoop/

# download and unpack spark
SPARK_VERSION=2.4.5
SPARK_URL_PATH=spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz
SPARK_TGZ_URL=${APACHE_MIRROR_URL}${SPARK_URL_PATH}
SPARK_ASC_URL=https://www.apache.org/dist/${SPARK_URL_PATH}.asc
download_and_verify_asc $SPARK_TGZ_URL $SPARK_ASC_URL `basename $SPARK_URL_PATH` `basename $SPARK_URL_PATH`.asc
mkdir -p $BUILD_DIR/spark && tar -xvzf ${DOWNLOAD_DIR}/`basename $SPARK_URL_PATH` --strip-components 1 -C $BUILD_DIR/spark/

# download and unpack kafka
KAFKA_VERSION=2.4.0
KAFKA_URL_PATH=kafka/$KAFKA_VERSION/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
KAFKA_TGZ_URL=${APACHE_MIRROR_URL}${KAFKA_URL_PATH}
KAFKA_ASC_URL=https://www.apache.org/dist/${KAFKA_URL_PATH}.asc
download_and_verify_asc $KAFKA_TGZ_URL $KAFKA_ASC_URL `basename $KAFKA_URL_PATH` `basename $KAFKA_URL_PATH`.asc
mkdir -p $BUILD_DIR/kafka && tar -xvzf ${DOWNLOAD_DIR}/`basename $KAFKA_URL_PATH` --strip-components 1 -C $BUILD_DIR/kafka/

# build docker
cp -rf $THIS_DIR/src/* $BUILD_DIR/
cd $BUILD_DIR
clear_docker_img bdplay
docker build -t bdplay --build-arg BASE_IMAGE=$BASE_IMAGE --build-arg SCALA_VERSION_ARG=$SCALA_VERSION \
    --build-arg FLINK_VERSION_ARG=$FLINK_VERSION --build-arg HADOOP_VERSION_ARG=$HADOOP_VERSION \
    --build-arg SPARK_VERSION_ARG=$SPARK_VERSION --build-arg KAFKA_VERSION_ARG=$KAFKA_VERSION \
    .
