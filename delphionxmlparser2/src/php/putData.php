<?php
   mysql_connect('localhost', 'root', 'root');
   mysql_select_db( 'syntheticbiology' );
   $Query = str_replace('\\','',"INSERT INTO termsynthbio VALUES (0, '".$_POST['pubnum']."', '".$_POST['s1']."', '".$_POST['s2']."', '".$_POST['s3']."', '".$_POST['s4']."', '".$_POST['s5']."', '".$_POST['s6']."', '".$_POST['s7']."', '".$_POST['s8']."', '".$_POST['s9']."', '".$_POST['s10']."', '".$_POST['s11']."', '".$_POST['s12']."', '".$_POST['s13']."', '".$_POST['s14']."', '".$_POST['s15']."', '".$_POST['s16']."')");
   $Result = mysql_query( $Query ) or die('Query failed: ' . mysql_error());
   print("done");

 ?>