import com.adobe.images.PNGEncoder;

import flash.events.Event;
import flash.events.GeolocationEvent;
import flash.events.UncaughtErrorEvent;
import flash.sensors.Geolocation;

import mx.collections.ArrayCollection;
import mx.core.DPIClassification;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.events.DragEvent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.ResizeEvent;
import mx.events.TouchInteractionEvent;
import mx.graphics.codec.JPEGEncoder;
import mx.utils.Base64Encoder;

import spark.components.ActionBar;
import spark.components.BusyIndicator;
import spark.components.ButtonBar;
import spark.components.Group;
import spark.components.View;
import spark.components.ViewNavigator;
import spark.effects.Resize;
import spark.events.ElementExistenceEvent;
import spark.events.IndexChangeEvent;
import spark.managers.PersistenceManager;
import spark.transitions.CrossFadeViewTransition;
import spark.transitions.FlipViewTransition;
import spark.transitions.ViewTransitionBase;
import spark.transitions.ZoomViewTransition;

import views.AccountSettings;
import views.Home;
import views.Login;
import views.Profile;
import views.Restrictions;
import views.Reviews;
import views.Settings;
import views.SpecialsAll; 
import views.MenuAll; 

include "../includes/BusyIndicatorUtil.as";
include "../includes/TrafficUtil.as";
include "../includes/AppConfig.as";
include "../includes/ZoomControlUtil.as";
include "../includes/InfoWindowUtil.as";
include "../includes/GpsUtil.as";





[Bindable]
public var map:TileMap;
public var gps:Geolocation;
public var gpsLatLng:LatLng;
private var zoomControl:SMZoomControl;
private var traffic:Traffic;
public var gpsPoi:Poi;
public var gpsIsSupported:Boolean = false;
public var trafficEnabled:Boolean = false;
public var gpsTried:Boolean = false;
[Bindable]
public var assetPath:String;
[Bindable]
public var durationofmovment:Number = 50;
public var biBusyIndicator:BusyIndicator;		
public var searchLocation:String;
public var searchTerm:String;
public var directionsLocations:Array;
public var crosstrans:CrossFadeViewTransition = new CrossFadeViewTransition(); 
protected var sqlConnection:SQLConnection;
public var xFadeTrans:CrossFadeViewTransition = new CrossFadeViewTransition();
[Bindable]
public var homeitems:ArrayCollection = new ArrayCollection();
[Bindable]
public var filteritems:ArrayCollection = new ArrayCollection(
	[	
		
		{name2:"Open Now",chosen:'no',type:1},
		{name2:"Offering Specials",chosen:'no',type:1},
		{name2:"",chosen:'no',type:0},
		{name2:"I Have Eaten",chosen:'no',type:1},
		{name2:"I Haven't Eaten",chosen:'no',type:1}
	]);
import spark.core.ContentCache;
[Bindable]
public var actionbarheight:Number = 0;
static public const s_imageCache:ContentCache = new ContentCache();
protected function tabbedmobileapplication1_applicationCompleteHandler(event:FlexEvent):void {
	trace(numElements);
}
protected function onApplicationComplete():void
{
	switch (applicationDPI)
	{
		case DPIClassification.DPI_640:
		{
			actionbarheight = 172;
			break;
		}
		case DPIClassification.DPI_480:
		{
			actionbarheight = 129;
			break;
		}
		case DPIClassification.DPI_320:
		{
			actionbarheight = 86;
			break;
		}
		case DPIClassification.DPI_240:
		{
			actionbarheight = 65;
			break;
		}
		default:
		{
			actionbarheight = 43;
			break;
		}
	}
	
	
	homeitems = new ArrayCollection([{name2:"Profile",img:menu_account,colorid:"0x50bcb6"},
		{name2:"Home",img:menu_home,colorid:"0xef4056", selected:true},
		{name2:"Restrictions",img:menu_restrictions,colorid:"0xfcb643"},
		{name2:"Dishes",img:menu_ratings,colorid:"0xfcb643"},
		{name2:"Specials",img:menu_ratings,colorid:"0xfcb643"},
		{name2:"Reviews",img:menu_review,colorid:"0xfcb643"},
		{name2:"Settings",img:menu_settings,colorid:"0xfcb643"}
	]);
	this.stage.autoOrients = false;				
	addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, onDisplayStateChange);			
	NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
	NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
	NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
	loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);
	NativeApplication.nativeApplication.addEventListener(Event.EXITING,onAppExiting);
	NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	//	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	//	Multitouch.mapTouchToMouse = true;
	this.addEventListener(ResizeEvent.RESIZE,this.onResize,false,0,true);
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
		"email varchar(255)," +
		"name varchar(255)," +
		"country varchar(255)," +
		"active varchar(255))";
	stmt.execute();
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT email, name, country, active FROM localuser where active = 'yes'";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	if (resData.length != 0){
		var namego:String = resData[0].name;
		for (var i:uint = 0; i < homeitems.length; i++){
			if (homeitems[i].name == "Profile"){
				homeitems[i].name = namego;
			}
		}
		if (mainNavigator.navigator.firstView == null){
			if (mainNavigator.navigator.activeView == null){
				mainNavigator.navigator.firstView = Home;
				mainNavigator.navigator.pushView(Home);	
			}
			
		}
		
	}
	else {
		if (mainNavigator.navigator.firstView == null){
			if (mainNavigator.navigator.activeView == null){
				mainNavigator.navigator.firstView = Login;
				mainNavigator.navigator.pushView(Login);
			}
			
		}
	}	
	
	var loadManager:PersistenceManager = new PersistenceManager();
	this.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
	
	
}

public function onSwipe(event:TransformGestureEvent):void
{
	var ev:MouseEvent;
	if (event.currentTarget.id != 'uic'){
		switch(event.offsetX)
		{
			case 1:
			{
				// swiped right also back swipe
				
				//opening menu or closing filters
				if ((filtersmoving == false)&&(filtersopen)){
					setNavigatorMovingStatus(true);
					autofiltersmove = false;
					openclosestatus = 2;
					filtersmoving = true;
					mainNavigator.navigator.activeView.mouseChildren = false;
					this.addEventListener(MouseEvent.MOUSE_MOVE, updateFiltersLocation);
					menufeaturebutton.visible = false;
					
				}
				else if ((mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('login') == -1)){ 
					if (menumoving == false){
						setNavigatorMovingStatus(true);
						automenumove = false;
						openclosestatus = 1;
						menumoving = true;
						mainNavigator.navigator.activeView.mouseChildren = false;
						this.addEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
						filterfeaturebutton.visible = false;
					}	
				}
				
				
				
				break;
			}
			case -1:
			{
				// swiped left
				
				//opening filters or closing menu
				if ((menumoving == false)&&(menuopen)){
					setNavigatorMovingStatus(true);
					openclosestatus = 2;
					automenumove = false;
					menumoving = true;
					mainNavigator.navigator.activeView.mouseChildren = false;
					this.addEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
					filterfeaturebutton.visible = false;
				}
				else if ((mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('home') != -1)||
					(mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('specialsall') != -1)||
					(mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('menuall') != -1)){
					
					if (filtersmoving == false){
						setNavigatorMovingStatus(true);
						openclosestatus = 1;
						autofiltersmove = false;
						filtersmoving = true;
						mainNavigator.navigator.activeView.mouseChildren = false;
						this.addEventListener(MouseEvent.MOUSE_MOVE, updateFiltersLocation);
						menufeaturebutton.visible = false;
					}
					
				}
				
				
				
				break;
			}
		}
		switch(event.offsetY)
		{
			case 1:
			{
				// swiped down
				break;
			}
			case -1:
			{
				// swiped up
				break;
			}
		}
		
	}		
}
public function logout():void {
	var vn4:ViewNavigator = new ViewNavigator();
	vn4.firstView = views.Login;
	vn4.percentWidth = 100;
	vn4.percentHeight = 100;
}	
public function menuchange(event:IndexChangeEvent):void
{
	// TODO Auto-generated method stub
	
	if (menuopen){
		closeMenu();
		pushScreen(listmenu.selectedIndex);
	}
	else {
		pushScreen(listmenu.selectedIndex);
	}
	
}

public function pushScreen(u:uint):void {
	if (u == 0){
		//your account
		mainNavigator.navigator.pushView(Profile);
	}
	else if (u == 1){
		//home
		mainNavigator.navigator.pushView(Home);
	}
	else if (u == 2){
		//restrictions
		mainNavigator.navigator.pushView(Restrictions);
		
	}
	else if (u == 3){
		//specials
		mainNavigator.navigator.pushView(MenuAll);	
	}
	else if (u == 4){
		//specials
		mainNavigator.navigator.pushView(SpecialsAll);	
	}
	else if (u == 5){
		//ratings and review
		mainNavigator.navigator.pushView(Reviews);
	}
	else if (u == 6){
		//settings
		mainNavigator.navigator.pushView(Settings);
	}	
}
public function filterchange(event:IndexChangeEvent):void
{
	// TODO Auto-generated method stub
	var homefilterarray:Array = new Array();
	
	try{
		for (var i:uint = 0; i < event.currentTarget.selectedItems.length; i++){
			if (event.currentTarget.selectedItems[i].type == 1){
				if (event.currentTarget.selectedItems[i].name == "Open Now"){
					homefilterarray.push(event.currentTarget.selectedItems[i].name);
				}
				else if (event.currentTarget.selectedItems[i].name == "Offering Specials"){
					homefilterarray.push(event.currentTarget.selectedItems[i].name);
				}
				else if (event.currentTarget.selectedItems[i].name == "I Have Eaten"){
					homefilterarray.push(event.currentTarget.selectedItems[i].name);
				}
				else if (event.currentTarget.selectedItems[i].name == "I Haven't Eaten"){
					homefilterarray.push(event.currentTarget.selectedItems[i].name);
				}
			}
		}	
	}
	catch(e:Error){
		
	}
	xFadeTrans.duration = 400;
	mainNavigator.navigator.pushView(Home,{homefilterarray:homefilterarray},null,xFadeTrans);
	var ev:MouseEvent;
	closeFilters();
	
}
public function viewadd(event:ElementExistenceEvent):void
{
	
	if (menuopen){
		closeMenu();
	}
	
	if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('profile') != -1){
		listmenu.selectedIndex = 0;
		filterfeaturebutton.visible = true;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('home') != -1){
		listmenu.selectedIndex = 1;
		filterfeaturebutton.visible = true;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('restrictions') != -1){
		listmenu.selectedIndex = 2;
		filterfeaturebutton.visible = false;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('menuall') != -1){
		listmenu.selectedIndex = 3;
		filterfeaturebutton.visible = false;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('specials') != -1){
		listmenu.selectedIndex = 4;
		filterfeaturebutton.visible = false;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('review') != -1){
		listmenu.selectedIndex = 5;
		filterfeaturebutton.visible = false;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('accountsettings') != -1){
		listmenu.selectedIndex = 6;
		filterfeaturebutton.visible = false;
	}
	
	
}
public function clearallclick(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	listfilters.selectedIndex = -1;
}	

public function navigatorClick(event:MouseEvent):void
{	
	if ((menuopen)&&(menumoving == false)){
		menumoving = true;
		closeMenu();
	}
	else if ((filtersopen)&&(filtersmoving == false)){
		filtersmoving = true;
		closeFilters();
	}
}