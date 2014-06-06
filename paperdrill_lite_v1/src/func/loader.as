import flash.events.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.*;
import flash.utils.Timer;

import mx.binding.utils.ChangeWatcher;
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
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.events.ToolTipEvent;
import mx.logging.Log;
import mx.logging.targets.TraceTarget;
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
[Bindable]
public var caty1:String = "";
[Bindable]
public var caty2:String = "";
[Bindable]
public var caty3:String = "";
[Bindable]
public var sChoice:ArrayCollection = new ArrayCollection();
[Bindable]
public var dChoice:ArrayCollection = new ArrayCollection();
private var widthWatch:ChangeWatcher;
private var heightWatch:ChangeWatcher;
private var resizeExecuting:Boolean = false;
public function init():void {
	widthWatch = ChangeWatcher.watch(this,'width',onSizeChange);
	heightWatch = ChangeWatcher.watch(this,'height',onSizeChange);
	fChoice.addItem({name:"1"});
	fChoice.addItem({name:"2"});
	fChoice.addItem({name:"3"});
	dChoice.addItem({name:"5"});
	dChoice.addItem({name:"10"});
	dChoice.addItem({name:"20"});
	dChoice.addItem({name:"40"});
	dChoice.addItem({name:"60"});
	sChoice.addItem({name:"Author & Title"});
	sChoice.addItem({name:"Author"});
	sChoice.addItem({name:"Title"});
	sChoice.addItem({name:"Abstract"});
	searchOptions.selectedIndex = 0;
	citingLevel.selectedIndex = 0;
	citedLevel.selectedIndex = 0;
	//arrangeType.text = "Publication Date";
	
	loadTimer.addEventListener(TimerEvent.TIMER, loadInt);
	loadTimer.start();
	disconnectAllConnections();
	runHomeSquareFetch();
	
}
private function onSizeChange(event:Event):void
{
	if(!resizeExecuting)
		callLater(handleResize);
	resizeExecuting = true;
}

private function handleResize():void
{
	//do expensive work here
	if (view1.visible == true){
		displayHomeSquares();
	}
	else if (view2.visible == true){
		displayAlphaSquares();
	}
	resizeExecuting = false;
}

private function stopWatching():void 
{
	//invoke this to stop watching the properties and prevent the handleResize method from executing
	widthWatch.unwatch();
	heightWatch.unwatch();
}
public function runHomeSquareFetch():void {
	if (userCat1.text.length < 3){
		userCat1.text = "science";
	}
	if (userCat2.text.length < 3){
		userCat2.text = "medic";
	}
	if (userCat3.text.length < 3){
		userCat3.text = "busines";
	}
	
	caty1 = userCat1.text;
	caty2 = userCat2.text;
	caty3 = userCat3.text;
	
	
	getHomeSquares.send();
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