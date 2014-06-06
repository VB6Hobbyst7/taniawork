<?php
    $mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'scpubmed3' );
    $Query = "update list set affiliation2 = '".$_POST['s2']."' where id = ".$_POST['s1'];
    $Result = mysql_query( $Query );
    print($Query);
   
 ?>
