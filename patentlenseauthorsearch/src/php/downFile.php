
<?php

require_once './htmlpurifier/library/HTMLPurifier.auto.php';
//require_once '/htmlpurifier2/HTMLPurifier.standalone.php';
$urlo = $_POST['urlString2'];
//$urlo = "http://www.patentlens.net/patentlens/citation.html?patnum=WO_2007_098548_A1&language=en";
$lines = file($urlo);
$outputtext = "";
// Loop through our array, show HTML source as HTML source; and line numbers too.
foreach ($lines as $line_num => $line) {
    $outputtext = $outputtext."Line #<b>{$line_num}</b> : " . htmlspecialchars($line) . "<br />\n";
}

print($outputtext);
 ?>
