<?php
  include("dbconnect.php");
   $Return = "ok2";
   appendCitation();
   print($Return);
function appendCitation(){
   //CITED SECTION
for ($i = 200000; $i >= 0; $i--) {
   $Query = "SELECT citef, citeb  from list4 WHERE id = ".$i."";
   $Result = mysql_query( $Query );
   if ($Result){
   		//$User->citef
   	while ( $User = mysql_fetch_object( $Result ) )
   	{
  	 	$au1 = $User->citef;
  	 	$au1b = $User->citef;
   	}
   	//Citation Forward Stuff
   	if ($au1 == ""){
   	}
   	else if (strpos($au1, ",")){
   		do {
   			$au2 = substr($au1,0,strpos($au1, ","));
   			$authid = $au2;
   			$Query2 = "insert into linkage values (".$i.",".$authid.")";
   			$Result = mysql_query( $Query2 );
   			$au1 = substr($au1,strpos($au1, ",")+2,strlen($au1));
   			
   		}while (strpos($au1, ","));
   		$Query2 = "insert into linkage values (".$i.",".$au1.")";
   		$Result = mysql_query( $Query2 );
   	}
   	else {
   		$Query2 = "insert into linkage values (".$i.",".$au1.")";
   		$Result = mysql_query( $Query2 );
   	}
   	//Citation Backward Stuff
   	if ($au1b == ""){ 
   	}
   	else if (strpos($au1b, ",")){
   		do {
   			$au2b = substr($au1b,0,strpos($au1b, ","));
   			$authid2 = $au2b;
   	
   			$Query2 = "insert into linkage values (".$authid2.",".$i.")";
   			$Result = mysql_query( $Query2 );
   	
   	
   			$au1b = substr($au1b,strpos($au1b, ",")+2,strlen($au1b));
   	
   		}while (strpos($au1b, ","));
   		 
   		$Query2 = "insert into linkage values (".$au1b.",".$i.")";
   		$Result = mysql_query( $Query2 );
   	}
   	else {
   		$Query2 = "insert into linkage values (".$au1b.",".$i.")";
   		$Result = mysql_query( $Query2 );
   	}
   }  
}  
}
 ?>