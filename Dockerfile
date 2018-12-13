FROM ubuntu:18.04

MAINTAINER Cylo "noc@cylo.io"

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901

### Envrionment config
ENV HOME=/home/appbox \
    TERM=xterm \
    STARTUPDIR=/usr/local/appbox/starup \
    INST_SCRIPTS=/usr/local/appbox/install \
    NO_VNC_HOME=/usr/local/appbox/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x800 \
    VNC_PW=letmein \
    VNC_VIEW_ONLY=false \
    USER_PASSWORD=letmein
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

ADD ./src/runasroot.sh /usr/local/appbox/starup/runasroot.sh
RUN chmod +x /usr/local/appbox/starup/runasroot.sh

ADD ./src/supervisord.conf /etc/supervisord.conf
RUN rm -fr /etc/ssh/sshd_config
ADD ./src/sshd_config /etc/ssh/sshd_config

RUN adduser -u 1000 appbox
RUN usermod -aG sudo appbox
RUN usermod -g 107 sshd

# Expose ports
EXPOSE 80 22 ${VNC_PORT} ${NO_VNC_PORT}

CMD ["/usr/local/appbox/starup/runasroot.sh"]