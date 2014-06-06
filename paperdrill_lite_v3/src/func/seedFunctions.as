import flash.events.MouseEvent;
import flash.events.*;
import flash.events.MouseEvent;
import flash.net.*;
import flash.utils.Timer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import mx.events.EffectEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.events.ToolTipEvent;
import spark.effects.Move;
import spark.effects.Scale;
import spark.events.IndexChangeEvent;
import spark.filters.GlowFilter;
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.*;
import mx.controls.ColorPicker;
import mx.effects.Glow;
import mx.events.*;
import mx.events.EffectEvent;
import mx.managers.*;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.states.*;
import spark.components.BorderContainer;
import spark.components.Label;
import spark.effects.Scale;
import spark.filters.GlowFilter;
// ActionScript file
public function startSeed(ev:MouseEvent):void {
	//id = currentResultSelectedIndex
	
	addCrumb(infoAuthor.text,"small",currentResultSelectedIndex);
	try{
	seedOn(currentResultSelectedIndex,
		Number(citedLevel.selectedItem.name),
		Number(citingLevel.selectedItem.name));
	}
	catch(e:Error){
		citingLevel.selectedIndex = 1;
		citingLevel.selectedIndex = 1;
		seedOn(currentResultSelectedIndex,
			1,
			1);
	}
}
public function seedOn(s:Number,n1:uint,n2:uint):void {
	infoBox.visible = false;
	//textModeBtn.mouseEnabled = false;
//	tileModeBtn.mouseEnabled = false;
	authorTextOut = s.toString();
	levelSpan1 = n1;
	levelSpan2 = n2;
	disconnectAllConnections();
	getLinks.send();
	showScreen(4);
	status.visible = true;
	cancler.visible = true;
	status.text = "Loading Please Wait"
	loadTimer = new Timer(250,1000);
	loadTimer.addEventListener(TimerEvent.TIMER, loadInt);
	loadTimer.start();
}