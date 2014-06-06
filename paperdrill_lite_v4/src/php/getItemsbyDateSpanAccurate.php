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
   
   $datespace = round($maxd-$mind, 0)/4;
   $date1 = $maxd-(3*$datespace);
   $date2 = $maxd-(2*$datespace);
   $date3 = $maxd-$datespace;
   

  
   $Query = "SELECT PY, heatcount from list WHERE SC like '".$cat1."'";
   $result = mysql_query($Query);
   $Return .= "<ress>";
   while($row = mysql_fetch_array($result)){
   	if ($row['PY'] <=  $date1){
   		$Return .= "<res1>";
   		$Return .= "<heatcount>";
  		$Return .= $row['heatcount'];
  		$Return .= "</heatcount>";
  		$Return .= "</res1>";
   	}
   	else if (($row['PY'] >  $date1)&&($row['PY'] <=  $date2)){
   		$Return .= "<res2>";
   		$Return .= "<heatcount>";
  		$Return .= $row['heatcount'];
  		$Return .= "</heatcount>";
  		$Return .= "</res2>";
   	}
   	else if (($row['PY'] >  $date2)&&($row['PY'] <=  $date3)){
   		$Return .= "<res3>";
   		$Return .= "<heatcount>";
  		$Return .= $row['heatcount'];
  		$Return .= "</heatcount>";
  		$Return .= "</res3>";
   	}
   	else if ($row['PY'] >  $date3){
   		$Return .= "<res4>";
   		$Return .= "<heatcount>";
  		$Return .= $row['heatcount'];
  		$Return .= "</heatcount>";
  		$Return .= "</res4>";
   	}
   }
   $Return .= "</ress>";
   
   
   $Return .= "<date1>".$date1."</date1>";
   $Return .= "<date2>".$date2."</date2>";
   $Return .= "<date3>".$date3."</date3>";
   
   
   
   
   
   
   
    	
   $Return .= "</items>";   
   print ($Return);
 
 ?>