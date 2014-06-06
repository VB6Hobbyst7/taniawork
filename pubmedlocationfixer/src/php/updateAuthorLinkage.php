<?php
    $mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'webofscience4' );
    $Query = "update list set goodtext = '".$_POST['s2']."' where id = ".$_POST['s1'];
    $Result = mysql_query( $Query );
    print($Query);
   
 ?>
