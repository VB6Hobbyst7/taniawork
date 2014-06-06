<?php
  include("dbconnect.php");  
 $startDate = $_POST['startDate'];
  $cato = $_POST['cato'];
   $endDate = $_POST['endDate'];
   $alphaEnd = $_POST['alphaEnd'];
   $alphaStart = $_POST['alphaStart'];
	/*$startDate = 2009;
	$cato = "medic";
	$endDate = 2011;
	$alphaEnd = "Z";
	$alphaStart = "K";*/
   
   $Query = "SELECT id, AU, TI, PY, heatcount, hasabstract from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and SC like '%".$cato."%' and TI > '".$alphaStart."' and TI < '".$alphaEnd."'";
   $Result = mysql_query( $Query );
     $Return = "<res>";
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
    	 $Return .= "<re>
    	 <id>".$User->id."</id>
    	 <AU>".cleanit($User->AU)."</AU>
    	 <TI>".cleanit($User->TI)."</TI>
    	 <PY>".$User->PY."</PY>
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

