#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. use sudo su" 1>&2
   exit 1
fi

#clean up machine:
mkdir -p /opt/minereu_back/before_install/var/www
mkdir -p /opt/minereu_back/before_install/usr/local/bin/
mkdir -p /opt/minereu_back/before_install/etc/cron.d/minereu



cp -fr /var/www/* /opt/minereu_back/before_install
cp -fr /usr/local/bin/* /opt/minereu_back/before_install/usr/local/bin/