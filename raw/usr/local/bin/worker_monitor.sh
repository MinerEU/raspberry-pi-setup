#!/bin/sh
ports=`netstat -nlpt|grep cgminer|awk -F ":" '{print $2}'|awk '{print $1}'`

for port in $ports ; do
/usr/local/bin/worker_checker.sh 127.0.0.1 $port
done
