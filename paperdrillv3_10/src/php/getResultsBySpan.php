<?php
  include("dbconnect.php");  
   
 $startDate = $_POST['startDate'];
  $cato = $_POST['cato'];
   $endDate = $_POST['endDate'];
   $alphaEnd = $_POST['alphaEnd'];
   $alphaStart = $_POST['alphaStart'];
   /* $startDate = 2005;
  $cato = "science";
   $endDate =2011;*/
   
   $Query = "SELECT id, AU, TI from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and SC like '%".$cato."%' and TI > '".$alphaStart."' and TI < '".$alphaEnd."'";
   $Result = mysql_query( $Query );
     $Return = "<res>";
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
    	 $Return .= "<re>
    	 <id>".$User->id."</id>
    	 <AU>".$User->AU."</AU>
    	 <TI>".$User->TI."</TI>
    	 </re>"; 
   		  echo ("\r\n");
 	  	}
   }
     $Return .= "</res>";
   print ($Return);
 ?>

