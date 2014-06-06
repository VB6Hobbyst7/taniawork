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



public function showScreen(u:uint):void {
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	if (u == 1){
		th3.text = fullCount.toString();
		showLabels = true;
		showLabels2 = false;
		recHolder.visible = true;
		recHolder2.visible = false;
		resultHolder.visible = false;
		//citationViewHolder.visible = false;
		citation1Holder.visible = false;
		citation2Holder.visible = false;
		arrangeType.text = "Publication Date";
	}
	else if (u == 2){
		th3.text = dateCount.toString();
		showLabels = false;
		showLabels2 = true;
		recHolder.visible = false;
		recHolder2.visible = true;
		resultHolder.visible = false;
	//	citationViewHolder.visible = false;
		citation1Holder.visible = false;
		citation2Holder.visible = false;
		arrangeType.text = "Alphabetical";
	}
	else if (u == 3){
		th3.text = alphaCount.toString();
		showLabels = false;
		showLabels2 = false;
		recHolder.visible = false;
		recHolder2.visible = false;
		resultHolder.visible = true;
		//citationViewHolder.visible = false;
		citation1Holder.visible = false;
		citation2Holder.visible = false;
		arrangeType.text = "Alphabetical";	
	}
	else if (u == 4){
		citation1Holder.removeAllChildren();
		citation2Holder.removeAllElements();
		th3.text = "";
		showLabels = false;
		showLabels2 = false;
		recHolder.visible = false;
		recHolder2.visible = false;
		resultHolder.visible = false;
		citation1Holder.visible = true;
		citation2Holder.visible = false;
		//citationViewHolder.visible = true;
		arrangeType.text = "Citation Relation";
	}
	else if (u == 5){
		citation1Holder.removeAllChildren();
		citation2Holder.removeAllElements();
		th3.text = "";
		showLabels = false;
		showLabels2 = false;
		recHolder.visible = false;
		recHolder2.visible = false;
		resultHolder.visible = false;
		citation1Holder.visible = false;
		citation2Holder.visible = true;
		//citationViewHolder.visible = true;
		arrangeType.text = "Citation Relation";
	}
}

//First display function called in the crumb process
//Uses recHolder
public function displayHomeSquares(ev:ResultEvent):void {
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	showLabels = true;
	benloaded = true;
	if (ev.result.items != null){
		var maxCount:Number = -1;
		var minCount:Number = 9999999; 
		var tempArray:Object = ev.result.items;
		if (tempArray.date1.cat1 > maxCount){
			maxCount = tempArray.date1.cat1;
		}
		if (tempArray.date1.cat1 < minCount){
			minCount = tempArray.date1.cat1;
		}
		if (tempArray.date1.cat2 > maxCount){
			maxCount = tempArray.date1.cat2;
		}
		if (tempArray.date1.cat2 < minCount){
			minCount = tempArray.date1.cat2;
		}
		if (tempArray.date1.cat3 > maxCount){
			maxCount = tempArray.date1.cat3;
		}
		if (tempArray.date1.cat3 < minCount){
			minCount = tempArray.date1.cat3;
		}
		
		if (tempArray.date2.cat1 > maxCount){
			maxCount = tempArray.date2.cat1;
		}
		if (tempArray.date2.cat1 < minCount){
			minCount = tempArray.date2.cat1;
		}
		if (tempArray.date2.cat2 > maxCount){
			maxCount = tempArray.date2.cat2;
		}
		if (tempArray.date2.cat2 < minCount){
			minCount = tempArray.date2.cat2;
		}
		if (tempArray.date2.cat3 > maxCount){
			maxCount = tempArray.date2.cat3;
		}
		if (tempArray.date2.cat3 < minCount){
			minCount = tempArray.date2.cat3;
		}
		
		if (tempArray.date3.cat1 > maxCount){
			maxCount = tempArray.date3.cat1;
		}
		if (tempArray.date3.cat1 < minCount){
			minCount = tempArray.date3.cat1;
		}
		if (tempArray.date3.cat2 > maxCount){
			maxCount = tempArray.date3.cat2;
		}
		if (tempArray.date3.cat2 < minCount){
			minCount = tempArray.date3.cat2;
		}
		if (tempArray.date3.cat3 > maxCount){
			maxCount = tempArray.date3.cat3;
		}
		if (tempArray.date3.cat3 < minCount){
			minCount = tempArray.date3.cat3;
		}
		
		if (tempArray.date4.cat1 > maxCount){
			maxCount = tempArray.date4.cat1;
		}
		if (tempArray.date4.cat1 < minCount){
			minCount = tempArray.date4.cat1;
		}
		if (tempArray.date4.cat2 > maxCount){
			maxCount = tempArray.date4.cat2;
		}
		if (tempArray.date4.cat2 < minCount){
			minCount = tempArray.date4.cat2;
		}
		if (tempArray.date4.cat3 > maxCount){
			maxCount = tempArray.date4.cat3;
		}
		if (tempArray.date4.cat3 < minCount){
			minCount = tempArray.date4.cat3;
		}
		
		
		
		fullCount = tempArray.totalcount.toString();
		th3.text = tempArray.totalcount.toString();
		th3.visible = true;
		var hs1:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date1.cat1,0,date1,1,"a","z",0,maxCount,minCount);
		hs1.x = 3;
		hs1.y = 5;
		var hs2:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date1.cat2,0,date1,2,"a","z",0,maxCount,minCount);
		hs2.x = 3;
		hs2.y = 10+(recHolder.height/3);
		var hs3:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date1.cat3,0,date1,3,"a","z",0,maxCount,minCount);
		hs3.x = 3;
		hs3.y = 15+(2*(recHolder.height/3));
		//*****************
		var hs4:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date2.cat1,date1,date2,1,"a","z",0,maxCount,minCount);
		hs4.y = 5;
		hs4.x = 7+(recHolder.width/4);
		var hs5:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date2.cat2,date1,date2,2,"a","z",0,maxCount,minCount);
		hs5.y = 10+(recHolder.height/3);
		hs5.x = 7+(recHolder.width/4);
		var hs6:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date2.cat3,date1,date2,3,"a","z",0,maxCount,minCount);
		hs6.y = 15+(2*(recHolder.height/3));
		hs6.x = 7+(recHolder.width/4);
		//*****************
		var hs7:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date3.cat1,date2,date3,1,"a","z",0,maxCount,minCount);
		hs7.y = 5;
		hs7.x = 11+(2*(recHolder.width/4));
		var hs8:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date3.cat2,date2,date3,2,"a","z",0,maxCount,minCount);
		hs8.y = 10+(recHolder.height/3);
		hs8.x = 11+(2*(recHolder.width/4));
		var hs9:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date3.cat3,date2,date3,3,"a","z",0,maxCount,minCount);
		hs9.y = 15+(2*(recHolder.height/3));
		hs9.x = 11+(2*(recHolder.width/4));
		//*****************
		var hs10:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date4.cat1,date3,date4,1,"a","z",0,maxCount,minCount);
		hs10.y = 5;
		hs10.x = 15+(3*(recHolder.width/4));
		var hs11:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date4.cat2,date3,date4,2,"a","z",0,maxCount,minCount);
		hs11.y = 10+(recHolder.height/3);
		hs11.x = 15+(3*(recHolder.width/4));
		var hs12:holderSquare = new holderSquare(recHolder.width/4-spaceVal,
			recHolder.height/3-spaceVal,
			tempArray.date4.cat3,date3,date4,3,"a","z",0,maxCount,minCount);
		hs12.y = 15+(2*(recHolder.height/3));
		hs12.x = 15+(3*(recHolder.width/4));
		
		hs1.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs2.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs3.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs4.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs5.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs6.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs7.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs8.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs9.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs10.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs11.addEventListener(MouseEvent.CLICK, homesquareClick);
		hs12.addEventListener(MouseEvent.CLICK, homesquareClick);
		recHolder.addElement(hs1);
		recHolder.addElement(hs2);
		recHolder.addElement(hs3);
		recHolder.addElement(hs4);
		recHolder.addElement(hs5);
		recHolder.addElement(hs6);
		recHolder.addElement(hs7);
		recHolder.addElement(hs8);
		recHolder.addElement(hs9);
		recHolder.addElement(hs10);
		recHolder.addElement(hs11);
		recHolder.addElement(hs12);
	}
}
//Second display function called in the crumb process
//Uses recHolder2
public function displayAlphaSquares(ev:ResultEvent):void {
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	var stop:String = "";  
	if (ev.result[0].items != null){
		var tempArray:Object = ev.result[0].items;
		th3.text = dateCount.toString();
		th3.visible = true;
		var hs1:holderSquare = new holderSquare(recHolder.width/3-spaceVal,
			recHolder.height-spaceVal,
			tempArray.alpha1,startDateP,endDateP,catoSave,"A","J",1);
		hs1.x = 3;
		hs1.y = 5;
		
		var hs2:holderSquare = new holderSquare(recHolder.width/3-spaceVal,
			recHolder.height-spaceVal,
			tempArray.alpha2,startDateP,endDateP,catoSave,"K","Q",1);
		hs2.x = 11+(1*(recHolder.width/3));
		hs2.y = 5;
		
		var hs3:holderSquare = new holderSquare(recHolder.width/3-spaceVal,
			recHolder.height-spaceVal,
			tempArray.alpha3,startDateP,endDateP,catoSave,"R","Z",1);
		hs3.x = 15+(2*(recHolder.width/3));
		hs2.y = 5
		//*****************
		hs1.addEventListener(MouseEvent.CLICK, alphaSquareClick);
		hs2.addEventListener(MouseEvent.CLICK, alphaSquareClick);
		hs3.addEventListener(MouseEvent.CLICK, alphaSquareClick);
		recHolder2.addElement(hs1);
		recHolder2.addElement(hs2);
		recHolder2.addElement(hs3);
	}
}
public function displayCitationData(level1:uint,level2:uint):void {
	var i:uint = 0;
	loadTimer.stop();
	status.visible = false;
	cancler.visible = false;
	citation1Holder.removeAllElements();
	var colData1:ArrayCollection = new ArrayCollection();
	var colData2:ArrayCollection = new ArrayCollection();
	var vb1:itemResultColumn = new itemResultColumn();
	var vb2:itemResultColumn = new itemResultColumn();
	vb1.colLabelText = "Cited Links";
	vb2.colLabelText = "Citing Links";
	var vbheight:uint = citation1Holder.height;
	vb1.height = vbheight;
	vb2.height = vbheight;

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
						citeType:1});		
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
						bookID:citingArray[i].id,
						citeType:2});	
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
					citeType:1});		
			}	
			vb1.colDataT = colData1;
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
				colData2.addItem({bookID:citingArray[i].id,
					citeType:2});	
			}	
			vb2.colDataT = colData2;
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
	}
	
	
	
	if (citationWaterMode == 1){
		//both mode
		var vbwidth:uint = citation1Holder.width/2-15;
		vb1.width = vbwidth;
		vb2.width = vbwidth;
		citation1Holder.addElement(vb1);
		citation1Holder.addElement(vb2);
		vb1.left = 0;
		vb1.top = 0;
		vb2.right = 0;
		vb2.top = 0;
		th3.text = (colData1.length + colData2.length).toString();
	}
	else if (citationWaterMode == 2){
		//cited mode
		var vb1width:uint = citation1Holder.width-15;
		vb1.width = vb1width;
		citation1Holder.addElement(vb1);
		vb1.left = 0;
		vb1.top = 0;
		th3.text = (colData1.length).toString();
		
	}
	else if (citationWaterMode == 3){
		//citing mode
		var vb2width:uint = citation1Holder.width-15;
		vb2.width = vb2width;
		citation1Holder.addElement(vb2);
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