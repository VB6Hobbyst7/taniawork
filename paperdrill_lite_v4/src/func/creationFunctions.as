import mx.collections.ArrayCollection;
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

public function createCitedSquares(ev:ArrayCollection):void {
	
	
}
public function createCitingSquares(ev:ArrayCollection):void {
	
	
}
public function inCited(_a:String,_t:String):Number {
	for (var i:uint = 0; i < citedArray.length; i++){
		if ((citedArray[i].cs.author == _a)&&(citedArray[i].cs.title == _t)){
			return i; 
		}
	}
	return -1;
}
public function inCiting(_a:String,_t:String):Number {
	for (var i:uint = 0; i < citingArray.length; i++){
		if ((citingArray[i].cs.author == _a)&&(citingArray[i].cs.title == _t)){
			return i; 
		}
	}
	return -1;
}
public function citeSquaro(_a:String,_id:int,_ctype:uint,_title:String,_date:Number,_id2:Number,_sCount:Number):citeItem {
	var ci:citeItem = new citeItem();
	ci.author = _a;
	ci.id1 = _id;
	ci.citeType = _ctype;
	ci.title = _title;
	ci.date = _date;
	ci.date2 = _date.toString();
	ci.height = 15;
	ci.width = 80;
	ci.setText(_a);
	ci.seedCount = _sCount;
	ci.setStyle("fontSize",10);
	ci.setStyle("color","#000000");
	ci.setStyle("fontFamily","Verdana");
	ci.buttonMode = true;
	ci.addEventListener(MouseEvent.CLICK, clickAuthorItem);
	ci.addEventListener(MouseEvent.MOUSE_OVER, overBoxe2);
	ci.addEventListener(MouseEvent.MOUSE_OUT, outBoxe2);
	ci.id2 = _id2;
	return ci;
}
