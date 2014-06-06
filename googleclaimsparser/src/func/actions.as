import air.net.ServiceMonitor;
import air.net.URLMonitor;
import air.update.ApplicationUpdaterUI;
import air.update.events.UpdateEvent;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.errors.IOError;
import flash.events.*;
import flash.events.NativeWindowBoundsEvent;
import flash.events.UncaughtErrorEvent;
import flash.filesystem.*;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.html.HTMLLoader;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.controls.Alert;
import mx.events.AIREvent;
import mx.rpc.events.ResultEvent;

import spark.collections.SortField;

public var urlCount1:uint = 1;
public var urlCount2:uint = 1;
public var majorCounter:uint = 1;
public var authorSeperateColIndex:uint = 0;
public var superCount:uint = 0;
public var pArray:Array = new Array();
public var pArraySecond:Array = new Array();
public var WOScounter:uint = 0;
public var WOSPagecounter:uint = 1;
public var wosdate:String = "2008";
public var woslimit:uint = 150;
public var getnum:uint = 1;
public function init():void {
	getnum = 5718;
	i1 = getnum;
	getId.send();
}
public function afterGetId(ev:ResultEvent):void {
	var stop:String = "";
	s1 = ev.result.pubs.pub.urlgoogle;
	//getClaimo.send();
	if ((ev.result.pubs.pub.text != null)||(ev.result.pubs.pub.urlgoogle == null)){
		getnum++;
		i1 = getnum;
		getId.send();
	}
	else {
		var mu:URLRequest = new URLRequest(ev.result.pubs.pub.urlgoogle);
		var ml:URLLoader = new URLLoader();
		ml.addEventListener(Event.COMPLETE, afterGetClaim);
		ml.addEventListener(IOErrorEvent.IO_ERROR, errorGET);
		
		ml.load(mu);
	}
}
public function afterGetClaim(ev:Event):void {
	var temp:String = ev.target.data;
	temp = temp.substring(temp.indexOf("patent_claims_anchor")+22,temp.length);
	if (temp.indexOf("vertical_module_list_row") > 3){
		temp = temp.substring(0,temp.indexOf("vertical_module_list_row")-1);
	}
	var j:RegExp;
	j =/\>/gi;
	temp = temp.replace(j, "");
	j =/\</gi;
	temp = temp.replace(j, "");
	j =/\;/gi;
	temp = temp.replace(j, "");
	j =/\,/gi;
	temp = temp.replace(j, "");
	j =/\//gi;
	temp = temp.replace(j, "");
	j =/\=/gi;
	temp = temp.replace(j, "");
	j =/\'/gi;
	temp = temp.replace(j, "");
	var ld:uint = temp.length;
	if (temp != ""){
		var stoper:String = "";
	}
	i1 = getnum;
	s1 = temp;
	
	updateClaim.send();
	
}
public function afterUpdateClaim(ev:ResultEvent):void {
	
	
	if (getnum < 13256){
		getnum++;
		i1 = getnum;
		getId.send();
	}
}
public function init2():void {
	pArray = new Array();
/*	fileGET.addEventListener(ResultEvent.RESULT, afterGetCsvNsplit);
	fileGET.url = "data/pubnum-citing-cited.csv";
	fileGET.addEventListener(ResultEvent.RESULT, afterGetRegularCsv);*/
	//fileGET.url = "data/woEDITED2.csv";
	fileGET.url = "c:/Main1.csv";
	//fileGET.addEventListener(ResultEvent.RESULT, afterGetRegularCsv);
	//authorSeperateColIndex = 2;
	//fileGET.send();
	//goWOS();
	var file4:File = new File("c:/Main1.csv");
	//var file4:File = new File("app:/appplug/i.txt");
	var fs2:FileStream = new FileStream();
	fs2.open(file4, FileMode.READ);
	var mtext2:String = fs2.readUTFBytes(fs2.bytesAvailable);
	afterGetRegularCsv(mtext2);
}
public function afterGetCsvNsplit(ev:ResultEvent):void {
	var temp:String = ev.result.toString();
	var array1:Array = new Array();
	
	pArray = new Array();
	temp = temp.substring(temp.indexOf("\r\n")+2,temp.length);
	do {
		var line:String = temp.substring(0,temp.indexOf("\r\n"));
		var authorArray:Array = new Array();
		
			var ent:String = "";
			var col1:String = line.substring(0,line.indexOf(","));
			line = line.substring(line.indexOf(",")+1,line.length);
			
			var col2:String = line.substring(0,line.indexOf(","));
			line = line.substring(line.indexOf(",")+1,line.length);
			
			var col3:String = line;
			var col2Array:Array = new Array();
			var col3Array:Array = new Array();
			
			if (col2 != ""){
				if (col2.indexOf("|") != -1){
					do {
						var v1:String = col2.substring(0,col2.indexOf("|"));
						col2 = col2.substring(col2.indexOf("|")+1,col2.length);
						if (v1.charAt(v1.length-1) == " " ){
							v1 = v1.substring(0,v1.length-1);
						}
						
						if (col2.charAt(0) == " "){
							col2 = col2.substring(1,col2.length);
						}
						col2Array.push(v1);	
					}while (col2.indexOf("|") != -1);
				}
				
				if (col2 != ""){
					col2Array.push(col2);
				}
			}
			
			if (col3 != ""){
				if (col3.indexOf("|") != -1){
					do {
						var v2:String = col3.substring(0,col3.indexOf("|"));
						col3 = col3.substring(col3.indexOf("|")+1,col3.length);
						if (v2.charAt(v2.length-1) == " " ){
							v2 = v2.substring(0,v2.length-1);
						}
						
						if (col3.charAt(0) == " "){
							col3 = col3.substring(1,col3.length);
						}
						col3Array.push(v2);	
					}while (col3.indexOf("|") != -1);
				}
				
				if (col3 != ""){
					col3Array.push(col3);
				}
			}
			
			var i:uint = 0;
			for (i = 0; i < col3Array.length; i++){
				var array3:Array = new Array();
				array3[0] = col1;
				array3[1] = col3Array[i];
				array1.push(array3);
			}
			
			for (i = 0; i < col2Array.length; i++){
				var array2:Array = new Array();
				array2[0] = col2Array[i];
				array2[1] = col1;
				array1.push(array2);
			}
		
		
		
		temp = temp.substring(temp.indexOf("\r\n")+2,temp.length);
	}while (temp.indexOf("\r\n") != -1);
	pArray = array1;
	superPut();
}
public function goWOS():void {
	
	fileGET.addEventListener(ResultEvent.RESULT, afterWOSget);
	WOSPagecounter = 1;
	var wosurl:String = "";
	if (WOSPagecounter < 10){
		wosurl =  "data2/"+wosdate+"/00"+WOSPagecounter.toString()+".txt";
	}
	else if ((WOSPagecounter < 100)&&(WOSPagecounter > 9)){
		wosurl =  "data2/"+wosdate+"/0"+WOSPagecounter.toString()+".txt";
	}
	else {
		wosurl =  "data2/"+wosdate+"/"+WOSPagecounter.toString()+".txt";
	}
	fileGET.url = wosurl;
	fileGET.send();
}
public function afterWOSget(ev:ResultEvent):void {
	var temp:String = ev.result.toString();
	var array2:Array = new Array();
	temp = temp.substring(temp.indexOf("\n")+1,temp.length);
	do {
		var line:String = temp.substring(0,temp.indexOf("\n"));
		var stop33:String = "";
		do {
			var ent:String = "";
				if (line.indexOf("\t") != -1){
					ent = line.substring(0,line.indexOf("\t"));
					line = line.substring(line.indexOf("\t")+1,line.length);
				}
				else {
					ent = line;
					line = "";
				}
			
			array2.push(ent);
		}while (line.length > 0);
		pArray.push(array2);
		array2 = new Array();
		temp = temp.substring(temp.indexOf("\n")+1,temp.length);
	}while (temp.indexOf("\n") != -1);
	
	if (WOSPagecounter < woslimit){
		WOSPagecounter++;
		var wosurl:String = "";
		if (WOSPagecounter < 10){
			wosurl =  "data2/"+wosdate+"/00"+WOSPagecounter.toString()+".txt";
		}
		else if ((WOSPagecounter < 100)&&(WOSPagecounter > 9)){
			wosurl =  "data2/"+wosdate+"/0"+WOSPagecounter.toString()+".txt";
		}
		else {
			wosurl =  "data2/"+wosdate+"/"+WOSPagecounter.toString()+".txt";
		}
		fileGET.url = wosurl;
		fileGET.send();
	}
	else {
		var stop:String = "";
		WOScounter = 0;
		putWOSstart();
	}

}
public function putWOSstart():void {
	putit.url = "http://localhost/googleclaimsparser/src/php/putWData.php"
	putit.addEventListener(ResultEvent.RESULT,afterputWOS);
	s1 = pArray[WOScounter][0];
	s2 = pArray[WOScounter][1];
	s3 = pArray[WOScounter][2];
	s4 = pArray[WOScounter][3];
	s5 = pArray[WOScounter][4];
	s6 = pArray[WOScounter][5];
	s7 = pArray[WOScounter][6];
	s8 = pArray[WOScounter][7];
	s9 = pArray[WOScounter][8];
	s10 = pArray[WOScounter][9];
	s11 = pArray[WOScounter][10];
	s12 = pArray[WOScounter][11];
	s13 = pArray[WOScounter][12];
	s14 = pArray[WOScounter][13];
	
	s15 = pArray[WOScounter][14];
	s16 = pArray[WOScounter][15];
	s17 = pArray[WOScounter][16];
	s18 = pArray[WOScounter][17];
	s19 = pArray[WOScounter][18];
	s20 = pArray[WOScounter][19];
	s21 = pArray[WOScounter][20];
	s22 = pArray[WOScounter][21];
	s23 = pArray[WOScounter][22];
	s24 = pArray[WOScounter][23];
	s25 = pArray[WOScounter][24];
	s26 = pArray[WOScounter][25];
	s27 = pArray[WOScounter][26];
	s28 = pArray[WOScounter][27];
	s29 = pArray[WOScounter][28];
	s30 = pArray[WOScounter][29];
	s31 = pArray[WOScounter][30];
	s32 = pArray[WOScounter][31];
	s33 = pArray[WOScounter][32];
	s34 = pArray[WOScounter][33];
	s35 = pArray[WOScounter][34];
	s36 = pArray[WOScounter][35];
	s37 = pArray[WOScounter][36];
	s38 = pArray[WOScounter][37];
	s39 = pArray[WOScounter][38];
	s40 = pArray[WOScounter][39];
	s41 = pArray[WOScounter][40];
	s42 = pArray[WOScounter][41];
	s43 = pArray[WOScounter][42];
	s44 = pArray[WOScounter][43];
	s45 = pArray[WOScounter][44];
	s46 = pArray[WOScounter][45];
	s47 = pArray[WOScounter][46];
	s48 = pArray[WOScounter][47];
	s49 = pArray[WOScounter][48];
	s50 = pArray[WOScounter][49];
	s51 = pArray[WOScounter][50];
	
	putit.send();


}
public function afterputWOS(ev:ResultEvent):void {
	putit.url = "http://localhost/googleclaimsparser/src/php/putWData.php"
	if (WOScounter < pArray.length-1){
		WOScounter++;
		s1 = pArray[WOScounter][0];
		s2 = pArray[WOScounter][1];
		s3 = pArray[WOScounter][2];
		s4 = pArray[WOScounter][3];
		s5 = pArray[WOScounter][4];
		s6 = pArray[WOScounter][5];
		s7 = pArray[WOScounter][6];
		s8 = pArray[WOScounter][7];
		s9 = pArray[WOScounter][8];
		s10 = pArray[WOScounter][9];
		s11 = pArray[WOScounter][10];
		s12 = pArray[WOScounter][11];
		s13 = pArray[WOScounter][12];
		s14 = pArray[WOScounter][13];
		
		s15 = pArray[WOScounter][14];
		s16 = pArray[WOScounter][15];
		s17 = pArray[WOScounter][16];
		s18 = pArray[WOScounter][17];
		s19 = pArray[WOScounter][18];
		s20 = pArray[WOScounter][19];
		s21 = pArray[WOScounter][20];
		s22 = pArray[WOScounter][21];
		s23 = pArray[WOScounter][22];
		s24 = pArray[WOScounter][23];
		s25 = pArray[WOScounter][24];
		s26 = pArray[WOScounter][25];
		s27 = pArray[WOScounter][26];
		s28 = pArray[WOScounter][27];
		s29 = pArray[WOScounter][28];
		s30 = pArray[WOScounter][29];
		s31 = pArray[WOScounter][30];
		s32 = pArray[WOScounter][31];
		s33 = pArray[WOScounter][32];
		s34 = pArray[WOScounter][33];
		s35 = pArray[WOScounter][34];
		s36 = pArray[WOScounter][35];
		s37 = pArray[WOScounter][36];
		s38 = pArray[WOScounter][37];
		s39 = pArray[WOScounter][38];
		s40 = pArray[WOScounter][39];
		s41 = pArray[WOScounter][40];
		s42 = pArray[WOScounter][41];
		s43 = pArray[WOScounter][42];
		s44 = pArray[WOScounter][43];
		s45 = pArray[WOScounter][44];
		s46 = pArray[WOScounter][45];
		s47 = pArray[WOScounter][46];
		s48 = pArray[WOScounter][47];
		s49 = pArray[WOScounter][48];
		s50 = pArray[WOScounter][49];
		s51 = pArray[WOScounter][50];
		putit.send();
	}
}
public function afterGetRegularCsv(ev:String):void {
	var temp:String = ev;
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
	getSecondCSV();
}
public function getSecondCSV():void {
	fileGET.removeEventListener(ResultEvent.RESULT, afterGetRegularCsv);

	fileGET.url = "data/Merge1.csv";
	//fileGET.addEventListener(ResultEvent.RESULT, afterGetRegularCsvSecond);
	//authorSeperateColIndex = 2;
	//fileGET.send();
	var file4:File = new File("c:/Merge1.csv");
	//var file4:File = new File("app:/appplug/i.txt");
	var fs2:FileStream = new FileStream();
	fs2.open(file4, FileMode.READ);
	var mtext2:String = fs2.readUTFBytes(fs2.bytesAvailable);
	afterGetRegularCsvSecond(mtext2);
}
public function afterGetRegularCsvSecond(ev:String):void {
	var temp:String = ev;
	var array1:Array = new Array();
	var array2:Array = new Array();
	pArraySecond = new Array();
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
	pArraySecond = array1;
	var stopo:String = "";
	mergeThem();
}
public function mergeThem():void {
	for (var i:uint = 0; i < pArray.length; i++){
		var ntcNum:String = pArray[i][0];
		for (var j:uint = 0; j < pArraySecond.length; j++){
			if (ntcNum.toLowerCase() == pArraySecond[j][0].toString().toLowerCase()){
				for (var k:uint = 1; k < 55; k++){
					pArray[i].push(pArraySecond[j][k]);
				}
			}
		}
	}
	createCSVFILE();
	
	
	
}
public function createCSVFILE():void {
	var csvString:String = "";
	var file:File = File.documentsDirectory;
	file = file.resolvePath("c:/mergeout.txt");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	for (var i:uint = 0; i < pArray.length; i++){
		for (var j:uint = 0; j < pArray[i].length; j++){
			if (j != pArray[i].length-1){
				csvString = csvString + pArray[i][j].toString() + ",";
			}
			else {
				csvString = csvString + pArray[i][j].toString() + "\r\n"
			}
		}
	}
	fileStream.writeUTFBytes(csvString);
	fileStream.close();
	var jo:String = "";
}
public function afterGetAuthorSeperateCsv(ev:ResultEvent):void {
	var temp:String = ev.result.toString();
	var array1:Array = new Array();
	var array2:Array = new Array();
	pArray = new Array();
	do {
		var colCount:uint = 0;
		var line:String = temp.substring(0,temp.indexOf("\r\n"));
		var stop33:String = "";
		var authorArray:Array = new Array();
		do {
			var ent:String = "";
			if (colCount == authorSeperateColIndex){
				var line2:String = "";
				if (line.charAt(0) == "\""){
					line = line.substring(1,line.length);
					line2 = line.substring(0,line.indexOf("\""));
					line = line.substring(line.indexOf("\"")+1,line.length);
					if (line.charAt(0) == ","){
						line = line.substring(1,line.length);
					}
				}
				else {
					if (line.indexOf(",") != -1){
						line2 = line.substring(0,line.indexOf(","));
						line = line.substring(line.indexOf(",")+1,line.length);
					}
					else {
						line2 = line;
						line = "";
					}
				}
				
				if (line2 != ""){
					do {
						authorArray.push(line2.substring(0,line2.indexOf(";")));
						line2 = line2.substring(line2.indexOf(";")+2,line2.length);
					}while (line2.indexOf(";")!=-1);
					authorArray.push(line2);
				}
				ent = "";
			}
			else{
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
			}
			array2.push(ent);
			colCount++;
		}while (line.length > 1);
		for (var i:uint = 0; i < authorArray.length; i++){
			
			
			
			
			array2[authorSeperateColIndex] = authorArray[i];
			for (var k:uint = 0; k < authorArray.length; k++){
				if (authorArray[k] != authorArray[i]){
				
					var tempArray:Array = new Array();
					for (var j:uint = 0; j < array2.length; j++){
						tempArray.push(array2[j]);
					}
					tempArray.push(authorArray[k]);
					array1.push(tempArray);
				}
			}
			
		}
		array2 = new Array();
		temp = temp.substring(temp.indexOf("\r\n")+2,temp.length);
	}while (temp.indexOf("\r\n") != -1);
	pArray = array1;
	superPut();
	//getClaimsStart(1);
}
public function getClaimsStart(u:uint):void {
	for (var i :uint = 1; i < pArray.length; i++){
		var title:String = pArray[i][u];
		if (title.indexOf("|") != -1){
			title = title.substring(0,title.indexOf("|"));
		}
		var j:RegExp;
		if (title.indexOf(" ") != -1){
			j =/\ /gi;
			title = title.replace(j, "+");
		}
		if (title.indexOf(",") != -1){
			j =/\ /gi;
			title = title.replace(j, "%2C");
		}
		var url:String = "http://www.google.com/patents?q="+title+"&btnG=Search+Patents";
		pArray[i].push(url);
	}
	urlCount1 = 1;
	getUrlSearch1();
}
public function getUrlSearch1():void {
	var mu:URLRequest = new URLRequest(pArray[urlCount1][pArray[urlCount1].length-1]);
	var ml:URLLoader = new URLLoader();
	ml.addEventListener(Event.COMPLETE, muComplete);
	ml.addEventListener(IOErrorEvent.IO_ERROR, errorGET);
	//htmo.location = mu.url;
	
	
	ml.load(mu);
}
public function errorGET(ev:IOErrorEvent):void {
	var stop:String = "";
}
public function muComplete(ev:Event):void {
	var temp:String = ev.target.data;
	temp = temp.substring(temp.indexOf("class=\"result_spacer\""),temp.length);
	temp = temp.substring(temp.indexOf("href")+6,temp.length);
	temp = temp.substring(0,temp.indexOf(">")-1);
	var urlo:String = temp;
	pArray[urlCount1].push(urlo);
	
	
	
	
	//if (urlCount1 < 5){
	if (urlCount1 < pArray.length-1){
		urlCount1++;
		var mu:URLRequest = new URLRequest(pArray[urlCount1][pArray[urlCount1].length-1]);
		var ml:URLLoader = new URLLoader();
		ml.addEventListener(Event.COMPLETE, muComplete);
		ml.load(mu);
	}
	else {
		cc1.text = urlCount1.toString();
		urlCount2 = 1;
		//getUrlSearch2();
	}
}
public function getUrlSearch2():void {
	var cu:URLRequest = new URLRequest(pArray[urlCount2][pArray[urlCount2].length-1]);
	var cl:URLLoader = new URLLoader();
	cl.addEventListener(Event.COMPLETE, cuComplete);
	cl.load(cu);
}
public function cuComplete(ev:Event):void {
	var temp:String = ev.target.data;
	temp = temp.substring(temp.indexOf("patent_claims_anchor")+22,temp.length);
	temp = temp.substring(0,temp.indexOf("vertical_module_list_row")-1);
	var j:RegExp;
	j =/\>/gi;
	temp = temp.replace(j, "");
	j =/\</gi;
	temp = temp.replace(j, "");
	j =/\;/gi;
	temp = temp.replace(j, "");
	j =/\,/gi;
	temp = temp.replace(j, "");
	j =/\//gi;
	temp = temp.replace(j, "");
	j =/\=/gi;
	temp = temp.replace(j, "");
	
	
	s1 = pArray[urlCount2][0];
	s2 = pArray[urlCount2][1];
	s3 = pArray[urlCount2][2];
	s4 = pArray[urlCount2][3];
	s5 = pArray[urlCount2][4];
	s6 = pArray[urlCount2][5];
	s7 = pArray[urlCount2][6];
	s8 = pArray[urlCount2][7];
	s9 = pArray[urlCount2][8];
	s10 = pArray[urlCount2][9];
	s11 = pArray[urlCount2][10];
	s12 = pArray[urlCount2][11];
	s13 = pArray[urlCount2][12];
	//s14 = temp;
	s14 = "";
	
	putit.send();
	if (urlCount2 < pArray.length-1){
	//if (urlCount2 < 2){
		urlCount2++;
		cc2.text = urlCount2.toString();
		do{
			if (pArray[urlCount2][pArray[urlCount2].length-1].indexOf("http") == -1){
				urlCount2++;
			}
		}while (pArray[urlCount2][pArray[urlCount2].length-1].indexOf("http") == -1);
		var cu:URLRequest = new URLRequest(pArray[urlCount2][pArray[urlCount2].length-1]);
		var cl:URLLoader = new URLLoader();
		cl.addEventListener(Event.COMPLETE, cuComplete);
		cl.load(cu);
	}
	else {
		//done the hole thing
	}
}
public function superPut():void {
	putit.addEventListener(ResultEvent.RESULT,afterPut);
	superCount = 0;
	putit.url = "http://localhost/googleclaimsparser/src/php/putAData.php";
	//putit.url = "http://localhost/googleclaimsparser/src/php/putAData.php"
	s1 = pArray[superCount][0];
	s2 = pArray[superCount][1];
	s3 = pArray[superCount][2];
	s4 = pArray[superCount][3];
	if (s3.toLowerCase().indexOf("mullan") != -1){
		s3 = "Mullan, M";
	}
	
	if (s4.toLowerCase().indexOf("mullan") != -1){
		s4 = "Mullan, M";
	}
	
	if (s3.toLowerCase().indexOf("lannfelt,") != -1){
		s3 = "Lannfelt";
	}
	
	if (s4.toLowerCase().indexOf("lannfelt,") != -1){
		s4 = "Lannfelt";
	}
	s5 = "";//pArray[superCount][4];
	s6 = "";//pArray[superCount][5];
	s7 = "";//pArray[superCount][6];
	s8 = "";//pArray[superCount][7];
	s9 = "";//pArray[superCount][8];
	s10 = "";//pArray[superCount][9];
	s11 = "";//pArray[superCount][10];
	s12 = "";//pArray[superCount][11];
	s13 = "";//pArray[superCount][12];
	//s14 = temp;
	s14 = "";
	putit.send();
}
public function afterPut(ev:ResultEvent):void {
	if (superCount < pArray.length){
		superCount++;
		s1 = pArray[superCount][0];
		s2 = pArray[superCount][1];
		s3 = pArray[superCount][2];
		s4 = pArray[superCount][3];
		if (s3.toLowerCase().indexOf("mullan") != -1){
			s3 = "Mullan, M";
		}
		
		if (s4.toLowerCase().indexOf("mullan") != -1){
			s4 = "Mullan, M";
		}
		
		if (s3.toLowerCase().indexOf("lannfelt,") != -1){
			s3 = "Lannfelt";
		}
		
		if (s4.toLowerCase().indexOf("lannfelt,") != -1){
			s4 = "Lannfelt";
		}
		putit.send();
	}
	else {
		var stop0:String = "";
	}
}