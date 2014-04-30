<?php

$worker=$_GET["worker"];
$password=$_GET["password"];
$pool=$_GET["pool"];
$timeout=$_GET["timeout"];

$file_path_prefix="/opt/minereu/etc/.kv-bash/";
if(empty($worker) || empty($pool) ){
?>
    <html>
    <body>

    <form action="setup.php" method="get">
        Workers: <input type="text" size="200" name="worker"><br>
        Passwords: <input type="text" size="35" name="password"><br>
        Pools: <input type="text" size="100" name="pool"><br>
        seconds to wait to restart cgminer when no share commit: <input type="text" size="100" value="600" name="timeout"><br>
        <input type="submit">
    </form>

    </body>
    </html>
<?php
}else{
    if(empty($password))$password="x";
    if(empty($timeout))$timeout="600";


    $workers = explode(",",$worker);
    $passwords = explode(",",$password);
    $pools = explode(",",$pool);

    $num_of_workers=count($workers);

    $default_worker=$workers[0];
    $default_password=$passwords[0];
    $default_pool=$pools[0];

    file_put_contents($file_path_prefix."worker", $default_worker);
    file_put_contents($file_path_prefix."password", $default_password);
    file_put_contents($file_path_prefix."pool", $default_pool);
    file_put_contents($file_path_prefix."timeout", $timeout);

    $password_size=count($passwords);
    $pool_size=count($pools);

    for ($i = 0; $i < $num_of_workers; $i++) {
        $my_index=sprintf('%03d', $i);
        $my_worker=$default_worker;
        $my_pass=$default_password;
        $my_pool=$default_pool;

        $worker_file_name=$file_path_prefix."49".$my_index."worker";
        $password_file_name=$file_path_prefix."49".$my_index."password";
        $pool_file_name=$file_path_prefix."49".$my_index."pool";


        if($workers[$i] != ""){
            $my_worker=$workers[$i];
            $default_worker=$workers[$i];
            file_put_contents($worker_file_name, $my_worker);
            echo "<br>wrting config for worker".$worker_file_name.":".$my_worker;
        }
        if($i < $password_size && $passwords[$i] != ""){
            $my_pass=$passwords[$i];
            $default_password=$passwords[$i];
            file_put_contents($password_file_name, $my_pass);
            echo "<br>wrting config for password".$password_file_name.":".$my_pass;
        }
        if($i < $pool_size && $pools[$i] != ""){
            $my_pool=$pools[$i];
            $default_pool=$pools[$i];
            file_put_contents($pool_file_name, $my_pool);
            echo "<br>wrting config for pool".$pool_file_name.":".$my_pool;
        }

        $file_path_prefix="/opt/minereu/etc/command/";
        $cmd="/usr/local/bin/minereu.sh  -s 0 -o killall";
        file_put_contents($file_path_prefix."cmd",$cmd);

    }


// Write the contents back to the file
  //  file_put_contents($file, $current);
}

?>