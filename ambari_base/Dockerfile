FROM centos:7
MAINTAINER dudu

RUN yum install epel-release -y && yum clean all
RUN yum update -y && yum clean all

RUN yum install -y yum-utils yum-plugin-ovl tar git curl bind-utils unzip wget && yum clean all

# Setup sshd
RUN yum install -y openssh-server openssh-clients && yum clean all
RUN systemctl enable sshd

# kerberos client
RUN yum install -y krb5-workstation 

# initscripts (service wrapper for servicectl) is need othewise the Ambari is unable to start postgresql
RUN yum install -y initscripts 

RUN yum install -y java

RUN rpm -e --nodeps java-1.8.0-openjdk-1.8.0.201.b09-2.el7_6.x86_64 \
    && rpm -e --nodeps java-1.8.0-openjdk-headless-1.8.0.201.b09-2.el7_6.x86_64
ADD jdk-8u201-linux-x64.rpm /tmp/

RUN rpm -ivh /tmp/jdk-8u201-linux-x64.rpm

#&& yum clean all
# JDK8
ENV JDK_VERSION 1.8.0_201
ENV JAVA_HOME /usr/bin

RUN echo  "* soft nofile 65536" >>  /etc/security/limits.conf \
    && echo "* hard nofile 65536" >> /etc/security/limits.conf \
    && echo "* soft nproc 131072" >>  /etc/security/limits.conf \ 
    && echo "* hard nproc 131072 " >> /etc/security/limits.conf

#RUN systemctl disable firewalld \
#    && systemctl stop firewalld

RUN sh -c "echo umask 0022 >> /etc/profile"
