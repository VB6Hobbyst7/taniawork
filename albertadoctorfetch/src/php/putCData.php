<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'patentdatacitation' );
    $Query = "insert into list values ('',
    '".$_POST['s1']."',
    '".$_POST['s2']."')";
    $Result = mysql_query( $Query );
    print("ok");
 ?>
