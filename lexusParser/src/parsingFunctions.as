
import flash.events.*;
import flash.filesystem.File;
import flash.html.*;
import flash.html.HTMLLoader;
import flash.html.HTMLPDFCapability;
import flash.net.FileReference;
import flash.system.*;
import flash.utils.*;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

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
[Bindable]
public var xm:XML = <Articles></Articles>;
public function init():void {
	databaseReload();
}
public function databaseReload():void {
	
	senderCount = 1;
	filesLimit = 4;
	filePath = "data2/ukocularfactiva/"+senderCount.toString()+".html";
	parseFile.send();
	
}
public function databaseReload2():void {
	
	senderCount = 0;
	filesLimit = 13;
	filePath = "data2/usocularfactiva/"+senderCount.toString()+".html";
	parseFile.send();
	
}

public function gotFile(ev:ResultEvent):void {
	if (ev.result != null){
		var artic:ArrayCollection = new ArrayCollection();
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
				
					
			}
			
			superArray.addItem({type:node1,title:node2,wordcount:node4,date:node5,source:node6,text:node8,refnum:node9});
			
			
			var xmlString:String = "";
			xmlString += "<article>"
				
			xmlString += "<type>"+node1+"</type>";
			xmlString += "<title>"+node2+"</title>";
			xmlString += "<wordcount>"+node4+"</wordcount>";
			xmlString += "<date>"+node5+"</date>";
			xmlString += "<source>"+node6+"</source>";
			xmlString += "<text>"+node8+"</text>";
			xmlString += "<refnum>"+node9+"</refnum>";
			
			
			xmlString += "</article>"
			var xmlList:XMLList = XMLList(xmlString);
			counter++;
			xm.appendChild(xmlList);
			//var xm:XMLNode = XMLNode(
		}
		
		
	}
	
	if (senderCount < filesLimit){
		senderCount++;
		filePath = "data2/ukocularfactiva/"+senderCount.toString()+".html";
		parseFile.send();
	}
	else {
		
		/*var fr:FileReference = new FileReference();
		var ba:ByteArray = new ByteArray();
		ba.writeMultiByte(xm.toXMLString(), 'utf-8');
		fr.save(ba);
		
	}
}


