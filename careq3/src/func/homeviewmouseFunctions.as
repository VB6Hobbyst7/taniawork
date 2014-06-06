import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.DragEvent;

import spark.filters.GlowFilter;
public var profDraging:Boolean = false;

public function tOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function tOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}
public function gOver(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(000000,1,4,4,1,1,true);
	ev.currentTarget.filters = [gl];
}
public function gDown(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(000000,1,4,4,1,1,true);
	ev.currentTarget.filters = [gl];
}
public function gOut(ev:MouseEvent):void {
	ev.currentTarget.filters = [];
	if (profDraging){
		profDraging = false;
		this.removeEventListener(MouseEvent.MOUSE_MOVE, moveProfBtn);
		if (!profWaiting){
			activateProfile();
		}
	}
}
public function profDown(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(000000,1,4,4,1,1,true);
	ev.currentTarget.filters = [gl];
	this.addEventListener(MouseEvent.MOUSE_MOVE, moveProfBtn);
}
public function profUp(ev:MouseEvent):void {
	ev.currentTarget.filters = [];
	this.removeEventListener(MouseEvent.MOUSE_MOVE, moveProfBtn);
	
	
}
public function moveProfBtn(ev:MouseEvent):void {
	//profileBtn.x = this.mouseX;
	profileCont.visible = true;
	profileBtn.y = this.mouseY-40;
	profileCont.y = this.mouseY+24;
	profDraging = true;
		
}
