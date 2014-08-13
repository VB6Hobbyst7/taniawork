<?php
    $mysql = mysql_connect('31.222.177.156', 'root', 'radr');
    mysql_select_db( 'dyntoc' );
    $Query = "insert into curatortags values (0,'".$_POST['s1']."',".$_POST['s2'].",'".$_POST['s3']."','".$_POST['s4']."','".$_POST['s5']."',".$_POST['s6'].")";
    $Result = mysql_query( $Query );
 ?>
