<?php
    $mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'scpubmed3' );
 
   $Return = "<items>";
   $Query = "SELECT title, affiliation2, country from list where country like 'uk'";
   $Result = mysql_query( $Query );
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
   			
   		$affiliation = $User->affiliation2;
   		//$affiliation = preg_replace("/","",$affiliation);
   		//$affiliation = preg_replace("<","",$affiliation);
   		//$affiliation = preg_replace(">","",$affiliation);
    	 $Return .= "<item>
    	 <title>".$User->title."</title>
    	 <affiliation>".$affiliation."</affiliation>
    	 <country>".$User->country."</country>
    	 </item>"; 
   		  echo ("\r\n");
 	  	}
   }
   
   $Return .= "</items>";

 
   print ($Return);
 ?>