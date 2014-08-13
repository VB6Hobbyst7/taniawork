<?php
 
$upload_dir = $_SERVER['DOCUMENT_ROOT'] .  dirname($_SERVER['PHP_SELF']) . '/';
$upload_url = "http://".$_SERVER['HTTP_HOST'].dirname($_SERVER['PHP_SELF']) . '/';
$message ="";

$temp_name = $_FILES['Filedata']['tmp_name'];
$file_name = $_FILES['Filedata']['name']; 
$file_name = str_replace("","",$file_name);
$file_name = str_replace("'","",$file_name);
$file_path = $upload_dir.$file_name;

$result  =  move_uploaded_file($temp_name, $file_path);
if ($result)
{
	$message =  "<result><status>OK</status><message>$file_name uploaded successfully.</message></result>";
}
else 
{
	$message = "<result><status>Error</status><message>Somthing is wrong with uploading a file.</message></result>";
}
 
echo $message;
?> 