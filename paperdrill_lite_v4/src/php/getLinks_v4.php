<?php
//reciviable inputs (id, citation forward length, citation backward length).
//echo ('hey');
include("dbconnect.php");
$id = isset($_POST['id']) ? $_POST['id'] : 1;
$levels = isset($_POST['levelSpan1']) ? $_POST['levelSpan1'] : 2;
$levels2 = isset($_POST['levelSpan2']) ? $_POST['levelSpan2'] : 2;

//preset inputs used for testing
//$id = 1;
//$levels = 1;
//$levels2 = 1;

// an integer defining how deep to chain (if result number is greater then only last chain's will be trimmed. if level 2 gives > max then you will never see level 3
$max = isset($_POST['max']) ? $_POST['max'] : 2000;

// global cache of citations
$cache = array();

// global array of found ids
$ids1 = array();
$ids2 = array();

//global string of cited data in xml format
$citedArray = "<cited>";

//global string of citing data in xml format
$citingArray = "<citing>";

$starttime = microtime(true);
getIds($id,1,0);
$processingtime = microtime(true)-$starttime;

$citedArray .= "</cited>";
$citingArray .= "</citing>";

$Return = "<links>";
$Return .= "<id>".$id."</id>"; 
$Return .= "<level1>".$levels."</level1>"; 
$Return .= "<level2>".$levels2."</level2>"; 
$Return .= $citedArray;
$Return .= $citingArray;
$Return .= "</links>"; 

print $Return;


   
function getIds($id, $level,$path) {
	global $ids1, $ids2, $cache, $max, $levels, $levels2, $citedArray, $citingArray;
	// acquire citations
	$citationsFile = @file("data/$id.txt", FILE_IGNORE_NEW_LINES);
	//echo("data/$id.txt");
	if (!$citationsFile) {return;}
	$cites = array();
	$cites2 = array();
	$direction = 0;
	foreach ($citationsFile as $citationLine) {
		$citations = explode(',', $citationLine);
		if (($direction == 0)&&(($path == 0)||($path == 1))){
			foreach ($citations as $citation) {
				$cites[] = $citation;
			}
		}
		else if (($direction == 1)&&(($path == 0)||($path == 2))){
			foreach ($citations as $citation) {
				$cites2[] = $citation;
			}
			$direction = 0;
		}
		$direction = 1;
	}
	 
	$cites = array_unique($cites);
	$cites2 = array_unique($cites2);
	$count = count($ids);
		if (($levels == 1)&&($levels2 == 1)){
					//grab all the links data
					$sids = join(',',$cites); 
					$sids2 = join(',',$cites2); 
					
					$Query1 = "SELECT id, AU, TI, SC, PY, heatcount, hasabstract from list WHERE id IN($sids)";
					$Result = mysql_query($Query1);
  					if ($Result){
   						while ( $User = mysql_fetch_object( $Result ) )
   						{
							$citedArray .= "<link><id>".$User->id."</id>";
   							$citedArray .= "<AU>".cleanit($User->AU)."</AU>";
   							$citedArray .= "<TI>".cleanit($User->TI)."</TI>";
   							$citedArray .= "<SC>".$User->SC."</SC>";
							$citedArray .= "<PY>".$User->PY."</PY>";
							$citedArray .= "<heatcount>".$User->heatcount."</heatcount>";	
							$citedArray .= "<hasabstract>".$User->hasabstract."</hasabstract>";							
							$citedArray .= "</link>";
 	  					}
   					}
					$Query2 = "SELECT id, AU, TI, SC, PY, heatcount, hasabstract from list WHERE id IN($sids2)";
					$Result = mysql_query($Query2);
  					if ($Result){
   						while ( $User = mysql_fetch_object( $Result ) )
   						{
							$citingArray .= "<link><id>".$User->id."</id>";
   							$citingArray .= "<AU>".cleanit($User->AU)."</AU>";
   							$citingArray .= "<TI>".cleanit($User->TI)."</TI>";
   							$citingArray .= "<SC>".$User->SC."</SC>";
							$citingArray .= "<PY>".$User->PY."</PY>";								
							$citingArray .= "<heatcount>".$User->heatcount."</heatcount>";
							$citingArray .= "<hasabstract>".$User->hasabstract."</hasabstract>";							
							$citingArray .= "</link>";
 	  					}
   					}			
		}
		else if (($levels == 1)&&($levels2 != 1)){
			//grab all the links data
			$sids = join(',',$cites); 
			$Query1 = "SELECT id, AU, TI, SC, PY, heatcount, hasabstract from list WHERE id IN($sids)";
			$Result = mysql_query($Query1);
  			if ($Result){
   				while ( $User = mysql_fetch_object( $Result ) )
   				{
					$citedArray .= "<link><id>".$User->id."</id>";
   					$citedArray .= "<AU>".cleanit($User->AU)."</AU>";
   					$citedArray .= "<TI>".cleanit($User->TI)."</TI>";
   					$citedArray .= "<SC>".$User->SC."</SC>";
					$citedArray .= "<PY>".$User->PY."</PY>";
					$citedArray .= "<heatcount>".$User->heatcount."</heatcount>";	
					$citedArray .= "<hasabstract>".$User->hasabstract."</hasabstract>";							
					$citedArray .= "</link>";
 	  			}
   			}	
			foreach ($cites2 as $cite2) {
				if ($count++>=$max) {return;}
				
				if ($cite2 != null){
					$citingArray .= "<link><id>".$cite2."</id><level>".$level."</level></link>";
					$ids2[$cite2]++;
				if ($level<$levels2) {
					getIds($cite2, $level+1,2);
				}
				}
			}					
		}
		else if (($levels != 1)&&($levels2 == 1)){
					//grab all the links data	
			foreach ($cites as $cite) {
				if ($count++>=$max) {
					return;
				}
				
				if ($cite != null){
				$citedArray .= "<link><id>".$cite."</id><level>".$level."</level></link>";
				$ids1[$cite]++;
				if ($level<$levels) {
					getIds($cite, $level+1,1);
				}
				}
			}
			
			$sids2 = join(',',$cites2); 
					$Query2 = "SELECT id, AU, TI, SC, PY, heatcount, hasabstract from list WHERE id IN($sids2)";
					$Result = mysql_query($Query2);
  					if ($Result){
   						while ( $User = mysql_fetch_object( $Result ) )
   						{
							$citingArray .= "<link><id>".$User->id."</id>";
   							$citingArray .= "<AU>".$User->AU."</AU>";
   							$citingArray .= "<TI>".$User->TI."</TI>";
   							$citingArray .= "<SC>".$User->SC."</SC>";
							$citingArray .= "<PY>".$User->PY."</PY>";							
							$citingArray .= "<heatcount>".$User->heatcount."</heatcount>";
							$citingArray .= "<hasabstract>".$User->hasabstract."</hasabstract>";							
							$citingArray .= "</link>";
 	  					}
   					}			
		}
		else {
		
			foreach ($cites as $cite) {
				if ($count++>=$max) {
					return;
				}
				
				if ($cite != null){
				$citedArray .= "<link><id>".$cite."</id><level>".$level."</level></link>";
				$ids1[$cite]++;
				
				
				if ($level<$levels) {
					getIds($cite, $level+1,1);
				}
				}
			}
			foreach ($cites2 as $cite2) {
				if ($count++>=$max) {return;}
				
				if ($cite2 != null){
				$citingArray .= "<link><id>".$cite2."</id><level>".$level."</level></link>";
				$ids2[$cite2]++;
				if ($level<$levels2) {
					getIds($cite2, $level+1,2);
				}
				}
			}
			
			if ($path == 0){
				arsort($ids1);
				arsort($ids2);
				foreach ($ids1 as $ido) {
					$citedArray .= "<link><id>".$ido."</id><level>".$level."</level></link>";
				}
				foreach ($ids2 as $ido) {
					$citingArray .= "<link><id>".$ido."</id><level>".$level."</level></link>";
				}
				
			}
			
		}
		
		
}

function cleanit($sr){
   	$patterns = array();
   	$patterns[0] = '/>/';
   	$patterns[1] = '/</';
   	$patterns[2] = '/</';
   	$replacements = array();
   	$replacements[2] = ' ';
   	$replacements[1] = ' ';
   	$replacements[0] = ' ';
   	return preg_replace($patterns, $replacements, $sr);
}
?>