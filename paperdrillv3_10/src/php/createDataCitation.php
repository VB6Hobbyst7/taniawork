<?php
include("dbconnect.php");
$Query = "SELECT id, citef, citeb from list";
$Result = mysql_query( $Query );


if ($Result){
	while ( $User = mysql_fetch_object( $Result ) )
	{
		$stringout = $User->citef;
		$stringout .= "\n";
		$stringout .= $User->citeb;
		$ourFileName = "../data/".$User->id.".txt";
		//$ourFileName = "data/".$User->id.".txt";
		$ourFileHandle = fopen($ourFileName, 'w') or die("can't open file");
		fwrite($ourFileHandle, $stringout);
		fclose($ourFileHandle);
	}
}
print("done");

?>

