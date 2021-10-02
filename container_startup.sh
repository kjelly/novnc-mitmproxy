#!/bin/bash
echo $PASSWORD > /tmp/password
fc-cache -fv

# start VNC server (Uses VNC_PASSWD Docker ENV variable)
mkdir -p $HOME/.vnc && echo "$PASSWORD" | vncpasswd -f > $HOME/.vnc/passwd

vncserver :0 -localhost no -nolisten -rfbauth $HOME/.vnc/passwd -xstartup /opt/x11vnc_entrypoint.sh

sudo /usr/bin/supervisord
