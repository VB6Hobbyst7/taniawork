<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'patentdatamain2' );
    $Query = "update listwaddress set lensassignee = '".$_POST['newAssignee']."' where pubnum like '".$_POST['wiponum']."%'";
   

    $Result = mysql_query( $Query );
    print("ok");
 ?>
