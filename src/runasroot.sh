#!/bin/bash
set -x

mkdir -p /etc/supervisor/conf.d
mkdir -p /run/sshd
chmod 755 /run/sshd

echo -e "\n\n------------------ Set User Password ------------------"
echo "appbox:${USER_PASSWORD}" | chpasswd

#exec su -c "/dockerstartup/vnc_startup.sh" -s /bin/sh appbox

/bin/sh /usr/local/appbox/starup/vnc_startup.sh