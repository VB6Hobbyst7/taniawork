[Bindable]
public var VERSIONID:Number = 7;
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
	
	homeitems = new ArrayCollection([{name:"Profile",img:menu_account,colorid:"0x50bcb6"},
		{name:"Home",img:menu_home,colorid:"0xef4056", selected:true},
		{name:"Restrictions",img:menu_restrictions,colorid:"0xfcb643"},
		{name:"Dishes",img:menu_dish,colorid:"0xfcb643"},
		{name:"Specials",img:menu_ratings,colorid:"0xfcb643"},
		{name:"Settings",img:menu_settings,colorid:"0xfcb643"}
	]);
	this.stage.autoOrients = false;				
	NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	verifyDataTablesViaVersion();
	createIfNotExsist("localuser");
	var resData:ArrayCollection = getDatabaseArray( "SELECT email, name, country, active FROM localuser where active = 'yes'");
	
	if (resData.length != 0){
		nameGo = resData[0].name;
		emailGo = resData[0].email;
		getUserInfo.send();
		for (var i:uint = 0; i < homeitems.length; i++){
			if (homeitems[i].name == "Profile"){
				homeitems[i].name = nameGo.charAt(0).toUpperCase()+nameGo.substring(1,nameGo.length);
			}
		}
		if (mainNavigator.navigator.firstView == null){
			if (mainNavigator.navigator.activeView == null){
				loadedview = true;
				mainNavigator.navigator.firstView = Home;
				mainNavigator.navigator.pushView(Home);	
			}
		}
		
	}
	else {
		if (mainNavigator.navigator.firstView == null){
			if (mainNavigator.navigator.activeView == null){
				loadedview = true;
				mainNavigator.navigator.firstView = Login;
				mainNavigator.navigator.pushView(Login);
			}
		}
	}	
	

	
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
public function goProfile(event:MouseEvent):void
{
	mainNavigator.navigator.pushView(Profile);
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
					//homefilterarray.push(event.currentTarget.selectedItems[i].name);
				}
				else if (event.currentTarget.selectedItems[i].name == "I Haven't Eaten"){
					if (eatinval == 0){
						eatinval = 2;
					}
					else {
						eatinval = 3;
					}
					//homefilterarray.push(event.currentTarget.selectedItems[i].name);
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
	else {
		mainNavigator.navigator.pushView(Home,{homefilterarray:homefilterarray},null,xFadeTrans);
	}
	
	var ev:MouseEvent;
	closeFilters();
	
}
public function viewadd(event:ElementExistenceEvent):void
{
	
	if (menuopen){
		closeMenu();
	}
	
	if ((mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('home') == -1)&&
		(mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('menuall') == -1)){
		listfilters.selectedItems = null;
		for (var i:uint = 0; i < filteritems.length; i++){
			filteritems[i].chosen = 'n'
		}
	}
	
	if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('profile') != -1){
		listmenu.selectedIndex = 0;
		filterfeaturebutton.visible = false;
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
		filterfeaturebutton.visible = true;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('specials') != -1){
		listmenu.selectedIndex = 4;
		filterfeaturebutton.visible = false;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('settings') != -1){
		listmenu.selectedIndex = 5;
		filterfeaturebutton.visible = false;
	}
	else if (mainNavigator.navigator.activeView.name.toLocaleLowerCase().indexOf('map') != -1){

	}
	else {
		listmenu.selectedIndex = -1;
	}

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
	doQuery("DROP TABLE merchusers");
	doQuery("DROP TABLE specials");
	doQuery("DROP TABLE localuser");
	doQuery("DROP TABLE dishes");
	if (loadedview == false){
		try{
			if (mainNavigator.navigator.activeView.title != "login"){
				mainNavigator.navigator.firstView = Login;
				mainNavigator.navigator.pushView(Login);
			}
		}
		catch(e:Error){
			mainNavigator.navigator.firstView = Login;
			mainNavigator.navigator.pushView(Login);
		}
		
	}
}