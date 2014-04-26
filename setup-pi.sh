#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. use sudo su" 1>&2
   exit 1
fi

apt-get update
apt-get install -y lighttpd unzip wget openssl
apt-get install -y  php5-common php5-cgi php5 
apt-get install -y  php5-rrd libexpect-php5 php-auth-sasl php-mail php-net-smtp php-net-socket rrdtool
apt-get install -y  libjansson4 libusb-1.0-0 ntpdate screen

lighty-enable-mod fastcgi-php
mkdir /etc/lighttpd/certs
cd /etc/lighttpd/certs
openssl req -new -x509 -keyout lighttpd.pem -out lighttpd.pem -days 365 -nodes -subj "/C=US/ST=TEC/L=LONDON/O=DIS/CN=scripta.minereu.com" 
chmod 400 lighttpd.pem
/etc/init.d/lighttpd restart
ssl_option=`grep "ssl.pemfile" /etc/lighttpd/lighttpd.conf`
if [ "$ssl_option" == "" ]
	then
echo '$SERVER["socket"] == ":443" { ssl.engine = "enable" ssl.pemfile = "/etc/lighttpd/certs/lighttpd.pem" }' | tee -a  /etc/lighttpd/lighttpd.conf
fi
cd /

/etc/init.d/lighttpd restart




#install scripta
#forked version from mox235 to udpate a few configuration to support the G-Blade 40 chip
cd /tmp
wget -O scriptaming.zip  https://github.com/MinerEU/scripta/archive/master.zip
unzip -o scriptaming.zip
cd scripta-master/

rm -fr /var/www/*
rm -fr /opt/scripta/*
rm -fr /etc/cron.d/timeupdate
cp -fr usr etc opt var /
chown -R  www-data /var/www
chown -R  www-data /opt/scripta/

chmod -R +x /var/www/
chmod -R +x  /opt/scripta/bin/
chmod -R +x  /opt/scripta/startup/

#generate the uniqe id for this device
#echo -n $(cat /proc/cpuinfo|grep Serial|awk '{print $3}')|md5sum|awk '{print $1}'


is_raspbian=`cat /etc/os-release|grep Raspbian`
if [ "$is_raspbian" == "" ]
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
	 echo  "$(cat /boot/cmdline.txt) slub_debug=FPUZ" > /boot/cmdline.txt
fi

/opt/scripta/startup/miner-stop.sh
/opt/scripta/startup/miner-start.sh
