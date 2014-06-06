
import flash.events.*;
import flash.filesystem.*;
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
import mx.controls.*;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.utils.ArrayUtil;



public var senderCount:int = 0;
public var senderCount2:int = 0;
public var proFinished:Boolean = false;
public var tlist:String = "";
[Bindable]
public var counter:uint = 0;
private var fileOpened:File;
private var fileContents:String = "";;
private var stream:FileStream;

private var html:HTMLLoader;
[Bindable]
public var xm:XML = <Articles></Articles>;
public var texto:String = "";

private var fileCounter:int = 0;
private var bytesLoaded:int = 0;


private var filePath:String = "C:/";//"data/page_no"+i.toString()+".htm";
private var fileName:String = "ocularnewstand";               
private var fileExtension:String = ".html";
private var file:File = new File(filePath+fileName+fileExtension);

//split size = 1 GB 
private var splitSize:int = 50000;

private var fs:FileStream = new FileStream();
private var newfs:FileStream = new FileStream();
private var byteArray:ByteArray = new ByteArray();

private function init():void{
	//var h:String = "data/page_no"+i.toString()+".htm";

	fs.addEventListener(Event.COMPLETE,onFsComplete);
	fs.addEventListener(ProgressEvent.PROGRESS,onFsProgress);
	
	newfs.open(new File(filePath+fileName+fileExtension),FileMode.WRITE);
	fs.openAsync(new File(filePath+fileName+fileExtension),FileMode.READ);
}

private function onFsComplete(e:Event=null):void{                    
	fs.readBytes(byteArray,0,fs.bytesAvailable);                    
	newfs.writeBytes(byteArray,0,Math.min(splitSize-bytesLoaded,fs.bytesAvailable));
	
	for(var i:int = 0; i < byteArray.length; i+=splitSize){
		newfs.close();
		newfs.open(new File(filePath+fileName+fileCounter+fileExtension),FileMode.WRITE);
		newfs.writeBytes(byteArray,i,Math.min(splitSize,byteArray.length-i));
		
		fileCounter++;
		
		trace("Part " + fileCounter + " Complete");
	}
}

private function onFsProgress(e:ProgressEvent):void{
	if((bytesLoaded+fs.bytesAvailable)==file.size){
		onFsComplete();                         
	}
	else if((bytesLoaded + fs.bytesAvailable)>=splitSize){
		fs.readBytes(byteArray,0,splitSize-bytesLoaded);
		
		newfs.writeBytes(byteArray,0,byteArray.length);
		newfs.close();
		
		bytesLoaded = fs.bytesAvailable;
		fs.readBytes(byteArray,0,bytesLoaded);
		
		fileCounter++;
		newfs.open(new File(filePath+fileName+fileCounter+fileExtension),FileMode.WRITE);                         
		newfs.writeBytes(byteArray,0,byteArray.length);
		
		byteArray.clear();
		
		trace("Part " + fileCounter + " Complete");
	}
	else{
		bytesLoaded+=fs.bytesAvailable;
		fs.readBytes(byteArray,0,fs.bytesAvailable);
		newfs.writeBytes(byteArray,0,byteArray.length);
		
		byteArray.clear();     
	}                    
}



