#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
source /usr/local/bin/kv-bash.sh

running=`ps -ef |grep "\-o scan"|grep -v grep`
if [ "$running" = "" ]; then
    echo "Another process is running , exist now!";
    exit 1
fi

usage () {
cat << EOD
Use following
$y-o$c $g optional$c: $y operation:killall,scan$c
$y-l$c $g optional$c: $y location, i.e. bh,wh,bo$c
$y-p$c $g optional$c: $y pool prefix,i.e. minereu_ , minereu. $c
$y-c$c $g optional$c: $y country code, cn, uk$c
$y-d$c $g optional$c: $y device name, i.e. a1,a2,a3$c
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
devices=`lsusb|grep 0483:5740|sort -k 4|awk '{print $2":"$4}'|rev|cut -c 2- |rev`
current_running_device=`ps -ef |grep SCREEN|grep -v grep |awk '{print $10 "-" $15}'|sort -k 2`


for l1 in $devices; do
current_dev=`ps -ef |grep $l1|grep "usb"|grep -v grep`;

if [ "$current_dev" == "" ]
then
echo "Found unassigned device:$l1";
counter=0;
while true; do
printf -v worker "%02d" $counter
pool_worker="$worker_prefix$worker_country$worker_location$worker_pi_name$worker"
screen_exists=`ps -ef|grep "dmS s$counter"|grep -v grep`
if [ "$screen_exists" == "" ] ; then
echo "Assign unassigned device $l1 to screen s$counter and worker $pool_worker"
port=490$worker
worker_name=`kvget "$port"worker`
if [ "$worker_name" != "" ]; then
pool_worker="$worker_name"
fi
screen -dmS s$counter /usr/local/bin/cgminer --api-port $port --usb $l1 -o stratum+tcp://stratum.scryptguild.com:3333 -u $pool_worker -p x -c /opt/minereu/etc/common.conf
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
        p  ) worker_prefix=$OPTARG;;
        c  ) worker_country=$OPTARG;;
        l  ) worker_location=$OPTARG;;
        d  ) worker_pi_name=$OPTARG;;
        s  ) sleep_sec=$OPTARG;;
        \? ) echo "Unknown option: -$OPTARG" >&2; usage ; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG, if it is optional,and you want to omit it, don't provide -$OPTARG at all" >&2; usage ;exit 1;;
        *  ) echo "Unimplimented option: -$OPTARG" >&2; usage ;exit 1;;
    esac
done

choose_operation $operation

