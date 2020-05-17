FROM centos:centos7

RUN yum update -y && \
  yum install -y epel-release 

ADD varnishcache_varnish5.repo /etc/yum.repos.d/varnishcache_varnish5.repo

RUN yum -q makecache -y --disablerepo='*' --enablerepo='varnishcache_varnish5'

RUN yum install -y varnish && \
  yum install -y libmhash-devel && \
  yum clean all

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      64m
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600

CMD /start.sh
EXPOSE 80
