<?php
  include("dbconnect.php");
   /*$AuthorID = $_POST['authorText'];
  $citedSpan = $_POST['span1'];
  $citingSpan = $_POST['span2'];*/
  
  $AuthorID = 494099;
  $citedSpan = 1;
  $citingSpan = 1;
  
   $Return = "<links>";
   $Return .= appendCited($AuthorID,$citedSpan);
   $Return .= appendCiting($AuthorID,$citingSpan);
   $Return .= "</links>";   
   print($Return);
function appendCited($s1,$n1){
   //CITED SECTION
	if ($n1 == 0){
		$Return2 = "<cited>";
		$Return2 .= "</cited>";
	}
	else {
		$Return2 = workCited($s1,0,$n1);
	}
   	return $Return2;
}
function workCited($s1,$n1,$n2){
   		$au1 = $s1;
   		$ncount = $n1+1;
   		$carray1 = array();
   		$Return2 = "<cited>";
   		if ($au1 != ""){
   			$Query2 = "SELECT id, AU, TI from list WHERE id in (select id2 from linkage2 where id1 = ".$s1.")"; 					
  			$Result2 = mysql_query( $Query2 );
			if ($Result2){
   				while ( $User2 = mysql_fetch_object( $Result2 ))
   				{			
   					$Return2 .= "<link>";
   					if ($ncount < $n2){
   						$Return2 .= workCited($User2->id,$ncount,$n2);
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
  if ($n1 == 0){
		$Return2 = "<citing>";
		$Return2 .= "</citing>";
	}
	else {
		$Return2 = workCiting($s1,0,$n1);
	}
   	return $Return2;
}
function workCiting($s1,$n1,$n2){
  	$au1 = $s1;
   		$ncount = $n1+1;
   		$carray1 = array();
   		$Return2 = "<citing>";
   		if ($au1 != ""){
   			$Query2 = "SELECT id, AU, TI from list WHERE id in (select id1 from linkage2 where id2 = ".$s1.")"; 					
  			$Result2 = mysql_query( $Query2 );
			if ($Result2){
   				while ( $User2 = mysql_fetch_object( $Result2 ))
   				{			
   					$Return2 .= "<link>";
   					if ($ncount < $n2){
   						$Return2 .= workCiting($User2->id,$ncount,$n2);
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