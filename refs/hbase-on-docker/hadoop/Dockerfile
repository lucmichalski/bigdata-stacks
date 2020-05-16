# hadoop 2.7.3
FROM mathstana/centos:6.6-jdk8
MAINTAINER Yung-An He <mathstana@gmail.com>

#Download hadoop tar gz file
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz -P /opt
RUN cd /opt && tar zxvf /opt/hadoop-2.7.3.tar.gz
RUN mv /opt/hadoop-2.7.3 /opt/hadoop
RUN rm /opt/hadoop-2.7.3.tar.gz
#Copy configuration file from local to images
COPY config /opt/hadoop/etc/hadoop

#Set env variable
ENV HADOOP_HOME /opt/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
