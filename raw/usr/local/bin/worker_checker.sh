#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
source /usr/local/bin/kv-bash.sh
SRC=$(cd $(dirname "$0"); pwd)
esc=`echo -en "\033"`
c=`echo -en "${esc}[m\017"`;
# Set colors

r="$c${esc}[0;31m"
g="$c${esc}[0;32m"
y="$c${esc}[0;33m"
b="$c${esc}[0;34m"
w="$c${esc}[1;37m"


host=$1
port=$2

exec 3<>/dev/tcp/$1/$2 ||exit
echo "summary|" >&3

current_time=`date +%s`
current_share=`cat <&3|egrep -a -o "Difficulty Accepted=[0-9]+"|awk -F "=" '{print $2}'`
last_share=`kvget "$port"lastshare`
last_time=`kvget "$port"lasttime`
time_diff=$(expr $current_time - $last_time)
share_diff=$(expr $current_share - $last_share);
if [ $time_diff -gt 60 ] && [ $time_diff -lt 120 ] && [ $share_diff -eq 0 ]; then
echo "$2 $y $time_diff$c sec share diff : $y $share_diff$c"
elif [ $time_diff -gt 120 ] && [ $share_diff -eq 0 ]; then
echo "$2 $r $time_diff$c sec share diff : $r $share_diff$c"
else
echo "$2 $g $time_diff$c sec share diff : $g $share_diff$c"
fi

target_timeout=`kvget timeout`
if [ "$target_timeout" == "" ]; then
    target_timeout=600;
fi


if [ "$current_share" == "$last_share"  ] && [ $time_diff -gt  600 ];then
echo "longer than 3 mins, kill"
exec 3<>/dev/tcp/$1/$2
echo "quit|" >&3
fi

if [ "$current_share" != "$last_share" ]; then
kvset "$port"lasttime $current_time
fi

kvset "$port"lastshare $current_share