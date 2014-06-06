<?php
   mysql_connect('localhost', 'root', '');
   mysql_select_db( 'patentdatamain' );
   $Query = "INSERT INTO citation VALUES ('".$_POST['s1']."', '".$_POST['s2']."')";
   $Result = mysql_query( $Query ) or die('Query failed: ' . mysql_error());
   print("done");

 ?>