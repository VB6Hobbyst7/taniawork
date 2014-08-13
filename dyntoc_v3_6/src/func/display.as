import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.engine.TextLine;
import flash.utils.Timer;

import flashx.textLayout.compose.IFlowComposer;
import flashx.textLayout.compose.TextFlowLine;
import flashx.textLayout.conversion.ITextImporter;
import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.FlowElement;
import flashx.textLayout.elements.SpanElement;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.collections.ArrayCollection;

import spark.components.BorderContainer;
import spark.components.Label;
import spark.utils.TextFlowUtil;
public var textFlow:TextFlow;
[Bindable]
public var curatorTagArray:ArrayCollection = new ArrayCollection();
[Bindable]
public var curatorAcceptArray:ArrayCollection = new ArrayCollection();

// DISPLAY FUNCTIONS that cover all display functionality 
public function showView():void {
	if (graphHolder.visible){
		bookHolder.visible = true;
		graphHolder.visible = false;
		prefButton.label = "graph mode";
	}
	else if (bookHolder.visible){
		bookHolder.visible = false;
		graphHolder.visible = true;
		prefButton.label = "reader mode";
	}
}
/*This displays the chaper given by variable u. u is the 
index of the textFlowArray[u-1] where that chapters text 
can be analyzed */
public function displayChapter(u:uint):void {
	var i:uint = 0;
	if ((textFlowArray.length > 0)&&(textFlowArray.length >= u)){
		currentChapterView = u;
		bookText.x = 30;
		bookText.removeAllElements();
		tc = new SpriteVisualElement();
		bookText.addElement(tc);
		textFlow = new TextFlow();
		var importer:ITextImporter = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT);
		importer.throwOnError = false;
		var tlf:TextLayoutFormat = new TextLayoutFormat();
		tlf.fontFamily = "Times New Roman";
		tlf.lineHeight = 20.2;
		tlf.columnGap = 50;
		tlf.paddingTop = 50;
		tlf.columnWidth = 380;
		hslider1.value = 0;
		var columnLineCount:Number = 28;
		var pageCount:Number = 25;
		if (highlightTexto != ""){
			var paragraph:ParagraphElement = new ParagraphElement(); 
			textFlow.addChild(paragraph); 
			var textNOTAGS:String = TextConverter.export(
				importer.importToFlow(textFlowArray[u-1].ctext),
				TextConverter.PLAIN_TEXT_FORMAT,
				ConversionType.STRING_TYPE).toString();
			var elements:Vector.<FlowElement> = 
				highlight(textNOTAGS, highlightTexto,highlightOccur);
			var n:int = elements.length;     
			for (i = 0; i < n; i++){         
				paragraph.addChild(elements[i]);     
			} 
			
			textFlow.flowComposer.addController(new ContainerController(tc,
				20000, bookText.height-50));
			textFlow.format = tlf;
			textFlow.flowComposer.updateAllControllers();
			try{
			var start:Number = paragraph.mxmlChildren[1].parentRelativeStart;
			for (i = 1; i < pageCount; i++){
				var tfline:TextFlowLine = textFlow.flowComposer.getLineAt(columnLineCount*i);
				if (tfline != null){
					var charVal:uint = tfline.absoluteStart;
					if (charVal >= start){
						hslider1.value = (i-1);
						var m:Move = new Move();
						m.target = bookText;
						m.xTo = 30- (i-1)*435;
						m.duration = 500;
						m.play();
						i = pageCount;
					}
				}
				else {
					hslider1.value = (i-1);
					var m2:Move = new Move();
					m2.target = bookText;
					m2.xTo = 30- (i-1)*435;
					m2.duration = 500;
					m2.play();
					i = pageCount;
				}
			}
			}
			catch(Exception:Error){
				var stop:String = "";
			}
			highlightOccur = 1;
			highlightTexto = "";
		}
		else {
			textFlow = importer.importToFlow(textFlowArray[u-1].ctext);
			//5555555555555555555555555555555555555555555555555555555555555555
			// NEED TO FIX 20000 SO THAT CHAPTER LENGTH IS PROPER
			textFlow.flowComposer.addController(new ContainerController(tc,
				20000, bookText.height-50));
			textFlow.format = tlf;
			textFlow.flowComposer.updateAllControllers();
		}
		if (!textFlow)
		{
			var errors:Vector.<String> = importer.errors;
		}
	}
}
public function displayCuratorTags():void {
	var sx:uint = 0;
	var sy:uint = 0;
	if (curatorTagBox.numChildren != 0){
		curatorTagArray = new ArrayCollection();
	}
	for (var i:uint = 0; i < tagCollection.length; i++){
		curatorTagArray.addItem({name:tagCollection[i].ttype,
			num:tagCollection[i].tarray.length.toString(),
			index:i,type:2,show:false});
	}
	
	if (this.currentState == 'curatorLibrary'){
		graphHolder.visible = false;
		bookHolder.visible = true;
		prefButton.label = "graph mode";
		this.currentState = 'curatorBookView';
	}
	else {
		graphHolder.visible = false;
		bookHolder.visible = true;
		prefButton.label = "graph mode";
		this.currentState = 'userBookView';
	}
	s1 = superBookName;
	getCuratorTags.send();
}
public function refreshNotes():void {
	var sx:uint = 0;
	var sy:uint = 0;
	dynTool.notes.removeAllElements();
	dynTool.noteIndex = 0;
	dynTool.notesLeftButton.enabled = false;
	dynTool.noteText.text = "";
	dynTool.notes.x = 0;
	if (currentChapterView != -1){
		if (chapterContents[currentChapterView-1].children != null){
			var tempCon:ArrayCollection = chapterContents[currentChapterView-1].children;
			for (var i:uint = 0; i < tempCon.length; i++){
				dynTool.notes.addElement(noteItem(tempCon[i].name,tempCon[i].sTip,tempCon[i].occurindex));
				dynTool.notes.getElementAt(dynTool.notes.numElements-1).x = sx;
				dynTool.notes.getElementAt(dynTool.notes.numElements-1).y = sy;
				sx = sx + dynTool.notes.getElementAt(dynTool.notes.numElements-1).width;
			}
		}
	}	
}
public function showWarn(s:String):void {
	mainWarnLabel.text = s;
	mainWarn.visible = true;
	warnTimer.stop();
	warnTimer.reset();
	warnTimer.removeEventListener(TimerEvent.TIMER, hideWarn);
	warnTimer.addEventListener(TimerEvent.TIMER, hideWarn);
	warnTimer.start();
}
public function hideWarn(ev:TimerEvent):void {
	mainWarn.visible = false;
}