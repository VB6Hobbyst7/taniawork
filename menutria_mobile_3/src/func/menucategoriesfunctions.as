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
import views.MenuCatAll;
import views.Menu;
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
public var reverse:Boolean = false;;
[Bindable]
public var locatoinidGo:Number = -1;
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
	setLoginVars();
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
	var sampleimage:String = "";
	
	
	for (var i:uint = 0; i < listData.length; i++){
		listData[i].business_name = data.business_name;
		if ((sampleimage == "")&&(listData[i].picture != "None")&&
			(listData[i].picture != "")&&
			(listData[i].picture != null)&&
			(listData[i].picture != "null")){
			sampleimage = listData[i].picture;
		}
	}
	
	listData.addItemAt({name:"All",picture:sampleimage,frequency:ev.result[0].ress2.res2.total,categoryid:"-1",locationid:locationid},0);
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
			if (storeList.selectedIndex == 0){
				navigator.pushView(MenuCatAll, listData[storeList.selectedIndex]);
			}
			else {
				navigator.pushView(Menu, listData[storeList.selectedIndex]);
			}	
		}
		else {
			allreadylistclicked = false;
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
	return true;
}
private function returnall(item:Object):Boolean{
	return true;
}
public function press(event:KeyboardEvent):void {
	searchClick();
}
public function goback(ev:MouseEvent):void {
	navigator.popView();
}