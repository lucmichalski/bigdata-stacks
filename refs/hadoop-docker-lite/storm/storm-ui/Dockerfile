FROM pkeropen3/storm_debian:0.10.0
MAINTAINER pkeropen3<pkeropen3@163.com>

LABEL description="Docker Storm UI image"

RUN /usr/bin/config-supervisord.sh ui

EXPOSE 8080
CMD /usr/bin/start-supervisor.sh

