import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import spark.components.Image;
import spark.components.TextArea;

public function bookItem(i:uint,n:String):BorderContainer {
	var bo:BorderContainer = new BorderContainer();
	bo.height = 30;
	bo.width = bookLib.width;
	if (Math.round((i+2)/2)*2 == (i+2)){
		bo.setStyle("backgroundAlpha",0.0);
	}
	else {
		bo.setStyle("backgroundColor","#000000");
		bo.setStyle("backgroundAlpha",0.05);
	}
	bo.name = n;
	bo.id = i.toString();
	bo.addEventListener(MouseEvent.CLICK, mainLabelClick);
	bo.addEventListener(MouseEvent.MOUSE_OVER, glowOver);
	bo.addEventListener(MouseEvent.MOUSE_OUT, glowOut);
	bo.setStyle("borderAlpha",0.0);
	bo.setStyle("cornerRadius",5);
	var la:Label = new Label(); 
	la.text = n;
	la.setStyle("color","#3C3C3C");
	la.setStyle("fontFamily","Myriad Pro");
	la.setStyle("fontWeight","normal");
	la.setStyle("fontSize",12);
	bo.addElement(la);
	la.top = 10;
	la.left = 20;
	return bo;
}
/* This returns note items that are in the
dyntocTool compoent in the main.mxml file */
public function noteItem(name:String,sTip:String,occurCount:Number):Label {
	var la:Label = new Label(); 
	var tempName:String = name;
	if (tempName.indexOf(":") != -1){
		tempName = tempName.substring(tempName.indexOf(":")+1,tempName.length);
	}
	if (tempName.length > 13){
		la.text = tempName.substring(0,10)+"..."
	}
	else {
		la.text = tempName;
	}
	la.name = name+"&^%"+occurCount.toString()+"&^%"+sTip;
	la.setStyle("color","#FFFFFF");
	la.setStyle("fontFamily","Myriad Pro");
	la.setStyle("fontWeight","normal");
	la.setStyle("fontSize",12);
	la.width = 100;
	la.addEventListener(MouseEvent.CLICK, noteItemClick);
	la.addEventListener(MouseEvent.MOUSE_OVER, textOver);
	la.addEventListener(MouseEvent.MOUSE_OUT, textOut);
	return la;
}