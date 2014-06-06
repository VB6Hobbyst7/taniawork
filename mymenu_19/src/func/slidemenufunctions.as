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
public var filtersmoving:Boolean = false;
[Bindable]
public var filtersopen:Boolean = false;
[Bindable]
public var autofiltersmove:Boolean = false;
[Bindable]
public var openclosestatus:Number = 0;

//general menu functions
protected function overAllMouseUp(event:MouseEvent):void{
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateFiltersLocation);
	if ((menumoving)&&(automenumove == false)){
		menumoving = false;
		calculateMenuOperation();
	}
	else if ((filtersmoving)&&(autofiltersmove == false)){
		filtersmoving = false;
		calculateFiltersOperation();
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
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
	var menuendx:Number = menu.x+menu.width;
	var mo:Move = new Move();
	mo.target = menu;
	mainNavigator.activeView.mouseChildren = false;
	mo.addEventListener(EffectEvent.EFFECT_END,afterCloseMenu );
	mo.xTo = 0-(this.width/1.15)-1;
	mo.duration = 100;
	mo.play();
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
	mo.target = menu;
	mainNavigator.activeView.mouseChildren = false;
	mo.addEventListener(EffectEvent.EFFECT_END, afterOpenMenu);
	mo.xTo = 0;
	mo.duration = 100;
	mo.play();
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
	}
}






//Filters menu functions
public function filtersButtonClick():void {
	if (filtersmoving == false){
		autofiltersmove = true;
		filtersmoving = true;
		if (filtersopen){
			closeFilters();
		}
		else {
			openFilters();
		}
	}
}
public function calculateFiltersOperation():void {
	var filtersendx:Number = filtersmenu.x+filtersmenu.width;
	if (filtersmoving == false){
		filtersmoving = true;
		if (openclosestatus == 1){
			//most likeley openinging
			openclosestatus = 0;
			if (filtersendx <= ((this.width)-this.width/4)){
				openFilters();
			}
			else {
				closeFilters();
			}	
		}
		else if (openclosestatus == 2){
			//most likely closing
			openclosestatus = 0;
			if (filtersendx <= (this.width/3)*2){
				openFilters();
			}
			else {
				closeFilters();
			}
		}
	}
}
public function closeFilters():void {
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateFiltersLocation);
	var filtersendx:Number = filtersmenu.x+filtersmenu.width;
	var mo:Move = new Move();
	mo.target = filtersmenu;
	mainNavigator.activeView.mouseChildren = false;
	mo.addEventListener(EffectEvent.EFFECT_END,afterCloseFilters );
	mo.xTo = this.width;
	mo.duration = 100;
	mo.play();
	menufeaturebutton.visible = true;
	filtersopen = false;	
}
public function afterCloseFilters(ev:EffectEvent):void {
	filtersopen = false;
	filtersmoving = false;
	autofiltersmove = false;
	mainNavigator.activeView.mouseChildren = true;
	
}
public function openFilters():void {
	this.removeEventListener(MouseEvent.MOUSE_MOVE, updateFiltersLocation);
	var mo:Move = new Move();
	mo.target = filtersmenu;
	mainNavigator.activeView.mouseChildren = false;
	mo.addEventListener(EffectEvent.EFFECT_END, afterOpenFilters);
	mo.xTo = this.width-filtersmenu.width;
	mo.duration = 100;
	mo.play();
	menufeaturebutton.visible = false;
	filtersopen = false;	
}
public function afterOpenFilters(ev:EffectEvent):void {
	filtersopen = true;
	filtersmoving = false;
	autofiltersmove = false;
}
public function updateFiltersLocation(ev:MouseEvent):void {
	if (ev.stageX >= this.width-filtersmenu.width){
		filtersopen = true;
		mainNavigator.activeView.mouseChildren = true;
		filtersmoving = true;
		autofiltersmove = false;
		filtersmenu.x = ev.stageX;
	}
}
