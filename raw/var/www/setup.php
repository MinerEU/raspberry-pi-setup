<?php

$worker=$_GET["worker"];
$password=$_GET["password"];
$pool=$_GET["pool"];

if(empty($worker) || empty($pool) ){
    echo "The http api support following parameters: ";
    echo "worker, pool, password you can pass mulitple worker with comma seperated values";
    echo "https://ip/setup.php?worker=minereu&password=x&pool=stratum+tcp://stratum.scryptguild.com:3333";
}else{
    $file = '';




// Write the contents back to the file
    file_put_contents($file, $current);
}

?>