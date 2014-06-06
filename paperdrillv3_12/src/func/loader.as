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
import data.GrapheLibrary;

import fr.kapit.actionscript.lang.ApplicationContext;
import fr.kapit.actionscript.lang.command.CommandEvent;
import fr.kapit.actionscript.net.command.BaseDataLoaderCommand;
import fr.kapit.actionscript.net.command.INetLoaderCommand;
import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.lab.demo.ui.components.popupLogger.PopupLogger;
import fr.kapit.logging.FlexConsoleTarget;

import mx.events.FlexEvent;
import mx.logging.Log;
import mx.logging.targets.TraceTarget;
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
	new PopupLogger();
	createLogTargets();
}
private function createLogTargets():void
{
	var traceTarget:TraceTarget = new TraceTarget();
	traceTarget.filters = [ "fr.kapit.lab.demo.*" ];
	Log.addTarget(traceTarget);
	
	
	// to use with the FlexConsole AIR application
	var consoleTarget:FlexConsoleTarget = new FlexConsoleTarget();
	consoleTarget.includeDate = true;
	consoleTarget.includeTime = true;
	consoleTarget.includeCategory = true;
	consoleTarget.includeLevel = true;
	consoleTarget.filters = [ "fr.kapit.lab.demo.*" ];
	Log.addTarget(consoleTarget);
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