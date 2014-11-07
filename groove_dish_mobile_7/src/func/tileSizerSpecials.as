import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import spark.effects.Scale;
public var mousedown:Boolean = false;
public var isscaled:Boolean = false;
public var ti:Timer;
public function tileDown(event:MouseEvent):void
{
	
	mousedown = true;
	ti = new Timer(250,0);
	ti.addEventListener(TimerEvent.TIMER, afterti);
	ti.start();
	
	
}
public function afterti(ev:TimerEvent):void {
	ti.stop();
	ti.removeEventListener(TimerEvent.TIMER, afterti);
	if (mousedown){
		isscaled = true;
		var sc:Scale = new Scale();
		sc.target = v0.getChildByName("megacont");
		sc.autoCenterTransform = true;
		sc.scaleXFrom = 1;
		sc.scaleXTo = 0.96;
		sc.scaleYFrom = 1;
		sc.scaleYTo = 0.92;
		sc.duration = 100;
		sc.play();
	}
}
protected function tileUp(event:MouseEvent):void
{
	mousedown = false;
	if (isscaled){
		isscaled = false;
		var sc:Scale = new Scale();
		sc.target = v0.getChildByName("megacont");
		sc.autoCenterTransform = true;
		sc.scaleXFrom = 0.96;
		sc.scaleXTo = 1;
		sc.scaleYFrom = 0.92;
		sc.scaleYTo = 1;
		sc.duration = 100;
		sc.play();
		
	}	
}

protected function imedDown(event:MouseEvent):void
{
	isscaled = true;
	mousedown = true;
	var sc:Scale = new Scale();
	sc.target = v0.getChildByName("megacont");
	sc.autoCenterTransform = true;
	sc.scaleXFrom = 1;
	sc.scaleXTo = 0.96;
	sc.scaleYFrom = 1;
	sc.scaleYTo = 0.92;
	sc.duration = 0;
	sc.play();
	
}
