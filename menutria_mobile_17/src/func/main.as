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
public var VERSIONID:Number = 14;
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
public var statusbuffertop:Number = 0;
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
public var pm:PersistenceManager = new PersistenceManager();
protected function creationcomplete(event:FlexEvent):void
{
	startCoreMobile();
	svt.duration = slideduration;
	svt.direction =  ViewTransitionDirection.LEFT;
	svt2.duration = slideduration;
	svt2.direction =  ViewTransitionDirection.RIGHT;
	svt2.mode = SlideViewTransitionMode.UNCOVER;
	mainNavigator.defaultPushTransition = svt;
	mainNavigator.defaultPopTransition = svt2;
	NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, nativeKeyDown);
	initGPS();

	if (getDPIHeight() == 640){
		actionbarheight = 172;	
	}
	else if (getDPIHeight() == 480){
		actionbarheight = 129;		
	}
	else if (getDPIHeight() == 320){
		actionbarheight = 86;
	}
	else if (getDPIHeight() == 240){
		actionbarheight = 65;
	}
	else {
		actionbarheight = 43;
	}

	
	

		
	if (Capabilities.version.indexOf('IOS') > -1){
		if (getDPIHeight() == 320){
			obarheight = 0;
			statusbuffertop = 20;
		}
		else if (getDPIHeight() == 160){
			obarheight = 0;
			statusbuffertop = 10;
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
		
		if (mainNavigator.firstView == null){
			if (mainNavigator.activeView == null){
				loadedview = true;
				mainNavigator.pushView(Home,null,null,crosstrans);	
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
		mainNavigator.pushView(Login,null,null,crosstrans);
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
		if ((mainNavigator.activeView.className == "Home")||
			(mainNavigator.activeView.className == "Login")){
			//dont pop
		}
		else if ((mainNavigator.activeView.className == "Profile")||
			(mainNavigator.activeView.className == "MenuAll")||
			(mainNavigator.activeView.className == "Settings")||
			(mainNavigator.activeView.className == "SpecialsAll")||
			(mainNavigator.activeView.className == "Restrictions")){
			var slideTrans:SlideViewTransition = new SlideViewTransition();
			slideTrans.duration = slideduration;
			slideTrans.direction = ViewTransitionDirection.RIGHT;
			slideTrans.mode = SlideViewTransitionMode.UNCOVER;  //or COVER and PUSH modes
			mainNavigator.pushView(Home, null,null,slideTrans);
		}
		else {
			mainNavigator.popView();
		}
		event.preventDefault();
	}
	if (key == Keyboard.MENU){
		if ((mainNavigator.activeView.className != "Login")&&
			(mainNavigator.activeView.className != "Signup_step1")&&
			(mainNavigator.activeView.className != "Signup_step2")){
			menuButtonClick();
		}
		event.preventDefault();
	}
}
public function onSwipe(event:TransformGestureEvent):void
{
	hidekeyboard();
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
					mainNavigator.activeView.mouseChildren = false;
					this.addEventListener(MouseEvent.MOUSE_MOVE, updateFiltersLocation);
					menufeaturebutton.visible = false;
					
				}
				else if ((mainNavigator.activeView.name.toLocaleLowerCase().indexOf('login') == -1)){ 
					if (menumoving == false){
						setNavigatorMovingStatus(true);
						automenumove = false;
						openclosestatus = 1;
						menumoving = true;
						mainNavigator.activeView.mouseChildren = false;
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
					mainNavigator.activeView.mouseChildren = false;
					this.addEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
					filterfeaturebutton.visible = false;
				}
				else if ((mainNavigator.activeView.name.toLocaleLowerCase().indexOf('home') != -1)||
					(mainNavigator.activeView.name.toLocaleLowerCase().indexOf('specialsall') != -1)||
					(mainNavigator.activeView.name.toLocaleLowerCase().indexOf('menuall') != -1)){
					
					if (filtersmoving == false){
						setNavigatorMovingStatus(true);
						openclosestatus = 1;
						autofiltersmove = false;
						filtersmoving = true;
						mainNavigator.activeView.mouseChildren = false;
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
		if (mainNavigator.activeView.className.toLocaleLowerCase().indexOf('profile') == -1){
			mainNavigator.pushView(Profile);
		}
		else if (menuopen){
			closeMenu();
		}
		
	}
	else if (u == 1){
		//home
		if (mainNavigator.activeView.className.toLocaleLowerCase().indexOf('home') == -1){
			mainNavigator.pushView(Home,{homefilterarray:[]});
		}
		else if (menuopen){
			closeMenu();
		}
		
	}
	else if (u == 2){
		//restrictions
		if (mainNavigator.activeView.className.toLocaleLowerCase().indexOf('restrictions') == -1){
			mainNavigator.pushView(Restrictions);
		}
		else if (menuopen){
			closeMenu();
		}
	}
	else if (u == 3){
		//dishes
		if (mainNavigator.activeView.className.toLocaleLowerCase().indexOf('menuall') == -1){
			mainNavigator.pushView(MenuAll,{homefilterarray:[]});	
		}
		else if (menuopen){
			closeMenu();
		}
	}
	else if (u == 4){
		//specials
		if (mainNavigator.activeView.className.toLocaleLowerCase().indexOf('specialsall') == -1){
			mainNavigator.pushView(SpecialsAll);	
		}
		else if (menuopen){
			closeMenu();
		}
			
	}
	else if (u == 5){
		//settings
		if (mainNavigator.activeView.className.toLocaleLowerCase().indexOf('settings') == -1){
			mainNavigator.pushView(Settings);	
		}
		else if (menuopen){
			closeMenu();
		}
		
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
	stage.focus = null;
	mainNavigator.pushView(Home,null,null,crosstrans);
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
		if (mainNavigator.firstView == null){
			if (mainNavigator.activeView == null){
				mainNavigator.pushView(Home,null,null,crosstrans);
			}
		}
	}
	else {
		mainNavigator.pushView(Login,null,null,crosstrans);
	}
}
public function logout():void {
	try{
		GoViral.goViral.logoutFacebook();
	}
	catch(e:Error){
		
	}
	dropalldatatables();
	mainNavigator.pushView(Login);
}
public function goProfile(event:MouseEvent):void
{
	if (mainNavigator.activeView.className.toLocaleLowerCase().indexOf('profile') == -1){
		mainNavigator.pushView(Profile);
	}
	else if (menuopen){
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
	if (mainNavigator.activeView.name.toLocaleLowerCase().indexOf('menuall') != -1){
		mainNavigator.pushView(MenuAll,{homefilterarray:homefilterarray},null,xFadeTrans);
	}
	else if (mainNavigator.activeView.name.toLocaleLowerCase().indexOf('specialsall') != -1){
		mainNavigator.pushView(SpecialsAll,{homefilterarray:homefilterarray},null,xFadeTrans);
	}
	else {
		mainNavigator.pushView(Home,{homefilterarray:homefilterarray},null,xFadeTrans);
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
		mainNavigator.pushView(Login,null,null,crosstrans);	
	}
}
public function showBusy():void {
	bi.visible = true;
}
public function hideBusy():void {
	bi.visible = false;
}



