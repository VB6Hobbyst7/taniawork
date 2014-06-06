import flash.events.*;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.html.*;
import flash.html.HTMLLoader;
import flash.html.HTMLPDFCapability;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.*;
import flash.utils.*;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.utils.ArrayUtil;
import mx.utils.StringUtil;
import mx.validators.Validator;
public var superArray:ArrayCollection = new ArrayCollection();
public var translateStartMain:uint =0;

public var translateStart:uint =0;
public var translateFinish:uint =0;

public var senderCount:int = 0;
public var senderCount2:int = 0;
public var proFinished:Boolean = false;
public var tlist:String = "";
[Bindable]
public var counter:uint = 0;
private var html:HTMLLoader;
public var filesLimit:uint = 4;
[Bindable]

public var sCount:int = 0;
public var sCount1:int = 0;
public var proFinished2:Boolean = false;
public var tlist2:String = "";
[Bindable]
public var counter2:uint = 1;
public var lexusArray:ArrayCollection = new ArrayCollection();
public var pArray:Array = new Array();
public var ti:Timer = new Timer(Math.random()*500,0);

public function init():void {
	pArray = new Array();
	var file4:File = new File("app:/data2/generalother/generalremove.csv");
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
	init3();
}
public function init3():void {
	//french stuff
	senderCount = 58;
	filesLimit = 64;
	//all stuff
	//senderCount = 0;
	//filesLimit = 70;
	filePath = "data2/generalother/"+senderCount.toString()+".txt";
	parseFile.send();
}

public function gotFile(ev:ResultEvent):void {
	if (ev.result != null){
		var ts:String = ev.result.toString();
		var e:uint = 0;
		do {
			e++;
			var node1:String = "No Section";
			var node2:String = "";
			var node3:String = "";
			var node4:String = "";
			var node5:String = "";
			var node6:String = "";
			var node7:String = "";
			var node8:String = "";
			var node10:String = "";
			//start of all parsing
			var ts2:String = ts.substring(0,
				ts.indexOf("DOCUMENTS\r",50));
			//start of date parsing
			ts2 = ts2.substring(ts2.indexOf("Copyright"),ts2.length);
			ts2 = ts2.substring(ts2.indexOf("\r\n")+2,ts2.length);
			ts2 = ts2.substring(ts2.indexOf("\r\n")+2,ts2.length);
			ts2 = StringUtil.trim(ts2);
			node10 = ts2.substring(0,ts2.indexOf("\r"));
			if ((node10.indexOf("200") != -1)||(node10.indexOf("19") != -1)){
				var choice:Number = -1;
				if (node10.indexOf("200") != -1) {
					choice = 0;
				}
				else if (node10.indexOf("19") != -1) {
					choice = 1;
				}
				ts2 = ts.substring(0,
					ts.indexOf("DOCUMENTS\r",50));
				//start of date parsing
				ts2 = ts2.substring(ts2.indexOf("Copyright"),ts2.length);
				ts2 = ts2.substring(ts2.indexOf("\r\n")+2,ts2.length);
				node10 = StringUtil.trim(ts2.substring(0,ts2.indexOf("\r")));
				ts2 = ts2.substring(ts2.indexOf("\r\n")+2,ts2.length);
				ts2 = StringUtil.trim(ts2);
				if (choice == 0){
					node5 = ts2.substring(0,ts2.indexOf("200")+4);
					
				}
				else if (choice == 1){
					node5 = ts2.substring(0,ts2.indexOf("19")+4);
					
				}
				
				//88888888888888888888888888888
				if ((node5.toLowerCase().indexOf("copy") != -1)||(node10.toLowerCase().indexOf("rights") != -1)){
					ts2 = ts2.substring(ts2.indexOf("\r\n")+2,ts2.length);
					ts2 = ts2.substring(ts2.indexOf("\r\n")+2,ts2.length);
					node10 = StringUtil.trim(ts2.substring(0,ts2.indexOf("\r")));
					ts2 = ts2.substring(ts2.indexOf("\r\n")+4,ts2.length);
					ts2 = StringUtil.trim(ts2);
					
					if (ts2.indexOf("200") != -1) {
						node5 = ts2.substring(0,ts2.indexOf("200")+4);
						node5 = fixDate(node5);
					}
					else if (ts2.indexOf("19") != -1) {
						node5 = ts2.substring(0,ts2.indexOf("19")+4);
						node5 = fixDate(node5);
					}
					
					
					if (ts2.indexOf("SECTION:") != -1){
						ts2 = ts2.substring(ts2.indexOf("SECTION:"),ts2.length);
						node1 = ts2.substring(9,ts2.indexOf(";"));
					}
					else if (ts2.indexOf("DISTRIBUTION:") != -1){
						//	ts2 = ts2.substring(ts2.indexOf("DISTRIBUTION:"),ts2.length);
						//node1 = ts2.substring(14,ts2.indexOf("\r"));
					}
					//start of title parsing
					ts2 = ts2.substring(ts2.indexOf("HEADLINE"),ts2.length);
					node2 = ts2.substring(ts2.indexOf("HEADLINE")+10, ts2.indexOf("\r"));
					//start of text parsing
					ts2 = ts2.substring(ts2.indexOf("BODY"),ts2.length);
					if ( ts2.indexOf("LOAD-DATE") != -1){
						node8 = ts2.substring(ts2.indexOf("BODY")+9, ts2.indexOf("LOAD-DATE"));
					}
					else {
						node8 = ts2.substring(ts2.indexOf("BODY")+9, ts2.length);
					}
					var stop:String = "";
				}
				else {
					node5 = fixDate(node5);
					if (ts2.indexOf("SECTION:") != -1){
						ts2 = ts2.substring(ts2.indexOf("SECTION:"),ts2.length);
						node1 = ts2.substring(9,ts2.indexOf(";"));
					}
					else if (ts2.indexOf("DISTRIBUTION:") != -1){
						//	ts2 = ts2.substring(ts2.indexOf("DISTRIBUTION:"),ts2.length);
						//node1 = ts2.substring(14,ts2.indexOf("\r"));
					}
					//start of title parsing
					ts2 = ts2.substring(ts2.indexOf("HEADLINE"),ts2.length);
					node2 = ts2.substring(ts2.indexOf("HEADLINE")+10, ts2.indexOf("\r"));
					//start of text parsing
					ts2 = ts2.substring(ts2.indexOf("BODY"),ts2.length);
					if ( ts2.indexOf("LOAD-DATE") != -1){
						node8 = ts2.substring(ts2.indexOf("BODY")+9, ts2.indexOf("LOAD-DATE"));
					}
					else {
						node8 = ts2.substring(ts2.indexOf("BODY")+9, ts2.length);
					}
				}
				var stop2:String = "";
				
			}
			else {
				ts2 = ts2.substring(ts2.indexOf("\r\n\r\n")+4,ts2.length);
				ts2 = StringUtil.trim(ts2);
				node5 = ts2.substring(0,ts2.indexOf("\r"));
				node5 = fixDate(node5);
				//start of section and page parsing
				if (ts2.indexOf("SECTION:") != -1){
					ts2 = ts2.substring(ts2.indexOf("SECTION:"),ts2.length);
					node1 = ts2.substring(9,ts2.indexOf(";"));
				}
				else if (ts2.indexOf("DISTRIBUTION:") != -1){
					//	ts2 = ts2.substring(ts2.indexOf("DISTRIBUTION:"),ts2.length);
					//node1 = ts2.substring(14,ts2.indexOf("\r"));
				}
				//start of title parsing
				ts2 = ts2.substring(ts2.indexOf("HEADLINE"),ts2.length);
				node2 = ts2.substring(ts2.indexOf("HEADLINE")+10, ts2.indexOf("\r"));
				//start of text parsing
				ts2 = ts2.substring(ts2.indexOf("BODY"),ts2.length);
				if ( ts2.indexOf("LOAD-DATE") != -1){
					node8 = ts2.substring(ts2.indexOf("BODY")+9, ts2.indexOf("LOAD-DATE"));
				}
				else {
					node8 = ts2.substring(ts2.indexOf("BODY")+9, ts2.length);
				}
				
			}
			ts = ts.substring(
				ts.indexOf("DOCUMENTS\r",50)+10,ts.length);
			
			try{
				var avoid:Boolean = false;
				for (var i:uint = 0; i < pArray.length; i++){
					if (node10.indexOf(pArray[i][0]) != -1){
						avoid = true;
					}
				}
				
				if (avoid == false){
				superArray.addItem({type:node1,title:node2,wordcount:node4,date:node5,source:node10,text:fixBodyText(node8),text2:"",refnum:"0"});

				
				}
			}
			catch(Exception){
				
			}
			
			
			
		}while (ts.indexOf("DOCUMENTS\r") != -1);
		
	}
	
	if (senderCount < filesLimit){
		senderCount++;
		if (senderCount > 70){
			filePath = "data2/generalother/"+senderCount.toString()+".html";
		}
		else {
			filePath = "data2/generalother/"+senderCount.toString()+".txt";
		}
		parseFile.send();
	}
	else {
		translateFromFrench();
		translateStartMain = 0;
		translateStart = 0;
		translateFinish = 10;
		//translateFromGerman();
		//createCSVFILE2();
		/*var fr:FileReference = new FileReference();
		var ba:ByteArray = new ByteArray();
		ba.writeMultiByte(xm2.toXMLString(), 'utf-8');
		fr.save(ba);*/
		
	}
}
public function translateFromFrench():void {
	var tempS:String = superArray[translateStart].text;
	if (tempS.length > 1000){
		s1 = tempS.substring(0,999);
		superArray[translateStart].text = tempS.substring(999,tempS.length);
	}
	else {
		s1 = tempS;
		superArray[translateStart].text = "";
	}
	
	ti = new Timer(Math.random()*500,0);
	ti.addEventListener(TimerEvent.TIMER, afterTi);
	ti.start();
}
public function translateFromGerman():void {
	
}
public function gotFrench(ev:ResultEvent):void {
	var stop:String = "";
	try{
	superArray[translateStart].text2 = superArray[translateStart].text2 + ev.result[0].french;
	
	
	if (superArray[translateStart].text != ""){
		var tempS:String = superArray[translateStart].text;
		if (tempS.length > 1000){
			s1 = tempS.substring(0,999);
			superArray[translateStart].text = tempS.substring(999,tempS.length);
		}
		else {
			s1 = tempS;
			superArray[translateStart].text = "";
		}
		
		ti = new Timer(Math.random()*500,0);
		ti.addEventListener(TimerEvent.TIMER, afterTi);
		ti.start();
	}
	else if (translateStart < translateFinish){
		translateStart++;
		var tempS:String = superArray[translateStart].text;
		if (tempS.length > 1000){
			s1 = tempS.substring(0,999);
			superArray[translateStart].text = tempS.substring(999,tempS.length);
		}
		else {
			s1 = tempS;
			superArray[translateStart].text = "";
		}
		
		ti = new Timer(Math.random()*500,0);
		ti.addEventListener(TimerEvent.TIMER, afterTi);
		ti.start();
		
	}
	else {
		createCSVFILE2();
	}
	}
	catch(e:Error){
		ti = new Timer(Math.random()*500,0);
		ti.addEventListener(TimerEvent.TIMER, afterTi);
		ti.start();
		
	}
}
public function afterTi(ev:TimerEvent):void {
	counter = translateStart;
	ti.stop();
	ti.removeEventListener(TimerEvent.TIMER, afterTi);
	translateFrench.send();
}
public function gotGerman(ev:ResultEvent):void {
	
}

public function createCSVFILE2():void {
	var csvString:String = "";
	var file:File = File.documentsDirectory;
	file = file.resolvePath("c:/frenchgeneralotherlexus.txt");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	csvString = csvString + "date" + "@";	
	csvString = csvString + "refnum" + "@";	
	csvString = csvString + "source" + "@";	
	csvString = csvString + "text" + "@";	
	csvString = csvString + "title" + "@";	
	csvString = csvString + "type" + "@";	
	csvString = csvString + "wordcount" + "\r\n";	
	for (var i:uint = translateStartMain; i <= translateFinish; i++){
		try{
		csvString = csvString + fixBodyText(superArray[i].date) + "@";	
		csvString = csvString + fixBodyText(superArray[i].refnum) + "@";	
		csvString = csvString + fixBodyText(superArray[i].source) + "@";	
		csvString = csvString + fixBodyText(superArray[i].text2) + "@";	
		csvString = csvString + fixBodyText(superArray[i].title) + "@";	
		csvString = csvString + fixBodyText(superArray[i].type) + "@";	
		csvString = csvString + fixBodyText(superArray[i].wordcount) + "\r\n";	
		}
		catch(e:Error){
			
		}
	}
	fileStream.writeUTFBytes(csvString);
	fileStream.close();	var jo:String = "";
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
	
	try{
	//if (b.indexOf("\r") != -1){
	j =/\r/gi;
	b = b.replace(j, "");
	j =/</gi;
	b = b.replace(j, "");
	j =/>/gi;
	b = b.replace(j, "");
	j =/\n/gi;
	b = b.replace(j, "");
	
	j =/$/gi;
	b = b.replace(j, "");
	//}
	b = b.replace(/[,$]/, "");
	j =/@/gi;
	b = b.replace(j, "");
	//}
	b = b.replace(/[,@]/, "");
	if (b.indexOf("\t") != -1){
	j =/\t/gi;
	b = b.replace(j, "");
		}
	if (b.indexOf("\n") != -1){
	j =/\n/gi;
	b = b.replace(j, "");
	}
	if (b.indexOf(",") != -1){
	j =/,/gi;
	b = b.replace(j, "");
	}
	
	}
	catch(e:Error){
		
	}
	
	return b;
}

public function afterstore(ev:ResultEvent):void {
	var s:String = "";
}

public function gotLexus(ev:ResultEvent):void {
	var s:String = "";
}
public function fixDate(s:String):String {
	var saveS:String = s;
	var p:String = "";
	var ss1:String = s.substring(0,s.indexOf(" ")).toLowerCase();
	var ss2:String = "";
	var ss3:String = "";
	if ((ss1 == "january")||(ss1 == "jan")){
		p = p+"jan";
	}
	else if ((ss1 == "february")||(ss1 == "feb")){
		p = p+"feb";
	}
	else if ((ss1 == "march")||(ss1 == "mar")){
		p = p+"mar";
	}
	else if ((ss1 == "april")||(ss1 == "apr")){
		p = p+"apr";
	}
	else if ((ss1 == "may")||(ss1 == "may")){
		p = p+"may";
	}
	else if ((ss1 == "june")||(ss1 == "jun")){
		p = p+"jun";
	}
	else if ((ss1 == "july")||(ss1 == "jul")){
		p = p+"jul";
	}
	else if ((ss1 == "august")||(ss1 == "aug")){
		p = p+"aug";
	}
	else if ((ss1 == "september")||(ss1 == "sep")||(ss1 == "sept")){
		p = p+"sept";
	}
	else if ((ss1 == "october")||(ss1 == "oct")){
		p = p+"oct";
	}
	else if ((ss1 == "november")||(ss1 == "nov")){
		p = p+"nov";
	}
	else if ((ss1 == "december")||(ss1 == "dec")){
		p = p+"dec";
	}
	s = s.substring(s.indexOf(" ")+1,s.length);
	if (s.charAt(0) == " "){
		s = s.substring(1,s.length);
	}
	
	
	
	if (s.indexOf(",") != -1){
		if (s.indexOf(" ") > s.indexOf(",")){
			ss2 = s.substring(0,s.indexOf(","));
			s = s.substring(s.indexOf(",")+1,s.length);
		}
		else {
			ss2 = s.substring(0,s.indexOf(" "));
			s = s.substring(s.indexOf(" ")+1,s.length);
		}
	}
	else {
		ss2 = s.substring(0,s.indexOf(" "));
		s = s.substring(s.indexOf(" ")+1,s.length);
	}
	
	if (s.charAt(0) == " "){
		s = s.substring(1,s.length);
	}
	
	if ((s.indexOf(",") == -1)&&(s.indexOf(" ") == -1)){
		ss3 = s;
	}
	else if (s.indexOf(",") != -1){
		if (s.indexOf(" ") > s.indexOf(",")){
			ss3 = s.substring(0,s.indexOf(","));
		}
		else {
			ss3 = s.substring(0,s.indexOf(" "));
		}
	}
	else {
		ss3 = s.substring(0,s.indexOf(" "));
	}
	
	if ((ss1.length < 3)||(ss3.length < 3)||(ss2.length < 1))
	{
		var hdhd:String = "";
		return "aug 24, 1988";
		
	}
	else {
		var soou:String = p+" "+ss2+", "+ss3;
		if (soou.indexOf("CTV") != -1){
			return "aug 24, 1988";
		}
		else if (soou.indexOf("NEWS") != -1){
			return "aug 24, 1988";
		}
		else if (soou.indexOf("POWER") != -1){
			return "aug 24, 1988";
		}
		else if (soou.indexOf("PLAY") != -1){
			return "aug 24, 1988";
		}
		else if (soou.indexOf("QUESTION") != -1){
			return "aug 24, 1988";
		}
		else if (soou.indexOf("PERIOD") != -1){
			return "aug 24, 1988";
		}
		else {
			return soou;
		}
	}
	
}




