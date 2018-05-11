FROM ubuntu:18.04

MAINTAINER Tobias Schneck "tobias.schneck@consol.de"

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV HOME=/usr/local/appbox \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/usr/local/appbox/install \
    NO_VNC_HOME=/usr/local/appbox/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1360x768 \
    VNC_PW=letmein \
    VNC_VIEW_ONLY=false \
    USER_PASSWORD=letmein \
    ROOT_PASSWORD=letrootin
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

RUN adduser -u 1000 appbox
RUN usermod -aG sudo appbox
RUN echo "appbox:temp123" | chpasswd
#RUN echo "root:fbF@ef2g5" | chpasswd

USER 1000:1000

EXPOSE 80 22

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]