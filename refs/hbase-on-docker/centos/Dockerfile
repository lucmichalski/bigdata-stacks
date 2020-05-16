FROM centos:6.6
MAINTAINER Yung-An He <mathstana@gmail.com>

USER root

# Install dev tools
RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y curl which tar sudo wget openssh-server openssh-clients rsync epel-release

RUN yum clean all; \
    yum update -y libselinux; \
    yum clean all; \
    yum install -y lsof ntpd telnet supervisor; \
    yum groupinstall -y "Development Tools"; \
    yum clean all

# Passwordless ssh
# Gen ssh /root/.ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config

# Start ssh daemon
ENTRYPOINT service sshd start && bash

RUN wget http://download.java.net/java/jdk8u162/archive/b01/binaries/jdk-8u162-ea-bin-b01-linux-x64-04_oct_2017.tar.gz
RUN cd /
RUN tar -zxvf jdk-8u162-ea-bin-b01-linux-x64-04_oct_2017.tar.gz
RUN rm jdk-8u162-ea-bin-b01-linux-x64-04_oct_2017.tar.gz

# Set Env
ENV JAVA_HOME /jdk1.8.0_162
ENV PATH $PATH:$JAVA_HOME/bin

#Modify root password
RUN echo "root:123456" | chpasswd
