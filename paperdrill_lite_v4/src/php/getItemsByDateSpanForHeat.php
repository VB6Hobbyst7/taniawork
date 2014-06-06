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
	
   $Return .= getCatResults((string)$_POST['caty1'],$maxd,$mind,"1");

print($Return);
   
function getCatResults($c,$maxd2,$mind2,$catid){
		$cat1 = "%".$c."%";
		$datespace = round($maxd2-$mind2, 0)/4;
		$date1 = $maxd2-(3*$datespace);
		$date2 = $maxd2-(2*$datespace);
		$date3 = $maxd2-$datespace;
		$Query = "SELECT PY, TI, heatcount from list WHERE SC like '".$cat1."'";
		$result = mysql_query($Query);
		$Return2 .= "<ress".$catid.">";
		while($row = mysql_fetch_array($result)){
			if ($row['PY'] <=  $date1){
				$Return2 .= "<res1>";
				$Return2 .= "<heatcount>";
				$Return2 .= $row['heatcount'];
				$Return2 .= "</heatcount>";
				$Return2 .= "</res1>";
				
				if (strtolower(substr($row['TI'],0,1)) <= "j"){
					$Return2 .= "<res11>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res11>";
					
				}
				else if ((strtolower(substr($row['TI'],0,1)) > "k")&&(strtolower(substr($row['TI'],0,1)) <= "q")){
					$Return2 .= "<res12>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res12>";
					
				}
				else if (strtolower(substr($row['TI'],0,1)) > "q"){
					$Return2 .= "<res13>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res13>";
						
				}
			}
			else if (($row['PY'] >  $date1)&&($row['PY'] <=  $date2)){
				$Return2 .= "<res2>";
				$Return2 .= "<heatcount>";
				$Return2 .= $row['heatcount'];
				$Return2 .= "</heatcount>";
				$Return2 .= "</res2>";
				if (strtolower(substr($row['TI'],0,1)) <= "j"){
					$Return2 .= "<res21>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res21>";
						
				}
				else if ((strtolower(substr($row['TI'],0,1)) > "k")&&(strtolower(substr($row['TI'],0,1)) <= "q")){
					$Return2 .= "<res22>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res22>";
						
				}
				else if (strtolower(substr($row['TI'],0,1)) > "q"){
					$Return2 .= "<res23>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res23>";
				
				}
			}
			else if (($row['PY'] >  $date2)&&($row['PY'] <=  $date3)){
				$Return2 .= "<res3>";
				$Return2 .= "<heatcount>";
				$Return2 .= $row['heatcount'];
				$Return2 .= "</heatcount>";
				$Return2 .= "</res3>";
				if (strtolower(substr($row['TI'],0,1)) <= "j"){
					$Return2 .= "<res31>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res31>";
				
				}
				else if ((strtolower(substr($row['TI'],0,1)) > "k")&&(strtolower(substr($row['TI'],0,1)) <= "q")){
					$Return2 .= "<res32>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res32>";
				
				}
				else if (strtolower(substr($row['TI'],0,1)) > "q"){
					$Return2 .= "<res33>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res33>";
				
				}
			}
			else if ($row['PY'] >  $date3){
				$Return2 .= "<res4>";
				$Return2 .= "<heatcount>";
				$Return2 .= $row['heatcount'];
				$Return2 .= "</heatcount>";
				$Return2 .= "</res4>";
				if (strtolower(substr($row['TI'],0,1)) <= "j"){
					$Return2 .= "<res41>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res41>";
				
				}
				else if ((strtolower(substr($row['TI'],0,1)) > "k")&&(strtolower(substr($row['TI'],0,1)) <= "q")){
					$Return2 .= "<res42>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res42>";
				
				}
				else if (strtolower(substr($row['TI'],0,1)) > "q"){
					$Return2 .= "<res43>";
					$Return2 .= "<heatcount>";
					$Return2 .= $row['heatcount'];
					$Return2 .= "</heatcount>";
					$Return2 .= "</res43>";
				
				}
			}
		}
		
		
		
		
		
		
		
		$Return2 .= "</ress".$catid.">";
		 
		 
		$Return2 .= "<date1>".$date1."</date1>";
		$Return2 .= "<date2>".$date2."</date2>";
		$Return2 .= "<date3>".$date3."</date3>";
		 
		$Return2 .= "</items>";
		return ($Return2);
   	
   }
	
 
 ?>