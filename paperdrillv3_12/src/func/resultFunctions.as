import flash.events.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.*;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.*;
import mx.controls.ColorPicker;
import mx.effects.Glow;
import mx.events.*;
import mx.events.EffectEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.events.ToolTipEvent;
import mx.managers.*;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.states.*;

import spark.components.BorderContainer;
import spark.components.Label;
import spark.effects.Move;
import spark.effects.Scale;
import spark.events.IndexChangeEvent;
import spark.filters.GlowFilter;

// These functions are called after some call to the server
public function afterHomeSquareCall(ev:ResultEvent):void {
	displayHomeSquares(ev);
}
public function afterAlphaSquareCall(ev:ResultEvent):void {
	displayAlphaSquares(ev);
}
public function displayResults(ev:ResultEvent):void {
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	resultArray = new ArrayCollection();
	resultHolder.visible = true;
	
	ToolTipManager.enabled = true;
	ToolTipManager.showDelay = 750;
	ToolTipManager.hideDelay = 2000;
	var ttc:ToolTip = new ToolTip();
	ttc.alpha  = 0;
	if (ev.result[0] != null){
		resultArray = ev.result[0].res.re;
		var labelo:String = startDateP + " - " + endDateP + " / " + alphaStartP + " - " + alphaEndP;
		var xmlStringo:String = "<graphml><node id=\"n1\" label=\""+labelo+"\" layout=\"hierarchicalTree\">graph id=\"n1:\" edgedefault=\"undirected\">";
		for (var i:uint = 0; i < resultArray.length; i++){
			xmlStringo = xmlStringo + "<node id=\"n1::n"+(i+1).toString()+"\" label=\""+resultArray[i].AU+"\"/>"
		}
		xmlStringo = xmlStringo + "</graph></node></graphml>";
		var stop:String = "";
	//	var xmlstuff:XML = new XML(xmlStringo);
		//appModel.diagrammer.dataProvider = xmlstuff
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
		
		
		
		//SO IMPORTANT TO UNCOMMENT THIS
		//resultHolder.dataProvider = resultArray;
		
		
		
		
		
	}
}
public function afterGetLinks(ev:ResultEvent):void {
	//textModeBtn.mouseEnabled = true;
	//tileModeBtn.mouseEnabled = true;
	citedArray = new ArrayCollection();
	citingArray = new ArrayCollection();	
	if ((ev.result.links.level1 == 1)&&(ev.result.links.level2 == 1)){
	if (ev.result.links.cited != null){
		try{
			citedArray = ev.result.links.cited.link;
		}
		catch(e:Error){
			citedArray.addItem({AU:ev.result.links.cited.link.AU,id:ev.result.links.cited.link.id,
				SC:ev.result.links.cited.link.SC,TI:ev.result.links.cited.link.TI});
		}
		
	}
	else {
		citedArray = new ArrayCollection();
	}
	
	if (ev.result.links.citing != null){
		try{
			citingArray = ev.result.links.citing.link;
		}
		catch(e:Error){
			citingArray.addItem({AU:ev.result.links.citing.link.AU,id:ev.result.links.citing.link.id,
				SC:ev.result.links.citing.link.SC,TI:ev.result.links.citing.link.TI});
		}
	}
	else {
		citingArray = new ArrayCollection();	
	}
	}
	else {
		if (ev.result.links.cited != null){
			try{
				citedArray = ev.result.links.cited.link;
			}
			catch(e:Error){
				citedArray.addItem({id:ev.result.links.cited.link.id,
					level:ev.result.links.cited.link.level});
			}
			
		}
		else {
			citedArray = new ArrayCollection();
		}
		
		if (ev.result.links.citing != null){
			try{
				citingArray = ev.result.links.citing.link;
			}
			catch(e:Error){
				citingArray.addItem({id:ev.result.links.cited.link.id,
					level:ev.result.links.cited.link.level});
			}
		}
		else {
			citingArray = new ArrayCollection();	
		}
	}
	displayCitationData(ev.result.links.level1,ev.result.links.level2);
}