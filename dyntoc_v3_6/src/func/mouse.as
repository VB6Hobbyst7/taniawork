import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.charts.AxisRenderer;
import mx.charts.CategoryAxis;
import mx.charts.DateTimeAxis;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.Series;
import mx.charts.series.LineSeries;
import mx.collections.ArrayCollection;
import mx.events.EffectEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

import spark.components.HSlider;
import spark.events.IndexChangeEvent;

[Bindable]
public var grapherArray:ArrayCollection = new ArrayCollection([
	{chapter: "1", frequency: 2000},
	{chapter: "2", frequency: 1000},
	{chapter: "3", frequency: 1500} ]);
//[Bindable]
//public var hAxis:CategoryAxis = new CategoryAxis();
[Bindable]
public var myXML:XML =
	<dataset>
	<item>
		<who>Tom</who>
		<when>08/22/2006</when>
		<hours>5.5</hours>
	</item>
	<item>
		<who>Tom</who>
		<when>08/23/2006</when>
		<hours>6</hours>
	</item>
	<item>
		<who>Tom</who>
		<when>08/24/2006</when>
		<hours>4.75</hours>
	</item>
	<item>
		<who>Dick</who>
		<when>08/22/2006</when>
		<hours>6</hours>
	</item>
	<item>
		<who>Dick</who>
		<when>08/23/2006</when>
		<hours>8</hours>
	</item>
	<item>
		<who>Dick</who>
		<when>08/24/2006</when>
		<hours>7.25</hours>
	</item>
	<item>
		<who>Jane</who>
		<when>08/22/2006</when>
		<hours>6.5</hours>
	</item>
	<item>
		<who>Jane</who>
		<when>08/23/2006</when>
		<hours>9</hours>
	</item>
	<item>
		<who>Jane</who>
		<when>08/24/2006</when>
		<hours>3.75</hours>
	</item>
	</dataset>;
public function guestLoginClick(ev:MouseEvent):void {
	this.currentState = 'userLibrary';
	userChangerBack.visible = false;
	userChanger.visible = false;
	changeBookButton.x = 1120;
}
public function regLoginClick(ev:MouseEvent):void {
	if ((loginpass.text == "dynadmin")&&(loginname.text == "dynadmin")){
		this.currentState = 'curatorLibrary';
		userChangerBack.visible = true;
		userChanger.visible = true;
	}
	else {
		showWarn("Sorry Please Try Again");
	}
}
/* END LOGIN MOUSE FUNCTIONS */
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
/* START LIBRARY MOUSE FUNCTIONS */
public function bookChange(event:IndexChangeEvent):void
{
	superBookName = "pubmed";
	superBookId = "";
	if (bookLib.selectedItems != null){
		//superBookName = bookLib.selectedItems[0].name;
		superBookId = bookLib.selectedItems[0].id.toString();
	}
	
	//if ((superBookName == "Munro")||(superBookName == "Cecilia2")){
		lastFileUrl = serverLocation + "/fileref/" + superBookName+".xml";
		lastFileUrl = "fileref/" + superBookName+".xml";
		parseFile.send();
	//}
	
	bookLib.selectedIndex = -1;
	
	
}
public function mainLabelClick(ev:MouseEvent):void {
	
}
public function importClick(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
	importDocument();
}
/* END LIBRARY MOUSE FUNCTIONS */
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
/* START BOOKVIEW MOUSE FUNCTIONS */
public function page(u:Number):void {
	if ((hslider1.value == 0)&&(u == -1)){	
	}
	else if ((hslider1.value == hslider1.maximum)&&(u == 1)){	
	}
	else {
		hslider1.value = hslider1.value + u;
		var fEvent:Event = new Event(Event.CHANGE)
		hslider1.dispatchEvent(fEvent);
	}
}
public var tempHSlider:HSlider = new HSlider();
public function sliderChange(ev:Event):void {
	var currentSlider:HSlider=HSlider(ev.currentTarget);
	//currentSlider.value
	tempHSlider = HSlider(ev.currentTarget);
	var fd:Fade = new Fade();
	fd.target = bookText;
	fd.alphaFrom = 1;
	fd.alphaTo = 0;
	fd.duration = 250;
	fd.addEventListener(EffectEvent.EFFECT_END, afterFade);
	fd.play();
	
}
public function afterFade(ev:EffectEvent):void {
	var m:Move = new Move();
	m.addEventListener(EffectEvent.EFFECT_END, afterMove);
	m.target = bookText;
	m.xTo = 30 - tempHSlider.value*436;
	m.duration = 10;
	m.play();
}
public function afterMove(ev:EffectEvent):void {
	var fd:Fade = new Fade();
	fd.target = bookText;
	fd.alphaFrom = 0;
	fd.alphaTo = 1;
	fd.duration = 250;
	fd.play();
}
/* START CHAPTER MOUSE FUNCTIONS */
public function clickChapter(ev:ListEvent):void {
	if (ev.currentTarget.selectedItem != null){
		if (ev.currentTarget.selectedItem.count != -1){
			displayChapter(ev.currentTarget.selectedItem.count+1);
			refreshNotes();
		}
		else if (ev.currentTarget.selectedItem.type == 1) {
			var tempIndex:Number = ev.currentTarget.selectedIndex;
			for (var i:uint = 0; i < chapterContents.length; i++){
				for (var j:uint = 0; j < chapterContents[i].children.length; j++){
					if (chapterContents[i].children[j] == ev.currentTarget.selectedItem){
						
						highlightText(ev.currentTarget.selectedItem.name,
							ev.currentTarget.selectedItem.occurindex);
						
						displayChapter(i+1);
						refreshNotes();
						if (dynTool.notes.numElements != -1){
							var m:Move = new Move();
							m.target = dynTool.notes;
							m.xTo = 0-((j-1)*100);
							if ((0-((j-1)*100)) < 50){
								dynTool.notesLeftButton.enabled = true;
							}
							else {
								dynTool.notesLeftButton.enabled = false;
							}
							if (j >= dynTool.notes.numElements-1){
								dynTool.notesRightButton.enabled = false;
							}
							else {
								dynTool.notesLeftButton.enabled = true;
							}	
							dynTool.noteText.text = ev.currentTarget.selectedItem.sTip;
							m.duration = 500;
							m.play();
							dynTool.noteIndex = j;
						}
					}
				}
			}
			
		}
	}
	
}
public function rollChapter(ev:ListEvent):void {
	var data:Object = ev.itemRenderer.data; 
	// If the item has a tooltip attribute, display it 
	if(data.hasOwnProperty("sTip")){
		ev.target.toolTip = data.sTip;
	}
}
/* END CHAPTER MOUSE FUNCTIONS */
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
/* START TAG MOUSE FUNCTIONS */
public function checkUserTags():void {
	bubbleSearchOptions.removeAll();
	var hLabelArray:ArrayCollection = new ArrayCollection();
	var i:uint = 0;
	var j:uint = 0;
	var k:uint = 0;
	var u:uint = 0;
	var sdk:ArrayCollection = new ArrayCollection();
	var jArray:ArrayCollection = new ArrayCollection();
	var cArray:Array = new Array();
	for (i = 0; i < chapterContents.length; i++){
		hLabelArray.addItem({chapter:chapterContents[i].name});
	}
	//linechart.series = [];
	for (i = 0; i < chapterContents.length; i++){
		chapterContents[i].children = new ArrayCollection();
	}
	var xmlString:String = "<dataset>";
	for (u = 0; u < userTagArray.length; u++){
		if (userTagArray[u].show){
		//	var freqArray:ArrayCollection = new ArrayCollection();
			for (i = 0; i < chapterContents.length; i++){
				if (chapterContents[i].children == null){
					chapterContents[i].children = new ArrayCollection();
				}
				jArray = tagCollection[userTagArray[u].xmlid].tarray;
				
				//freqArray.addItem({chapter:chapterContents[i].name,frequency:jArray.length});
				cArray = new Array();
				for (j = 0; j < jArray.length; j++){
					if (jArray[j].cindex == i){
						cArray.push(new chapter(
							jArray[j].ttext,
							null,
							jArray[j].chunkText,
							1,
							-1,
							jArray[j].occurindex));
						var bfound:Boolean = false;
						var bfoundindex:Number = -1;
						for (var p:uint = 0; p < bubbleSearchOptions.length; p++){
							if (bubbleSearchOptions[p].label == jArray[j].ttext){
								bfound = true;
								bfoundindex = p;
							}
						}
						if (bfound == false){
							var bc:Array = new Array();
							for (var y:uint = 0; y < chapterContents.length; y++){
								bc.push(new Array);
							}
							bc[i].push(jArray[j].mark);
							bubbleSearchOptions.addItem({label:jArray[j].ttext,occurArray:bc,maxcnum:jArray[j].tot});
							
						}
						else if (bfound){
							if (bfoundindex != -1){
								bubbleSearchOptions[bfoundindex].occurArray[i].push(jArray[j].mark);
							}
						}	
					}
				}
				sdk = chapterContents[i].children;
				for (k = 0; k < sdk.length; k++){
					cArray.push(sdk.getItemAt(k));
				}
				xmlString = xmlString + "<item><who>"+userTagArray[u].xmlname+
					"</who><chapter>"+chapterContents[i].name+
					"</chapter><frequency>"+cArray.length.toString()+"</frequency></item>";
				chapterContents[i].children = new ArrayCollection(cArray);
			}	
		}	
	}
	xmlString = xmlString + "</dataset>";
	loadGraphs(xmlString,hLabelArray);
	chapterTree.openItems = chapterContents;
	dynTool.bubbleTree.openItems = dynTool.bubbleContents;
	dynTool.bubbleSearch.dataProvider = bubbleSearchOptions;
	refreshNotes();
}
public function loadGraphs(s:String,chapterArray:ArrayCollection):void {
		var wholist:Array = new Array();
		myXML = new XML(s);
		linechart.series = new Array();
		
		for each(var property:XML in myXML.item.who) {
			// Create an Array of unique names.
			if (wholist[property] != property)
				wholist[property] = property;
		}
		
		// Iterate over names and create a new series 
		// for each one.
		for (var s:String in wholist) {
			// Use all items whose name matches s.
			var localXML:XMLList = myXML.item.(who==s);
			
			// Create the new series and set its properties.
			var localSeries:LineSeries = new LineSeries();
			localSeries.dataProvider = localXML;
			localSeries.yField = "frequency";
			localSeries.xField = "chapter";
			
			
			// Set values that show up in dataTips and Legend.
			localSeries.displayName = s;
			
			// Back up the current series on the chart.
			var currentSeries:Array = linechart.series;
			// Add the new series to the current Array of series.
			currentSeries.push(localSeries);
			// Add the new Array of series to the chart.
			linechart.series = currentSeries;
		}	
		//linechart.horizontalAxis = null;
		//[Bindable]
		//hAxis = new CategoryAxis();
		//hAxis.categoryField = "chapter";
		//hAxis.title = "Chapter";
		//var chapterArray2:ArrayCollection = new ArrayCollection();
		//if (chapterArray.length > 10){
			grapherArray.removeAll();
			for (var i:uint = 0; i < chapterArray.length; i++){
				grapherArray.addItem(chapterArray.getItemAt(i));
			}
		//}
		//grapherArray = chapterArray;
		//hAxisRen.
	//	hAxis.dataProvider = grapherArray;
		
		//var ar:AxisRenderer = new AxisRenderer();
		//ar.labelRenderer = 90;
		//ar.labelRendere
		//ar.axis = hAxis;
		//linechart.seriesFilters = [];
		//linechart.horizontalAxis = hAxis;
		//linechart.horizontalAxisRenderers = [ar];
		//linechart.
}
public function labelFunction(categoryValue:Object,
							  previousCategoryValue:Object,
							  axis:CategoryAxis,
							  categoryItem:Object):String {
	var s:String = categoryValue.toString();
	return s;
}
public function parseFunction(label:Object):String {
	return label.toString();
}
/* END TAG MOUSE FUNCTIONS */
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
/* START NOTE MOUSE FUNCTIONS */
public function noteItemClick(ev:MouseEvent):void {
	var text:String = ev.currentTarget.name;
	
	var name:String = text.substring(0,text.indexOf("&^%"));
	text = text.substring(text.indexOf("&^%")+3,text.length);
	var occurCount:String = text.substring(0,text.indexOf("&^%"))
	try{
		var chunk:String = text.substring(text.indexOf("&^%")+3,text.length);
	 	dynTool.noteText.text = chunk;
	}
	catch(Exception:Error){
		
	}
	highlightText(name,Number(occurCount));
	
	displayChapter(currentChapterView);
}
/* END NOTE MOUSE FUNCTIONS */
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
/* START BUBBLE MOUSE FUNCTIONS */
public function bubbleEnterKey(ev:KeyboardEvent):void {
	if (ev.keyCode == 13){
		var kd:MouseEvent;
		addBubble(kd);
	}
}
public function addBubble(ev:MouseEvent):void {
	if (dynTool.bubbleSearch.textInput.text != ""){
		var s:String = dynTool.bubbleSearch.textInput.text.toLowerCase();
		var la:Label = new Label();
		la.text = s;
		la.y = 5;
		try{
			la.setStyle("color",
				dynTool.colorArray[dynTool.bubSelection.numElements]);
			la.setStyle("fontFamily","Myriad Pro");
			la.setStyle("fontWeight","normal");
			la.setStyle("fontSize",12);
			dynTool.bubSelection.addElement(la);
			var oArray:Array = new Array();
			for (var i:uint = 0; i < textFlowArray.length; i++){
				var chapText:String = textFlowArray[i].ctext.toLowerCase();
				var occurArray:Array = new Array()
				if (chapText.indexOf(s) != -1){
					var tempTexto:String = chapText;
					var n:uint = 0;
					do {
						if (tempTexto.indexOf("<") < 1){
							n = n + tempTexto.indexOf(">")+1;
							tempTexto = tempTexto.substring(tempTexto.indexOf(">")+1,tempTexto.length);
						}
						
						if (tempTexto.indexOf("<") != -1){
							if (tempTexto.substring(0,tempTexto.indexOf("<")).indexOf(s) != -1){
								n = n + tempTexto.indexOf(s);
								occurArray.push(n);
								tempTexto = tempTexto.substring(tempTexto.indexOf(s)+s.length,tempTexto.length);
								n = n + s.length;	
							}
							else {
								tempTexto = tempTexto.substring(tempTexto.indexOf("<"),tempTexto.length);
							}
						}
						else if (tempTexto.length > 1){
							if (tempTexto.indexOf(s) != -1){
								n = n + tempTexto.indexOf(s);
								occurArray.push(n);
								tempTexto = tempTexto.substring(tempTexto.indexOf(s)+s.length,tempTexto.length);
								n = n + s.length;	
							}
						}
						
						
					}while (tempTexto.indexOf(s) != -1);
				}
				oArray.push(occurArray);
			}
			dynTool.displayBubbleLines(s,oArray,
				dynTool.colorArray[dynTool.bubSelection.numElements-1],
				chapterMax,chapterMin);
		}
		catch(Exception:Error){}
	}
}
public function rollBubble(ev:ListEvent):void {
	var data:Object = ev.itemRenderer.data; 
	// If the item has a tooltip attribute, display it 
	if(data.hasOwnProperty("sTip")){
	//	ev.target.toolTip = data.sTip;
		ev.target.toolTip = data.name;
	}
}
public function clickBubble(ev:ListEvent):void {
	try{
	if (dynTool.bubbleTree.selectedItem.selected){
		highlightText(dynTool.bubbleTree.selectedItem.name,
			dynTool.bubbleTree.selectedItem.occurIndex);
		displayChapter(dynTool.bubbleTree.selectedItem.chapterIndex+1);
		dynTool.bubbleTree.selectedItem.selected = false;
		dynTool.bubbleTree.selectedItem.occurIndex = -1;
	}
	}
	catch(Exception:Error){
		
	}
}
/* END BUBBLE MOUSE FUNCTIONS */
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
public function saveCuratorSelection():void {
	if (this.currentState == "curatorBookView"){
		s1 = superBookName;
		preDelete.send();
	}
}
public function afterPreDelete(ev:ResultEvent):void {
	if (this.currentState == "curatorBookView"){
		for (var i:uint = 0; i < curatorAcceptArray.length; i++){
			s1 = superBookName;
			s2 = curatorAcceptArray[i].index;
			s3 = curatorAcceptArray[i].name;
			s4 = curatorAcceptArray[i].newname;
			s5 = "true";
			s6 = curatorAcceptArray[i].num;
			updateCuratorTags.send();
		}
	}
}
public function checkCuratorTags():void {
	curatorAcceptArray = new ArrayCollection();
	for (var i:uint = 0; i < curatorTagArray.length; i++){
		if (curatorTagArray.getItemAt(i).show == true){
			curatorAcceptArray.addItem({name:curatorTagArray.getItemAt(i).name,
				newname:curatorTagArray.getItemAt(i).name,
				num:curatorTagArray.getItemAt(i).num,
				index:curatorTagArray.getItemAt(i).index,
				type:curatorTagArray.getItemAt(i).type,
				show:curatorTagArray.getItemAt(i).show});
		}
	}
}

public function glowOver(ev:MouseEvent):void {
	var g:GlowFilter = new GlowFilter(16711680,1,5,5,1);
	ev.currentTarget.filters = [g];
}
public function glowOut(ev:MouseEvent):void {
	ev.currentTarget.filters = [];
}
public function textOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function textOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}
public function changeBook():void
{
	const state:String = currentState;
	if ( state == 'userBookView' ) {
		currentState='userLibrary';
	}
	if ( state == 'curatorBookView' ) {
		currentState='curatorLibrary';
	}
}
public function changeAuthority():void
{
	const state:String = currentState;
	if ( state == 'userBookView' ) {
		currentState='curatorBookView';
	}
	if ( state == 'userLibrary' ) {
		currentState='curatorLibrary';
	}
	if ( state == 'curatorBookView' ) {
		getCuratorTags.send();
		currentState='userBookView';
	}
	if ( state == 'curatorLibrary' ) {
		currentState='userLibrary';
	}
}
