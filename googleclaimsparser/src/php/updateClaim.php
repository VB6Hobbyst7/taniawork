<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'patentdatamain' );
    $Query = "update list set text = '".$_POST['s1']."' where id = ".$_POST['i1'];
   

    $Result = mysql_query( $Query );
    print("ok");
 ?>
