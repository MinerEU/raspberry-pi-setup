#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
source ./kv-bash.sh
host=$1
port=$2

exec 3<>/dev/tcp/$1/$2 ||exit
echo "summary|" >&3

current_time=`date +%s`
current_share=`cat <&3|egrep -a -o "Difficulty Accepted=[0-9]+"|awk -F "=" '{print $2}'`
last_share=`kvget "$port"lastshare`
last_time=`kvget "$port"lasttime`
time_diff=$(expr $current_time - $last_time)
echo "$current_time :$current_share  $last_time:$last_share  timediff:$time_diff"


if [ "$current_share" == "$last_share"  ] && [ $time_diff -gt  180 ];then
echo "longer than 3 mins, kill"
exec 3<>/dev/tcp/$1/$2
echo "quit|" >&3
fi

if [ "$current_share" != "$last_share" ]; then
kvset "$port"lasttime $current_time
fi

kvset "$port"lastshare $current_share