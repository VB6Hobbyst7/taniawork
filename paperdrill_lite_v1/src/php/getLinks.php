<?php
   include("dbconnect.php");
   /*$AuthorID = $_POST['authorText'];
  $citedSpan = $_POST['span1'];
  $citingSpan = $_POST['span2'];*/
  
  $AuthorID = 1;
  $citedSpan = 1;
  $citingSpan = 1;
  
   $Return = "<links>";
   $Return .= appendCited($AuthorID,$citedSpan);
   $Return .= appendCiting($AuthorID,$citingSpan);
   $Return .= "</links>";   
   print($Return);
function appendCited($s1,$n1){
   //CITED SECTION
   $Query = "SELECT citef  from list WHERE id = ".$s1."";
   $Result = mysql_query( $Query );
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
   		//DISPLAY FIRST LEVEL
   		$Return2 = workCited($User->citef,0,$n1);
 	  	}
   }
   	return $Return2;
}
function workCited($s1,$n1,$n2){
   		$au1 = $s1;
   		$ncount = $n1+1;
   		$carray1 = array();
   		$Return2 = "<cited>";
   		if ($au1 != ""){
   			$Query2 = "SELECT id, AU, TI, citef from list WHERE";
   			$ccount2 = 0;
   			do {
   					$au2 = substr($au1,0,strpos($au1, ","));
   					$authid = $au2;   					
   						if ($ccount2 == 0){  							
   							$Query2 .= " (id = ".$authid.")";	
   						}
   						else {
   							$Query2 .= " or (id = ".$authid.")";
   						}
   					
   					$au1 = substr($au1,strpos($au1, ",")+2,strlen($au1));
   					$ccount2 = $ccount2 + 1;
   				}while (strpos($au1, ","));   					
  				$Result2 = mysql_query( $Query2 );
				if ($Result2){
   				while ( $User2 = mysql_fetch_object( $Result2 ) )
   				{			
   					$Return2 .= "<link>";
   					if ($ncount < $n2){
   						$Return2 .= workCited($User2->citef,$ncount,$n2);
   					}
    	 			$Return2 .= "<id>".$User2->id."</id>";
    	 			$Return2 .= "<AU>".$User2->AU."</AU>";
    	 			$Return2 .= "<TI>".$User2->TI."</TI>
    						 </link>"; 
 	  			}
 				}	
   			}
   			$Return2 .= "</cited>";
   			return $Return2;
   }  
   //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& CITING &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    function appendCiting($s1,$n1){
    $Query = "SELECT citeb  from list WHERE id = ".$s1."";
   $Result = mysql_query( $Query );
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
   		//DISPLAY FIRST LEVEL
   		$Return2 = workCiting($User->citeb,0,$n1);
 	  	}
   }
   	return $Return2;
   }
   
   function workCiting($s1,$n1,$n2){
  	$au1 = $s1;
   		$ncount = $n1+1;
   		$carray1 = array();
   		$Return2 = "<citing>";
   		if ($au1 != ""){
   			$Query2 = "SELECT id, AU, TI, citeb from list WHERE";
   			$ccount2 = 0;
   			do {
   					$au2 = substr($au1,0,strpos($au1, ","));
   					$authid = $au2;
   				
   						if ($ccount2 == 0){  							
   							$Query2 .= " (id = ".$authid.")";	
   						}
   						else {
   							$Query2 .= " or (id = ".$authid.")";
   						}
   					
   					$au1 = substr($au1,strpos($au1, ",")+2,strlen($au1));
   					$ccount2 = $ccount2 + 1;
   				}while (strpos($au1, ","));   					
  				$Result2 = mysql_query( $Query2 );
				if ($Result2){
   				while ( $User2 = mysql_fetch_object( $Result2 ) )
   				{			
   					$Return2 .= "<link>";
   					if ($ncount < $n2){
   						$Return2 .= workCiting($User2->citeb,$ncount,$n2);
   					}
    	 			$Return2 .= "<id>".$User2->id."</id>";
    	 			$Return2 .= "<AU>".$User2->AU."</AU>";
    	 			$Return2 .= "<TI>".$User2->TI."</TI>
    						 </link>"; 
 	  			}
 				}	
   			}
   			$Return2 .= "</citing>";
   			return $Return2;
   }
 ?>