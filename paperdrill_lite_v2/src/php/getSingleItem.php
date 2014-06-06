<?php
  include("dbconnect.php");  
 $itemID = $_POST['singleBookId'];
   

$Query = "SELECT id, AU, TI, heatcount, hasabstract from list WHERE id = ".$itemID;
 
 	
  
   $Result = mysql_query( $Query );
     $Return = "<res>";
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
    	 $Return .= "<re>
    	 <id>".$User->id."</id>
    	 <AU>".cleanit($User->AU)."</AU>
    	 <TI>".cleanit($User->TI)."</TI>
    	 <heatcount>".$User->heatcount."</heatcount>
    	  <hasabstract>".$User->hasabstract."</hasabstract>
    	 </re>"; 
   		 // echo ("\r\n");
 	  	}
   }
     $Return .= "</res>";
   print ($Return);
   
   function cleanit($sr){
   	$patterns = array();
   	$patterns[0] = '/>/';
   	$patterns[1] = '/</';
   	$patterns[2] = '/</';
   	$replacements = array();
   	$replacements[2] = ' ';
   	$replacements[1] = ' ';
   	$replacements[0] = ' ';
   	return preg_replace($patterns, $replacements, $sr);
   }
 ?>

