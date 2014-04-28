#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. use sudo su" 1>&2
   exit 1
fi

#clean up machine:
mkdir -p /opt/minereu_back/before_install/var/www
mkdir -p /opt/minereu_back/before_install/usr/local/bin/
mkdir -p /opt/minereu_back/before_install/etc/cron.d/
mkdir -p /opt/minereu_back/before_install/opt/scripta/


mv -f /var/www/* /opt/minereu_back/before_install 2>/dev/null;
mv -f /usr/local/bin/* /opt/minereu_back/before_install/usr/local/bin/ 2>/dev/null;
mv -f /etc/cron.d/minereu /opt/minereu_back/before_install/etc/cron.d/ 2>/dev/null;
mv -f /opt/scripta  /opt/minereu_back/before_install/opt/ 2>/dev/null;
mv -f /etc/rc.local /opt/minereu_back/before_install/etc 2>/dev/null;


##
apt-get update
apt-get install -y lighttpd unzip wget openssl
apt-get install -y  php5-common php5-cgi php5
apt-get install -y  php5-rrd libexpect-php5 php-auth-sasl php-mail php-net-smtp php-net-socket rrdtool
apt-get install -y  libjansson4 libusb-1.0-0 ntpdate screen

lighty-enable-mod fastcgi-php

if [ ! -f "/etc/lighttpd/certs/lighttpd.pem" ]; then
mkdir /etc/lighttpd/certs
cd /etc/lighttpd/certs
openssl req -new -x509 -keyout lighttpd.pem -out lighttpd.pem -days 365 -nodes -subj "/C=US/ST=TEC/L=LONDON/O=DIS/CN=minereu.com"
chmod 400 lighttpd.pem
/etc/init.d/lighttpd restart
ssl_option=`grep "ssl.pemfile" /etc/lighttpd/lighttpd.conf`
if [ "$ssl_option" == "" ]
	then
echo '$SERVER["socket"] == ":443" { ssl.engine = "enable" ssl.pemfile = "/etc/lighttpd/certs/lighttpd.pem" }' | tee -a  /etc/lighttpd/lighttpd.conf
fi
cd /

/etc/init.d/lighttpd restart
fi

#install minereu controller
cd /tmp
wget -O minereu.zip  https://github.com/MinerEU/raspberry-pi-setup/archive/master.zip
unzip -o minereu.zip
cd  /tmp/raspberry-pi-setup-master/raw

cp -fr etc opt var usr /
chown -R  www-data /var/www

chmod -R +x /var/www/
chmod -R +x /usr/local/bin/*
chown -R  www-data /opt/minereu/etc/.kv-bash/
chown -R  www-data /opt/minereu/etc/command
#generate the uniqe id for this device
#echo -n $(cat /proc/cpuinfo|grep Serial|awk '{print $3}')|md5sum|awk '{print $1}'


is_raspbian=`cat /etc/os-release|grep Raspbian`
if [ "$is_raspbian" == "" ] || [  -f "/usr/local/bin/cgminer" ]
	then
apt-get install -y  build-essential git pkg-config libtool libcurl4-openssl-dev libncurses5-dev libudev-dev autoconf automake
wget -O cgminer-gc3355.zip https://github.com/MinerEU/cgminer-gc3355/archive/master.zip
unzip -o cgminer-gc3355.zip
cd cgminer-gc3355-master
./configure --enable-scrypt --enable-gridseed
make install
fi
#if it is not compiled version for Pi, then you will need to
chmod +x /usr/local/bin/cgminer

#fix the bug that pi stuck when mining
slub_debug_content=$(grep slub_debug< /boot/cmdline.txt)
if [ "$slub_debug_content" == "" ]
	then
	#append  slub_debug=FPUZ to existing content and write back
	 echo  "$(cat /boot/cmdline.txt) slub_debug=FPUZ" >> /boot/cmdline.txt
fi