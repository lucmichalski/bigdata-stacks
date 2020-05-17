#!/bin/bash

$HADOOP_HOME/bin/hadoop jar $JAR_FILEPATH $CLASS_TO_RUN $PARAMS

chmod 777 /tmp
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

sed -i "s/^#HostKey \/etc\/ssh_host_rsa_key/HostKey \/etc\/ssh\/host_keys\/ssh_host_rsa_key/g" /etc/ssh/sshd_config
sed -i "s/^#HostKey \/etc\/ssh_host_dsa_key/HostKey \/etc\/ssh\/host_keys\/ssh_host_dsa_key/g" /etc/ssh/sshd_config
grep -q "^HostKey /etc/ssh/host_keys/ssh_host_ed25519_key" /etc/ssh/sshd_config || sed -i "/^# HostKeys for protocol version 2/a HostKey \/etc\/ssh\/host_keys\/ssh_host_ed25519_key" /etc/ssh/sshd_config

mkdir -p /var/run/sshd

mkdir -p /etc/ssh/host_keys
if [[ ! -e /etc/ssh/host_keys/ssh_host_rsa_key ]]; then 
	ssh-keygen -t dsa -N '' -f /etc/ssh/host_keys/ssh_host_dsa_key;
	ssh-keygen -t rsa -N '' -b 4096 -f /etc/ssh/host_keys/ssh_host_rsa_key;
	ssh-keygen -t ed25519 -N '' -f  /etc/ssh/host_keys/ssh_host_ed25519_key;
fi

[ -n "$TERM_GROUPS" ] && TERM_GROUPS="--groups ${TERM_GROUPS}"
[ -n "$TERM_USER_ID" ] && TERM_USER_ID="--uid ${TERM_USER_ID}"

echo "Login: ${TERM_USER}"
if [ -z "${TERM_PASS}" ]; then
    TERM_PASS=$(openssl rand -base64 22)
    echo "Password: ${TERM_PASS}"
else
    echo "Password: x*x*x*x*x"
fi

useradd -m -U --shell /bin/bash ${TERM_USER_ID} ${TERM_GROUPS} "$TERM_USER"
echo "$TERM_USER:$TERM_PASS" |chpasswd

exec /usr/sbin/sshd -De