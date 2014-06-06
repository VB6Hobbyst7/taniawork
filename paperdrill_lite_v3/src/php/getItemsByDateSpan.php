<?php
include("dbconnect.php");
 
   
   $Return = "<items>";
  
   $maxd = 0;
   $mind = 0;
   
   $Query = "SELECT count(*) as countt, min(py) as minn, max(py) as maxx from list";
   $Result = mysql_query( $Query );
   if ($Result){
   	while ( $User = mysql_fetch_object( $Result ) )
   	{
   		$Return .= "<totalcount>";
  		$Return .= $User->countt;
   		$Return .= "</totalcount>";
  		$Return .= "<mindate>";
    	$mind = $User->minn;
  		$Return .= $mind;
  		$Return .= "</mindate>";
  		$Return .= "<maxdate>";
   		$maxd = $User->maxx;
   		$Return .= $maxd;
		$Return .= "</maxdate>";
   	}
   }
	
	
	
	$cat1 = "%".(string)$_POST['caty1']."%";
   $cat2 =  "%".(string)$_POST['caty2']."%";
   $cat3 =  "%".(string)$_POST['caty3']."%";
   
   $datespace = round($maxd-$mind, 0)/4;
   $date1 = $maxd-(3*$datespace);
   $date2 = $maxd-(2*$datespace);
   $date3 = $maxd-$datespace;
   $date4 = $maxd;

   $Return .= "<date>";
   	 $Return .= "<val>";
  	$Return .= $date1;
    $Return .= "</val>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date1." and SC like '".$cat1."'";
  			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date1." and SC like '".$cat2."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date1." and SC like '".$cat3."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   $Return .= "</date>";

   $Return .= "<date>";
    $Return .= "<val>";
  	$Return .= $date2;
    $Return .= "</val>";
    
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date2." and PY > ".$date1." and SC like '".$cat1."'";
  			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date2." and PY > ".$date1." and SC like '".$cat2."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date2." and PY > ".$date1." and SC like '".$cat3."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   $Return .= "</date>";
   
   $Return .= "<date>";
    $Return .= "<val>";
  	$Return .= $date3;
    $Return .= "</val>";
    
   				$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date3." and PY > ".$date2." and SC like '".$cat1."'";
  			$Result = mysql_query( $Query );
  			$Return .= mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date3." and PY > ".$date2." and SC like '".$cat2."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date3." and PY > ".$date2." and SC like '".$cat3."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   $Return .= "</date>";
   
      $Return .= "<date>";
       $Return .= "<val>";
  	$Return .= $date4;
    $Return .= "</val>";
    
   				$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date4." and PY > ".$date3." and SC like '".$cat1."'";
  			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date4." and PY > ".$date3." and SC like '".$cat2."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
   			$Return .= "<cat>";
   			$Query = "SELECT count(*) from list WHERE PY < ".$date4." and PY > ".$date3." and SC like '".$cat3."'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</cat>";
 
   $Return .= "</date>";
   $Return .= "<cat>";
   $Return .= $cat1;
   $Return .= "</cat>";
    $Return .= "<cat>";
   $Return .= $cat2;
   $Return .= "</cat>";
    $Return .= "<cat>";
   $Return .= $cat3;
   $Return .= "</cat>";
   
    $Return .= "<dateref>";
   $Return .= $date1;
   $Return .= "</dateref>";
    $Return .= "<dateref>";
   $Return .= $date2;
   $Return .= "</dateref>";
    $Return .= "<dateref>";
   $Return .= $date3;
   $Return .= "</dateref>";
    $Return .= "<dateref>";
   $Return .= $date4;
   $Return .= "</dateref>";
   
   $Return .= "</items>";   
   print ($Return);
   
   function appendResult($sqlResult){
   /*	$Return2 = "";
    if ($sqlResult){
   		while ( $User = mysql_fetch_object( $sqlResult ) )
   		{
    	 $Return .= "<item>
    	   <AU>".$User->AU."</AU>
    	   <TI>".$User->TI."</TI>
    	   <SO>".$User->SO."</SO>
    	   <LA>".$User->LA."</LA>
    	   <AB>".$User->AB."</AB>
    	   <CR>".$User->CR."</CR>
    	   <PY>".$User->PY."</PY>
    	   <SC>".$User->SC."</SC>
    	 </item>"; 
    	 $Return2 .= "<item>
    	   <AU>".$User->AU."</AU>
    	   <TI>".$User->TI."</TI>
    	   <PY>".$User->PY."</PY>
    	 </item>"; 
   		  echo ("\r\n");
 	  	}
   }*/
   	
   return mysql_num_rows($sqlResult);
   }
   
 ?>