import flash.events.Event;
import flash.events.MouseEvent;
import mx.events.EffectEvent;
import spark.effects.Move;
[Bindable]
public var menumoving:Boolean = false;
[Bindable]
public var menuopen:Boolean = false;
[Bindable]
public var automenumove:Boolean = false;
[Bindable]
public var openclosestatus:Number = 0;
//general menu functions
protected function overAllMouseUp(event:MouseEvent):void{
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	if ((menumoving)&&(automenumove == false)){
		menumoving = false;
		calculateMenuOperation();
	}
}
public function setNavigatorMovingStatus(b:Boolean):void {
	if (mainNavigator.activeView.data == null){
		mainNavigator.activeView.data = {moving:b};
	}
	else {
		mainNavigator.activeView.data.moving = b;	
	}
}
//Menu Menu functions
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
	hidekeyboard();
	var menuendx:Number = menu.x+menu.width;
	if (menumoving == false){
		menumoving = true;
		if (openclosestatus == 1){
			//most likeley openinging
			openclosestatus = 0;
			if (menuendx >= this.width/4){
				openMenu();
			}
			else {
				closeMenu();
			}	
		}
		else if (openclosestatus == 2){
			//most likely closing
			openclosestatus = 0;
			if (menuendx >= (this.width/3)*2){
				openMenu();
			}
			else {
				closeMenu();
			}
		}
	}
}
public function closeMenu():void {
	hidekeyboard();
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	var menuendx:Number = menu.x+menu.width;
	var mo:Move = new Move();
	mo.target = menu;
	mainNavigator.activeView.mouseChildren = false;
	mo.addEventListener(EffectEvent.EFFECT_END,afterCloseMenu );
	mo.xTo = 0-(this.width/1.15)-1;
	mo.duration = 100;
	mo.play();
}
public function afterCloseMenu(ev:EffectEvent):void {
	menuopen = false;
	menumoving = false;
	automenumove = false;
	mainNavigator.activeView.mouseChildren = true;
	setNavigatorMovingStatus(false);

}
public function openMenu():void {
	hidekeyboard();
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	var menuendx:Number = menu.x+menu.width;
	var mo:Move = new Move();
	mo.target = menu;
	mainNavigator.activeView.mouseChildren = false;
	mo.addEventListener(EffectEvent.EFFECT_END, afterOpenMenu);
	mo.xTo = 0;
	mo.duration = 100;
	mo.play();
}
public function afterOpenMenu(ev:EffectEvent):void {
	menuopen = true;
	menumoving = false;
	automenumove = false;
	setNavigatorMovingStatus(false);
}
public function updateMenuLocation(ev:MouseEvent):void {
	if (ev.stageX <= menu.width){
		menuopen = true;
		menumoving = true;
		automenumove = false;
		menu.x = ev.stageX-menu.width;
		//mainNavigator.enabled = false;	
	}
}