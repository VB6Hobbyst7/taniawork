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

public var catoSave:uint = 0;
public var dateCount:uint = 0;
public var alphaCount:uint = 0;
public var fullCount:uint = 0;
public var currentResultSelectedIndex:Number = 0;
public var infoTimer:Timer = new Timer(5000);

//First screen mouse call called when the initall homesquares are clicked
public function homesquareClick(ev:MouseEvent):void {
	var index:Number = Number(ev.currentTarget.name);
	if (ev.currentTarget.cato == 1){
		catoP = "science";
	}
	else if (ev.currentTarget.cato == 2){
		catoP = "medic";
	}
	else if (ev.currentTarget.cato == 3){
		catoP = "busines";
	}
	dateCount = ev.currentTarget.count;
	th3.text = ev.currentTarget.count.toString();
	catoSave = ev.currentTarget.cato;
	endDateP = ev.currentTarget.endDate;
	startDateP = ev.currentTarget.startDate;
	//SO IMPORTANT TO UNCOMMENT THIS
	//resultHolder.dataProvider = new ArrayCollection();
	//resultHolder.removeAllElements();
	recHolder2.removeAllElements();
	showScreen(2);
	loadTimer.addEventListener(TimerEvent.TIMER, loadInt);
	loadTimer.start();
	if (startDateP == 0){
		addCrumb("1800-"+endDateP.toString());
	}
	else {
		addCrumb(startDateP.toString()+"-"+endDateP.toString());
	}
	disconnectAllConnections();
	getAlphaSquares.send();
}
public function alphaSquareClick(ev:MouseEvent):void {
	var index:Number = Number(ev.currentTarget.name);
	if (ev.currentTarget.cato == 1){
		catoP = "science";
	}
	else if (ev.currentTarget.cato == 2){
		catoP = "medic";
	}
	else if (ev.currentTarget.cato == 3){
		catoP = "busines";
	}
	alphaCount = ev.currentTarget.count.toString();
	th3.text = ev.currentTarget.count.toString();
	endDateP = ev.currentTarget.endDate;
	startDateP = ev.currentTarget.startDate;
	alphaStartP = ev.currentTarget.alphaStart;
	alphaEndP = ev.currentTarget.alphaEnd;
	//SO IMPORTANT TO UNCOMMENT THIS
	//resultHolder.dataProvider = new ArrayCollection();
	//resultHolder.removeAllElements();
	showScreen(3);
	loadTimer.addEventListener(TimerEvent.TIMER, loadInt);
	loadTimer.start();
	//VCHANGE THIS 77777777777777777777777777777777777777777
	var ci:crumbItem = new crumbItem();
	ci.setStyle("color","#FFFFFF");
	ci.setText(alphaStartP+"-"+alphaEndP);
	ci.addEventListener(MouseEvent.CLICK, backToResultSpan);
	crumbBox.addChild(ci);
	disconnectAllConnections();
	getResults.send();
}
public function pathLengthChange(ev:IndexChangeEvent):void {
	if (citation1Holder.visible == true){
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
}
public function backToResultSpan(ev:MouseEvent):void {
	if (crumbBox.numChildren>2){
		do {
			crumbBox.removeChild(crumbBox.getChildAt(crumbBox.numChildren-1));
		}while(crumbBox.numChildren > 2);
	}
	showScreen(3);
}
public function backToAlphaSpan(ev:MouseEvent):void {
	if (crumbBox.numChildren>1){
		do {
			crumbBox.removeChild(crumbBox.getChildAt(crumbBox.numChildren-1));
		}while(crumbBox.numChildren > 1);
	}
	showScreen(2);
}
public function overLevelItem(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(16711680,1,4,4,5,1,true);
	ev.currentTarget.filters = [gl];
	if (ev.currentTarget.authorName != infoAuthor.text){
		infoBox.visible = false;
	}
}
public function outLevelItem(ev:MouseEvent):void {
	ev.currentTarget.filters = []
}
public function levelToolShow(ev:MouseEvent):void {
	infoTimer.removeEventListener(TimerEvent.TIMER, infoTimerEvent);
	currentResultSelectedIndex = ev.currentTarget.indexID;
	infoAuthor.text = ev.currentTarget.authorName;
	infoBoxText.text = ev.currentTarget.title;
	infoBox.x = this.mouseX-5;
	infoBox.y = this.mouseY-10;
	infoBox.visible = true;
	infoTimer = new Timer(5000);
	infoTimer.addEventListener(TimerEvent.TIMER, infoTimerEvent);
	infoTimer.start();
}

public function infoTimerEvent(ev:TimerEvent):void {
	infoTimer.removeEventListener(TimerEvent.TIMER, infoTimerEvent);
	infoBox.visible = false;
	infoTimer.stop();
}

public function overBoxe2(ev:MouseEvent):void {
	if (openRec){
		var g:GlowFilter = new GlowFilter(16711689,1);
		ev.currentTarget.filters = [g];
	}
}
public function outBoxe2(ev:MouseEvent):void {
	if (openRec){
		ev.currentTarget.scaleX = 1;
		ev.currentTarget.scaleY = 1;
		ev.currentTarget.filters = [];}
}
public function overBoxe(ev:MouseEvent):void {
	ti.removeEventListener("timer", timedone);
	ti = new Timer(3000,0);
	ti.addEventListener("timer", timedone);
	ti.start();
}
public function timedone(ev:TimerEvent):void {
	infoBox.visible = false;
}

public function unglowItem(ev:MouseEvent):void {
	ev.currentTarget.filters = [];
}
public function glowItem(ev:MouseEvent):void {
		var g:spark.filters.GlowFilter = new spark.filters.GlowFilter(111689,0.5);
		ev.currentTarget.filters = [g];
}

public function clickAuthorItem(ev:MouseEvent):void {
	infoBox.visible = true;
	ti.addEventListener("timer", timedone);
	ti.start();
	infoBox.x = this.mouseX-23;
	infoBox.y = this.mouseY-20;
	var dataSortField:SortField = new SortField();
	var nameSort:Sort = new Sort();
	dataSortField.name = "superid";
	dataSortField.numeric = true;
	nameSort.fields = [dataSortField];
	collections.sort = nameSort;
	collections.refresh();
	var s:String = ev.currentTarget.title;
	if (s.length > 100){
		s = s.substr(0,50) + "...";
	}
	infoBoxText.text = s;
	var p:String = ev.currentTarget.author;
	if (p.length > 25){
		p = p.substr(0,23) + "...";
	}
	infoAuthor.text = p;
	iddo = ev.currentTarget.id1;
	if (ev.currentTarget.citeType != -1){
		currentID = ev.currentTarget.id1;
	}
	else {
		currentID = ev.currentTarget.indexid;
	}
	seedAuthor = ev.currentTarget.author;
	seedTitle = ev.currentTarget.title;
	citeType.text = ev.currentTarget.citeType.toString();
	//savedCollectIndex = uint(ev.currentTarget.name);
	if (ev.currentTarget.fileLoc == "NONE"){
		infoBoxButton0.visible = false;}
	else {
		infoBoxButton0.visible = true;
	}
}
public function viewDoc(ev:MouseEvent):void {
	idout = currentResultSelectedIndex;
	disconnectAllConnections();
	getDocText.send();
	docOpen = true;
	textico.visible = true
	var s:Scale = new Scale;
	var m:Move = new Move();
	m.xFrom = this.mouseX;
	m.yFrom = this.mouseY;
	m.xTo = 100;
	m.yTo = 200;
	m.duration = 1000;
	s.duration = 1000;
	m.target = textico;
	s.target = textico;
	s.scaleXBy = 1;
	s.scaleYBy = 1;
	//m.play();
	s.play();
	
	//texticoBody.text = collections[currentID].description;
	//getDescription.send();
}
public function overaaa(ev:EffectEvent):void {
	ev.currentTarget.target.visible = true;
}

public function refreshCitations():void {
	var s:MouseEvent;
	seedAuthor = mainSeedAuthor;
	seedTitle = mainSeedTitle;
	startSeed(s);
}
public function refreshDrill():void {
	
}
public function startSeed3(ev:MouseEvent):void {
//	if (togglebutton4.selected){
		//togglebutton4.selected = false;
		var s:Scale = new Scale;
		var m:Move = new Move();
		m.xTo = 400;
		m.yTo = 400;
		m.duration = 1000;
		s.duration = 1000;
		//m.target = centerCircle;
		//s.target = centerCircle;
		s.scaleXBy = -1;
		s.scaleYBy = -1;
		s.addEventListener(EffectEvent.EFFECT_END, drillCloser);
		//m.play();
		//s.play();
	//}
	collections.filterFunction = null;
	collections.refresh();
//	getCited.cancel();
	//getCiting.cancel();
	citedX = 50;
	citedY = 0;
	citingX = 0;
	citingY = 0;
	seedPath = 1;
	
	/*if (citeType.text == "2"){
	seedAuthor = citedArray[currentID].author;
	seedTitle = citedArray[currentID].title;
	mainSeedAuthor = citedArray[currentID].author;
	mainSeedTitle = citedArray[currentID].title;
	}
	else if (citeType.text == "1"){
	seedAuthor = citingArray[currentID].author;
	seedTitle = citingArray[currentID].title;
	mainSeedAuthor = citingArray[currentID].author;
	mainSeedTitle = citingArray[currentID].title;
	
	}
	else {
	seedAuthor = collections[currentID].author;
	seedTitle = collections[currentID].title;
	mainSeedAuthor = collections[currentID].author;
	mainSeedTitle = collections[currentID].title;
	}
	*/
	mainSeedAuthor = seedAuthor;
	mainSeedTitle = seedTitle;
	seedOut();
	if (lastCrumbAdded != seedAuthor){
		lastCrumbAdded = seedAuthor;
		var cb:crumbItem = new crumbItem();
		cb.author = seedAuthor;
		cb.title = seedTitle;
		cb.type = lastViewedType;
		cb.addEventListener(MouseEvent.CLICK, crumbClick);
		cb.addEventListener(MouseEvent.MOUSE_OVER, crumbOver);
		cb.addEventListener(MouseEvent.MOUSE_OUT, crumbOut);
		if (this.currentState != 'home'){
			cb.crumbLevel = crumbBox.numElements;}
		else {
			cb.crumbLevel = 0;}
		cb.setText(seedAuthor);
		cb.setStyle("fontSize",10);
		cb.setStyle("color","#FFFFFF");
		cb.setStyle("fontFamily","Verdana");
		cb.buttonMode = true;
		cb.height = 15;
		cb.width = 80;
		crumbBox.addElement(cb);}
	
}
public function seedOut():void {
	lastViewedType = citeType.text;
	infoBox.visible = false;
	if (this.currentState == 'home'){
		this.currentState = 'both';
		this.setCurrentState('both');}
	citedArray = new ArrayCollection();
	citingArray = new ArrayCollection();
	//citingCont.removeAllElements();
	cancler.visible = true;
	status.visible = true;
	//getCited.send();
	//getCiting.send();
}
public function crumbClic3k(ev:MouseEvent):void {
	//if (togglebutton4.selected){
	//	togglebutton4.selected = false;
	//	drillChange();
	//}
	while (crumbBox.numElements-1 != ev.currentTarget.crumbLevel){
		crumbBox.removeElementAt(crumbBox.numElements-1);
	}
	collections.filterFunction = null;
	collections.refresh();
	//getCited.cancel();
	//getCiting.cancel();
	citedX = 50;
	citedY = 0;
	citingX = 0;
	citingY = 0;
	seedPath = 1;
	seedAuthor = ev.currentTarget.author;
	seedTitle = ev.currentTarget.title;
	seedOut();
	//citeType.text = "-1";
}
public function crumbOver(ev:MouseEvent):void {
	var g:spark.filters.GlowFilter = new spark.filters.GlowFilter(16711689,1);
	ev.currentTarget.filters = [g];
}
public function crumbOut(ev:MouseEvent):void {
	ev.currentTarget.filters = [];
}


public function drillChange():void {


}
public function drillCloser(ev:EffectEvent):void {
	ev.currentTarget.target.visible = false;
	
}
public function pathLength65Change():void {
	
}
public function drillLengthChange():void {
}

public function textButtonOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}
public function textButtonOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function waterButtonClick(u:uint):void {
	if (citation1Holder.visible == true){
		if (u == 1){
			//clicked on citedButton
			if ((citedButton.alpha == 1)&&(citingButton.alpha == 1)){
				citedButton.alpha = 0.7;
				citationWaterMode = 3;
				displayCitationData(Number(citedLevel.selectedItem.name),Number(citingLevel.selectedItem.name));
			}
			else if ((citedButton.alpha != 1)&&(citingButton.alpha == 1)){
				citedButton.alpha = 1;
				citationWaterMode = 1;
				displayCitationData(Number(citedLevel.selectedItem.name),Number(citingLevel.selectedItem.name))
			}
			else {
				citedButton.alpha = 1;
				citingButton.alpha = 0.7;
				citationWaterMode = 2;
			}
		}
		else {
			//clicked on citingButton
			if ((citingButton.alpha == 1)&&(citedButton.alpha == 1)){
				citingButton.alpha = 0.7;
				citationWaterMode = 2;
				displayCitationData(Number(citedLevel.selectedItem.name),Number(citingLevel.selectedItem.name))
			}
			else if ((citingButton.alpha != 1)&&(citedButton.alpha == 1)){
				citingButton.alpha = 1;
				citationWaterMode = 1;
				displayCitationData(Number(citedLevel.selectedItem.name),Number(citingLevel.selectedItem.name));
			}
			else {
				citingButton.alpha = 1;
				citedButton.alpha = 0.7;
				citationWaterMode = 3;
			}
		}
	}
}
public function citationViewSwitch(u:uint):void {
	if (u == 1){
		//textModeBtn.setStyle("color","#000000");
		//tileModeBtn.setStyle("color","#D96E27");
	}
	else {
		//textModeBtn.setStyle("color","#D96E27");
		//tileModeBtn.setStyle("color","#000000");
	}
	citationViewVal = u;
	displayCitationData(citedLevel.selectedItem,citingLevel.selectedItem);
}
public function stopEverything():void {
	getAlphaSquares.disconnect();
	getResults.disconnect();
	getDocText.disconnect();
	getLinks.disconnect();
	
	crumbBox.removeAllChildren();
	loadCurrentCrumb();
}
