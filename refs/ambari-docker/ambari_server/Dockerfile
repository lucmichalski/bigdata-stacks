FROM smzx/ambari_base:v1

MAINTAINER dudu

# add ambari repo
ADD ambari.repo /etc/yum.repos.d/
ADD hdp.repo /etc/yum.repos.d/

ADD mysql-community-release-el7-5.noarch.rpm /opt/
RUN rpm -ivh /opt/mysql-community-release-el7-5.noarch.rpm

RUN yum install -y  mysql-community-server

#Setting up systemd
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/usr/sbin/init"]
#EXPOSE 8080

RUN yum install -y ambari-server

ADD mysql-connector-java-5.1.40.jar /opt/
ADD init.sql /opt/
RUN cp /opt/mysql-connector-java-5.1.40.jar /usr/share/java/mysql-connector-java.jar
RUN cp /usr/share/java/mysql-connector-java.jar /var/lib/ambari-server/resources/mysql-jdbc-driver.jar
RUN echo "" >> /etc/ambari-server/conf/ambari.properties
RUN echo "server.jdbc.driver.path=/usr/share/java/mysql-connector-java.jar" >> /etc/ambari-server/conf/ambari.properties
