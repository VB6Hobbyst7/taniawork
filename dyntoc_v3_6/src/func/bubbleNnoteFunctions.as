// Bubble Related Functions
import assets.graphics.Graphic30;
import assets.graphics.Graphic31;
import assets.graphics.Graphic32;
import mx.collections.ArrayCollection;
import mx.graphics.SolidColorStroke;
import spark.components.Label;
import spark.primitives.Line;
import vo.MyVO;
import vo.bubble;
public var noteIndex:uint = 0;
[Bindable]
public var bubbleContents:ArrayCollection =  new ArrayCollection();
public var colorArray:Array = new Array("#f88636", "#00b0ea",
	"#34ae56","#eb277e","#e2c62a","#8e15b5",
	"#000000","#FFFFFF","#FFFFFF","#FFFFFF",
	"#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF",
	"#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF",
	"#000000","#8e15b5","#e2c62a","#eb277e",
	"#34ae56", "#00b0ea","#f88636");
public function tover(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
	ev.currentTarget.setStyle("color","#FFFFFF");
}
public function tout(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
	ev.currentTarget.setStyle("color","#FFFFFF");
}
public function tclick(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
	ev.currentTarget.setStyle("color","#000000");
	//remove all stuff in bubble
	bubbleSearch.textInput.text = "";
	bubSelection.removeAllElements();
	for (var i:uint = 0; i < bubbleContents.length; i++){
		bubbleContents[i].children = null;
	}
	bubbleTree.openItems = bubbleContents;
}
public function displayBubbleLines(l:String,o:Array,
								   colr:String,cmax:Number,cmin:Number):void {
	for (var i:uint = 0; i < o.length; i++){
		var sdk:ArrayCollection = new ArrayCollection();
		var bArray:Array = new Array();
		if (o[i].length > 0){
			if (bubbleContents[i].children == null){
				bubbleContents[i].children = new ArrayCollection();
			}
			bArray.push(new bubble(l,null,colr,
				1,bubbleContents[i].type,o[i],true,
				cmax,cmin,false,i,-1));
			
			sdk = bubbleContents[i].children;
			for (var k:uint = 0; k < sdk.length; k++){
				bArray.push(sdk.getItemAt(k));
			}
			bubbleContents[i].children = new ArrayCollection(bArray);
		}
	}
	bubbleTree.openItems = bubbleContents;
}
public function button_clickHandler():void
{
	currentState='Notes';
}
public function button_clickHandler_1():void
{
	currentState='Bubble';
}
public function noteGo(u:Number):void {
	noteIndex = noteIndex + u;
	if (noteIndex < 0){
		noteIndex = 0;
	}
	else if (noteIndex > notes.numElements-1){
		noteIndex = notes.numElements-1;
	}
	
	if (noteIndex == 0){
		notesLeftButton.enabled = false;
	}
	else {
		notesLeftButton.enabled = true;
	}
	
	if (noteIndex == notes.numElements){
		notesRightButton.enabled = false;
	}
	else {
		notesRightButton.enabled = true;
	}
	var m:Move = new Move();
	m.target = notes;
	m.xTo = 0-((noteIndex-1)*100);
	m.duration = 500;
	m.play();
}