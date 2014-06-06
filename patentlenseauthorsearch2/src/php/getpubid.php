<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'patentdatamain2' );
      $Query = "select id, pubnum from listwaddress";
    $Result = mysql_query( $Query );
    $Return = "<pubs>";
   while($row = mysql_fetch_array($Result)){
         $Return .= "<pub>
    	 <id>".$row[id]."</id>
     	<pubnum>".$row[pubnum]."</pubnum>
     	</pub>"; 
     	echo ("\r\n");
    }
   $Return .= "</pubs>";
   mysql_free_result( $Result );
   print ($Return);
 ?>
