import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.html.HTMLLoader;
import flash.net.URLRequest;
import flash.sensors.Geolocation;	
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.effects.Fade;
import mx.effects.effectClasses.FadeInstance;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;
import mx.rpc.events.ResultEvent;
import spark.components.supportClasses.StyleableTextField;
import spark.core.ContentCache;
import spark.events.IndexChangeEvent;
import spark.events.ListEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var actions:ArrayCollection;
[Bindable]
private var _data:Object;
[Bindable]
private var _addrString:String;
[Bindable]
private var _distString:String;
[Bindable]
public var googleTravelUrl:String = "";
protected var g:Geolocation = new Geolocation();    
[Bindable]
public var frontview:Boolean = true;
[Bindable]
public var listData:ArrayCollection = new ArrayCollection();
[Bindable]
public var locationType:String = "1";
[Bindable]
public var currentSelectedLocationName:String = "";
[Bindable]
public var currentSelectedWaitTime:String = "7 min";
[Bindable]
public var currentSelectedAddress:String = "";
[Bindable]
public var mylat:Number = 53.59221;
[Bindable]
public var mylong:Number = -113.54009;
[Bindable]
public var myradius:Number = 50;
[Bindable]
public var radiusOptions:ArrayCollection = new ArrayCollection();
[Bindable]
public var mysearch:String = "";
[Bindable]
public var sortMode:Number = 0;
[Bindable]
public var reverse:Boolean = false;
[Bindable]
public var emailGo:String = "none";
[Bindable]
public var locatoinidGo:Number = -1;
protected var sqlConnection:SQLConnection;
[Bindable]
public var busy:Boolean = true;
[Bindable]
public var mapUrl:String = "http://simplipay.ca/php/locations/mobilemap.php";
[Bindable]
public var totalurl:String = mapUrl+'?mylat='+mylat+'&mylong='+mylong+'&search='+"johnson";//key.text;
protected function view1_activateHandler(event:Event):void
{
	try{
		locationType = "1";
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
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
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
	getLocations.send();
}	

public function afterGetLocations(event:ResultEvent):void
{
	busy = false;
	listData = new ArrayCollection();
	try{			
		listData = event.result[0].ress.res;		
	}
	catch(e:Error){
		try{
			
			listData.addItem(event.result[0].ress.res);
		}
		catch(e:Error){
			//listData.addItem({name:"error",id:1,address:"error",tagline:"error",distance:0});
		}
	}
	sortPress(sortMode);
	searchClick();
	if (listData.length == 0){
		//listData.addItem({name:"error",id:1,address:"error",tagline:"error",distance:0});
	}
} 
public function storeListClick():void {	
	var stop:String = "";
	if (storeList.selectedIndex != -1){
		var id:String = listData[storeList.selectedIndex].id;
		var lat:Number = Number(listData[storeList.selectedIndex].lat);
		var long:Number = Number(listData[storeList.selectedIndex].long);
		
		
		var waittimeText:String = (listData[storeList.selectedIndex].distance).toString();
		if (waittimeText.length > 4){
			waittimeText = waittimeText.substr(0,4);
		}
		currentSelectedWaitTime = waittimeText+" km";
		navigator.pushView(itemDescription, listData[storeList.selectedIndex]);	
		
	}
}
public function clickSortDrop():void {
	sortBTN.openDropDown();
}
public function sortPress(u:uint):void {
	sortBTN.closeDropDown();
	var dataSortField:mx.collections.SortField = new mx.collections.SortField();
	var dataSortField2:mx.collections.SortField = new mx.collections.SortField();
	var dataSortField3:mx.collections.SortField = new mx.collections.SortField();
	var numericDataSort:Sort = new Sort();
	var stringDataSort:Sort = new Sort();
	
	
	if (sortMode == u){
		if (reverse){
			reverse = false;
		}
		else {
			reverse = true;
		}
	}
	else {
		reverse = false;
	}
	
	
	dataSortField.descending = reverse;
	dataSortField2.descending = reverse;
	dataSortField3.descending = reverse;
	
	
	
	sortMode = u;
	
	
	if (u == 0){
		dataSortField.name = "name";
		dataSortField.numeric = false;
		stringDataSort.fields = [dataSortField];
		listData.sort = stringDataSort;
	}
	else if (u == 1){
		dataSortField.name = "distance";
		dataSortField.numeric = true;
		
		numericDataSort.fields = [dataSortField];
		listData.sort = numericDataSort;
		
	}
	
	listData.refresh();
	storeList.dataProvider = listData;
}
public function searchClick():void
{
	
		listData.filterFunction = filterCompleted;
	
	
	listData.refresh();
	storeList.dataProvider = listData;
	var s:String = "";
	s.toLowerCase();
	if (key.text != ""){
	}
	else {
	}
}
private function filterCompleted(item:Object):Boolean{
	if((item.business_name.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
		(item.business_description.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
		(item.business_tagline.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1))
		return true;
	return false;
}
public function filterPress(u:uint):void {	
}
private function returnall(item:Object):Boolean{
	return true;
}
protected function onUpdate(event:GeolocationEvent):void
{
	mylat = event.latitude;
	mylong = event.longitude;	
}	
protected function onRemove(event:ViewNavigatorEvent):void
{
	g.removeEventListener(GeolocationEvent.UPDATE, onUpdate);                
}
private function onViewDeactivate():void {
	//hide the map's infowindow
	this.parentApplication.map.infoWindow.hide();
	this.parentApplication.disableTraffic();
}
public function tOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function tOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}

public function press(event:KeyboardEvent):void {
	searchClick();
}
public function profDown(ev:MouseEvent):void {
	var gl:spark.filters.GlowFilter = new GlowFilter(000000,0.6,10,10,15,1,true);
	ev.currentTarget.filters = [gl];
}
public function profUp(ev:MouseEvent):void {
	ev.currentTarget.filters = [];				
}
public function resconf(ev:ResultEvent):void {
	var s:String = "";
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