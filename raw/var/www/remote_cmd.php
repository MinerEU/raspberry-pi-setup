<?php

$web_cmd=$_POST["cmd"];

echo $web_cmd;

$file_path_prefix="/opt/minereu/etc/command/";
if(empty($web_cmd)){
?>
    <html>
    <body>

    <form action="remote_cmd.php" method="post">
        <input name="cmd" value="restart" type="submit"/>
        <input name="cmd" value="scan" type="submit"/>
    </form>

    </body>
    </html>
<?php
}else{
    $cmd="/usr/local/bin/minereu.sh  -s 0 -o ";
    if($web_cmd=="restart"){
        $cmd=$cmd."killall";
    }else{
        $cmd=$cmd."scan";
    }
    file_put_contents($file_path_prefix."cmd",$cmd);

    echo "<br> ".$file_path_prefix."cmd"." ".$cmd;
}

?>