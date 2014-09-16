import com.google.analytics.GATracker;
import com.milkmangames.nativeextensions.GVFacebookFriend;
import com.milkmangames.nativeextensions.GoViral;
import com.milkmangames.nativeextensions.events.GVFacebookEvent;
import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.events.Event;
import flash.events.GeolocationEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TransformGestureEvent;
import flash.events.UncaughtErrorEvent;
import flash.filesystem.File;
import flash.sensors.Geolocation;
import flash.system.Capabilities;
import flash.ui.Keyboard;
import mx.collections.ArrayCollection;
import mx.core.DPIClassification;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;
import spark.events.ElementExistenceEvent;
import spark.events.IndexChangeEvent;
import spark.events.ViewNavigatorEvent;
import spark.managers.PersistenceManager;
import spark.transitions.CrossFadeViewTransition;
import spark.transitions.SlideViewTransition;
import spark.transitions.SlideViewTransitionMode;
import spark.transitions.ViewTransitionDirection;
import views.Home;
import views.MapView;
public static const FACEBOOK_APP_ID:String="1424621771149692";
[Bindable]
public var VERSIONID:Number = 10;
public var crosstrans:CrossFadeViewTransition = new CrossFadeViewTransition(); 
public var resData:ArrayCollection = new ArrayCollection();
[Bindable]
public var homeitems:ArrayCollection = new ArrayCollection();
[Bindable]
public var actionbarheight:Number = 0;
public var svt:SlideViewTransition = new SlideViewTransition();
public var svt2:SlideViewTransition = new SlideViewTransition();
public var pm:PersistenceManager = new PersistenceManager();
public var loadedview:Boolean = false;
protected function afterappcomplete(event:FlexEvent):void
{
	var tracker:GATracker = new GATracker( this, "UA-44766703-2", "AS3", false );
	tracker.trackPageview( "Application Load" );
}
public function creationcomplete(event:FlexEvent):void
{
	svt.duration = slideduration;
	svt.direction =  ViewTransitionDirection.LEFT;
	svt2.duration = slideduration;
	svt2.direction =  ViewTransitionDirection.RIGHT;
	svt2.mode = SlideViewTransitionMode.UNCOVER;
	mainNavigator.defaultPushTransition = svt;
	mainNavigator.defaultPopTransition = svt2;
	NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, nativeKeyDown);
	initGPS();
	startRate();
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
			obarheight = 40;
		}
		else if (getDPIHeight() == 160){
			obarheight = 20;
		}
	}
	
	homeitems = new ArrayCollection([{name:"Profile",img:menu_prof,colorid:"0x50bcb6"},
		{name:"My Rewards",img:menu_cup,colorid:"0xef4056"},
		{name:"Locations",img:menu_pin,colorid:"0xfcb643"},
		{name:"Activity",img:menu_stat,colorid:"0xfcb643"},
		{name:"Settings",img:menu_settings,colorid:"0xfcb643"}
	]);
	verifyDataTablesViaVersion();
	createIfNotExsist("localuser");
	resData = getDatabaseArray( "SELECT email, name, city  FROM localuser");				
	loadStuff(resData);
	this.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
}
public function nativeKeyDown(event:KeyboardEvent):void
{
	var key:uint = event.keyCode;
	if (key == Keyboard.BACK){
		if ((mainNavigator.activeView.className == "Home")||
			(mainNavigator.activeView.className == "Signin")){
			//dont pop
		}
		else if ((mainNavigator.activeView.className == "Activity")||
			(mainNavigator.activeView.className == "Loyalty")||
			(mainNavigator.activeView.className == "Stores")||
			(mainNavigator.activeView.className == "Settings")||
			(mainNavigator.activeView.className == "MapView")){
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
		if ((mainNavigator.activeView.className != "Signin")&&
			(mainNavigator.activeView.className != "Signup_step1")&&
			(mainNavigator.activeView.className != "Signup_step2")){
			menuButtonClick();
		}
		event.preventDefault();
	}
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
				//opening menu 
				if ((mainNavigator.activeView.name.toLocaleLowerCase().indexOf('sign') == -1)&&
					(mainNavigator.activeView.name.toLocaleLowerCase().indexOf('map') == -1)){ 
					if (menumoving == false){
						setNavigatorMovingStatus(true);
						automenumove = false;
						openclosestatus = 1;
						menumoving = true;
						mainNavigator.activeView.mouseChildren = false;
						this.addEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
					}	
				}
				
				
				
				break;
			}
			case -1:
			{
				// swiped left
				// closing menu
				if ((menumoving == false)&&(menuopen)){
					setNavigatorMovingStatus(true);
					openclosestatus = 2;
					automenumove = false;
					menumoving = true;
					mainNavigator.activeView.mouseChildren = false;
					this.addEventListener(MouseEvent.MOUSE_MOVE, updateMenuLocation);
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
public function navigatorClick(event:MouseEvent):void
{	
	if ((menuopen)&&(menumoving == false)){
		menumoving = true;
		closeMenu();
	}
}
public function pushScreen(u:uint):void {
	if (u == 0){
		//profile
		mainNavigator.pushView(Home);
	}
	else if (u == 1){
		//my rewards
		mainNavigator.pushView(Loyalty);
	}
	else if (u == 2){
		//locations
		mainNavigator.pushView(Stores);
	}
	else if (u == 3){
		//stats
		mainNavigator.pushView(Activity);	
	}
	else if (u == 4){
		//settings
		mainNavigator.pushView(Settings);
	}	
	listmenu.selectedIndex = -1;
}

public function viewadd(event:ElementExistenceEvent):void
{
	if (menuopen){
		closeMenu();
	}	
}
public function goProfile(event:MouseEvent):void
{
	mainNavigator.pushView(Home);
}
public function setProfImage(s:String):void {
	profimage.source = s;
	profimage.scaleMode = "zoom";
	profimage.visible = true;
}
public function reloadProfInfo():void {
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT email, name, city FROM localuser";
	stmt.execute();
	resData = new ArrayCollection(stmt.getResult().data);	
	
	if (resData.length > 0){
		nameGo = resData[0].name;
		emailGo = resData[0].email;
		cityGo = resData[0].city;
		getUserInfo.send();
	}
}
public function loadStuff(r:ArrayCollection,mylat:Number = 53.55921, mylong:Number = -113.54009):void {
	if (r.length != 0){
		nameGo = r[0].name;
		emailGo = r[0].email;
		cityGo = r[0].city;
		getUserInfo.send();
		if (mainNavigator.firstView == null){
			if (mainNavigator.activeView == null){
				mainNavigator.pushView(Home,null,null,crosstrans);
			}
		}
	}
	else {
		mainNavigator.pushView(Signin,null,null,crosstrans);
	}
	loadedview = true; 
}
public function logout():void {
	try{
		GoViral.goViral.logoutFacebook();
	}
	catch(e:Error){
		
	}
	dropalldatatables();
	mainNavigator.pushView(Signin);
}
public function verifyDataTablesViaVersion():void {
	var stmt:SQLStatement = new SQLStatement();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS versionhistory (version varchar(255))";
	stmt.execute();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT version from versionhistory";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	if (resData.length != 0){
		var versiontocheck:String = resData[0].version;
		if (versiontocheck != VERSIONID.toString()){
			dropalldatatables();
		}
		stmt = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "update versionhistory set version = ('"+VERSIONID.toString()+"')";
		stmt.execute();
	}
	else {
		stmt = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "insert into versionhistory values ('"+VERSIONID.toString()+"')";
		stmt.execute();
		dropalldatatables();
	}
	
	
	/*sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS timesran (amt varchar(255))";
	stmt.execute();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT amt from timesran";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	if (resData.length != 0){
		var prevamt:Number = Number(resData[0].amt)+1;
		
		if (prevamt == 4){
			showRate();
		}
		
		
		stmt = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "update timesran set amt = ('"+prevamt.toString()+"')";
		stmt.execute();
	}
	else {
		stmt = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "insert into timesran values ('1')";
		stmt.execute();
	}*/
}
public function dropalldatatables():void {
	var stmt:SQLStatement = new SQLStatement();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "DROP TABLE merchusers";
	try{
		stmt.execute();	
	}
	catch(e:Error){}
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "DROP TABLE localuser";
	try{
		stmt.execute();	
	}
	catch(e:Error){}
}
public function initz(event:FlexEvent):void
{
	
	pm.load();
	try{
		loadedview = true; 
		mainNavigator.loadViewData(pm.getProperty("sviewdata"));
	}
	catch(e:Error){
		loadedview = true; 
		mainNavigator.pushView(Signin,null,null,crosstrans);
	}
	try{
	GoViral.create();
	GoViral.goViral.initFacebook(FACEBOOK_APP_ID, "");
	GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN,onFacebookEvent);
	GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT,onFacebookEvent);
	GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED,onFacebookEvent);
	GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED,onFacebookEvent);
	try{
		NativeApplication.nativeApplication.autoExit = false;
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		NativeApplication.nativeApplication.executeInBackground = true;
	}
	catch(e:Error){	
	}	
	
	
	checkfacebookin();
}
catch(e:Error){}
	
}
public function checkfacebookin():void {
	doFacebookStuff();
}
private function onFacebookEvent(e:GVFacebookEvent):void
{
	try{
		var s:String = "";
		switch(e.type)
		{
			case GVFacebookEvent.FB_LOGGED_IN:
				
				checkfacebookin();
				s = "Logged in to facebook:"+GoViral.VERSION+
				",denied: ["+GoViral.goViral.getDeclinedFacebookPermissions()+
				"], profile permission?"+GoViral.goViral.isFacebookPermissionGranted("public_profile");
				break;
			case GVFacebookEvent.FB_LOGGED_OUT:
				s = "Logged out of facebook.";
				break;
			case GVFacebookEvent.FB_LOGIN_CANCELED:
				s = "Canceled facebook login.";
				break;
			case GVFacebookEvent.FB_LOGIN_FAILED:
				s = "Login failed:"+e.errorMessage+",sn?"+e.shouldNotifyFacebookUser+",cat?"+e.facebookErrorCategoryId;
				break;
			case GVFacebookEvent.FB_PUBLISH_PERMISSIONS_FAILED:
			case GVFacebookEvent.FB_READ_PERMISSIONS_FAILED:
				s =  "perms failed:"+e.errorMessage+",sn?"+e.shouldNotifyFacebookUser+",cat?"+e.facebookErrorCategoryId+","+e.permissions;
				break;
			case GVFacebookEvent.FB_READ_PERMISSIONS_UPDATED:
			case GVFacebookEvent.FB_PUBLISH_PERMISSIONS_UPDATED:
				s = "Perms updated:"+e.permissions;
		}
	}
	catch(e:Error){}
	
	
}
public function refresh(email:String):void {
	reloadProfInfo();
	mainNavigator.pushView(Home);
}
public function facebookloging():void {
	if(!GoViral.goViral.isFacebookAuthenticated())
	{
		GoViral.goViral.authenticateWithFacebook("email,public_profile,user_birthday,user_location");
	}
	else {		
		doFacebookStuff();		
	}
}
public function doFacebookStuff():void {
	try{
		GoViral.goViral.requestMyFacebookProfile().addRequestListener(function(e:GVFacebookEvent):void {
			if (e.type==GVFacebookEvent.FB_REQUEST_RESPONSE)
			{
				var myProfile:GVFacebookFriend=e.friends[0];
				
				fsid = myProfile.id.toString();
				
				try{
					fsemail = myProfile.email();
				}
				catch(e:Error){}
				
				try{
					fsname = myProfile.name.toString();
				}
				catch(e:Error){}
				
				try{
					fscity = myProfile.locationName.toString().substr(
						0,
						myProfile.locationName.toString().indexOf(","));
				}
				catch(e:Error){
					try{
						fscity = myProfile.properties.user_location.toString().substr(
							0,
							myProfile.properties.user_location.toString().indexOf(","));
					}
					catch(e:Error){
						
						fscity = "";
					}
					
				}
				
				try{
					fslocality = myProfile.locationName.toString().substr(
						myProfile.locationName.toString().indexOf(",")+2, 
						myProfile.locationName.toString().length);
				}
				catch(e:Error){
					try{
						fslocality = myProfile.properties.user_location.toString().substr( 
							myProfile.properties.user_location.toString().indexOf(",")+2,
							myProfile.properties.user_location.toString().length);
					}
					catch(e:Error){
						
						fslocality = "";
					}
					
				}
				
				
				
				try{
					fsgender = myProfile.gender.toString().substr(0,1);
				}
				catch(e:Error){
					fsgender = "";
				}
				
				
				var tempBirthString:String = "";
				try{
					tempBirthString = myProfile.properties["birthday"].toString();
				}
				catch(e:Error){}
				
				
				
				try{
					fsbirthmonth = tempBirthString.substr(0,tempBirthString.indexOf("/"));
					tempBirthString = tempBirthString.substring(tempBirthString.indexOf("/")+1,tempBirthString.length);
				}
				catch(e:Error){
					fsbirthmonth = "0";
				}
				
				
				try{
					fsbirthday = tempBirthString.substr(0,tempBirthString.indexOf("/"));
					tempBirthString = tempBirthString.substring(tempBirthString.indexOf("/")+1,tempBirthString.length);
				}
				catch(e:Error){
					fsbirthday = "0";
				}
				
				
				try{
					fsbirthyear = tempBirthString;
				}
				catch(e:Error){
					fsbirthyear = "0";
				}
				
				
				syncfacebook.send();			
			}
			
		});
	}
	catch(e:Error){
	
	}
	
}
public function aftersyncfacebook(ev:ResultEvent):void {
	createIfNotExsist("localuser");
	doQuery("delete FROM localuser;");
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "INSERT into localuser values(:email,:name,:city,:active)";
	stmt.parameters[":email"] = fsemail;
	stmt.parameters[":name"] = fsname;
	stmt.parameters[":city"] = fscity;
	stmt.parameters[":active"] = "yes";
	stmt.execute();
	reloadProfInfo();
	if (mainNavigator.activeView.name.toLocaleLowerCase().indexOf('sign') != -1){
		mainNavigator.pushView(Home,null,null,crosstrans);
	}
}
public function afterGetUserInfo(ev:ResultEvent):void {
	try{
		var newpicture:String = ev.result[0].ress.res.picture;
		if (newpicture.length > 1){
			profimage.source = newpicture;
			profimage.scaleMode = "zoom";
			profimage.visible = true;
		}
	}
	catch(e:Error){}
}