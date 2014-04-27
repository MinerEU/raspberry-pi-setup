#!/bin/sh

if [ -a "/tmp/minereu.lock" ]; then
running=`ps -ef |grep minereu.sh|grep -v grep`
if [ "$running" == "" ]; then
    rm /tmp/minereu.lock
fi
fi
