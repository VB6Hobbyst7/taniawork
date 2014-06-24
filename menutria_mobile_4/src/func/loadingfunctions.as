import flash.events.Event;
import mx.events.EffectEvent;
import spark.effects.Fade;
[Bindable]
public var busy:Boolean = true;
public function showloading():void {
	busy = true;
}
public function hideloading():void {	
	busy = false;
}
public function afterFade(ev:EffectEvent):void {
}