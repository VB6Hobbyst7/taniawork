import flash.events.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.*;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.*;
import mx.controls.ColorPicker;
import mx.controls.ToolTip;
import mx.effects.Glow;
import mx.events.*;
import mx.events.EffectEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.events.ToolTipEvent;
import mx.managers.*;
import mx.managers.ToolTipManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.states.*;

import spark.components.BorderContainer;
import spark.components.Label;
import spark.effects.Move;
import spark.effects.Scale;
import spark.events.IndexChangeEvent;
import spark.filters.GlowFilter;

public var date1:uint = 1985;
public var date2:uint = 1992;
public var date3:uint = 2005;
public var date4:uint = 2011;
public var spaceVal:uint = 50;
[Bindable]
public var showLabels:Boolean = false;
[Bindable]
public var showLabels2:Boolean = false;
public var resultArray:ArrayCollection = new ArrayCollection();
public var loadTimer:Timer = new Timer(250,1000);
[Bindable]
public var benloaded:Boolean = false;
public function init():void {
	
	fChoice.addItem({name:"1"});
	fChoice.addItem({name:"2"});
	fChoice.addItem({name:"3"});
	citingLevel.selectedIndex = 0;
	citedLevel.selectedIndex = 0;
	arrangeType.text = "Publication Date";
	backButton.visible = false;
	loadTimer.addEventListener(TimerEvent.TIMER, loadInt);
	loadTimer.start();
	disconnectAllConnections();
	getHomeSquares.send();
}


public function displayResults(ev:ResultEvent):void {
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	resultArray = new ArrayCollection();
	resultHolder.visible = true;
	var stop:String = "";
	ToolTipManager.enabled = true;
	ToolTipManager.showDelay = 750;
	ToolTipManager.hideDelay = 2000;
	var ttc:ToolTip = new ToolTip();
	ttc.alpha  = 0;
	if (ev.result[0] != null){
		resultArray = ev.result[0].res.re;
		/*var icount:uint = 0;
		for (var i:uint = 0; i < resultArray.length; i++){
			var li:levelItem = new levelItem();
			li.addEventListener(MouseEvent.CLICK , levelToolShow);
			li.addEventListener(MouseEvent.MOUSE_OVER,overLevelItem);
			li.addEventListener(MouseEvent.MOUSE_OUT,outLevelItem);
			li.setStyle("borderVisible",true);
			li.setStyle("backgroundColor","#666666");
			li.setStyle("borderColor","#FFFFFF");
			li.setStyle("buttonMode", true);
			li.indexID = resultArray[i].id;
			var squareHeight:uint = (resultHolder.height-(Math.sqrt(resultArray.length)+2))/
				(Math.sqrt(resultArray.length));
			var squareWidth:uint = (resultHolder.width-(Math.sqrt(resultArray.length)+2))/
				(Math.sqrt(resultArray.length));
			li.setView(1,squareHeight,squareWidth);
			li.authorName = resultArray[i].AU;
			li.title = resultArray[i].TI;
			resultHolder.addChild(li);
		}*/
		resultHolder.dataProvider = resultArray;
	}
}
public function displayDocText(ev:ResultEvent):void {
	try{
		texticoBody.text = ev.result[0].text.te.AB.toString();
	}
	catch(e:Error){texticoBody.text = "Text Not Available";}
}
public function displayLinks(ev:ResultEvent):void {
	
	
	
	
	
}

public function loadInt(ev:TimerEvent):void {
	status.visible = true;
	if (benloaded == true){
		cancler.visible = true;
	}
	
	if (status.text == "Loading Please Wait"){
		status.text = "Loading Please Wait."
	}
	else if (status.text == "Loading Please Wait."){
		status.text = "Loading Please Wait.."
	}
	else if (status.text == "Loading Please Wait.."){
		status.text = "Loading Please Wait..."
	}
	else {
		status.text = "Loading Please Wait"
	}
}
public function disconnectAllConnections():void {
	getHomeSquares.disconnect();
	getHomeSquares.logout();
	getAlphaSquares.disconnect();
	getAlphaSquares.logout();
	getResults.disconnect();
	getResults.logout();
	getDocText.disconnect();
	getDocText.logout();
	getLinks.disconnect();
	getLinks.logout();
	
}