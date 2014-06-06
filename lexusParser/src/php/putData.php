<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'shellyset' );
    $Query = "insert into list values ('',
    '".$_POST['s1']."',
    '".$_POST['s2']."',
    '".$_POST['s3']."',
    '".$_POST['s4']."',
    '".$_POST['s5']."',
    '".$_POST['s6']."')";
    $Result = mysql_query( $Query );
    print($Result);
 ?>
