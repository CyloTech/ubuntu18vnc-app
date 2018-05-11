#!/bin/bash
set -x

mkdir -p /etc/supervisor/conf.d

echo -e "\n\n------------------ Set User Password ------------------"
echo "appbox:${USER_PASSWORD}" | chpasswd

#exec su -c "/dockerstartup/vnc_startup.sh" -s /bin/sh appbox

/bin/sh /dockerstartup/vnc_startup.sh