#!/bin/bash
apt-get update
apt-get install -y lighttpd unzip
apt-get install -y  php5-common php5-cgi php5 
apt-get install -y  php5-rrd libexpect-php5 php-auth-sasl php-mail php-net-smtp php-net-socket
apt-get install -y  libjansson4 libusb-1.0-0 ntpdate screen
apt-get install -y  wget build-essential git pkg-config libtool libcurl4-openssl-dev libncurses5-dev libudev-dev autoconf automake

lighty-enable-mod fastcgi-php
mkdir /etc/lighttpd/certs
cd /etc/lighttpd/certs
openssl req -new -x509 -keyout lighttpd.pem -out lighttpd.pem -days 365 -nodes -subj "/C=US/ST=TEC/L=LONDON/O=DIS/CN=scripta.minereu.com" 
chmod 400 lighttpd.pem
/etc/init.d/lighttpd restart
echo '$SERVER["socket"] == ":443" { ssl.engine = "enable" ssl.pemfile = "/etc/lighttpd/certs/lighttpd.pem" }' | tee -a  /etc/lighttpd/lighttpd.conf
cd /
/etc/init.d/lighttpd restart
#compile CGMINER
cd /tmp
wget -O cgminer-gc3355.zip https://github.com/girnyau/cgminer-gc3355/archive/master.zip
unzip cgminer-gc3355.zip
cd cgminer-gc3355-master
./configure --enable-scrypt --enable-gridseed
make install

#install scripta
cd /tmp
wget -O scriptaming.zip https://github.com/scriptamining/scripta/archive/master.zip
unzip scriptaming.zip
cd scripta-master/
cp -fr etc opt var /
chown -R  www-data /var/www
chown -R  www-data /opt/scripta/

chmod -R +x /var/www/
chmod -R +x  /opt/scripta/bin/
chmod -R +x  /opt/scripta/startup/
#repace the cgminer with the local compiled version
cp /usr/local/bin/cgminer /opt/scripta/bin/cgminer

reboot