<?php
   $mysql = mysql_connect('31.222.177.156', 'root', 'radr');
    mysql_select_db( 'dyntoc' );
    $Query = "select * from xmlcollection";
    $Result = mysql_query( $Query );
    $Return = "<books>";
   while($row = mysql_fetch_array($Result)){
         $Return .= "<book>
    	 <id>".$row[id]."</id>
     	<name>".$row[name]."</name>
     	</book>"; 
     	echo ("\r\n");
    }
   $Return .= "</books>";
   mysql_free_result( $Result );
   print ($Return);
 ?>