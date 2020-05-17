FROM ubuntu:18.04

MAINTAINER JONATAS VIEIRA


WORKDIR /opt/

RUN apt-get -qq update -y

RUN apt-get -qqy install wget openssh-server openssh-client sudo

RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

RUN mkdir -p /root/.ssh/

COPY ./bash_files/* /root/
COPY ./ssh_keys/* /root/.ssh/

RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
RUN chmod 0600 /root/.ssh/id_rsa
RUN wget http://apache.cs.utah.edu/hadoop/common/current/hadoop-3.1.2.tar.gz
RUN tar -xzf hadoop-3.1.2.tar.gz
RUN mv hadoop-3.1.2 ./hadoop

COPY ./hadoop-conf-files/* ./hadoop/etc/hadoop/

# To download HIVESERVER
RUN wget http://ftp.unicamp.br/pub/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
RUN tar -xzf apache-hive-3.1.2-bin.tar.gz
RUN mv apache-hive-3.1.2-bin ./apache-hive

# Download and copy mysql connector driver
RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.17-1ubuntu18.04_all.deb
RUN dpkg -i mysql-connector-java_8.0.17-1ubuntu18.04_all.deb
RUN ln -s /usr/share/java/mysql-connector-java-8.0.17.jar /opt/apache-hive/lib/mysql-connector-java.jar


# To fix hive error when startup
RUN wget http://monalisa.cern.ch/MONALISA/download/java/jdk-8u40-linux-x64.tar.gz
RUN mkdir -p /usr/lib/jvm/
RUN tar -xzf jdk-8u40-linux-x64.tar.gz -C /usr/lib/jvm/

ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_40
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY ./hive/hive-env.sh apache-hive/conf/hive-env.sh
COPY ./hive/hive-site.xml apache-hive/conf/hive-site.xml

# RUN echo "export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | tee -a ./hadoop/etc/hadoop/hadoop-env.sh && echo $JAVA_HOME
#Regenerate ssh keys
RUN /usr/bin/ssh-keygen -A

# RUN ./hadoop/bin/hdfs namenode -format

COPY ./docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 22
CMD ["hadoop"]




