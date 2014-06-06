
import flash.events.*;
import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.html.*;
import flash.html.HTMLLoader;
import flash.html.HTMLPDFCapability;
import flash.net.FileReference;
import flash.system.*;
import flash.utils.*;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.rpc.events.ResultEvent;
import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.utils.ArrayUtil;

public var superArray:ArrayCollection = new ArrayCollection();

public var senderCount:int = 0;
public var senderCount2:int = 0;
public var proFinished:Boolean = false;
public var tlist:String = "";
[Bindable]
public var counter:uint = 0;
private var html:HTMLLoader;
public var filesLimit:uint = 4;
public var datafolderstring:String = "";
[Bindable]
public var xm:XML = <Articles></Articles>;
public function init():void {
	databaseReload4();
}
public function databaseReload4():void {
	
	// 
	senderCount = 77;
	filesLimit = 77;
	datafolderstring = "generalother";
	filePath = "data2/generalother/"+senderCount.toString()+".htm";
	parseFile.send();
	
}
public function databaseReload49():void {
	
	senderCount = 1;
	filesLimit = 4;
	datafolderstring = "ukocularfactiva";
	filePath = "data2/ukocularfactiva/"+senderCount.toString()+".html";
	parseFile.send();
	
}
public function databaseReload():void {
	
	senderCount = 0;
	filesLimit = 13;
	datafolderstring = "usocularfactiva";
	filePath = "data2/usocularfactiva/"+senderCount.toString()+".html";
	parseFile.send();
	
}

public function gotFile(ev:ResultEvent):void {
	if (ev.result != null){
		var artic:ArrayCollection = new ArrayCollection();
		try{
		artic = ev.result.html.body.form.div[1].div.div;
		
		
		for (var i:uint = 0; i < artic.length; i++){
			
			var ainfo:ArrayCollection = new ArrayCollection();
			ainfo = artic[i].p[0].div;
			var node1:String = "";
			var node2:String = "";
			var node3:String = "";
			var node4:String = "";
			var node5:String = "";
			var node6:String = "";
			var node7:String = "";
			var node8:String = "";
			for (var io:uint = 1; io < artic[i].p.length-1; io++){
				node8 += artic[i].p[io].toString();

			}
			
			var node9:String = artic[i].p[artic[i].p.length-1].toString();
			try{
				node1 = ainfo[0].toString();
				node2 = ainfo[1].b.toString();
				
			} 
			catch(Exception){
				try{
				node1 = ainfo[1].toString();
				node2 = ainfo[2].b.toString();
				}
				catch(Exception){
					node1 = ainfo[1].toString();
					node2 = ainfo[0].b.toString();
				}
			}
			for(var j:uint = 2; j < ainfo.length; j++){
				if (ainfo[j].toString().indexOf("words") != -1){
					node4 = ainfo[j].toString();
				}
				if ((ainfo[j].toString().indexOf("2009") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2010") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2008") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2007") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2006") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2005") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2004") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2003") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2002") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2001") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("2000") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1999") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1998") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1997") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1996") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1995") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1994") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1993") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1992") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1991") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				if ((ainfo[j].toString().indexOf("1990") != -1)&&(ainfo[j].toString().indexOf("Copyright") == -1)&&(node5 == "")){
					node5 = ainfo[j].toString();
					node6 = ainfo[j+1].toString();
				}
				
					
			}
			
		
		superArray.addItem({type:node1,title:node2,wordcount:node4,date:node5,source:node6,text:node8,refnum:node9});
		
		}
		}
		catch(ee:Error){
			trace(senderCount.toString());
		}
		
	}

	if (senderCount < filesLimit){
		senderCount++;
		filePath = "data2/"+datafolderstring+"/"+senderCount.toString()+".htm";
		parseFile.send();
	}
	else {
		createCSVFILE2();
	}
}
public function createCSVFILE2():void {
	var csvString:String = "";
	var file:File = File.documentsDirectory;
	file = file.resolvePath("c:/shellyFactivaGerman.txt");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	csvString = csvString + "date" + "@";	
	csvString = csvString + "refnum" + "@";	
	csvString = csvString + "source" + "@";	
	csvString = csvString + "text" + "@";	
	csvString = csvString + "title" + "@";	
	csvString = csvString + "type" + "@";	
	csvString = csvString + "wordcount" + "\r\n";	
	for (var i:uint = 0; i < superArray.length; i++){
		csvString = csvString + fixBodyText(superArray[i].date) + "@";	
		csvString = csvString + fixBodyText(superArray[i].refnum) + "@";	
		csvString = csvString + fixBodyText(superArray[i].source) + "@";	
		csvString = csvString + fixBodyText(superArray[i].text) + "@";	
		csvString = csvString + fixBodyText(superArray[i].title) + "@";	
		csvString = csvString + fixBodyText(superArray[i].type) + "@";	
		csvString = csvString + fixBodyText(superArray[i].wordcount) + "\r\n";	
	}
	fileStream.writeUTFBytes(csvString);
	fileStream.close();
	var jo:String = "";
}
public function fixBodyText(s:String):String {
	var j:RegExp;
	var b:String = s;
	j =/\r/gi;
	b = b.replace(j, "");
	j =/\r/gi;
	b = b.replace(j, "");
	j =/$/gi;
	b = b.replace(j, "");
	b = b.replace(/[,$]/, "") 
	j =/@/gi;
	b = b.replace(j, "");
	b = b.replace(/[,@]/, "") 
	j =/\t/gi;
	b = b.replace(j, "");
	j =/\n/gi;
	b = b.replace(j, "");
	j =/,/gi;
	b = b.replace(j, "");
	j = new RegExp("<p>","g");
	b = b.replace(j,"");	
	j = new RegExp("</p>","g");
	b = b.replace(j,"");
	return b;
}