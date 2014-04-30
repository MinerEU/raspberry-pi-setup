#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
source /usr/local/bin/kv-bash.sh



usage () {
cat << EOD
Use following
$y-o$c $g optional$c: $y operation:killall,scan$c
$y-s$c $g optional$c: $y how many second to sleep before start scan$c

EOD
 };

choose_operation(){
  case $1 in
killall  )
    echo "kill all session now:"
    close_all_screen  ;;
scan  )
    sleep $sleep_sec;
    echo "start to scan devices with worker setting: $worker_prefix$worker_country$worker_location$worker_pi_name";
    init_devices ;;

 * )
    echo "Unrecoginized operation, valid: "
    echo "$y killall$c ";
    echo "$y scan$c ";
    exit 1 ;;
esac
}

close_all_screen(){
screens=`screen -list  |egrep "s[0-9]"| cut -f1 -d'.' | sed 's/\W//g'`
for s in $screens ; do
screen -X -S $s quit
done
}

init_devices(){


if  [ -a  /tmp/minereu.lock ]; then
    echo "Another process is running or it is locked , exist now!";
    echo "if you are sure there is no lock, please use rm /tmp/minereu.lock"
    exit 1
fi

touch /tmp/minereu.lock


devices=`lsusb|grep 0483:5740|sort -k 4|awk '{print $2":"$4}'|rev|cut -c 2- |rev`
current_running_device=`ps -ef |grep SCREEN|grep -v grep |awk '{print $10 "-" $15}'|sort -k 2`

default_pool=`kvget pool`
default_worker=`kvget worker`
default_password=`kvget password`

for l1 in $devices; do
current_dev=`ps -ef |grep $l1|grep "usb"|grep -v grep`;

if [ "$current_dev" == "" ]
then
echo "Found unassigned device:$l1";
counter=0;

while true; do
printf -v fcounter "%03d" $counter
prefix=49$fcounter;


screen_exists=`ps -ef|grep "dmS s$counter"|grep -v grep`
if [ "$screen_exists" == "" ] ; then
pool_name=`kvget $prefix"pool"`
worker_name=`kvget $prefix"worker"`
password=`kvget $prefix"password"`
port=$prefix

echo "Assign unassigned device $l1 to screen s$counter and worker $worker_name"


if [ "$worker_name" == "" ]; then
worker_name="$default_worker"
fi


if [ "$pool_name" == "" ]; then
pool_name="$default_pool"
fi


if [ "$password" == "" ]; then
password="$default_password"
fi
screen -dmS s$counter /usr/local/bin/cgminer --api-port $port --usb $l1 -o $pool_name -u $worker_name -p $password -c /opt/minereu/etc/miner/common.json
echo "screen -dmS s$counter /usr/local/bin/cgminer --api-port $port --usb $l1 -o $pool_name -u $worker_name -p $password -c /opt/minereu/etc/miner/common.json"
sleep 1;

current_time=`date +%s`
kvset "$port"lasttime $current_time
kvset "$port"lastshare 0
break ;
fi
counter=$(($counter+1))
done

fi

done
}

####################################
####################################
####################################
SRC=$(cd $(dirname "$0"); pwd)
esc=`echo -en "\033"`
c=`echo -en "${esc}[m\017"`;
# Set colors

r="$c${esc}[0;31m"
g="$c${esc}[0;32m"
y="$c${esc}[0;33m"
b="$c${esc}[0;34m"
w="$c${esc}[1;37m"


operation="scan"
worker_prefix="minereu_"
worker_country="uk"
worker_location="bh"
worker_pi_name="p1"
sleep_sec=0

options=':o:p:c:l:d:s:'
while getopts $options option
do
    case $option in
        o  ) operation=$OPTARG;;
        s  ) sleep_sec=$OPTARG;;
        \? ) echo "Unknown option: -$OPTARG" >&2; usage ; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG, if it is optional,and you want to omit it, don't provide -$OPTARG at all" >&2; usage ;exit 1;;
        *  ) echo "Unimplimented option: -$OPTARG" >&2; usage ;exit 1;;
    esac
done

choose_operation $operation

rm -f /tmp/minereu.lock