<?php
    $mysql = mysql_connect('31.222.177.156', 'root', 'radr');
    mysql_select_db( 'dyntoc' );
    $Query = "delete from curatortags where bookname = '".$_POST['s1']."'";
    $Result = mysql_query( $Query );
   print ("OK");
 ?>