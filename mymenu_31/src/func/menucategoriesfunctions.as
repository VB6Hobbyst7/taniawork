import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.GeolocationEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.html.HTMLLoader;
import flash.net.URLRequest;
import flash.sensors.Geolocation;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.effects.effectClasses.FadeInstance;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;
import mx.rpc.events.ResultEvent;

import spark.collections.SortField;
import spark.components.supportClasses.StyleableTextField;
import spark.core.ContentCache;
import spark.events.IndexChangeEvent;
import spark.events.ListEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.managers.PersistenceManager;

import views.Menu;
static public const s_imageCache:ContentCache = new ContentCache();;
[Bindable]
public var googleTravelUrl:String = "";
protected var g:Geolocation = new Geolocation();    

[Bindable]
public var locationid:String = "";
[Bindable]
public var radiusOptions:ArrayCollection = new ArrayCollection();
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
public var currentselectmode:Number = 1;
[Bindable]
public var listData:ArrayCollection = new ArrayCollection();
[Bindable]
public var backuplistdata:ArrayCollection = new ArrayCollection();
[Bindable]
public var ratingpriceoptionval:uint = 0;
protected function view1_activateHandler(event:Event):void
{
	warn.visible = false;
	busy = true;
	showloading();
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
	locationid = data.locationid;
	getMenu.send();
}	

public function afterGetMenu(ev:ResultEvent):void
{	busy = false;
	hideloading();
	listData = new ArrayCollection();
	try{			
		listData = ev.result[0].ress.res;		
	}
	catch(e:Error){
		try{
			
			listData.addItem(ev.result[0].ress.res);
		}
		catch(e:Error){
		}
	}
	
	
	listData.addItemAt({name:"All",frequency:ev.result[0].ress2.res2.total,categoryid:"-1",locationid:locationid},0);
	for (var i:uint = 0; i < listData.length; i++){
		listData[i].business_name = data.business_name;
	}
	
	
} 
public function populatelist():void {
	var srt:Sort = new Sort();
	if (ratingpriceoptionval == 0){
		srt.fields = [new SortField("rating")];
		listData.sort = srt;
		listData.refresh();
	}
	else if (ratingpriceoptionval == 1){
		srt.fields = [new SortField("cost")];
		listData.sort = srt;
		listData.refresh();
	}
	storeList.dataProvider = listData;
	
}
public var allreadylistclicked:Boolean = false
public function storeListClick():void {	
	if (allreadylistclicked == false){
		allreadylistclicked = true;
		if (storeList.selectedIndex != -1){
			navigator.pushView(Menu, listData[storeList.selectedIndex]);	
		}
	}
	
}
public function searchClick():void
{
	listData.filterFunction = filterCompleted;
	listData.refresh();
	storeList.dataProvider = listData;
	
}
private function filterCompleted(item:Object):Boolean{
	//if((item.cost.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
	//(item.name.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)
	//)
	return true;
	//return false;
}
private function returnall(item:Object):Boolean{
	return true;
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