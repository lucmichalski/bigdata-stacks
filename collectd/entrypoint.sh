#!/bin/bash
set -eo pipefail


sleep 5

sed -i "s/{{HOSTNAME}}/$HOSTNAME/g" /etc/collectd/collectd.conf
sed -i "s:{{basedir}}:$basedir:g" /etc/collectd/collectd.conf
sed -i "s/{{SPLUNK_TOKEN}}/$SPLUNK_TOKEN/g" /etc/collectd/collectd.d/network.conf

sleep 60

exec /usr/sbin/collectd -f
