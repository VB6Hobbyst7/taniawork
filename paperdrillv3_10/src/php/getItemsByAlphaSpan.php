<?php
   include("dbconnect.php");
   $startDate = $_POST['startDate'];
  $cato = $_POST['cato'];
   $endDate = $_POST['endDate'];
   $Return = "<items>";
  
    
   			$Return .= "<alpha1>";
   $Query = "SELECT count(*) from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and SC like '%".$cato."%' and TI > 'A' and TI < 'J'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</alpha1>";
   			$Return .= "<alpha2>";
   $Query = "SELECT count(*) from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and
     SC like '%".$cato."%' and TI > 'K' and TI < 'Q'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</alpha2>";
   			$Return .= "<alpha3>";
   $Query = "SELECT count(*) from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and
     SC like '%".$cato."%' and TI > 'R' and TI < 'Z'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</alpha3>";
 
   
   $Return .= "</items>";   
   print ($Return);
   
  
   
 ?>