import com.facebook.graph.FacebookMobile;
import com.facebook.graph.data.FacebookAuthResponse;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.GeolocationEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.dns.AAAARecord;
import flash.sensors.Geolocation;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;
import mx.rpc.events.ResultEvent;

import spark.collections.Sort;
import spark.collections.SortField;
import spark.components.Image;
import spark.core.ContentCache;
import spark.effects.Fade;
import spark.events.IndexChangeEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.managers.PersistenceManager;
import spark.transitions.CrossFadeViewTransition;
import spark.transitions.FlipViewTransition;
import spark.transitions.FlipViewTransitionMode;
import spark.transitions.ViewTransitionDirection;

static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var alphatitle:String = "Home";
[Bindable]
public var emailGo:String = "";
[Bindable]
public var nameGo:String = "";
protected var g:Geolocation = new Geolocation();    
[Bindable]
public var specialData:ArrayCollection = new ArrayCollection();
[Bindable]
public var mylat:Number = 53.59221;
[Bindable]
public var mylong:Number = -113.54009;
[Bindable]
public var radiusOptions:ArrayCollection = new ArrayCollection();
[Bindable]
public var mysearch:String = "";
[Bindable]
public var sortMode:Number = 0;
[Bindable]
public var reverse:Boolean = false;
[Bindable]
public var locatoinidGo:Number = -1;
protected var sqlConnection:SQLConnection;
[Bindable]
public var busy:Boolean = true;
[Bindable]
public var mapUrl:String = "https://scoutcard.ca/php/specials/mobilemap.php";
[Bindable]
public var totalurl:String = mapUrl+'?mylat='+mylat+'&mylong='+mylong+'&search='+"";//key.text;
public var maintimer:Timer = new Timer(5000,0);
[Bindable]
public var currentselectmode:Number = 1;
[Bindable]
public var hfilterarray:Array = new Array();
[Bindable]
public var filterData1:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData2:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData3:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData4:ArrayCollection = new ArrayCollection();
[Bindable]
public var hfilterstring:String = "";
[Bindable]
public var filtermode:Boolean = false;
public var crosstrans:CrossFadeViewTransition = new CrossFadeViewTransition(); 
[Bindable]
public var homeitems:ArrayCollection = new ArrayCollection(
	[{label:"Restaurants",img:"../assets/backgrounds/resback.jpg",colorid:"0x50bcb6"},
		{label:"Specials",img:"../assets/backgrounds/mapback.jpg",colorid:"0xef4056"},
		{label:"Restrictions",img:"../assets/backgrounds/restback.jpg",colorid:"0xfcb643"}
	]);
private const APP_ID:String = "277005535795275";
private const FACEBOOK_APP_ORIGIN:String = "http://mymenuapp.ca/facebook";
private const PERMISSIONS:Array = ["email","user_birthday","user_location","basic_info",'read_stream', 'publish_stream'];
private var facebookWebView:StageWebView;
private var accessToken:String = "";
[Bindable]
public var facebookid:String = "";
public var sentfacebookrequest:Boolean = false;
[Bindable]
public var staticmapimageurl:String = "";
[Bindable]
public var prefound:Boolean = false;
[Bindable]
public var postalString:String = "";
[Bindable]
public var screenwidth:Number = 200;
public function onActivate(event:Event):void
{
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	try{
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT email, active FROM localuser where active = 'yes'";
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
	
	
	screenwidth = this.width;
	
	FacebookMobile.init(APP_ID, onFacebookInit);
	filterData1 = new ArrayCollection();
	filterData2 = new ArrayCollection();
	filterData3 = new ArrayCollection();
	filterData4 = new ArrayCollection();
	filterData1.addItem({name:"Nearby"});
	filterData1.addItem({name:"Postal Code"});
	filterData1.addItem({name:"Address"});
	filterData2.addItem({name:"All"});
	filterData3.addItem({name:"Highest"});
	filterData3.addItem({name:"Lowest"});
	filterData4.addItem({name:"Highest"});
	filterData4.addItem({name:"Lowest"});
	navigator.visible = true;
	
	try{
		stmt = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "DROP TABLE specials";
		stmt.execute();
	}
	catch(e:Error){
		
	}
	
	
	nofind.visible = false;
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS specials (" +
		"id int(255)," +
		"business_name longtext," +
		"business_postalcode longtext," +
		"categoryname longtext," +
		"cost float," +
		"description longtext," +
		"lat varchar(255)," +
		"longa varchar(255)," +
		"name longtext," +
		"picture longtext," +
		"rating double," +
		"divtype int," +
		"distance varchar(255))";							
	stmt.execute();
	
	var doPreload:Boolean = true;
	try{
		if (data != null){
			if (data.homefilterarray != null){
				if (data.homefilterarray.length != 0){
					doPreload = false;
				}
			}
		}
	}
	catch(e:Error){}
	
	try{
		if (doPreload == true){
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "SELECT * FROM specials";
			stmt.execute();
			var merchData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
			if (merchData.length != 0){
				specialData = merchData;
				busy = false;
				prefound = true;
				
				staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
				for (var i:uint =  0; i < specialData.length; i++){
					staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+specialData[i].lat.toString()+","+specialData[i].longa.toString();
				}
				staticmapimageurl = staticmapimageurl + "&sensor=false";
				mapimage.source = staticmapimageurl;
				mapimage.visible = true;
				
				var dataSortField:SortField = new SortField();
				dataSortField.name = "distance";
				dataSortField.numeric = true;
				var numericDataSort:Sort = new Sort();
				numericDataSort.fields = [dataSortField];
				specialData.sort = numericDataSort;
				specialData.refresh();
				menuList.dataProvider = specialData;
			}
			
			//searchClick();
		}
		else {
			specialData = new ArrayCollection();
			
		}	
	}
	catch(e:Error) {
		specialData = new ArrayCollection();
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
	
	maintimer = new Timer(5000,0);
	maintimer.addEventListener(TimerEvent.TIMER,aftertimer);
	maintimer.start();
	
	
	try{
		if (data.homefilterarray != null){
			if (data.homefilterarray != []){
				filtermode = true;
				hfilterarray = data.homefilterarray;
				for (var i:uint = 0; i < hfilterarray.length; i++){
					if (i == 0){
						hfilterstring = hfilterstring+hfilterarray;
					}
					else {
						hfilterstring = hfilterstring+","+hfilterarray;
					}
					
				}
				
			}
			else {
				filtermode = false;
			}
		}
		else {
			filtermode = false;
		}
	}
	catch(e:Error) {
		filtermode = false;
		
	}
	
	if (filtermode){
		getSpecials2.send();
	}
	else {
		getSpecials.send();
	}
	
	
	filterarea.visible = true;
	
}
private function onFacebookInit(result:Object, fail:Object):void
{
	var stop:String = "";
}
public function aftertimer(ev:TimerEvent):void {
	if (specialData.length <= 0){
		busy = true;
		getSpecials.cancel();
		//specialData = new ArrayCollection();
		maintimer.removeEventListener(TimerEvent.TIMER,aftertimer);
		maintimer.stop();
		maintimer = new Timer(5000,0);
		maintimer.addEventListener(TimerEvent.TIMER,aftertimer);
		maintimer.start();
		if (filtermode){
			getSpecials2.send();
		}
		else {
			getSpecials.send();
		}
	}
}
public function afterGetSpecials(event:ResultEvent):void
{
	nofind.visible = false;
	var diddistanceupdate:Boolean = false;
	var stmt:SQLStatement = new SQLStatement();
	if ((isFingerDown == false)){
		
		if (prefound == false){
			
			busy = false;
			var i:uint = 0;
			specialData = new ArrayCollection();
			try{			
				specialData = event.result[0].ress.res;		
			}
			catch(e:Error){
				try{
					
					
					specialData.addItem(event.result[0].ress.res);
				}
				catch(e:Error){
				}
			}
			
			staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
			var usedlocationarray:Array = new Array();
			for (i=  0; i < specialData.length; i++){
				var goodlocationid:Boolean = true;
				for (var j:uint = 0; j < usedlocationarray.length; j++){
					if (usedlocationarray[j] == specialData[i].locationid){
						goodlocationid = false;
					}
				}
				if (goodlocationid){
					specialData[i].distance = Number(getDistance(mylat,mylong,specialData[i].lat,specialData[i].longa));
					staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+specialData[i].lat.toString()+","+specialData[i].longa.toString();
					usedlocationarray.push(specialData[i].locationid);
				}
				
			}
			diddistanceupdate = true;
			staticmapimageurl = staticmapimageurl + "&sensor=false";
			mapimage.source = staticmapimageurl;
			mapimage.visible = true;
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "distance";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			specialData.sort = numericDataSort;
			specialData.refresh();
			
			if (specialData.length > 0){
				sqlConnection = new SQLConnection();
				sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
				var stmt2:SQLStatement = new SQLStatement();
				stmt2.sqlConnection = sqlConnection;
				stmt2.text = "delete from specials";
				stmt2.execute();
				prefound = false;
				for (i = 0; i < specialData.length; i++){
					specialData[i].description  = specialData[i].description .replace(/'/g, "");
					specialData[i].business_name  = specialData[i].business_name .replace(/'/g, "");
					specialData[i].categoryname  = specialData[i].categoryname .replace(/'/g, "");
					specialData[i].name  = specialData[i].name .replace(/'/g, "");
					stmt = new SQLStatement();
					stmt.sqlConnection = sqlConnection;
					
					
					stmt.text = "insert into specials values(" +
						specialData[i].id+",'" +
						specialData[i].business_name+"','" +
						specialData[i].business_postalcode+"','" +
						specialData[i].categoryname+"'," +
						specialData[i].cost+",'" +
						specialData[i].description+"','" +
						specialData[i].lat+"','" +
						specialData[i].longa+"','" +
						specialData[i].name+"','" +
						specialData[i].picture+"'," +
						specialData[i].rating+"," +
						specialData[i].divtype+",'" +
						specialData[i].distance+"')";		
					stmt.execute();
				}
				
			}
			populatelist(0);
		}
		else {
			var templistData:ArrayCollection = new ArrayCollection();
			try{			
				templistData = event.result[0].ress.res;
				for (i=  0; i < templistData.length; i++){
					templistData[i].distance = Number(getDistance(mylat,mylong,templistData[i].lat,templistData[i].longa));
				}
				diddistanceupdate = true;
			}
			catch(e:Error){
				try{
					templistData.addItem(event.result[0].ress.res);
					templistData[0].distance = Number(getDistance(mylat,mylong,templistData[0].lat,templistData[0].longa));
				}
				catch(e:Error){
				}
				diddistanceupdate = true;
			}
			
			if (templistData.length > 0){
				
				stmt = new SQLStatement();
				sqlConnection = new SQLConnection();
				sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
				var stmt3:SQLStatement = new SQLStatement();
				stmt3.sqlConnection = sqlConnection;
				stmt3.text = "delete from specials";
				stmt3.execute();
				for (var j:uint = 0; j < templistData.length; j++){
					templistData[j].description  = templistData[j].description .replace(/'/g, "");
					templistData[j].business_name  = templistData[j].business_name .replace(/'/g, "");
					templistData[j].categoryname  = templistData[j].categoryname .replace(/'/g, "");
					templistData[j].name  = templistData[j].name .replace(/'/g, "");
					
					stmt = new SQLStatement();
					stmt.sqlConnection = sqlConnection;
					stmt.text = "insert into specials values(" +
						templistData[j].id+",'" +
						templistData[j].business_name+"','" +
						templistData[j].business_postalcode+"','" +
						templistData[j].categoryname+"'," +
						templistData[j].cost+",'" +
						templistData[j].description+"','" +
						templistData[j].lat+"','" +
						templistData[j].longa+"','" +
						templistData[j].name+"','" +
						templistData[j].picture+"'," +
						templistData[j].rating+"," +
						templistData[j].divtype+",'" +
						templistData[j].distance+"')";		
					stmt.execute();
				}
				//specialData = new ArrayCollection();
				specialData = templistData;
				populatelist(0);
				
			}
		}
		
		if (diddistanceupdate == false){
			for (i=  0; i < specialData.length; i++){
				specialData[i].distance = Number(getDistance(mylat,mylong,specialData[i].lat,specialData[i].longa));
			}
			populatelist(0);
		}
		
	}
	generateCategoryFilterArray();
	
} 

public function afterGetSpecialsFilter(event:ResultEvent):void
{
	nofind.visible = false;
	busy = false;
	var i:uint = 0;
	specialData = new ArrayCollection();
	try{			
		specialData = event.result[0].ress.res;		
	}
	catch(e:Error){
		try{
			
			specialData.addItem(event.result[0].ress.res);
		}
		catch(e:Error){
			
		}
	}
	if (specialData.length > 0){
		staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
		var usedlocationarray:Array = new Array();
		for (i=  0; i < specialData.length; i++){
			var goodlocationid:Boolean = true;
			for (var j:uint = 0; j < usedlocationarray.length; j++){
				if (usedlocationarray[j] == specialData[i].locationid){
					goodlocationid = false;
				}
			}
			if (goodlocationid){
				specialData[i].distance = Number(getDistance(mylat,mylong,specialData[i].lat,specialData[i].longa));
				staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+specialData[i].lat.toString()+","+specialData[i].longa.toString();
				usedlocationarray.push(specialData[i].locationid);
			}
			
		}
		staticmapimageurl = staticmapimageurl + "&sensor=false";
		mapimage.source = staticmapimageurl;
		mapimage.visible = true;
		
		
		var dataSortField:SortField = new SortField();
		dataSortField.name = "distance";
		dataSortField.numeric = true;
		var numericDataSort:Sort = new Sort();
		numericDataSort.fields = [dataSortField];
		specialData.sort = numericDataSort;
		specialData.refresh();
		
		populatelist(0);
	}
	else {
		mapimage.visible = false;
		nofind.visible = true;
	}
	
	
} 

public function generateCategoryFilterArray():void {
	var tempfilter2:ArrayCollection = new ArrayCollection();
	if (specialData.length > 0){
		for (var i:uint =  0; i < specialData.length; i++){
			var tempfail:Boolean = false;
			for (var j:uint = 0; j < tempfilter2.length; j++){
				if (tempfilter2[j].name == specialData[i].categoryname){
					tempfail = true;
				}
			}
			if (tempfail == false){
				tempfilter2.addItem({name:specialData[i].categoryname});
			}
			
		}
	}
	
	var filtercatsf:SortField = new SortField();
	filtercatsf.name = "name";
	filtercatsf.numeric = false;
	var fcst:Sort = new Sort();
	fcst.fields = [filtercatsf];
	tempfilter2.sort = fcst;
	tempfilter2.refresh();
	
	
	filterData2 = new ArrayCollection();
	filterData2.addItem({name:"All"});
	for (var k:uint = 0; k < tempfilter2.length; k++){
		filterData2.addItem({name:tempfilter2[k].name});
	}
}
public function populatelist(u:uint):void {
	var srt:Sort = new Sort();
	if (currentselectmode == 1){
		srt.fields = [new SortField("distance")];
		specialData.sort = srt;
		specialData.refresh();
		for (var i:uint = 0; i < specialData.length; i++){
			specialData[i].divtype = 0;
		}
	}
	else if (currentselectmode == 2){
		srt.fields = [new SortField("categoryname")];
		specialData.sort = srt;
		specialData.refresh();
		var lastcat:String = "";
		for (var i:uint = 0; i < specialData.length; i++){
			if ((specialData[i].categoryname.toLowerCase() != lastcat)||(lastcat == "")){
				specialData[i].divtype = 1;
			}
			else {
				specialData[i].divtype = 0;
				
			}
			lastcat = specialData[i].categoryname.toLowerCase();
		}
	}
	else if (currentselectmode == 3){
		
		
		srt.fields = [new SortField("rating",!reverse,true)];
		specialData.sort = srt;
		specialData.refresh();
		for (var i:uint = 0; i < specialData.length; i++){
			specialData[i].divtype = 0;
		}
	}
	else if (currentselectmode == 4){
		
		srt.fields = [new SortField("cost",!reverse,true)];
		specialData.sort = srt;
		specialData.refresh();
		for (var i:uint = 0; i < specialData.length; i++){
			specialData[i].divtype = 0;
		}
	}
	menuList.dataProvider = specialData;
	if (u == 0){
		generateCategoryFilterArray();
	}
	
	
}
public function press(event:KeyboardEvent):void {
	searchClick();
}
public function postalpress(event:KeyboardEvent):void {
	var tempText:String = svi2.text;
	var rex:RegExp = /[\s\r\n]*/gim;
	var dashes:RegExp = /-/gi; // match "dashes" in a string
	tempText = tempText.replace(rex,'');
	tempText = tempText.replace(dashes,'');
	
	if (tempText.length == 6){
		postalString = tempText;
		getSpecialsPostal.send();
	}
	else {
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT * FROM specials";
		stmt.execute();
		var merchData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (merchData.length != 0){
			specialData = merchData;
			busy = false;
			prefound = true;
			
			staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
			for (var i:uint =  0; i < specialData.length; i++){
				staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+specialData[i].lat.toString()+","+specialData[i].longa.toString();
			}
			staticmapimageurl = staticmapimageurl + "&sensor=false";
			mapimage.source = staticmapimageurl;
			mapimage.visible = true;
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "distance";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			specialData.sort = numericDataSort;
			specialData.refresh();
			menuList.dataProvider = specialData;
		}
	}
}

public function addressPress(event:KeyboardEvent):void {
	var tempText:String = svi3.text;
	if (tempText.length >= 6){
		postalString = tempText;
		getSpecialsPostal.send();
	}
	else {
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT * FROM specials";
		stmt.execute();
		var merchData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (merchData.length != 0){
			specialData = merchData;
			busy = false;
			prefound = true;
			
			staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
			for (var i:uint =  0; i < specialData.length; i++){
				staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+specialData[i].lat.toString()+","+specialData[i].longa.toString();
			}
			staticmapimageurl = staticmapimageurl + "&sensor=false";
			mapimage.source = staticmapimageurl;
			mapimage.visible = true;
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "distance";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			specialData.sort = numericDataSort;
			specialData.refresh();
			menuList.dataProvider = specialData;
		}
	}
}
public function afterGetSpecialsPostal(ev:ResultEvent):void {
	busy = false;
	var tempstring:String = ev.result[0].toString();
	tempstring = tempstring.substring(tempstring.indexOf("lat")+3,tempstring.length);
	tempstring = tempstring.substring(tempstring.indexOf(">")+2,tempstring.length);
	var newlat:String = tempstring.substring(0,tempstring.indexOf("\n"));
	
	tempstring = tempstring.substring(tempstring.indexOf("long")+3,tempstring.length);
	tempstring = tempstring.substring(tempstring.indexOf(">")+2,tempstring.length);
	var newlong:String = tempstring.substring(0,tempstring.indexOf("\n"));
	var i:uint = 0;
	for (i =  0; i < specialData.length; i++){
		
		specialData[i].distance = Number(getDistance(Number(newlat),Number(newlong),specialData[i].lat,specialData[i].longa));
	}
	specialData.refresh();
	populatelist(0);
	
	
	for (i =  0; i < specialData.length; i++){
		
		specialData[i].distance = Number(getDistance(Number(newlat),Number(newlong),specialData[i].lat,specialData[i].longa));
	}
	specialData.refresh();
	populatelist(0);
}
public function searchClick():void
{
	specialData.filterFunction = filterCompleted;
	specialData.refresh();
	menuList.dataProvider = specialData;
}
private function filterCompleted(item:Object):Boolean{
	if((item.name.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
		(item.description.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
		(item.categoryname.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1))
		return true;
	return false;
}
private function onViewDeactivate():void {
	this.parentApplication.map.infoWindow.hide();
	this.parentApplication.disableTraffic();
}
public var goingtonext:Boolean = false;
public function menuListClick():void {	
	if (goingtonext == false){
		goingtonext = true;
		if (menuList.selectedIndex != -1){
			try{
				data.homefilterarray = [];
			}
			catch(e:Error){}
			navigator.pushView(MenuDescription, specialData[menuList.selectedIndex]);	
			//navigator.pushView(StoresDescription, specialData[menuList.selectedIndex]);	
		}
		else {
			goingtonext = false;
		}
	}
}
private function returnall(item:Object):Boolean{
	return true;
}
public var didupdate:Boolean = false;
protected function onUpdate(event:GeolocationEvent):void
{
	if (didupdate == false){
		didupdate = true;
		if (isFingerDown == false){
			mylat = event.latitude;
			mylong = event.longitude;	
			for (var i:uint=  0; i < specialData.length; i++){
				specialData[i].distance = Number(getDistance(mylat,mylong,specialData[i].lat,specialData[i].longa));
			}
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "distance";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			specialData.sort = numericDataSort;
			specialData.refresh();
		}
	}
}	
protected function onRemove(event:ViewNavigatorEvent):void
{
	g.removeEventListener(GeolocationEvent.UPDATE, onUpdate);                
}
public function tOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function tOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}
public function profDown(ev:MouseEvent):void {
	ev.currentTarget.alpha = 0.5;
}
public function profUp(ev:MouseEvent):void {
	ev.currentTarget.alpha = 1;
}
public function gOver(ev:MouseEvent):void {
	ev.currentTarget.alpha = 0.5;
}
public function gDown(ev:MouseEvent):void {
	ev.currentTarget.alpha = 0.5;
}
public function gOut(ev:MouseEvent):void {
	ev.currentTarget.alpha = 1;
}
public function goback(ev:MouseEvent):void {
	navigator.popView();
}
public function degreesToRadians(degrees:Number):Number {
	return degrees * Math.PI / 180;
}

public function radiansToDegrees(radians:Number):Number{
	return radians * 180 / Math.PI;	
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
public function usermenuclick():void {
	try{
		data.homefilterarray = [];
	}
	catch(e:Error){}
	navigator.pushView(AccountSettings);
}
public function logout():void {
	try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "update localuser set active = 'no' where email = '"+emailGo+"'";
		stmt.execute();
		emailGo = "";
		nameGo = "";
		var saveManager:PersistenceManager = new PersistenceManager();
		saveManager.setProperty("useremail", "ERRORBADERRORBAD");
		try{
			data.homefilterarray = [];
		}
		catch(e:Error){}
		navigator.pushView(Login);
	}
	catch(e:Error){
		try{
			data.homefilterarray = [];
		}
		catch(e:Error){}
		navigator.pushView(Login);
	}
}
public function filterClick(u:uint):void {
	specialData.filterFunction = allFilter;
	specialData.refresh();
	menuList.dataProvider = specialData;
	
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
		populatelist(0);
		
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
		for (var i:uint =  0; i < specialData.length; i++){
			specialData[i].distance = Number(getDistance(mylat,mylong,specialData[i].lat,specialData[i].longa));
		}
		populatelist(0);
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
	specialData.filterFunction = catFilter;
	specialData.refresh();
	menuList.dataProvider = specialData;
	//add filter here
	populatelist(1);
}
private function allFilter(item:Object):Boolean{
	return true;
}
private function catFilter(item:Object):Boolean{
	if (sv2label.text.toLowerCase() == "all"){
		return true;
	}
	else {
		if((item.categoryname.toString().toLowerCase().indexOf(	sv2label.text.toLowerCase()) != -1)){
			return true;
		}	
	}
	return false;
}
public function filter3Click():void {
	if (filterList3.selectedItem.name == "Highest"){
		
		currentselectmode = 3;
		reverse = false;
	}
	else if (filterList3.selectedItem.name == "Lowest"){
		
		currentselectmode = 3;
		reverse = true;
	}
	populatelist(0);
	sv3label.text = filterList3.selectedItem.name;
	goFilterScreen(2);
	
}
public function filter4Click():void {
	if (filterList4.selectedItem.name == "Highest"){
		
		currentselectmode = 4;
		reverse = false;
	}
	else if (filterList4.selectedItem.name == "Lowest"){
		
		currentselectmode = 4;
		reverse = true;
	}
	populatelist(0);
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

public function mapimageclick():void {
	var doMove:Boolean = true;
	
	try{
		if (data.moving == true){
			doMove = false;
		}
	}
	catch(e:Error){
		
	}
	if ((specialData.length > 0)&&(doMove)){
		try{
			data.homefilterarray = [];
		}
		catch(e:Error){}
		navigator.pushView(FullMap,{specialData:specialData});
	}
}
[Bindable]
public var isFingerDown:Boolean = false;
public function listFingerDown():void {
	isFingerDown = true;
}
public function listFingerUp():void {
	isFingerDown = false;
}