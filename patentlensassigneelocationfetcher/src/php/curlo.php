<?php

require_once './htmlpurifier/library/HTMLPurifier.auto.php';
//require_once '/htmlpurifier2/HTMLPurifier.standalone.php';
//$urlo = $_POST['urlString'];
$urlo = "http://www.patentlens.net/patentlens/patents.html?patnums=WO_2007_098548";
$res = get_web_page( $urlo );

print($res['content']);
$text = "No Page";
if ( $res['errno'] != 0 ){
    //error: bad url, timeout, redirect loop
   $text = "noo";
}
else if ( $res['http_code'] != 200 ){
    //error: no page, no permissions, no service 
    $text = "noo";
}
else {
	$encodedText = $res['content'];
	$config = HTMLPurifier_Config::createDefault();
    $config->set('Core.Encoding', 'ISO-8859-1'); // replace with your encoding
    $config->set('HTML.Doctype', 'HTML 4.01 Transitional'); // replace with your doctype
	$purifier = new HTMLPurifier($config);
    //$text = $purifier->purify($encodedText);
	$text = $encodedText;
}

if (!$text){
	$text = "noo";
}
//print($text);

function get_web_page( $url )
{
	$options = array(
		CURLOPT_RETURNTRANSFER => true,     // return web page
		CURLOPT_HEADER         => false,    // don't return headers
		CURLOPT_FOLLOWLOCATION => true,     // follow redirects
		CURLOPT_ENCODING       => "",       // handle compressed
		CURLOPT_USERAGENT      => "james", // who am i
		CURLOPT_AUTOREFERER    => true,     // set referer on redirect
		CURLOPT_CONNECTTIMEOUT => 120,      // timeout on connect
		CURLOPT_TIMEOUT        => 30,      // timeout on response
			CURLOPT_POST            => 1,            // i am sending post data
		CURLOPT_MAXREDIRS      => 20,       // stop after 10 redirects
	);

	$ch      = curl_init( $url );
	curl_setopt_array( $ch, $options );
	$content = curl_exec( $ch );
	$err     = curl_errno( $ch );
	$errmsg  = curl_error( $ch );
	$header  = curl_getinfo( $ch );
	curl_close( $ch );

	$header['errno']   = $err;
	$header['errmsg']  = $errmsg;
	$header['content'] = $content;
	return $header;
}

 ?>
