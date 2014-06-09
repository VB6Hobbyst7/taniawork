// ActionScript file
import flash.data.SQLConnection;
import flash.data.SQLStatement;

import mx.collections.ArrayCollection;
import mx.messaging.channels.StreamingAMFChannel;
import mx.rpc.events.ResultEvent;

import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
[Bindable]
public var scanningMode:Boolean = false;
[Bindable]
public var scannedText:String = "";
public var scannedText2:String = "";
[Bindable]
public var userID:String = "";
[Bindable]
public var payamount:Number = 0;
[Bindable]
public var logcode:String = "";
[Bindable]
public var amount:String = "";
[Bindable]
public var gst:String = "5";
[Bindable]
public var merchid:uint = 1;
[Bindable]
public var locationid:uint = 1;
public var codeArray:Array = new Array();
public function scanPress(event:MouseEvent):void {
	scannedText = "";
	scannedText2 = "";
	scanBTN.enabled = false;
	userLBL.text = "Scanning User...";
	scanningMode = true;
	/*				if (scanBTN.text == "Scan User"){
	scannedText = "";
	scannedText2 = "";
	codeArray = new Array();
	scanBTN.text = "Stop Scan";
	userLBL.text = "Scanning User...";
	scanningMode = true;
	}
	else if (scanBTN.text == "Process Payment"){
	if (scannedText2.toLowerCase().indexOf('formalendofstatement') != -1){
	amount = totalValue.text;
	code = scannedText2.substring(0,scannedText2.toLowerCase().indexOf('formalendofstatement')).toLowerCase();
	payGo.send();
	}
	else {
	reset(event);
	}
	
	}
	else if (scannedText2.toLowerCase().indexOf('formalendofstatement') != -1){
	goodScan(scannedText2);	
	}		
	else {
	reset(event);
	}*/
}
public function processPress(ev:MouseEvent):void {
	amount = totalValue.text;
	code = scannedText2.substring(0,scannedText2.toLowerCase().indexOf('formalendofstatement')).toLowerCase();
	payGo.send();
}
public function resetPress(event:MouseEvent):void {
	scanBTN.enabled = false;
	resetBTN.enabled = true;
	processBTN.enabled = false;
	totalValue.text = "0.00";
	codeArray = new Array();
	payamount = 0;
	scannedText = "";
	scannedText2 = "";
	scanningMode = false;
	userLBL.text = "Please Scan a User";
	/*scanBTN.text = "Scan User";
	userLBL.text = "Scan Aborted";
	scanningMode = false;
	codeArray = new Array();*/
}
public function process(s:String):void
{
	// TODO Auto-generated method stub
	if (totalValue.text == "0.00"){
		totalValue.text = "";
	}
	
	if (s == 'c'){
		totalValue.text = "";
		scanBTN.enabled = true;
		resetBTN.enabled = true;
		processBTN.enabled = false;
		codeArray = new Array();
		payamount = 0;
		scannedText = "";
		scannedText2 = "";
		scanningMode = false;
		userLBL.text = "Please Scan a User";
	}
	else {
		if (scanningMode == false){
			scanBTN.enabled = true;
		}
		
		var ptv:String =  totalValue.text + s;
		if (ptv.indexOf(".") != -1){
			if (ptv.indexOf(".") != ptv.lastIndexOf(".")){
				
			}
			else {
				var temp:String = ptv.substring(ptv.indexOf(".")+1,ptv.length);
				if (temp.length > 2){
					
				}
				else {
					totalValue.text = totalValue.text + s;
				}	
			}
			
		}
		else {
			totalValue.text = totalValue.text + s;
		}
		
	}
}
public function keypress(event:KeyboardEvent):void
{
	if (scanningMode){
		var me:String = String.fromCharCode(event.charCode);
		scannedText = scannedText+me;
		scannedText2 = scannedText2+me;
		codeArray.push(me);
		if (scannedText2.toLowerCase().indexOf('formalendofstatement') != -1){
			goodScan(scannedText2);
		}
	}
}
public function goodScan(s:String):void {
	userLBL.text = "Scan Finished, Please Process Payment";
	scanningMode = false;
	processBTN.enabled = true;		
}
public function afterProcess(ev:ResultEvent):void {
	var stop:String = "";
	var message:String = ev.result[0].res.message;
	scanBTN.enabled = true;
	resetBTN.enabled = true;
	processBTN.enabled = false;
	totalValue.text = "0.00";
	codeArray = new Array();
	payamount = 0;
	scannedText = "";
	scannedText2 = "";
	scanningMode = false;
	userLBL.text = message;
}


