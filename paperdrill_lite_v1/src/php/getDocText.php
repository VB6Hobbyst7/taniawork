<?php
  include("dbconnect.php");
 
   $Return = "<text>";
   $Query = "SELECT AB from abstracts WHERE id = ".$_POST['idout'];
   $Result = mysql_query( $Query );
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
    	 $Return .= "<te>
    	 <AB>".$User->AB."</AB>
    	 </te>"; 
   		  echo ("\r\n");
 	  	}
   }
   
   $Return .= "</text>";

 
   print ($Return);
 ?>