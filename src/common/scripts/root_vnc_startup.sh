#!/bin/bash
set -x

#if [ ! -f /home/appbox/.vnc/xstartup ]; then
#
#cat << EOF >> /home/appbox/.vnc/xstartup
##!/bin/sh
#
#unset SESSION_MANAGER
#unset DBUS_SESSION_BUS_ADDRESS
#OS=`uname -s`
#if [ $OS = 'Linux' ]; then
#  case "$WINDOWMANAGER" in
#    *gnome*)
#      if [ -e /etc/SuSE-release ]; then
#        PATH=$PATH:/opt/gnome/bin
#        export PATH
#      fi
#      ;;
#  esac
#fi
#
#zenity --warning --text="Appbox Warning\nPlease note that storing data outside of the\n<b>/home/appbox</b> directory will not be stored when updating or moving your Ubuntu app.\n\nClick OK to Continue to Desktop." --width="350"
#
#if [ -x /etc/X11/xinit/xinitrc ]; then
#  exec /etc/X11/xinit/xinitrc
#fi
#if [ -f /etc/X11/xinit/xinitrc ]; then
#  exec sh /etc/X11/xinit/xinitrc
#fi
#
#[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
#xsetroot -solid grey
#xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#twm &
#EOF
#
#fi

rm -rfv /tmp/.X*-lock /tmp/.X11-unix
/bin/su -c "vncserver -fg $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION" -s /bin/bash appbox