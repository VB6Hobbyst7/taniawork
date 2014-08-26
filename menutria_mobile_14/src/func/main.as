import com.milkmangames.nativeextensions.GoViral;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.desktop.NativeApplication;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.system.Capabilities;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.core.DPIClassification;
import mx.events.FlexEvent;

import spark.transitions.SlideViewTransition;
import spark.transitions.SlideViewTransitionMode;
import spark.transitions.ViewTransitionDirection;

import views.Home;
import views.Login;
[Bindable]
public var VERSIONID:Number = 13;
[Bindable]
public var durationofmovment:Number = 50;
public var searchLocation:String;
public var searchTerm:String;
public var directionsLocations:Array;
public var crosstrans:CrossFadeViewTransition = new CrossFadeViewTransition(); 
public var xFadeTrans:CrossFadeViewTransition = new CrossFadeViewTransition();
[Bindable]
public var actionbarheight:Number = 0;
[Bindable]
public var homeitems:ArrayCollection = new ArrayCollection();
[Bindable]
public var filteritems:ArrayCollection = new ArrayCollection(
	[	
		{name:"Open Now",chosen:'no',type:1},
		{name:"Offering Specials",chosen:'no',type:1},
		{name:"",chosen:'no',type:0},
		{name:"I Have Eaten",chosen:'no',type:1},
		{name:"I Haven't Eaten",chosen:'no',type:1}
	]);
public var loadedview:Boolean = false;
public var svt:SlideViewTransition = new SlideViewTransition();
public var svt2:SlideViewTransition = new SlideViewTransition();
protected function creationcomplete(event:FlexEvent):void
{
	startCoreMobile();
	svt.duration = slideduration;
	svt.direction =  ViewTransitionDirection.LEFT;
	svt2.duration = slideduration;
	svt2.direction =  ViewTransitionDirection.RIGHT;
	svt2.mode = SlideViewTransitionMode.UNCOVER;
	mainNavigator.navigator.defaultPushTransition = svt;
	mainNavigator.navigator.defaultPopTransition = svt2;
	NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, nativeKeyDown);
	initGPS();
	
	//hideStatusBar();
	
	
	
	
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
	
	

		
	if (Capabilities.version.indexOf('IOS') > -1){
		if (getDPIHeight() == 320){
			//obarheight = 40;
			obarheight = 0;
			mainNavigator.actionBar.height = actionbarheight + 40;
		}
		else if (getDPIHeight() == 160){
			//obarheight = 10;
			obarheight = 0;
			mainNavigator.actionBar.height = actionbarheight + 10;
		}
	}
	
		
	homeitems = new ArrayCollection([{name:"Profile",img:menu_account,colorid:"0x50bcb6"},
		{name:"Home",img:menu_home,colorid:"0xef4056", selected:true},
		{name:"Restrictions",img:menu_restrictions,colorid:"0xfcb643"},
		{name:"Dishes",img:menu_dish,colorid:"0xfcb643"},
		{name:"Specials",img:menu_ratings,colorid:"0xfcb643"},
		{name:"Settings",img:menu_settings,colorid:"0xfcb643"}
	]);
	verifyDataTablesViaVersion();
	createIfNotExsist("localuser");
	var resData:ArrayCollection = getDatabaseArray( "SELECT * FROM localuser");
	if (resData.length != 0){
		nameGo = resData[0].name;
		emailGo = resData[0].email;
		cityGo = resData[0].city;
	pictureGo = resData[0].picture;
	getUserInfo.send();
		for (var i:uint = 0; i < homeitems.length; i++){
			if (homeitems[i].name == "Profile"){
				homeitems[i].name = nameGo.charAt(0).toUpperCase()+nameGo.substring(1,nameGo.length);
			}
		}
		if (mainNavigator.navigator.firstView == null){
			if (mainNavigator.navigator.activeView == null){
				loadedview = true;
				mainNavigator.navigator.pushView(Home,null,null,crosstrans);	
			}
			else {
				loadedview = true;
			}
		}
		else {
			loadedview = true; 
		}
		
	}
	else {
		loadedview = true; 
		mainNavigator.navigator.pushView(Login,null,null,crosstrans);
	}	
	addswipefunctions();
}
public function addswipefunctions():void {
	this.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
}
public function removeswipefunctions():void {
	this.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
}
public function nativeKeyDown(event:KeyboardEvent):void
{
	var key:uint = event.keyCode;
	if (key == Keyboard.BACK){
		event.preventDefault();
	}
}
public function showStatusBar():void {
	/*if (Capabilities.version.indexOf('IOS') > -1){
		if (getDPIHeight() == 320){
			obarheight = 40;
		}
		else if (getDPIHeight() == 160){
			obarheight = 10;
		}
	}*/
}
public function hideStatusBar():void {
	/*if (Capabilities.version.indexOf('IOS') > -1){
		if (getDPIHeight() == 320){
			obarheight = 0;
		}
		else if (getDPIHeight() == 160){
			obarheight = 0;
		}
	}*/
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
				break;
			}
			case -1:
			{
				break;
			}
		}
		
	}		
}
public function menuchange(event:IndexChangeEvent):void
{
	if (menuopen){
		closeMenu();
		pushScreen(listmenu.selectedIndex);
	}
	else {
		pushScreen(listmenu.selectedIndex);
	}
	
}

public function pushScreen(u:uint):void {
	listmenu.selectedIndex = -1;
	if (u == 0){
		//your account
		mainNavigator.navigator.pushView(Profile);
	}
	else if (u == 1){
		//home
		mainNavigator.navigator.pushView(Home,{homefilterarray:[]});
	}
	else if (u == 2){
		//restrictions
		mainNavigator.navigator.pushView(Restrictions);
		
	}
	else if (u == 3){
		//specials
		mainNavigator.navigator.pushView(MenuAll,{homefilterarray:[]});	
	}
	else if (u == 4){
		//specials
		mainNavigator.navigator.pushView(SpecialsAll);	
	}
	else if (u == 5){
		//settings
		mainNavigator.navigator.pushView(Settings);
	}	
}
public function viewadd(event:ElementExistenceEvent):void
{
	if (menuopen){
		closeMenu();
	}
	listmenu.selectedIndex = -1;
}
public function setProfImage(s:String):void {
	profimage.source = s;
	profimage.scaleMode = "zoom";
	profimage.visible = true;
}
public function refresh(email:String):void {
	reloadProfInfo();
	mainNavigator.navigator.pushView(Home);
}
public function reloadProfInfo():void {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT * FROM localuser";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);	
	
	if (resData.length > 0){
		nameGo = resData[0].name;
		emailGo = resData[0].email;
		cityGo = resData[0].city;
		pictureGo = resData[0].pictre;
		getUserInfo.send();
	}
}
public function loadStuff(r:ArrayCollection,mylat:Number = 53.55921, mylong:Number = -113.54009):void {
	if (r.length != 0){
		nameGo = r[0].name;
		emailGo = r[0].email;
		cityGo = r[0].city;
		pictureGo = r[0].pictre;
		getUserInfo.send();
		if (mainNavigator.navigator.firstView == null){
			if (mainNavigator.navigator.activeView == null){
				mainNavigator.navigator.pushView(Home,null,null,crosstrans);
			}
		}
	}
	else {
		mainNavigator.navigator.pushView(Login,null,null,crosstrans);
	}
}
public function logout():void {
	try{
		GoViral.goViral.logoutFacebook();
	}
	catch(e:Error){
		
	}
	dropalldatatables();
	mainNavigator.navigator.pushView(Login);
}
public function goProfile(event:MouseEvent):void
{
	mainNavigator.navigator.pushView(Profile);
	if ((menuopen)&&(menumoving == false)){
		menumoving = true;
		closeMenu();
	}
}
public function filterchange(event:IndexChangeEvent):void
{
	// TODO Auto-generated method stub
	var homefilterarray:Array = new Array();
	
	try{
		var j:uint = 0;
		var eatinval:uint = 0;
		for (var i:uint = 0; i < event.currentTarget.selectedItems.length; i++){
			if (event.currentTarget.selectedItems[i].type == 1){
				if (event.currentTarget.selectedItems[i].name == "Open Now"){
					homefilterarray.push(event.currentTarget.selectedItems[i].name);
				}
				else if (event.currentTarget.selectedItems[i].name == "Offering Specials"){
					homefilterarray.push(event.currentTarget.selectedItems[i].name);
				}
				else if (event.currentTarget.selectedItems[i].name == "I Have Eaten"){
					if (eatinval == 0){
						eatinval = 1;
					}
					else {
						eatinval = 3;
					}
				}
				else if (event.currentTarget.selectedItems[i].name == "I Haven't Eaten"){
					if (eatinval == 0){
						eatinval = 2;
					}
					else {
						eatinval = 3;
					}
				}
			}
		}	
	}
	catch(e:Error){
		
	}
	
	if (eatinval == 1){
		homefilterarray.push("I Have Eaten");
	}
	else if (eatinval == 2){
		homefilterarray.push("I Haven't Eaten");
	}
	else {
		if (event.newIndex == 3){
			homefilterarray.push("I Have Eaten");
			//event.currentTarget.selectedItems.
		}
		else if (event.newIndex == 4){
			homefilterarray.push("I Haven't Eaten");
		}
	}
	xFadeTrans.duration = 400;
	if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('menuall') != -1){
		mainNavigator.navigator.pushView(MenuAll,{homefilterarray:homefilterarray},null,xFadeTrans);
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('specialsall') != -1){
		mainNavigator.navigator.pushView(SpecialsAll,{homefilterarray:homefilterarray},null,xFadeTrans);
	}
	else {
		mainNavigator.navigator.pushView(Home,{homefilterarray:homefilterarray},null,xFadeTrans);
	}
	
	var ev:MouseEvent;
	closeFilters();
	
}

public function clearallclick(event:MouseEvent):void
{
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
public function verifyDataTablesViaVersion():void {
	createIfNotExsist("versionhistory");
	var resData:ArrayCollection = getDatabaseArray("SELECT version from versionhistory");
	if (resData.length != 0){
		var versiontocheck:String = resData[0].version;
		if (versiontocheck != VERSIONID.toString()){
			dropalldatatables();
			doQuery("update versionhistory set version = ('"+VERSIONID.toString()+"')");
		}
	}
	else {
		doQuery("insert into versionhistory values ('"+VERSIONID.toString()+"')");
		dropalldatatables();
	}
}
public function dropalldatatables():void {
	try{
		doQuery("DROP TABLE merchusers");
		doQuery("DROP TABLE specials");
		doQuery("DROP TABLE localuser");
		doQuery("DROP TABLE dishes");
	}
	catch(e:Error){}
	if (loadedview == false){
		mainNavigator.navigator.pushView(Login,null,null,crosstrans);	
	}
}