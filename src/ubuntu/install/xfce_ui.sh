#!/usr/bin/env bash
### every exit != 0 fails the script
echo "Install Xfce4 UI components"
apt-get update 
apt-get install -y supervisor xfce4 xfce4-terminal
apt-get purge -y pm-utils xscreensaver*
apt-get clean -y