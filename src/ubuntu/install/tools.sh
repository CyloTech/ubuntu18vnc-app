#!/usr/bin/env bash
### every exit != 0 fails the script

echo "Install some common tools for further installation"
apt-get update 
apt-get install -y vim wget net-tools locales bzip2 \
    python-numpy #used for websockify/novnc
apt-get install -y sudo
apt-get install -y supervisor
apt-get install -y cron
apt-get install -y software-properties-common \
                   openssh-server \
                   nano \
                   rsync \
                   ffmpeg \
                   unzip \
                   curl \
                   tmux \
                   screen \
                   unrar \
                   man-db \
                   transmission \
                   filezilla \
                   wine64 \
                   zenity

dpkg --add-architecture i386
apt-get update
apt-get install -y wine32

apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg

apt-get clean -y


# RClone
cd /usr/local/appbox/install
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip; \
unzip rclone-current-linux-amd64.zip; \
cd rclone-*-linux-amd64; \
cp rclone /usr/bin/; \
chown root:root /usr/bin/rclone; \
chmod 755 /usr/bin/rclone; \
mkdir -p /usr/local/share/man/man1; \
cp rclone.1 /usr/local/share/man/man1/; \
mandb

# RClone Browser
wget https://github.com/mmozeiko/RcloneBrowser/releases/download/1.2/rclone-browser_1.2_amd64.deb
dpkg -i rclone-browser_1.2_amd64.deb; \
apt-get install -f -y; \
rm -fr rclone-browser*.deb

# Mono
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF; \
echo "deb http://download.mono-project.com/repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/mono-official.list; \
apt-get update; \
apt-get install -y mono-devel

# FlexGet
apt update; \
apt-get install -y python python-pip; \
pip install flexget

## MKVTool
wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | sudo apt-key add -
echo "deb https://mkvtoolnix.download/ubuntu/ bionic main
deb-src https://mkvtoolnix.download/ubuntu/ bionic main" > /etc/apt/sources.list.d/mkvtoolnix.list
apt update; \
apt -y install mkvtoolnix-gui

# Handbrake
add-apt-repository ppa:stebbins/handbrake-releases
apt -y install handbrake-gtk handbrake-cli

# Wine32
dpkg --add-architecture i386
apt-get update -y && apt-get install -y wine32

# qBitorrent
add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
apt-get -y update
apt-get -y install qbittorrent

echo "generate locales für en_US.UTF-8"
locale-gen en_US.UTF-8