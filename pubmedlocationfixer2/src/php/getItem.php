<?php
    $mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'scpubmed3' );
 
   $Return = "<items>";
   $Query = "SELECT id, affiliation, country from list";
   $Result = mysql_query( $Query );
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
    	 $Return .= "<item>
    	 <id>".$User->id."</id>
    	 <affiliation>".$User->affiliation."</affiliation>
    	 <country>".$User->country."</country>
    	 </item>"; 
   		  echo ("\r\n");
 	  	}
   }
   
   $Return .= "</items>";

 
   print ($Return);
 ?>