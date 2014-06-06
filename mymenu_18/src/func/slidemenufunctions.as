import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.EffectEvent;

import spark.effects.Move;

[Bindable]
public var menumoving:Boolean = false;
[Bindable]
public var menuopen:Boolean = false;
[Bindable]
public var filtersmoving:Boolean = false;
[Bindable]
public var filtersopen:Boolean = false;
[Bindable]
public var automenumove:Boolean = false;

protected function overAllMouseUp(event:MouseEvent):void
{
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	if ((menumoving)&&(automenumove == false)){
		menumoving = false;
		calculateMenuOperation();
	
	}
}
public function menuButtonClick():void {
	if (menumoving == false){
		automenumove = true;
		menumoving = true;
		if (menuopen){
			closeMenu();
		}
		else {
			openMenu();
		}
	}
	
}

public function calculateMenuOperation():void {
	if (menumoving == false){
		menumoving = true;
		var menuendx:Number = menu.x+menu.width;
		if (menuendx >= this.width/3){
			openMenu();
		}
		else {
			closeMenu();
		
		}
	}
	
}
public function closeMenu():void {
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	var menuendx:Number = menu.x+menu.width;
	var mo:Move = new Move();
	var mo2:Move = new Move();
	mo.target = menu;
	mo2.target = mainNavigator;
	mainNavigator.activeView.mouseChildren = false;
	mo2.addEventListener(EffectEvent.EFFECT_END,afterCloseMenu );
	mo.xTo = 0-(this.width/1.15)-1;
	mo.duration = 100;
	mo.play();
	mo2.xTo = 0;
	mo2.duration = 100;
	mo2.play();
	filterfeaturebutton.visible = true;
	filtersopen = false;	
}
public function afterCloseMenu(ev:EffectEvent):void {
	menuopen = false;
	menumoving = false;
	automenumove = false;
	mainNavigator.activeView.mouseChildren = true;

}
public function openMenu():void {
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	var menuendx:Number = menu.x+menu.width;
	var mo:Move = new Move();
	var mo2:Move = new Move();
	mo.target = menu;
	mainNavigator.activeView.mouseChildren = false;
	mo2.target = mainNavigator;
	mo2.addEventListener(EffectEvent.EFFECT_END, afterOpenMenu);
	mo.xTo = 0;
	mo.duration = 100;
	mo.play();
	mo2.xTo = menu.width;
	mo2.duration = 100;
	mo2.play();
	filterfeaturebutton.visible = false;
	filtersopen = false;	
	
	
	
}
public function afterOpenMenu(ev:EffectEvent):void {
	menuopen = true;
	menumoving = false;
	automenumove = false;
}

public function updateMenuLocation(ev:MouseEvent):void {
	if (ev.stageX <= menu.width){
		menuopen = true;
		mainNavigator.activeView.mouseChildren = true;
		menumoving = true;
		automenumove = false;
		menu.x = ev.stageX-menu.width;
		mainNavigator.x = ev.stageX;
	}
}

