<?php
require("GTranslate.php");
error_reporting(E_ALL);
ini_set('display_error',1);
//$translate_string = "bonjour";

$translate_string = $_POST['s1'];
 try{
       $gt = new Gtranslate;
      
        $Returno = "<french>";
	 	$Returno .= $gt->french_to_english($translate_string);
		$Returno .= "</french>";
		print($Returno);

} 
catch (GTranslateException $ge)
 {
       echo $ge->getMessage();
 }

?>
