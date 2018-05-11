#!/bin/bash
set -x

rm -rfv /tmp/.X*-lock /tmp/.X11-unix
/bin/su -c "$NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT &> $STARTUPDIR/no_vnc_startup.log &
PID_SUB=\$!
wait \$PID_SUB" -s /bin/bash appbox