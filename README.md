raspberry-pi-setup
==================

Bash script to setup Raspbian

```
curl -fsSL https://raw.githubusercontent.com/MinerEU/raspberry-pi-setup/master/setup-pi.sh|bash
```

this will
* setup an http server
* install build dependencies to build your cgminer for gridseed
* install scripta software web interface
* fix a raspberry pi bug that cause pi to die or stuck
* reboot your pi
and your Pi is ready for mining .

You can use this script on x86 debian wheezy as well. it will download cgminer source code and compile the x86 version for it. 
