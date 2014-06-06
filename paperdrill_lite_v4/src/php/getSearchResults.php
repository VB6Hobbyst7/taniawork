<?php
  include("dbconnect.php");  
 $searchString = $_POST['searchTexto'];
// $searchString = 'medic';
   
 if($_POST['searchType'] == 0){
 	$Query = "SELECT id, AU, TI, PY, heatcount, hasabstract from list WHERE AU like'%".$searchString."%' or TI like'%".$searchString."%'";
 }
 else if($_POST['searchType'] == 1){
 	$Query = "SELECT id, AU, TI, PY, heatcount, hasabstract from list WHERE AU like'%".$searchString."%'";
 }
 else if($_POST['searchType'] == 2){
 	$Query = "SELECT id, AU, TI, PY, heatcount, hasabstract from list WHERE TI like'%".$searchString."%'";
 }
 else if($_POST['searchType'] == 3){
 	$Query = "SELECT a.id, a.AU, a.TI, a.PY, a.heatcount, a.hasabstract from list a, abstracts b WHERE b.AB like'%".$searchString."%' and a.id = b.id";
 }
 	
  
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

