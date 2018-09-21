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

rm -fr /home/appbox/.vnc/xstartup
cat << EOF >> /home/appbox/.vnc/xstartup
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
OS=`uname -s`
if [ $OS = 'Linux' ]; then
  case "$WINDOWMANAGER" in
    *gnome*)
      if [ -e /etc/SuSE-release ]; then
        PATH=$PATH:/opt/gnome/bin
        export PATH
      fi
      ;;
  esac
fi

zenity --warning --text="Appbox Warning\nPlease note that storing data outside of the\n<b>/home/appbox</b> directory will not be stored when updating or moving your Ubuntu app.\n\nClick OK to Continue to Desktop." --width="350"

if [ -x /etc/X11/xinit/xinitrc ]; then
  exec /etc/X11/xinit/xinitrc
fi
if [ -f /etc/X11/xinit/xinitrc ]; then
  exec sh /etc/X11/xinit/xinitrc
fi

[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
twm &
EOF
chmod +x /home/appbox/.vnc/xstartup

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