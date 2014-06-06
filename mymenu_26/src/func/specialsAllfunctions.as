import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.events.Event;
import flash.events.GeolocationEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.sensors.Geolocation;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;

import spark.collections.Sort;
import spark.collections.SortField;
import spark.core.ContentCache;
import spark.effects.Fade;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;

import views.AccountSettings;

static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var emailGo:String = "";
[Bindable]
public var nameGo:String = "";
protected var sqlConnection:SQLConnection;
[Bindable]
public var togstatus:Boolean = false;
[Bindable]
public var listData:ArrayCollection = new ArrayCollection();
[Bindable]
public var backuplistdata:ArrayCollection = new ArrayCollection();
[Bindable]
public var busy:Boolean = false;
[Bindable]
public var currentfilterweekday:String = "monday";
[Bindable]
public var locationid:String = "";
[Bindable]
public var currentselectmode:Number = 1;
[Bindable]
public var filterData1:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData2:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData3:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData4:ArrayCollection = new ArrayCollection();
public var maintimer:Timer = new Timer(5000,0);
[Bindable]
public var prefound:Boolean = false;
[Bindable]
public var mylat:Number = 53.59221;
[Bindable]
public var mylong:Number = -113.54009;
protected var g:Geolocation = new Geolocation();    

public function onActivate(event:Event):void
{
	filterData1 = new ArrayCollection();
	filterData2 = new ArrayCollection();
	filterData3 = new ArrayCollection();
	filterData4 = new ArrayCollection();
	
	filterData1.addItem({name:"Nearby"});
	filterData1.addItem({name:"Postal Code"});
	filterData1.addItem({name:"Address"});
	
	filterData2.addItem({name:"All"});
	filterData2.addItem({name:"Food"});
	filterData2.addItem({name:"Drinks"});
	filterData2.addItem({name:"Desserts"});
	
	filterData3.addItem({name:"Highest"});
	filterData3.addItem({name:"Lowest"});
	
	filterData4.addItem({name:"Highest"});
	filterData4.addItem({name:"Lowest"});
	
	
	
	warn.visible = false;
	busy = true;
	try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT email, name, country, active FROM localuser";
		stmt.execute();
		var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		
		if (resData.length != 0){
			//good login
			var foundactive:Boolean = false;
			for (var i:uint = 0; i < resData.length; i++){
				if (resData[i].active == "yes"){
					foundactive = true;
					emailGo = resData[i].email;
					nameGo = resData[i].name;
				}
			}
		}
		else {
		}
	}
	catch(e:Error){
		
	}		
	scroller.visible = true;
	
	
	
	
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "DROP TABLE specialsall";
	stmt.execute();
	
	
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS specialsall (" +
		"id int(255)," +
		"name varchar(255)," +
		"locationid int(255)," +
		"weekday varchar(255)," +
		"description longtext," +
		"business_picture varchar(255)," +
		"categoryname varchar(255)," +
		"lat varchar(255)," +
		"longa varchar(255)," +
		"distance varchar(255))";							
	stmt.execute();
	
	var doPreload:Boolean = true;
	
	
	try{
		if (doPreload == true){
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "SELECT * FROM specialsall";
			stmt.execute();
			var specialsData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
			if (specialsData.length != 0){
				backuplistdata = specialsData;
				busy = false;
				prefound = false;
				
				
				var dataSortField:SortField = new SortField();
				dataSortField.name = "distance";
				dataSortField.numeric = true;
				var numericDataSort:Sort = new Sort();
				numericDataSort.fields = [dataSortField];
				backuplistdata.sort = numericDataSort;
				backuplistdata.refresh();
				populatelist();
				
				
			}
			
			//searchClick();
		}
		else {
			listData = new ArrayCollection();
			
		}	
	}
	catch(e:Error) {
		listData = new ArrayCollection();
	}	
	
	
	
	
	
	this.setStyle("contentBackgroundColor",0xFFFFFF);
	try{
		if (Geolocation.isSupported)
		{
			g.addEventListener(GeolocationEvent.UPDATE, onUpdate);
			addEventListener(ViewNavigatorEvent.REMOVING,onRemove);	
		}
		else
		{	
			mylat = 53.55921;
			mylong = -113.54009;
		}		
	}
	catch(e:Error){
		mylat = 53.59221;
		mylong = -113.54009;
	}
	busy = true;
	try{
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT email, name, country, active FROM localuser where active = 'yes'";
		stmt.execute();
		var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (resData.length != 0){
			emailGo = resData[0].email;
		}
		else {
			emailGo = "none";
		}	
	}
	catch(e:Error) {
		emailGo = "none";
	}	
	
	maintimer = new Timer(5000,0);
	maintimer.addEventListener(TimerEvent.TIMER,aftertimer);
	maintimer.start();
	
	
	
	
	
	
	
	filterarea.visible = true;
	
	
	getSpecials.send();
	
	
}

public function afterGetSpecials(ev:ResultEvent):void {
	
	busy = false;
	var stmt:SQLStatement = new SQLStatement();
	if ((isFingerDown == false)){
		
		
		backuplistdata = new ArrayCollection();
		try{			
			backuplistdata = ev.result[0].ress.res;		
		}
		catch(e:Error){
			try{
				
				backuplistdata.addItem(ev.result[0].ress.res);
			}
			catch(e:Error){
			}
		}
		
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt2:SQLStatement = new SQLStatement();
		stmt2.sqlConnection = sqlConnection;
		stmt2.text = "delete from merchusers";
		stmt2.execute();
		
		for (var i:uint =  0; i < backuplistdata.length; i++){
			backuplistdata[i].distance = Number(getDistance(mylat,mylong,backuplistdata[i].lat,backuplistdata[i].longa));
			
			backuplistdata[i].description  = backuplistdata[i].description .replace(/'/g, "")
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "insert into specialsall values(" +
				backuplistdata[i].id+",'" +
				backuplistdata[i].name+"'," +
				backuplistdata[i].locationid+",'" +
				backuplistdata[i].weekday+"','" +
				backuplistdata[i].description+"','" +
				backuplistdata[i].business_picture+"','" +
				backuplistdata[i].categoryname+"','" +
				backuplistdata[i].lat+"','" +
				backuplistdata[i].longa+"','" +
				backuplistdata[i].distance+"')";		
			stmt.execute();
			
			
		}
		
		prefound = true;
		
		
		
		populatelist();
		
		
		
		
		
		
	}
	else {
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
} 
public function populatelist():void {
	listData = new ArrayCollection();
	var datevar:Date = new Date();
	for (var j:uint = 0; j < 7; j++){
		if (j != 0){
			datevar.setDate(datevar.getDate() + 1);
		}
		var weekdaynum:Number = datevar.day;
		var monthstring:String = datevar.toDateString().split(' ')[1];
		var daystring:String = datevar.toDateString().split(' ')[2];	
		var currentfilterweekday:String = gettextweekday(weekdaynum);
		var tempweekstring:String = currentfilterweekday.charAt(0).toUpperCase()+currentfilterweekday.substring(1,currentfilterweekday.length);
		if (j == 0){
			listData.addItem({name:"Today",description:"",
				categoryname:"",type:0,weekday:"",business_picture:""});
		}
		else {
			listData.addItem({name:tempweekstring+", "+monthstring+" "+daystring,description:"",
				categoryname:"",type:0,weekday:"",business_picture:""});
		}
		
		for (var i:uint = 0; i < backuplistdata.length; i++){
			
			
			
			
			
			if (currentselectmode == 1){
				if (backuplistdata[i].weekday == currentfilterweekday){
					backuplistdata[i].type = 1;
					listData.addItem(backuplistdata[i]);
				}	
			}
			else if (currentselectmode == 2){
				if ((backuplistdata[i].weekday == currentfilterweekday)&&(backuplistdata[i].categoryname.toLowerCase() == "food")){
					backuplistdata[i].type = 1;
					listData.addItem(backuplistdata[i]);
				}
			}
			else if (currentselectmode == 3){
				if ((backuplistdata[i].weekday == currentfilterweekday)&&(backuplistdata[i].categoryname.toLowerCase() == "drinks")){
					backuplistdata[i].type = 1;
					listData.addItem(backuplistdata[i]);
				}
			}
			else if (currentselectmode == 4){
				if ((backuplistdata[i].weekday == currentfilterweekday)&&(backuplistdata[i].categoryname.toLowerCase() == "desserts")){
					backuplistdata[i].type = 1;
					listData.addItem(backuplistdata[i]);
				}
			}
			
			
			
		}
	}
}
public function getDistance(lat1:Number, lon1:Number, lat2:Number, lon2:Number):String {
	var R1:Number = 6371; // km
	var dLat:Number = degreesToRadians(lat2-lat1);
	var dLon:Number = degreesToRadians(lon2-lon1);
	var lat1:Number = degreesToRadians(lat1);
	var lat2:Number = degreesToRadians(lat2);
	
	var a:Number = Math.sin(dLat/2) * Math.sin(dLat/2) +
		Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
	var c:Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
	var d:Number = R1 * c;
	return d.toFixed(2);
}
public function degreesToRadians(degrees:Number):Number {
	
	return degrees * Math.PI / 180;
	
}

public function radiansToDegrees(radians:Number):Number{
	
	return radians * 180 / Math.PI;	
}
public function aftertimer(ev:TimerEvent):void {
	
	if (listData.length <= 0){
		busy = true;
		getSpecials.cancel();
		//backuplistdata = new ArrayCollection();
		maintimer.removeEventListener(TimerEvent.TIMER,aftertimer);
		maintimer.stop();
		maintimer = new Timer(5000,0);
		maintimer.addEventListener(TimerEvent.TIMER,aftertimer);
		maintimer.start();
		getSpecials.send();
	}
}

public function gettextweekday(u:uint):String{
	var temps:String = "";
	if (u == 0){
		temps = "sunday";
	}
	else if (u == 1){
		temps = "monday";
	}
	else if (u == 2){
		temps = "tuesday";
	}
	else if (u == 3){
		temps = "wednesday";
	}
	else if (u == 4){
		temps = "thursday";
	}
	else if (u == 5){
		temps = "friday";
	}
	else if (u == 6){
		temps = "saturday";
	}	
	return temps;
}
public function filterNow():void
{
	/*listData.filterFunction = filterCompleted;
	listData.refresh();
	loyaltyList.dataProvider = listData;
	
	if (listData.length == 0){
	warn.visible = true;
	}
	else {
	warn.visible  = false;
	}*/
}
private function filterCompleted(item:Object):Boolean{
	if((item.weekday.toString().toLowerCase().indexOf(currentfilterweekday) != -1))
		return true;
	return false;
}
public function tOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function tOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}
public function gOver(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(000000,0.4,20,20,5,1,true);
	ev.currentTarget.filters = [gl];
}
public function gDown(ev:MouseEvent):void {
	var gl:GlowFilter = new GlowFilter(000000,0.4,20,20,5,1,true);
	ev.currentTarget.filters = [gl];
}
public function gOut(ev:MouseEvent):void {
	ev.currentTarget.filters = [];
}
public function usermenuclick():void {
	navigator.pushView(AccountSettings);
}
public function filterClick(u:uint):void {
	var fadein:Fade = new Fade();
	fadein.alphaFrom = 0;
	fadein.alphaTo = 1;
	fadein.duration = 500;
	
	var fadeout:Fade = new Fade();
	fadeout.alphaFrom = 1;
	fadeout.alphaTo = 0;
	fadeout.duration = 500;
	
	
	
	if ((currentselectmode == 1)&&(currentselectmode != u)){
		fadeout.targets = [filterimage1];
	}
	else if ((currentselectmode == 2)&&(currentselectmode != u)){
		fadeout.targets = [filterimage2];
	}
	else if ((currentselectmode == 3)&&(currentselectmode != u)){
		fadeout.targets = [filterimage3];
	}
	else if ((currentselectmode == 4)&&(currentselectmode != u)){
		fadeout.targets = [filterimage4];
	}
	
	
	
	if ((u == 1)&&(currentselectmode != u)){
		filterList1.visible = true;
		filterList2.visible = false;
		filterList3.visible = false;
		filterList4.visible = false;
		
		selectview1.alpha = 1;
		selectview2.alpha = 0;
		selectview3.alpha = 0;
		selectview4.alpha = 0;
		
		fadein.targets = [filterimage1];
		
		
		selectview1.mouseEnabled = true;
		selectview1.mouseEnabledWhereTransparent = true;
		
		selectview2.mouseEnabled = false;
		selectview2.mouseEnabledWhereTransparent = false;
		
		selectview3.mouseEnabled = false;
		selectview3.mouseEnabledWhereTransparent = false;
		
		selectview4.mouseEnabled = false;
		selectview4.mouseEnabledWhereTransparent = false;
		
	}
	else if ((u == 2)&&(currentselectmode != u)){
		filterList1.visible = false;
		filterList2.visible = true;
		filterList3.visible = false;
		filterList4.visible = false;
		
		selectview1.alpha = 0;
		selectview2.alpha = 1;
		selectview3.alpha = 0;
		selectview4.alpha = 0;
		
		fadein.targets = [filterimage2];
		
		selectview1.mouseEnabled = false;
		selectview1.mouseEnabledWhereTransparent = false;
		
		selectview2.mouseEnabled = true;
		selectview2.mouseEnabledWhereTransparent = true;
		
		selectview3.mouseEnabled = false;
		selectview3.mouseEnabledWhereTransparent = false;
		
		selectview4.mouseEnabled = false;
		selectview4.mouseEnabledWhereTransparent = false;
	}
	else if ((u == 3)&&(currentselectmode != u)){
		filterList1.visible = false;
		filterList2.visible = false;
		filterList3.visible = true;
		filterList4.visible = false;
		
		selectview1.alpha = 0;
		selectview2.alpha = 0;
		selectview3.alpha = 1;
		selectview4.alpha = 0;
		
		fadein.targets = [filterimage3];
		
		selectview1.mouseEnabled = false;
		selectview1.mouseEnabledWhereTransparent = false;
		
		selectview2.mouseEnabled = false;
		selectview2.mouseEnabledWhereTransparent = false;
		
		selectview3.mouseEnabled = true;
		selectview3.mouseEnabledWhereTransparent = true;
		
		selectview4.mouseEnabled = false;
		selectview4.mouseEnabledWhereTransparent = false;
	}
	else if ((u == 4)&&(currentselectmode != u)){
		filterList1.visible = false;
		filterList2.visible = false;
		filterList3.visible = false;
		filterList4.visible = true;
		
		selectview1.alpha = 0;
		selectview2.alpha = 0;
		selectview3.alpha = 0;
		selectview4.alpha = 1;
		
		fadein.targets = [filterimage4];
		
		selectview1.mouseEnabled = false;
		selectview1.mouseEnabledWhereTransparent = false;
		
		selectview2.mouseEnabled = false;
		selectview2.mouseEnabledWhereTransparent = false;
		
		selectview3.mouseEnabled = false;
		selectview3.mouseEnabledWhereTransparent = false;
		
		selectview4.mouseEnabled = true;
		selectview4.mouseEnabledWhereTransparent = true;
	}
	
	
	
	
	
	if (currentselectmode != u){
		fadeout.play();
		fadein.play();
		currentselectmode = u;
		populatelist();
		
	}
	
	
}


public function goFilterScreen(u:uint):void {
	if (clickingsvi == false){
		if (dropDownContainer.visible){
			//close dropdown menu
			var fadeout:Fade = new Fade();
			fadeout.alphaFrom = 1;
			fadeout.alphaTo = 0;
			fadeout.duration = 500;
			fadeout.target = dropDownContainer;
			fadeout.play();
			fadeout.addEventListener(EffectEvent.EFFECT_END, afterdrophide);
		}
		else{
			//show dropdown menu
			var fadein:Fade = new Fade();
			fadein.alphaFrom = 0;
			fadein.alphaTo = 1;
			fadein.duration = 500;
			dropDownContainer.visible = true;
			fadein.target = dropDownContainer;
			fadein.play();
		}	
	}
	else {
		clickingsvi = false;
	}
	
}
public function afterdrophide(ev:EffectEvent):void {
	dropDownContainer.visible = false;
}

public function filter1Click():void {
	if (filterList1.selectedItem.name == "Nearby"){
		svi1.visible = true;
		svi2.visible = false;
		svi3.visible = false;
	}
	else if (filterList1.selectedItem.name == "Postal Code"){
		svi1.visible = false;
		svi2.visible = true;
		svi3.visible = false;
	}
	else if (filterList1.selectedItem.name == "Address"){
		svi1.visible = false;
		svi2.visible = false;
		svi3.visible = true;
	}
	goFilterScreen(0);
	
}
public function filter2Click():void {
	sv2label.text = filterList2.selectedItem.name;
	goFilterScreen(1);
	//add filter here
}
public function filter3Click():void {
	if (filterList3.selectedItem.name == "Highest"){
		trace("1");
	}
	else if (filterList3.selectedItem.name == "Lowest"){
		trace("2");
	}
	sv3label.text = filterList3.selectedItem.name;
	goFilterScreen(2);
	
}
public function filter4Click():void {
	if (filterList4.selectedItem.name == "Highest"){
		trace("1");
	}
	else if (filterList4.selectedItem.name == "Lowest"){
		trace("2");
	}
	sv4label.text = filterList3.selectedItem.name;
	goFilterScreen(3);
	
}
public var clickingsvi:Boolean = false;
public function svilabelclick():void {
	clickingsvi = true;
	if (dropDownContainer.visible){
		//close dropdown menu
		var fadeout:Fade = new Fade();
		fadeout.alphaFrom = 1;
		fadeout.alphaTo = 0;
		fadeout.duration = 500;
		fadeout.target = dropDownContainer;
		fadeout.play();
		fadeout.addEventListener(EffectEvent.EFFECT_END, afterdrophide);
	}
}

protected function onUpdate(event:GeolocationEvent):void
{
	if (isFingerDown == false){
		mylat = event.latitude;
		mylong = event.longitude;	
		for (var i:uint=  0; i < backuplistdata.length; i++){
			backuplistdata[i].distance = Number(getDistance(mylat,mylong,backuplistdata[i].lat,backuplistdata[i].longa));
		}
		
		var dataSortField:SortField = new SortField();
		dataSortField.name = "distance";
		dataSortField.numeric = true;
		var numericDataSort:Sort = new Sort();
		numericDataSort.fields = [dataSortField];
		backuplistdata.sort = numericDataSort;
		backuplistdata.refresh();
	}
	
}	
protected function onRemove(event:ViewNavigatorEvent):void
{
	g.removeEventListener(GeolocationEvent.UPDATE, onUpdate);                
}
[Bindable]
public var isFingerDown:Boolean = false;
public function listFingerDown():void {
	isFingerDown = true;
}
public function listFingerUp():void {
	isFingerDown = false;
}