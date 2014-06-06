<?php
// the id of the source work
$id = isset($_POST['id']) ? $_POST['id'] : 1;

// an integer defining how deep to chain
$levels = isset($_POST['levelSpan1']) ? $_POST['depth'] : 1;
$levels2 = isset($_POST['levelSpan2']) ? $_POST['depth'] : 1;

// an integer defining how deep to chain
$max = isset($_POST['max']) ? $_POST['max'] : 20000;

// global cache of citations
$cache = array();

// global array of found ids
$ids = array();

//global array of cited data
$citedArray = "<cited>";

//global array of citing data
$citingArray = "<citing>";

// let's go!
$starttime = microtime(true);
getIds($id);
$processingtime = microtime(true)-$starttime;
arsort($ids);
$citedArray.= "</cited>";
$citingArray.= "</citing>";
// sort IDs by frequency

 $Return = "<links>";
 $Return .= "<id>".$id."</id>"; 
 $Return .= $citedArray;
  $Return .= $citingArray;
 $Return .= "</links>"; 


function getIds($id, $level=0) {
	global $ids, $cache, $max, $levels, $levels2;
	
	// acquire citations
	$citationsFile = @file("data/$id.txt", FILE_IGNORE_NEW_LINES);
	//echo("data/$id.txt");
	if (!$citationsFile) {return;}
	$cites = array();
	$cites2 = array();
	$direction = 0;
	foreach ($citationsFile as $citationLine) {
		$citations = explode(',', $citationLine);
		if ($direction == 0){
			foreach ($citations as $citation) {
				$cites[] = $citation;
				$citedArray.= "<link>".$citation."</link>";
			}
			$direction = 1;
		}
		else if ($direction == 1){
			foreach ($citations as $citation) {
				$cites2[] = $citation;
				$citingArray.= "<link>".$citation."</link>";
			}
			$direction = 0;
		}
		

	}
	$cites = array_unique($cites);
	$cites2 = array_unique($cites2);
	
	
	// first add all the citations
	$count = count($ids);
	foreach ($cites as $cite) {
		// check to see we have room
		if ($count++>=$max) {return;}
		$ids[$cite]++;
	}
	foreach ($cites2 as $cite) {
		// check to see we have room
		if ($count++>=$max) {return;}
		$ids[$cite]++;
	}

	// then recurse
	if ($level<$levels) {
		foreach ($cites as $cite) {
			getIds($cite, $level+1);
		}
	}
	
	if ($level<$levels2) {
		foreach ($cites2 as $cite) {
			getIds($cite, $level+1);
		}
	}

}

?>
<html>
	<head>
		<title>PaperDrill Chain</title>
	</head>
	<body>
		<h1>PaperDrill Chain</h1>
		<table>
			<tr>
				<td>ID:</td>
				<td><?php echo $id, (isset($_REQUEST['id']) ? '' : ' (default)'); ?></td>
			</tr>
			<tr>
				<td>depth:</td>
				<td><?php echo number_format($levels), (isset($_REQUEST['levels']) ? '' : ' (default)'); ?></td>
			</tr>
			<tr>
				<td>max:</td>
				<td><?php echo number_format($max), (isset($_REQUEST['max']) ? '' : ' (default)'); ?></td>
			</tr>
			<tr>
				<td>items:</td>
				<td><?php echo number_format(count($ids)); ?></td>
			</tr>
			<tr>
				<td>top:</td>
				<td><?php
					$ind = 0;
					$link = $_SERVER['REQUEST_URI'] . '?';
					if (isset($_REQUEST['levels'])) {$link .= "levels=$levels&";}
					if (isset($_REQUEST['max'])) {$link .= "max=$max&";}
					foreach ($ids as $id => $count) {
						echo "<a href='$link&id=$id'>$id</a> ($count) ";
						if ($ind++<5) {echo ', ';}
						else {break;}
					} ?>
				</td>
			</tr>
			<tr>
				<td>processing:</td>
				<td><?php echo printf("%f", $processingtime); ?></td>
			</tr>
		</table>
	</body>
</html>
