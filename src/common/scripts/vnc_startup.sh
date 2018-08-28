#!/bin/bash
### every exit != 0 fails the script
set -x

# should also source $STARTUPDIR/generate_container_user
source $HOME/.bashrc

## correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

## write correct window size to chrome properties
/bin/sh ${STARTUPDIR}/chrome-init.sh

## resolve_vnc_connection
VNC_IP=$(hostname -i)

## change vnc password
echo -e "\n------------------ change VNC password  ------------------"
# first entry is control, second is view (if only one is valid for both)

chown -R appbox:appbox $HOME

mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"

echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH

echo "remove old vnc locks to be a reattachable container"
rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> $STARTUPDIR/vnc_startup.log \
|| echo "no locks present"

chown -R appbox:appbox /home/appbox/.vnc

chmod -R 755 /home/appbox/.ssh

cat << EOF >> /etc/supervisor/conf.d/vnc.conf
[program:vnc]
command=/bin/sh $STARTUPDIR/root_vnc_startup.sh
autostart=true
autorestart=true
priority=5
stdout_events_enabled=true
stderr_events_enabled=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF

cat << EOF >> /etc/supervisor/conf.d/novnc.conf
[program:novnc]
command=/bin/sh $STARTUPDIR/root_novnc_startup.sh
autostart=true
autorestart=true
priority=10
stdout_events_enabled=true
stderr_events_enabled=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF

if [ ! -f /etc/app_installed ]; then
    curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST "https://api.cylo.io/v1/apps/installed/$INSTANCE_ID"
    touch /etc/app_installed
fi

exec /usr/bin/supervisord -n -c /etc/supervisord.conf