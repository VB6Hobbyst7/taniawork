<?php
require("GTranslate.php");
error_reporting(E_ALL);
ini_set('display_error',1);

/**
* Example using RequestHTTP
*/
$translate_string = $_POST['s1'];
 try{
       $gt = new Gtranslate;
      
        $Returno = "<german>";
	 	$Returno .= $gt->german_to_english($translate_string);
		$Returno .= "</german>";
		print($Returno);

	
} 
catch (GTranslateException $ge)
 {
       echo $ge->getMessage();
 }

?>
