<?php
   include("dbconnect.php");
   $startDate = $_POST['startDate'];
  $cato = $_POST['cato'];
   $endDate = $_POST['endDate'];
   $Return = "<items>";
  
    
   			$Return .= "<alpha>";
   $Query = "SELECT count(*) from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and SC like '".$cato."' and TI > 'A' and TI < 'J'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</alpha>";
   			$Return .= "<alpha>";
   $Query = "SELECT count(*) from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and
     SC like '".$cato."' and TI > 'K' and TI < 'Q'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</alpha>";
   			$Return .= "<alpha>";
   $Query = "SELECT count(*) from list WHERE PY <= ".$endDate." and
    PY > ".$startDate." and
     SC like '".$cato."' and TI > 'R' and TI < 'Z'";
   			$Result = mysql_query( $Query );
  			$Return .=mysql_result($Result, 0);
   			$Return .= "</alpha>";
			
			$Return .= "<alpharef>";
			$Return .= "<alphaitem>";
			$Return .= "A";
			$Return .= "</alphaitem>";
			$Return .= "<alphaitem>";
			$Return .= "J";
			$Return .= "</alphaitem>";
			$Return .= "</alpharef>";
			$Return .= "<alpharef>";
			$Return .= "<alphaitem>";
			$Return .= "K";
			$Return .= "</alphaitem>";
			$Return .= "<alphaitem>";
			$Return .= "Q";
			$Return .= "</alphaitem>";
			$Return .= "</alpharef>";
			$Return .= "<alpharef>";
			$Return .= "<alphaitem>";
			$Return .= "R";
			$Return .= "</alphaitem>";
			$Return .= "<alphaitem>";
			$Return .= "Z";
			$Return .= "</alphaitem>";
			$Return .= "</alpharef>";
			
 
   
   $Return .= "</items>";   
   print ($Return);
   
  
   
 ?>