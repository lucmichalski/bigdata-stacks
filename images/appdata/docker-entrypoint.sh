#!/bin/bash
set -e

[ -f /etc/rsyncd.conf ] || cat <<EOF > /etc/rsyncd.conf
uid = root
gid = root
use chroot = yes
log file = /dev/stdout
reverse lookup = no
[warp]
    hosts allow = *
    read only = false
    path = /var/www/html
    comment = docker volume
EOF

# start rsync deamon
# exec /usr/bin/rsync --no-detach --daemon --config /etc/rsyncd.conf
/usr/bin/rsync --daemon --config /etc/rsyncd.conf

# execute [cmd]
exec "$@"