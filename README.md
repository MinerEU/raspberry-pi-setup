raspberry-pi-setup
==================

Bash script to setup Raspbian

```
curl -fsSL https://raw.githubusercontent.com/MinerEU/raspberry-pi-setup/master/setup-pi.sh|bash
```

if you are in china, run [如果是中国用户，请使用以下命令]
```
mkdir /etc/apt/sources.list.d/bk
mv /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/bk
echo  "deb http://mirrors.ustc.edu.cn/raspbian/raspbian/   wheezy main contrib non-free rpi" > /etc/apt/sources.list

curl -fsSL https://raw.githubusercontent.com/MinerEU/raspberry-pi-setup/master/setup-pi.sh|bash
```


this will
* setup an http server and self signed ssl certificate
* install build dependencies to build your cgminer for gridseed [only when it is x86, pi will already have a binary]
* install cgminer arm binary version to pi[only when run on pi]
* install scripta software web interface
* fix a raspberry pi bug that cause pi to die or stuck by adding flag to boot option.
* reboot your pi

and your Pi is ready for mining .


Please note:

* there is already 2 predefined pool with minereu worker defined, you will need to change it to your own pool and work
* make sure you change password and pool/worker first time you login. MinerEu doesn't accept any lose caused by not changing password

You can use this script on x86 debian wheezy as well. it will download cgminer source code and compile the x86 version for it. 
default login is :

```
https://yourip/
password: scripta
```


---
mining farm version:

```
curl -fsSL https://raw.githubusercontent.com/MinerEU/raspberry-pi-setup/master/setup_minereu_pi.sh|bash
```
