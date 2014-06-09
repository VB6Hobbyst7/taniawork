import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.rpc.events.ResultEvent;

public var lensCounter:uint = 1;
public function init3():void {
	pArray = new Array();
	var file4:File = new File("app:/data/woMissing.csv");
	var fs2:FileStream = new FileStream();
	fs2.open(file4, FileMode.READ);
	var temp:String = fs2.readUTFBytes(fs2.bytesAvailable);
	var array1:Array = new Array();
	var array2:Array = new Array();
	pArray = new Array();
	do {
		var line:String = temp.substring(0,temp.indexOf("\r\n"));
		var stop33:String = "";
		do {
			var ent:String = "";
			if (line.charAt(0) == "\""){
				line = line.substring(1,line.length);
				ent = line.substring(0,line.indexOf("\""));
				line = line.substring(line.indexOf("\"")+1,line.length);
				if (line.charAt(0) == ","){
					line = line.substring(1,line.length);
				}
			}
			else {
				if (line.indexOf(",") != -1){
					ent = line.substring(0,line.indexOf(","));
					line = line.substring(line.indexOf(",")+1,line.length);
				}
				else {
					ent = line;
					line = "";
				}
			}
			array2.push(ent);
		}while (line.length > 1);
		array1.push(array2);
		array2 = new Array();
		temp = temp.substring(temp.indexOf("\r\n")+2,temp.length);
	}while (temp.indexOf("\r\n") != -1);
	pArray = array1;
	lensCounter = 1;
	updateLensData();
	
}
public function updateLensData():void {
		var wiponum:String = pArray[lensCounter][1].toString();
	//	var urlStringout:String = "http://www.patentlens.net/patentlens/patents.html?patnums=";
		var urlStringout:String = "http://www.patentlens.net/patentlens/fulltext.html?patnum=";
		urlStringout = urlStringout + wiponum.substring(0,2)+"_"+
			wiponum.substring(2,6)+"_"+wiponum.substring(6,wiponum.indexOf("A"))+"_"+
			wiponum.substring(wiponum.indexOf("A"),wiponum.length);
	//	urlStringout = urlStringout + "&language=en&query=%28"+wiponum.toString()+"%20in%20publication_number%29&stemming=true&returnTo=structured.html%3Fquery%3D"+wiponum.toString()+"#tab_1";
		urlStringout = urlStringout + "&language=en&query=("+wiponum.toString()+"%20in%20publication_number)&stemming=true&pid=p0";
		s1 = urlStringout;
		getLensp.send();
		
	
		//var mu:URLRequest = new URLRequest(urlStringout);
		//var ml:URLLoader = new URLLoader();
		//ml.addEventListener(Event.COMPLETE, muComplete33);
	//	ml.load(mu);
}
public function afterLens(ev:ResultEvent):void {
	var stop:String = "";
	var webText:String = "";
	try{
		webText = fixBodyText(ev.result.toString());
		if (webText.indexOf("CLAIMS") != -1){
			webText = webText.substring(webText.indexOf("CLAIMS"),webText.length);
		}
		else if (webText.indexOf("CLAIMED") != -1){
			webText = webText.substring(webText.indexOf("CLAIMED"),webText.length);
		//	webText = "notext@";
		}
		else if (webText.indexOf("claims") != -1){
			webText = webText.substring(webText.indexOf("claims"),webText.length);
		}
		else if (webText.indexOf("claimed") != -1){
			webText = webText.substring(webText.indexOf("claimed"),webText.length);
			//	webText = "notext@";
		}
		else if (webText.indexOf("Claims") != -1){
			webText = webText.substring(webText.indexOf("Claims"),webText.length);
		}
		else if (webText.indexOf("Claimed") != -1){
			webText = webText.substring(webText.indexOf("Claimed"),webText.length);
			//	webText = "notext@";
		}
		else {
			webText = "notext@";
		}
	
	}
	catch(e:Error){
		webText = "notext@";
	}
	pArray[lensCounter].push(webText);
	if (lensCounter < pArray.length-1){
		lensCounter++;
		updateLensData();
	}
	else {
		createCSVFILE2();
	}
	
}
public function createCSVFILE2():void {
	var csvString:String = "";
	var file:File = File.documentsDirectory;
	file = file.resolvePath("c:/mainMissing.txt");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	for (var i:uint = 1; i < pArray.length; i++){
		if (pArray[i][pArray[i].length-1] == "notext@"){
		for (var j:uint = 0; j < pArray[i].length; j++){
			if (j != pArray[i].length-1){
				csvString = csvString + pArray[i][j].toString() + "$";
			}
			else {
				csvString = csvString + pArray[i][j].toString() + "\r\n"
			}
		}
		}
	}
	fileStream.writeUTFBytes(csvString);
	fileStream.close();
	var jo:String = "";
}
public function fixBodyText(s:String):String {
	/* TO DO : 
	REMOVE EVERYTHING BETWEEN 
	<mw type="sig" rend="align(center)"> AND </mw> INLCUDING TAGS
	<milestone... AND </mw> INCLUDING TAGS
	ever tag with length > 3 must be checked
	*/
	
	var j:RegExp;
	var b:String = s;
	
	
	//if (b.indexOf("\r") != -1){
		j =/\r/gi;
		b = b.replace(j, "");
		j =/$/gi;
		b = b.replace(j, "");
	//}
	//if (b.indexOf("\t") != -1){
		j =/\t/gi;
		b = b.replace(j, "");
//	}
	//if (b.indexOf("\n") != -1){
		j =/\n/gi;
		b = b.replace(j, "");
	//}
	//if (b.indexOf(",") != -1){
		j =/,/gi;
		b = b.replace(j, "");
	//}
	j = new RegExp("<p>","g");
	b = b.replace(j,"");	
	j = new RegExp("</p>","g");
	b = b.replace(j,"");

	return b;
}