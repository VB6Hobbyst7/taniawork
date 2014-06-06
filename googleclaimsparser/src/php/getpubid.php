<?php
 	$mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'patentdatamain' );
      $Query = "select id, urlgoogle, text from list where id = ".$_POST['s1'];
    $Result = mysql_query( $Query );
    $Return = "<pubs>";
   while($row = mysql_fetch_array($Result)){
         $Return .= "<pub>
    	 <id>".$row[id]."</id>
     	<urlgoogle>".$row[urlgoogle]."</urlgoogle>
     	<text>".$row[text]."</text>
     	</pub>"; 
     	echo ("\r\n");
    }
   $Return .= "</pubs>";
   mysql_free_result( $Result );
   print ($Return);
 ?>
