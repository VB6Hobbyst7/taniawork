<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'rhiannonauthordata' );
    $Query = "insert into list values ('',
    '".$_POST['s1']."',
    '".$_POST['s2']."',
    '".$_POST['s3']."',
     '".$_POST['s4']."')";
    $Result = mysql_query( $Query );
    print("ok");
 ?>
