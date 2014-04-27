#!/bin/sh
if [ -f "/tmp/minereu.lock" ]; then
running=`ps -ef |grep minereu.sh|grep -v grep`
if [ "$running" == ""  ]; then
    rm /tmp/minereu.lock
fi
fi