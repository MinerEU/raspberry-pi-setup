<?php

$worker=$_GET["worker"];
$password=$_GET["password"];
$pool=$_GET["pool"];

if(empty($worker) || empty($pool) ){
    echo "The http api support following parameters: ";
    echo "worker, pool, password you can pass mulitple worker with comma seperated values";
    echo "https://ip/setup.php?worker=minereu&password=x&pool=stratum+tcp://stratum.scryptguild.com:3333";
}else{
    $file = '/opt/minereu/etc/common.conf';

    $current = json_decode(file_get_contents($file));
    echo $$current;

    $current["pools"][0]["url"]= $pool;
    $current["pools"][0]["worker"]= $pool;
    $current["pools"][0]["password"]= $pool;


// Write the contents back to the file
    file_put_contents($file, $current);
}

?>