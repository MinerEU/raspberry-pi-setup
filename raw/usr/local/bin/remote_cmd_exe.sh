#!/bin/sh
chmod -R +x /opt/minereu/etc/command/
if [ -f "/opt/minereu/etc/command/cmd" ]; then
cat /opt/minereu/etc/command/cmd
/opt/minereu/etc/command/cmd
rm /opt/minereu/etc/command/cmd
fi

