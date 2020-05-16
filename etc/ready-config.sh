#!/bin/bash

#$1= cluster master hostname

echo "Editing hadoop and hbase Configuration ..."
find /opt/hadoop/etc/hadoop/*.xml | xargs -i sed -i s/{MASTER}/$1/g {}
find /opt/hbase/conf/*.xml | xargs -i sed -i s/{MASTER}/$1/g {}
