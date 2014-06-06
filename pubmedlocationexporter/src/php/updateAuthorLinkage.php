<?php
    $mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'scpubmed' );
    $Query = "update allmerged4 set affiliation = '".$_POST['s2']."' where id = ".$_POST['s1'];
    $Result = mysql_query( $Query );
    print($Query);
   
 ?>
