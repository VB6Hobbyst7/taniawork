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
import mx.collections.ArrayCollection;

public var crumbArray:ArrayCollection = new ArrayCollection();

public function addCrumb(s:String,size:String = "small",id:Number = 0):void {
	var ci:crumbItem = new crumbItem();
	ci.text = s;
	ci.size = size;
	ci.ido = id;
	ci.setStyle("color","#FFFFFF");
	ci.addEventListener(MouseEvent.CLICK, crumbClick);
	crumbArray.addItem({name:s,size:size,ido:id});
	crumbBox.addChild(ci);
}
public function crumbClick(ev:MouseEvent):void {
	while (crumbBox.getChildAt(crumbBox.numChildren-1) != ev.currentTarget){
		crumbBox.removeChildAt(crumbBox.numChildren-1);
		crumbArray.removeItemAt(crumbArray.length-1);
	}
	loadCurrentCrumb();
}
public function crumbBack():void {
	if (crumbBox.numChildren > 0){
		crumbBox.removeChildAt(crumbBox.numChildren-1);
		try{
			crumbArray.removeItemAt(crumbArray.length-1);
		}
		catch(e:Error){
			
		}
	}
	loadCurrentCrumb();
}
public function loadCurrentCrumb():void {
	if (crumbBox.numChildren == 0){
		showScreen(1);
	}
	else if (crumbBox.numChildren == 1){
		showScreen(2);
	}
	else if (crumbBox.numChildren == 2){
		showScreen(3);
	}
	else if (crumbBox.numChildren > 2){
		//if (crumbArray.getItemAt(crumbArray.length-1).size == "small"){
			showScreen(4);
		//}
		//else {
		//	showScreen(5);
		//}
		try{
		seedOn(crumbArray.getItemAt(crumbArray.length-1).ido,
			Number(citedLevel.selectedItem.name),
			Number(citingLevel.selectedItem.name));
		}
		catch(e:Error){
			trace("error in crumb functions");
		}
	}
	else {
		showScreen(1);
	}
}