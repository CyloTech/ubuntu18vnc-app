#!/bin/bash
set -x

rm -rfv /tmp/.X*-lock /tmp/.X11-unix
/bin/su -c "vncserver -fg $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION" -s /bin/bash appbox