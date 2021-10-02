# startxfce4&
openbox --reconfigure
/usr/bin/openbox --config-file /etc/xdg/openbox/rc.xml &

# fix for clipboard being passed through
vncconfig -nowin &
