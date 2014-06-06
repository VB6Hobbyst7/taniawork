<?php
    $mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'webofscience5' );
 
   $Return = "<items>";
   $Query = "SELECT id, PY, goodtext from list where PY = '1995'";
   $Result = mysql_query( $Query );
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
    	 $Return .= "<item>
    	 <id>".$User->id."</id>
    	 <PY>".$User->PY."</PY>
    	 <goodtext>".$User->goodtext."</goodtext>
    	 </item>"; 
   		  echo ("\r\n");
 	  	}
   }
   
   $Return .= "</items>";

 
   print ($Return);
 ?>