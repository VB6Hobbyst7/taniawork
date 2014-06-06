<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'patentdatamain' );
    $Query = "insert into list values ('',
    '".$_POST['s1']."',
    '".$_POST['s2']."',
    '".$_POST['s3']."',
    '".$_POST['s4']."',
    '".$_POST['s5']."',
    '".$_POST['s6']."',
    '".$_POST['s7']."',
    '".$_POST['s8']."',
    '".$_POST['s9']."',
    '".$_POST['s10']."',
    '".$_POST['s11']."',
    '".$_POST['s12']."',
    '".$_POST['s13']."',
    '".$_POST['s14']."')";
    $Result = mysql_query( $Query );
    print("ok");
 ?>
