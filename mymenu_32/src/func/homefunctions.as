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
public var homeData:ArrayCollection = new ArrayCollection();
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
public var mapUrl:String = "https://scoutcard.ca/php/locations/mobilemap.php";
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
	screenwidth = this.width;
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
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
	showloading();
	/*
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "DROP TABLE merchusers";
	stmt.execute();*/
	
	nofind.visible = false;
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS merchusers (" +
		"id int(255)," +
		"business_name varchar(255)," +
		"business_number varchar(255)," +
		"business_description longtext," +
		"business_picture varchar(255)," +
		"business_address1 longtext," +
		"business_city varchar(255)," +
		"business_locality varchar(255)," +
		"business_postalcode varchar(255)," +
		"business_country varchar(255)," +
		"lat varchar(255)," +
		"longa varchar(255)," +
		"facebook varchar(255)," +
		"twitter varchar(255)," +
		"website varchar(255)," +
		"rating double," +
		"ratingcount int," +
		"categoryname varchar(255)," +
		"price float," +
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
			stmt.text = "SELECT * FROM merchusers";
			stmt.execute();
			var merchData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
			if (merchData.length != 0){
				homeData = merchData;
				//hideloading();
				prefound = true;
				
				staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
				for (var i:uint =  0; i < homeData.length; i++){
					staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+homeData[i].lat.toString()+","+homeData[i].longa.toString();
				}
				staticmapimageurl = staticmapimageurl + "&sensor=false";
				mapimage.source = staticmapimageurl;
				mapimage.visible = true;
				
				var dataSortField:SortField = new SortField();
				dataSortField.name = "distance";
				dataSortField.numeric = true;
				var numericDataSort:Sort = new Sort();
				numericDataSort.fields = [dataSortField];
				homeData.sort = numericDataSort;
				homeData.refresh();
				storeList.dataProvider = homeData;
				hideloading();
			}
			
			//searchClick();
		}
		else {
			homeData = new ArrayCollection();
			
		}	
	}
	catch(e:Error) {
		homeData = new ArrayCollection();
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
	
	
	try{
		if (data.homefilterarray != null){
			if (data.homefilterarray != []){
				
				hfilterarray = data.homefilterarray;
				for (var i:uint = 0; i < hfilterarray.length; i++){
					if (i == 0){
						filtermode = true;
						hfilterstring = hfilterstring+hfilterarray;
					}
					else {
						filtermode = true;
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
		getLocations2.send();
	}
	else {
		getLocations.send();
	}
	
	
	filterarea.visible = true;
	
}
private function onFacebookInit(result:Object, fail:Object):void
{
	var stop:String = "";
}
public function aftertimer(ev:TimerEvent):void {
	if (homeData.length <= 0){
		showloading();
		getLocations.cancel();
		//homeData = new ArrayCollection();
		maintimer.removeEventListener(TimerEvent.TIMER,aftertimer);
		maintimer.stop();
		maintimer = new Timer(5000,0);
		maintimer.addEventListener(TimerEvent.TIMER,aftertimer);
		maintimer.start();
		if (filtermode){
			getLocations2.send();
		}
		else {
			getLocations.send();
		}
	}
}
public function afterGetLocations(event:ResultEvent):void
{
	hideloading();
	nofind.visible = false;
	var diddistanceupdate:Boolean = false;
	var stmt:SQLStatement = new SQLStatement();
	if ((isFingerDown == false)){
		
		if (prefound == false){
			
			hideloading();
			var i:uint = 0;
			homeData = new ArrayCollection();
			try{			
				homeData = event.result[0].ress.res;		
			}
			catch(e:Error){
				try{
					
					
					homeData.addItem(event.result[0].ress.res);
				}
				catch(e:Error){
				}
			}
			
			staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
			for (i=  0; i < homeData.length; i++){
				homeData[i].distance = Number(getDistance(mylat,mylong,homeData[i].lat,homeData[i].longa));
				staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+homeData[i].lat.toString()+","+homeData[i].longa.toString();
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
			homeData.sort = numericDataSort;
			homeData.refresh();
			
			if (homeData.length > 0){
				sqlConnection = new SQLConnection();
				sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
				var stmt2:SQLStatement = new SQLStatement();
				stmt2.sqlConnection = sqlConnection;
				stmt2.text = "delete from merchusers";
				stmt2.execute();
				prefound = false;
				for (i = 0; i < homeData.length; i++){
					homeData[i].business_description  = homeData[i].business_description .replace(/'/g, "")
					stmt = new SQLStatement();
					stmt.sqlConnection = sqlConnection;
					stmt.text = "insert into merchusers values(" +
						homeData[i].id+",'" +
						homeData[i].business_name+"','" +
						homeData[i].business_number+"','" +
						homeData[i].business_description+"','" +
						homeData[i].business_picture+"','" +
						homeData[i].business_address1+"','" +
						homeData[i].business_city+"','" +
						homeData[i].business_locality+"','" +
						homeData[i].business_postalcode+"','" +
						homeData[i].business_country+"','" +
						homeData[i].lat+"','" +
						homeData[i].longa+"','" +
						homeData[i].facebook+"','" +
						homeData[i].twitter+"','" +
						homeData[i].website+"'," +
						homeData[i].rating+"," +
						homeData[i].ratingcount+",'" +	
						homeData[i].categoryname+"'," +
						homeData[i].price+",'" +
						homeData[i].distance+"')";		
					stmt.execute();
				}
				
			}
			populatelist();
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
				stmt3.text = "delete from merchusers";
				stmt3.execute();
				for (var j:uint = 0; j < templistData.length; j++){
					templistData[j].business_description  = templistData[j].business_description .replace(/'/g, "")
					
					stmt = new SQLStatement();
					stmt.sqlConnection = sqlConnection;
					stmt.text = "insert into merchusers values(" +
						templistData[j].id+",'" +
						templistData[j].business_name+"','" +
						templistData[j].business_number+"','" +
						templistData[j].business_description+"','" +
						templistData[j].business_picture+"','" +
						templistData[j].business_address1+"','" +
						templistData[j].business_city+"','" +
						templistData[j].business_locality+"','" +
						templistData[j].business_postalcode+"','" +
						templistData[j].business_country+"','" +
						templistData[j].lat+"','" +
						templistData[j].longa+"','" +
						templistData[j].facebook+"','" +
						templistData[j].twitter+"','" +
						templistData[j].website+"'," +
						templistData[j].rating+"," +
						templistData[j].ratingcount+",'" +	
						templistData[j].categoryname+"'," +
						templistData[j].price+",'" +
						templistData[j].distance+"')";		
					stmt.execute();
				}
				//homeData = new ArrayCollection();
				homeData = templistData;
				populatelist();
				
			}
		}
		
		if (diddistanceupdate == false){
			for (i=  0; i < homeData.length; i++){
				homeData[i].distance = Number(getDistance(mylat,mylong,homeData[i].lat,homeData[i].longa));
			}
			populatelist();
		}
		
	}
	generateCategoryFilterArray();
	
} 

public function afterGetLocationsFilter(event:ResultEvent):void
{
	hideloading();
	nofind.visible = false;
	hideloading();
	var i:uint = 0;
	homeData = new ArrayCollection();
	try{			
		homeData = event.result[0].ress.res;		
	}
	catch(e:Error){
		try{
			
			homeData.addItem(event.result[0].ress.res);
		}
		catch(e:Error){
			
		}
	}
	if (homeData.length > 0){
		staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
		
		for (i=  0; i < homeData.length; i++){
			homeData[i].distance = Number(getDistance(mylat,mylong,homeData[i].lat,homeData[i].longa));
			staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+homeData[i].lat.toString()+","+homeData[i].longa.toString();
			
		}
		staticmapimageurl = staticmapimageurl + "&sensor=false";
		mapimage.source = staticmapimageurl;
		mapimage.visible = true;
		
		
		var dataSortField:SortField = new SortField();
		dataSortField.name = "distance";
		dataSortField.numeric = true;
		var numericDataSort:Sort = new Sort();
		numericDataSort.fields = [dataSortField];
		homeData.sort = numericDataSort;
		homeData.refresh();
		
		populatelist();
	}
	else {
		mapimage.visible = false;
		nofind.visible = true;
	}
	
	
} 

public function generateCategoryFilterArray():void {
	var tempfilter2:ArrayCollection = new ArrayCollection();
	if (homeData.length > 0){
		for (var i:uint =  0; i < homeData.length; i++){
			var tempfail:Boolean = false;
			for (var j:uint = 0; j < tempfilter2.length; j++){
				if (tempfilter2[j].name == homeData[i].categoryname){
					tempfail = true;
				}
			}
			if (tempfail == false){
				tempfilter2.addItem({name:homeData[i].categoryname});
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
	for (var k:uint = 0; k < tempfilter2.length; k++){
		filterData2.addItem({name:tempfilter2[k].name});
	}
}
public function populatelist():void {
	var srt:Sort = new Sort();
	if (currentselectmode == 1){
		srt.fields = [new SortField("distance")];
		homeData.sort = srt;
		homeData.refresh();
	}
	else if (currentselectmode == 2){
		srt.fields = [new SortField("categoryname")];
		homeData.sort = srt;
		homeData.refresh();
	}
	else if (currentselectmode == 3){
		
		
		srt.fields = [new SortField("rating",!reverse,true)];
		homeData.sort = srt;
		homeData.refresh();
	}
	else if (currentselectmode == 4){
		
		srt.fields = [new SortField("price",!reverse,true)];
		homeData.sort = srt;
		homeData.refresh();
	}
	storeList.dataProvider = homeData;
	generateCategoryFilterArray();
	
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
		getLocationsPostal.send();
		showloading();
	}
	else {
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT * FROM merchusers";
		stmt.execute();
		var merchData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (merchData.length != 0){
			homeData = merchData;
			hideloading();
			prefound = true;
			
			staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
			for (var i:uint =  0; i < homeData.length; i++){
				staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+homeData[i].lat.toString()+","+homeData[i].longa.toString();
			}
			staticmapimageurl = staticmapimageurl + "&sensor=false";
			mapimage.source = staticmapimageurl;
			mapimage.visible = true;
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "distance";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			homeData.sort = numericDataSort;
			homeData.refresh();
			storeList.dataProvider = homeData;
		}
	}
}

public function addressPress(event:KeyboardEvent):void {
	var tempText:String = svi3.text;
	if (tempText.length >= 6){
		postalString = tempText;
		getLocationsPostal.send();
		showloading();
	}
	else {
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT * FROM merchusers";
		stmt.execute();
		var merchData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (merchData.length != 0){
			homeData = merchData;
			hideloading();
			prefound = true;
			
			staticmapimageurl = "http://maps.googleapis.com/maps/api/staticmap?size="+this.width.toString()+"x"+Math.round((this.height/3.3)).toString()+"&maptype=roadmap";
			for (var i:uint =  0; i < homeData.length; i++){
				staticmapimageurl = staticmapimageurl + "&markers=color:green%7Clabel:"+i.toString()+"%7C"+homeData[i].lat.toString()+","+homeData[i].longa.toString();
			}
			staticmapimageurl = staticmapimageurl + "&sensor=false";
			mapimage.source = staticmapimageurl;
			mapimage.visible = true;
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "distance";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			homeData.sort = numericDataSort;
			homeData.refresh();
			storeList.dataProvider = homeData;
		}
	}
}
public function afterGetLocationsPostal(ev:ResultEvent):void {
	hideloading();
	var tempstring:String = ev.result[0].toString();
	tempstring = tempstring.substring(tempstring.indexOf("lat")+3,tempstring.length);
	tempstring = tempstring.substring(tempstring.indexOf(">")+2,tempstring.length);
	var newlat:String = tempstring.substring(0,tempstring.indexOf("\n"));
	
	tempstring = tempstring.substring(tempstring.indexOf("long")+3,tempstring.length);
	tempstring = tempstring.substring(tempstring.indexOf(">")+2,tempstring.length);
	var newlong:String = tempstring.substring(0,tempstring.indexOf("\n"));
	var i:uint = 0;
	for (i =  0; i < homeData.length; i++){
		
		homeData[i].distance = Number(getDistance(Number(newlat),Number(newlong),homeData[i].lat,homeData[i].longa));
	}
	homeData.refresh();
	populatelist();
	
	
	for (i =  0; i < homeData.length; i++){
		
		homeData[i].distance = Number(getDistance(Number(newlat),Number(newlong),homeData[i].lat,homeData[i].longa));
	}
	homeData.refresh();
	populatelist();
}
public function searchClick():void
{
	homeData.filterFunction = filterCompleted;
	homeData.refresh();
	storeList.dataProvider = homeData;
}
private function filterCompleted(item:Object):Boolean{
	if((item.business_name.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
		(item.business_description.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
		(item.categoryname.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1))
		return true;
	return false;
}
private function onViewDeactivate():void {
}
public var goingtonext:Boolean = false;
public function storeListClick():void {	
	if (goingtonext == false){
		goingtonext = true;
		if (storeList.selectedIndex != -1){
			try{
				data.homefilterarray = [];
			}
			catch(e:Error){}
			navigator.pushView(StoresDescription, homeData[storeList.selectedIndex]);	
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
			for (var i:uint=  0; i < homeData.length; i++){
				homeData[i].distance = Number(getDistance(mylat,mylong,homeData[i].lat,homeData[i].longa));
			}
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "distance";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			homeData.sort = numericDataSort;
			homeData.refresh();
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
	homeData.filterFunction = allFilter;
	homeData.refresh();
	storeList.dataProvider = homeData;
	
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
		for (var i:uint =  0; i < homeData.length; i++){
			homeData[i].distance = Number(getDistance(mylat,mylong,homeData[i].lat,homeData[i].longa));
		}
		populatelist();
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
	homeData.filterFunction = catFilter;
	homeData.refresh();
	storeList.dataProvider = homeData;
	//add filter here
	
}
private function allFilter(item:Object):Boolean{
	return true;
}
private function catFilter(item:Object):Boolean{
	if((item.categoryname.toString().toLowerCase().indexOf(	sv2label.text.toLowerCase()) != -1))
		return true;
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
	populatelist();
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
	populatelist();
	sv4label.text = filterList4.selectedItem.name;
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
	if ((homeData.length > 0)&&(doMove)){
		try{
			data.homefilterarray = [];
		}
		catch(e:Error){}
		navigator.pushView(FullMap,{homeData:homeData});
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