<?php
    $mysql = mysql_connect('localhost', 'root', '');
    mysql_select_db( 'patentdatamain2' );
 
   $Return = "<items>";
   $Query = "Select pubnum, cited, title1, title2, claims1, claims2, pubyear1, pubyear2 from citationwipo2";
   $Result = mysql_query( $Query );
   if ($Result){
   		while ( $User = mysql_fetch_object( $Result ) )
   		{
   			
   			
   		
   		//	$cl2 = "";
   			
   		$cl1 = str_replace("<", "", $User->claims1);
   		$cl1 = str_replace("\\", "", $cl1);
   		$cl1 = str_replace("/", "", $cl1);
   		$cl1 = str_replace(">", "", $cl1);
   		$cl1 = str_replace("&", "", $cl1);
   		$cl1 = str_replace("]", "", $cl1);
   		$cl1 = str_replace("[", "", $cl1);
   		$cl1 = str_replace("\"", "", $cl1);
   		$cl1 = str_replace("'", "", $cl1);
   		
   		
   		$cl2 = str_replace("<", "", $User->claims2);
   		$cl2 = str_replace("\\", "", $cl2);
   		$cl2 = str_replace("/", "", $cl2);
   		$cl2 = str_replace(">", "", $cl2);
   		$cl2 = str_replace("&", "", $cl2);
   		$cl2 = str_replace("]", "", $cl2);
   		$cl2 = str_replace("[", "", $cl2);
   		$cl2 = str_replace("\"", "", $cl2);
   		$cl2 = str_replace("'", "", $cl2);
   		
   		$ti1 = str_replace("<", "", $User->title1);
   		$ti1 = str_replace("\\", "", $ti1);
   		$ti1 = str_replace("/", "", $ti1);
   		$ti1 = str_replace(">", "", $ti1);
   		$ti1 = str_replace("\"", "", $ti1);
   		$ti1 = str_replace("'", "", $ti1);
   		
   		
   		$ti2 = str_replace("<", "", $User->title2);
   		$ti2 = str_replace("\\", "", $ti2);
   		$ti2 = str_replace("/", "", $ti2);
   		$ti2 = str_replace(">", "", $ti2);
   		$ti2 = str_replace("\"", "", $ti2);
   		$ti2 = str_replace("'", "", $$ti2);
   		
    	 $Return .= "<item>
    	 <pubnum>".$User->pubnum."</pubnum>
    	 <cited>".$User->cited."</cited>
    	 <title1>".$ti1."</title1>
    	  <title2>".$ti2."</title2>
    	 <claims1>".$cl1."</claims1>
    	  <claims2>".$cl2."</claims2>
    	  <pubyear1>".$User->pubyear1."</pubyear1>
    	 <pubyear2>".$User->pubyear2."</pubyear2>
    	 </item>"; 
   		  echo ("\r\n");
 	  	}
   }
   
   $Return .= "</items>";

 
   print ($Return);
 //  print ("hey");
   
  
   
 ?>