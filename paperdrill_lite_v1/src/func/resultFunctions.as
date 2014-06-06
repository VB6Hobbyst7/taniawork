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
[Bindable]
public var alphaSquareArray:Object = new Object();
[Bindable]
public var searchresultArray:ArrayCollection = new ArrayCollection();

// These functions are called after some call to the server
public function afterHomeSquareCall(ev:ResultEvent):void {
	if (ev.result.items != null){
		homeSquareArray = ev.result.items;	
		displayHomeSquares();
	}
	else {
		homeSquareArray = new Object();
	}
	
}
public function afterAlphaSquareCall(ev:ResultEvent):void {
	if (ev.result[0].items != null){
		alphaSquareArray = ev.result[0].items;	
		displayHomeSquares();
		displayAlphaSquares();
	}
	else {
		alphaSquareArray = new Object();
	}
}
public function afterResultCall(ev:ResultEvent):void {
	resultArray = new ArrayCollection();
	if (ev.result[0] != null){
		resultArray = ev.result[0].res.re;
		th3.text = resultArray.length.toString();
		displayResults();
	}
}
public function afterGetSearchResults(ev:ResultEvent):void {
	searchresultArray = new ArrayCollection();
	try{
		if (ev.result[0] != null){
			searchresultArray = ev.result[0].res.re;
		}
	}
	catch(e:Error){
		searchresultArray = new ArrayCollection();
	}
	th3.text = searchresultArray.length.toString();
	displaySearchResults();
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
			citedArray.addItem({AU:ev.result.links.cited.link.AU,
				id:ev.result.links.cited.link.id,
				SC:ev.result.links.cited.link.SC,TI:ev.result.links.cited.link.TI,
				heatcount:ev.result.links.cited.link.heatcount,
				hasabstract:ev.result.links.cited.link.hasabstract});
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
			citingArray.addItem({AU:ev.result.links.citing.link.AU,
				id:ev.result.links.citing.link.id,
				SC:ev.result.links.citing.link.SC,
				TI:ev.result.links.citing.link.TI,
				heatcount:ev.result.links.citing.link.heatcount,
				hasabstract:ev.result.links.citing.link.hasabstract});
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

public function afterGetSingleItem(ev:ResultEvent):void {
	try{
		var bookTitle:String = ev.result[0].res.re.TI;
		var bookAuthor:String = ev.result[0].res.re.AU;
	
		
		var s:String = bookTitle;
		if (s.length > 100){
			s = s.substr(0,50) + "...";
		}
		infoBoxText.text = s;
		var p:String = ev.result[0].res.re.AU;
		if (p.length > 25){
			p = p.substr(0,23) + "...";
		}
		infoAuthor.text = p;
		iddo = ev.result[0].res.re.id;
	
	
		seedAuthor = ev.result[0].res.re.AU;
		seedTitle = ev.result[0].res.re.TI;
		
	}
	catch(e:Error) {
		
	}
}