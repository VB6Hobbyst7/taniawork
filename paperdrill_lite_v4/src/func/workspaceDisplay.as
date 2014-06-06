// This file contains all the main display function shown in Paper Drill
import flash.events.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.*;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.containers.VBox;
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
public var colData1:ArrayCollection = new ArrayCollection();
[Bindable]
public var colData2:ArrayCollection = new ArrayCollection();
public var homeSquareArray:Object = new Object();



public function showScreen(u:uint):void {
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	if (u == 1){
		th3.text = fullCount.toString();
		showLabels = true;
		view1.visible = true;
		view2.visible = false;
		view3.visible = false;
		//citationViewHolder.visible = false;
		view4.visible = false;
		view5.visible = false;
		//citation2Holder.visible = false;
		
		arrangeType.enabled = false;
		drillCheck.enabled = false;
		drillCheck.selected = false;
		df1.enabled = false;
	}
	else if (u == 2){
		th3.text = dateCount.toString();
		showLabels = true;
		view1.visible = false;
		view2.visible = true;
		view3.visible = false;
	//	citationViewHolder.visible = false;
		view4.visible = false;
		view5.visible = false;
		//citation2Holder.visible = false;
		arrangeType.enabled = false;
		drillCheck.enabled = false;
		drillCheck.selected = false;
		df1.enabled = false;
	}
	else if (u == 3){
		th3.text = alphaCount.toString();
		showLabels = true;
		
		view1.visible = false;
		view2.visible = false;
		view3.visible = true;
		//citationViewHolder.visible = false;
		view4.visible = false;
		view5.visible = false;
		//citation2Holder.visible = false;
		arrangeType.enabled = true;	
		df1.enabled = false;
		drillCheck.enabled = true;
		drillCheck.selected = false;
		
	}
	else if (u == 4){
		view4Holder1.removeAllElements();
		//citation2Holder.removeAllElements();
		th3.text = "";
		showLabels = true;
		view1.visible = false;
		view2.visible = false;
		view3.visible = false;
		view4.visible = true;
		view5.visible = false;
		//citation2Holder.visible = false;
		//citationViewHolder.visible = true;
		arrangeType.enabled = true;
		df1.enabled = false;
		drillCheck.enabled = true;
		drillCheck.selected = false;
	}
	else if (u == 5){
		view5Holder1.removeAllElements();
		//citation2Holder.removeAllElements();
		th3.text = "";
		showLabels = true;
		view1.visible = false;
		view2.visible = false;
		view3.visible = false;
		view4.visible = false;
		view5.visible = true;
		//citation2Holder.visible = true;
		//citationViewHolder.visible = true;
		arrangeType.enabled = true;
		df1.enabled = false;
		drillCheck.enabled = true;
		drillCheck.selected = false;
	}
	
}

//First display function called in the crumb process
//Uses recHolder
public function displayHomeSquares():void {
	view1Holder.removeAllElements();
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	showLabels = true;
	benloaded = true;
	var maxCount:Number = -1;
	var minCount:Number = 9999999; 
	var showHeat:Number = 1;
	if (heatCheck.selected == false){
		showHeat = 0;
	}
	
		for (var e:uint = 0; e < 4; e++){
			for (var f:uint = 0; f < 3; f++){
				if (homeSquareArray.date[e].cat[f] > maxCount){
					maxCount = homeSquareArray.date[e].cat[f];
				}
				
				if (homeSquareArray.date[e].cat[f] < minCount){
					minCount = homeSquareArray.date[e].cat[f];
				}
			}
		}
		
			fullCount = homeSquareArray.totalcount.toString();
			th3.text = homeSquareArray.totalcount.toString();
			th3.visible = true;
			var superx:uint = 3;
			var supery:uint = 20;
			var catsdisplayed:Boolean = false;
			for (var i:uint = 0; i < 4; i++){
				supery = 5;
				var la:spark.components.Label = new spark.components.Label();
				if (i == 0){
					la.text = "0 - " + homeSquareArray.dateref[i].toString();
				}
				else if ( i== 3) {
					la.text = homeSquareArray.dateref[i-1].toString()+ " - present";
				}
				else {
					la.text = homeSquareArray.dateref[i-1].toString() + " - " +homeSquareArray.dateref[i].toString();
				}
				la.width = 150;
				la.height = 50;
				la.setStyle("fontFamily","Georgia");
				la.setStyle("fontSize",20);
				la.y = 5;
				la.x = superx + 25;
				view1Holder.addElement(la);
				for (var j:uint = 0; j < 3; j++){
					var hs:holderSquare = new holderSquare(0,0,0,0,0,0);
					if (catsdisplayed == false){
						var la2:spark.components.Label = new spark.components.Label();
						la2.text = homeSquareArray.cat[j].toString().substring(1,homeSquareArray.cat[j].toString().length-1);
						la2.width = 150;
						la2.height = 50;
						la2.setStyle("fontFamily","Georgia");
						la2.setStyle("fontSize",20);
						la2.y = supery + 125;
						la2.x = 5;
						la2.rotation = -90;
						view1Holder.addElement(la2);	
					}
					if (i == 0){
						hs = new holderSquare(view1Holder.width/4-spaceVal,
							view1Holder.height/3-spaceVal,
							homeSquareArray.date[i].cat[j],0,homeSquareArray.dateref[i],j,"a","z",showHeat,1,maxCount,minCount,"heat"+j.toString()+i.toString()+".png");
					}
					else if ( i== 3) {
						hs = new holderSquare(view1Holder.width/4-spaceVal,
							view1Holder.height/3-spaceVal,
							homeSquareArray.date[i].cat[j],homeSquareArray.dateref[i-1],2013,j,"a","z",showHeat,1,maxCount,minCount,"heat"+j.toString()+i.toString()+".png");
					}
					else {
						hs = new holderSquare(view1Holder.width/4-spaceVal,
							view1Holder.height/3-spaceVal,
							homeSquareArray.date[i].cat[j],homeSquareArray.dateref[i-1],homeSquareArray.dateref[i],j,"a","z",showHeat,1,maxCount,minCount,"heat"+j.toString()+i.toString()+".png");
					}
					
					hs.x = superx;
					hs.y = supery+20;
					hs.addEventListener(MouseEvent.CLICK, homesquareClick);
					hs.useHandCursor = true;
					hs.buttonMode = true;
					hs.mouseEnabled = true;
					view1Holder.addElement(hs);
					
					supery =  20 +((j+1)*(view1Holder.height/3))
				}
				catsdisplayed = true;
				superx =  10 + ((i+1)*(view1Holder.width/4))
			}
		
		
	
}
//Second display function called in the crumb process
//Uses recHolder2
public function displayAlphaSquares():void {
	view2Holder.removeAllElements();
	//view2.visible = true;
	showLabels = true;
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	var stop:String = "";  
	th3.text = dateCount.toString();
	th3.visible = true;
	var superx:uint = 15;
	var supery:uint = 30;
	var showHeat:Number = 1;
	if (heatCheck.selected == false){
		showHeat = 0;
	}
	for (var i:uint = 0; i < alphaSquareArray.alpha.length; i++){
		
		var la:spark.components.Label = new spark.components.Label();
		la.text = alphaSquareArray.alpharef[i].alphaitem[0] + " - " +
			alphaSquareArray.alpharef[i].alphaitem[1];
		la.width = 150;
		la.height = 50;
		la.setStyle("fontFamily","Georgia");
		la.setStyle("fontSize",20);
		la.y = 5;
		la.x = superx + 60;
		view2Holder.addElement(la)
			
			
		var cat:String = alphaSquareArray.cat.substring(1,alphaSquareArray.cat.length-1);
		var hs:holderSquare = new holderSquare(view2Holder.width/3-spaceVal,
			view2Holder.height-spaceVal,
			alphaSquareArray.alpha[i],startDateP,endDateP,
			catoSave,alphaSquareArray.alpharef[i].alphaitem[0],
			alphaSquareArray.alpharef[i].alphaitem[1],showHeat,2,-1,-1,"heat"+cat+i.toString()+".png");
		hs.x = superx;
		hs.y = supery;
		hs.addEventListener(MouseEvent.CLICK, alphaSquareClick);
		hs.useHandCursor = true;
		hs.buttonMode = true;
		hs.mouseEnabled = true;
		view2Holder.addElement(hs);
		superx = superx + (view2Holder.width/3);
	}
}
public function displayResults():void {
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	var stop:String = "";
	ToolTipManager.enabled = true;
	ToolTipManager.showDelay = 750;
	ToolTipManager.hideDelay = 2000;
	var ttc:ToolTip = new ToolTip();
	
	ttc.alpha  = 0;
	var icount:uint = 0;
	var maxHeat:uint = 0;
	var i:uint = 0;
	var minHeat:uint = 99999999;
	var dataSortField:SortField = new SortField(); 
	dataSortField.caseInsensitive = true; 
	
	var dataSort:Sort = new Sort(); 
	dataSortField.name = "heatcount"; 
	dataSortField.numeric = true; 
	dataSortField.descending = true;
	dataSort.fields = [dataSortField]; 
	resultArray.sort = dataSort; 
	resultArray.refresh();
	if (resultArray.length > 0){
		maxHeat = resultArray[0].heatcount;
		minHeat = resultArray[resultArray.length-1].heatcount;
	}
	

	 if (arrangeType.selectedIndex == 1){
			dataSortField.name = "AU"; 	
			dataSortField.numeric = false; 
			dataSortField.descending = false;
			dataSort.fields = [dataSortField]; 
			resultArray.sort = dataSort; 
			resultArray.refresh();	
	}
	else if (arrangeType.selectedIndex == 2){
		dataSortField.name = "TI"; 	
		dataSortField.numeric = false; 
		dataSortField.descending = false;
		dataSort.fields = [dataSortField]; 
		resultArray.sort = dataSort; 
		resultArray.refresh();	
	}
	else if (arrangeType.selectedIndex == 3){
		dataSortField.name = "PY"; 	
		dataSortField.numeric = true; 
		dataSortField.descending = true;
		dataSort.fields = [dataSortField]; 
		resultArray.sort = dataSort; 
		resultArray.refresh();	
	}
	
	
	
	
	
	if (v3option1.mouseEnabled == false){
		view3Holder1.removeAllChildren();
		for (i = 0; i < resultArray.length; i++){
			var li:levelItem = new levelItem();
			li.addEventListener(MouseEvent.CLICK , levelToolShow);
			li.addEventListener(MouseEvent.MOUSE_OVER,overLevelItem);
			li.addEventListener(MouseEvent.MOUSE_OUT,outLevelItem);
			li.setStyle("borderVisible",true);
			if (heatCheck.selected){
				li.setStyle("backgroundColor","#b00000");
				li.setStyle("backgroundAlpha", (resultArray[i].heatcount/(maxHeat))*1.2);
			}
			else {
				li.setStyle("backgroundColor","#000000");
				li.setStyle("backgroundAlpha", 0.6);
			}
			
			li.setStyle("borderColor","#000000");
			li.setStyle("borderAlpha",0.6);
			li.setStyle("buttonMode", true);
			li.indexID = resultArray[i].id;
			var squareHeight:uint = 25;
			var squareWidth:uint = 25;
			li.setView(1,squareHeight,squareWidth);
			li.authorName = resultArray[i].AU;
			li.title = resultArray[i].TI;
			li.date = resultArray[i].PY;
			li.heatcount = resultArray[i].heatcount;
			li.useHandCursor = true;
			li.buttonMode = true;
			li.mouseEnabled = true;
			view3Holder1.addChild(li);
			if (i > 5000){
				i = resultArray.length;
			}
			
			if (drillCheck.selected){
				if (i >= (Number(df1.selectedItem.name)-1)){
					i = resultArray.length;
				}
			}
		}
	}
	else if (v3option2.mouseEnabled == false){
		view3Holder2.removeAllElements();
		var vb1:itemResultColumn = new itemResultColumn();
		vb1.colLabelText = "Results";
		vb1.height = view3.height;
		vb1.mode = 0;
		var colData1:ArrayCollection = new ArrayCollection();
		for (i = 0; i < resultArray.length; i++){
			colData1.addItem({bookTitle:resultArray[i].TI,
					bookAuthor:resultArray[i].AU,
					bookID:resultArray[i].id,
					date:resultArray[i].PY,
					citeType:1,heatcount:resultArray[i].heatcount,
					isSelectedForSeed:false,
					hasabstract:resultArray[i].hasabstract});		
			
			if (resultArray[i].hasabstract == 1){
				var stopdd:String = "";
			}
			
			if (i > 5000){
				i = resultArray.length;
			}
			
			if (drillCheck.selected){
				if (i >= (Number(df1.selectedItem.name)-1)){
					i = resultArray.length;
				}
			}
		}	
		vb1.colData = colData1;
		vb1.listo.addEventListener(MouseEvent.CLICK, itemResultRenChange);
		view3Holder2.addElement(vb1);
	}
}
public function displaySearchResults():void {
	loadTimer.stop();
	status.visible = false;
	showLabels = true;
	cancler.visible = false;
	var stop:String = "";
	ToolTipManager.enabled = true;
	ToolTipManager.showDelay = 750;
	ToolTipManager.hideDelay = 2000;
	var ttc:ToolTip = new ToolTip();
	view5Holder1.removeAllChildren();
	view5Holder2.removeAllElements();
	ttc.alpha  = 0;
	var icount:uint = 0;
	var maxHeat:uint = 0;
	var minHeat:uint = 99999999;
	var bd:BorderContainer = new BorderContainer();
	bd.percentHeight = 100;
	bd.percentWidth = 100;
	var la1:spark.components.Label = new spark.components.Label();
	la1.setStyle("fontFamily","Myriad Pro");
	la1.setStyle("fontSize","25");
	la1.verticalCenter = 0;
	la1.horizontalCenter = 0;
	bd.setStyle("backgroundAlpha", 0);
	bd.setStyle("borderAlpha",0);
	
	
	
	
	if (searchresultArray.length < 1){
		la1.text = "No Results Links Found.";
		bd.addElement(la1);
		view5Holder1.addChild(bd);
	}
	else if (searchresultArray.length > 5000){
		la1.text = "To Many Results Found. Please Refine Your Search.";
		bd.addElement(la1);
		view5Holder1.addElement(bd);
	}
	else {
		
		
		
		var dataSortField:SortField = new SortField(); 
		dataSortField.caseInsensitive = true; 
		
		var dataSort:Sort = new Sort(); 
		dataSortField.name = "heatcount"; 
		dataSortField.numeric = true; 
		dataSortField.descending = true;
		dataSort.fields = [dataSortField]; 
		searchresultArray.sort = dataSort; 
		searchresultArray.refresh();
		if (searchresultArray.length > 0){
			maxHeat = searchresultArray[0].heatcount;
			minHeat = searchresultArray[searchresultArray.length-1].heatcount;
		}
		
		
		if (arrangeType.selectedIndex == 1){
			dataSortField.name = "AU"; 	
			dataSortField.numeric = false; 
			dataSortField.descending = false;
			dataSort.fields = [dataSortField]; 
			searchresultArray.sort = dataSort; 
			searchresultArray.refresh();	
		}
		else if (arrangeType.selectedIndex == 2){
			dataSortField.name = "TI"; 	
			dataSortField.numeric = false; 
			dataSortField.descending = false;
			dataSort.fields = [dataSortField]; 
			searchresultArray.sort = dataSort; 
			searchresultArray.refresh();	
		}
		else if (arrangeType.selectedIndex == 3){
			dataSortField.name = "PY"; 	
			dataSortField.numeric = true; 
			dataSortField.descending = true;
			dataSort.fields = [dataSortField]; 
			searchresultArray.sort = dataSort; 
			searchresultArray.refresh();	
		}
		
		
		
		
		if (v5option1.mouseEnabled == false){
			for (var i:uint = 0; i < searchresultArray.length; i++){
				var li:levelItem = new levelItem();
				li.addEventListener(MouseEvent.CLICK , levelToolShow);
				li.addEventListener(MouseEvent.MOUSE_OVER,overLevelItem);
				li.addEventListener(MouseEvent.MOUSE_OUT,outLevelItem);
				li.setStyle("borderVisible",true);
				if (heatCheck.selected){
					li.setStyle("backgroundColor","#FF0000");
					li.setStyle("backgroundAlpha", (searchresultArray[i].heatcount/(maxHeat))*1.2);
				}
				else {
					li.setStyle("backgroundColor","#000000");
					li.setStyle("backgroundAlpha", 0.6);
				}
				
				li.setStyle("borderColor","#000000");
				li.setStyle("borderAlpha",0.6);
				li.setStyle("buttonMode", true);
				li.indexID = searchresultArray[i].id;
				var squareHeight:uint = 25;//(view3Holder1.height-(Math.sqrt(resultArray.length)+2))/
				//(Math.sqrt(resultArray.length));
				var squareWidth:uint = 25;//((view3Holder1.width-(Math.sqrt(resultArray.length)+2))/
				//(Math.sqrt(resultArray.length)))/2;
				li.setView(1,squareHeight,squareWidth);
				li.authorName = searchresultArray[i].AU;
				li.title = searchresultArray[i].TI;
				li.date = searchresultArray[i].PY;
				li.heatcount = searchresultArray[i].heatcount;
				li.useHandCursor = true;
				li.buttonMode = true;
				li.mouseEnabled = true;
				view5Holder1.addChild(li);
				if (drillCheck.selected){
					if (i >= (Number(df1.selectedItem.name)-1)){
						i = searchresultArray.length;
					}
				}
			}
		}
		else if (v5option2.mouseEnabled == false){
			var vb1:itemResultColumn = new itemResultColumn();
			vb1.colLabelText = "Results";
			//vb1.setStyle("width","100%");
			vb1.height = view3.height;
			vb1.mode = 0;
			var colData1:ArrayCollection = new ArrayCollection();
			for (i = 0; i < searchresultArray.length; i++){
				colData1.addItem({bookTitle:searchresultArray[i].TI,
					bookAuthor:searchresultArray[i].AU,
					bookID:searchresultArray[i].id,
					date:searchresultArray[i].PY,
					citeType:1,heatcount:searchresultArray[i].heatcount,
					isSelectedForSeed:false,
					hasabstract:searchresultArray[i].hasabstract});		
				
				if (searchresultArray[i].hasabstract == 1){
					var stopdd:String = "";
				}
				
				if (drillCheck.selected){
					if (i >= (Number(df1.selectedItem.name)-1)){
						i = searchresultArray.length;
					}
				}
			}	
			vb1.colData = colData1;
			vb1.listo.addEventListener(MouseEvent.CLICK, itemResultRenChange);
			view5Holder2.addElement(vb1);
		}
	}
	
}
public function displayCitationData(level1:uint,level2:uint):void {
	var i:uint = 0;
	loadTimer.stop();
	status.visible = false;
	showLabels = true;
	cancler.visible = false;
	view4Holder1.removeAllElements();
	
	colData1 = new ArrayCollection();
	
	colData2 = new ArrayCollection();
	
	var vb1:itemResultColumn = new itemResultColumn();
	var vb2:itemResultColumn = new itemResultColumn();

	vb1.colLabelText = "Cited Links ("+citedArray.length.toString()+ ")";
	vb2.colLabelText = "Citing Links ("+citingArray.length.toString()+ ")";
	var vbheight:uint = view4Holder1.height;
	vb1.height = vbheight;
	vb2.height = vbheight;
	
	
	var dataSortField:SortField = new SortField(); 
	dataSortField.caseInsensitive = true; 
	var dataSort:Sort = new Sort(); 
	if (arrangeType.selectedIndex == 0){
		dataSortField.name = "heatcount"; 	
		dataSortField.numeric = true; 
		dataSortField.descending = true;
		dataSort.fields = [dataSortField]; 
		citedArray.sort = dataSort; 
		citedArray.refresh();	
		citingArray.sort = dataSort; 
		citingArray.refresh();	
	}
	else if (arrangeType.selectedIndex == 1){
		dataSortField.name = "AU"; 	
		dataSortField.numeric = false; 
		dataSortField.descending = false;
		dataSort.fields = [dataSortField]; 
		citedArray.sort = dataSort; 
		citedArray.refresh();
		citingArray.sort = dataSort; 
		citingArray.refresh();	
	}
	else if (arrangeType.selectedIndex == 2){
		dataSortField.name = "TI"; 	
		dataSortField.numeric = false; 
		dataSortField.descending = false;
		dataSort.fields = [dataSortField]; 
		citedArray.sort = dataSort; 
		citedArray.refresh();	
		citingArray.sort = dataSort; 
		citingArray.refresh();	
	}
	else if (arrangeType.selectedIndex == 3){
		dataSortField.name = "PY"; 	
		dataSortField.numeric = true; 
		dataSortField.descending = true;
		dataSort.fields = [dataSortField]; 
		citedArray.sort = dataSort; 
		citedArray.refresh();	
		citingArray.sort = dataSort; 
		citingArray.refresh();	
	}
	

	if ((level1 == 1)&&(level2 == 1)){
		//TEXT BOX MODE
		citationViewVal = 1;
		vb1.mode = 0;
		vb2.mode = 0;
			//cited first
			if (citedArray.length > 0){
				for (i = 0; i < citedArray.length; i++){
					colData1.addItem({bookTitle:citedArray[i].TI,
						bookAuthor:citedArray[i].AU,
						bookID:citedArray[i].id,
						date:citedArray[i].PY,
						citeType:1,heatcount:citedArray[i].heatcount,
						isSelectedForSeed:false,
						hasabstract:citedArray[i].hasabstract});		
					if (drillCheck.selected){
						if (i >= (Number(df1.selectedItem.name)-1)){
							i = citedArray.length;
						}
					}
				}	
				
				
				
				
				vb1.colData = colData1;
			}
			else {
				var la1:spark.components.Label = new spark.components.Label();
				la1.text = "No Cited Links Found";
				la1.setStyle("fontFamily","Myriad Pro");
				la1.setStyle("fontSize","25");
				la1.horizontalCenter = 0;
				la1.top = 200;
				vb1.addElement(la1);
			}
			//citing second
			if (citingArray.length > 0){
				for (i = 0; i < citingArray.length; i++){
					colData2.addItem({bookTitle:citingArray[i].TI,
						bookAuthor:citingArray[i].AU,
						date:citingArray[i].PY,
						bookID:citingArray[i].id,
						citeType:2,heatcount:citingArray[i].heatcount,
						isSelectedForSeed:false,
						hasabstract:citingArray[i].hasabstract});	
					if (drillCheck.selected){
						if (i >= (Number(df1.selectedItem.name)-1)){
							i = citingArray.length;
						}
					}
				}	
				
				
				vb2.colData = colData2;
			}
			else {
				var la2:spark.components.Label = new spark.components.Label();
				la2.text = "No Citing Links Found";
				la2.setStyle("fontFamily","Myriad Pro");
				la2.setStyle("fontSize","25");
				la2.horizontalCenter = 0;
				la2.top = 200;
				vb2.addElement(la2);	
			}
			vb1.listo.addEventListener(MouseEvent.CLICK, itemResultRenChange);
			vb2.listo.addEventListener(MouseEvent.CLICK, itemResultRenChange);
	}
	else {
		citationViewVal = 2;
		//TILE MODE
		//cited first
		vb1.mode = 1;
		vb2.mode = 1;
		if (citedArray.length > 0){
			for (i = 0; i < citedArray.length; i++){
				colData1.addItem({bookID:citedArray[i].id,
					citeType:1,
					isSelectedForSeed:false});	
				if (drillCheck.selected){
					if (i >= (Number(df1.selectedItem.name)-1)){
						i = citedArray.length;
					}
				}
			}	
			vb1.colDataT = colData1;
		}
		else {
			var la3:spark.components.Label = new spark.components.Label();
			la3.text = "No Cited Links Found";
			la3.setStyle("fontFamily","Myriad Pro");
			la3.setStyle("fontSize","25");
			la3.horizontalCenter = 0;
			la3.top = 200;
			vb1.addElement(la3);
		}
		//citing second
		if (citingArray.length > 0){
			for (i = 0; i < citingArray.length; i++){
				colData2.addItem({bookID:citingArray[i].id,
					citeType:2,
					isSelectedForSeed:false});
				if (drillCheck.selected){
					if (i >= (Number(df1.selectedItem.name)-1)){
						i = citingArray.length;
					}
				}
			}	
			vb2.colDataT = colData2;
		}
		else {
			var la4:spark.components.Label = new spark.components.Label();
			la4.text = "No Citing Links Found";
			la4.setStyle("fontFamily","Myriad Pro");
			la4.setStyle("fontSize","25");
			la4.horizontalCenter = 0;
			la4.top = 200;
			vb2.addElement(la4);	
		}
		vb1.listo2.addEventListener(MouseEvent.CLICK, citationTileClick);
		vb2.listo2.addEventListener(MouseEvent.CLICK, citationTileClick);
	}
	
	
	
	if (citationWaterMode == 1){
		//both mode
		var vbwidth:uint = view4Holder1.width/2-15;
		//vb1.width = vbwidth;
		//vb2.width = vbwidth;
		vb1.percentWidth = 50;
		vb2.percentWidth = 50;
		view4Holder1.addElement(vb1);
		view4Holder1.addElement(vb2);
		vb1.left = 0;
		vb1.top = 0;
		vb2.right = 0;
		vb2.top = 0;
		th3.text = (colData1.length + colData2.length).toString();
	}
	else if (citationWaterMode == 2){
		//cited mode
		var vb1width:uint = view4Holder1.width-15;
		vb1.percentWidth = 100;
		view4Holder1.addElement(vb1);
		vb1.left = 0;
		vb1.top = 0;
		th3.text = (colData1.length).toString();
		
	}
	else if (citationWaterMode == 3){
		//citing mode
		var vb2width:uint = view4Holder1.width-15;
		vb1.percentWidth = 100;
		view4Holder1.addElement(vb2);
		vb2.left = 0;
		vb2.top = 0;
		th3.text = (colData2.length).toString();
	}	
	
	
}
public function closetextico():void {
	docOpen = false;
	var s:Scale = new Scale;
	s.duration = 1000;
	s.target = textico;
	s.scaleXBy = -1;
	s.scaleYBy = -1;
	s.play();
	s.addEventListener(EffectEvent.EFFECT_END, afterScale);
}
public function afterScale(ev:EffectEvent):void {
	textico.visible = false;
}