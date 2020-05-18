FROM debian:stretch
MAINTAINER jwiebalk

RUN apt-get update -y && apt-get install collectd -y
ADD collectd.conf /etc/collectd/collectd.conf
ADD collectd.d /etc/collectd/collectd.d
ADD types.db /usr/share/collectd/types.db
ADD entrypoint.sh /collectd_entrypoint.sh
RUN chmod a+x /collectd_entrypoint.sh
RUN mkdir /var/lib/collectd/rrd

CMD /collectd_entrypoint.sh
