// ActionScript file
import flash.geom.ColorTransform;
import flash.sensors.Geolocation;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.events.FlexEvent;
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
private var _addrString:String;
[Bindable]
private var _distString:String;
private var mapIcon:Class;
[Bindable]
public var googleTravelUrl:String = "";
import spark.filters.GlowFilter;
import flash.filesystem.File;
import flash.display.Sprite;
import flash.data.SQLStatement;
import views.MenuDescription;
import flash.media.StageWebView;
import flash.events.MouseEvent;
import flash.display.Bitmap;
import flash.data.SQLConnection;
import views.ViewReview;
import views.StoreSpecials;
import flash.events.Event;
import views.StoreReviews;

[Bindable]
public var picture:String = "";
protected var sqlConnection:SQLConnection;
[Bindable]
public var emailGo:String = "";
[Bindable]
public var mylat:Number = 53.59221;
[Bindable]
public var mylong:Number = -113.54009;
[Bindable]
public var busy:Boolean = true;
[Bindable]
public var dragBar:Sprite;
[Bindable]
public var dragBitmap:Bitmap;
[Bindable]
public var stageWeb:StageWebView;
[Bindable]
public var storetoprateddata:ArrayCollection = new ArrayCollection();
[Bindable]
public var recentreviews:ArrayCollection = new ArrayCollection();
[Bindable]
public var topreviews:ArrayCollection = new ArrayCollection();
[Bindable]
public var topratedrecentval:uint = 1;


public function view1_activateHandler(event:Event):void
{
	
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
	img1.source = data.business_picture;
	googleTravelUrl = "http://maps.google.com/?q="+data.lat+","+data.longa;	
	scroller.visible = true;
	getTopRated.send();
	getTopReviews.send();
	
	
	var ratingstring:String = "";
	var ratingnumber:Number = 0;
	
	ratingstring = data.rating.toString();
	ratingnumber = Number(data.rating);
	
	if (ratingnumber == 0){
		ratinglabel.text = "-";
	}
	
	if (ratingnumber >= 10){
		ratingnumber = 10;
		ratinglabel.text = "10";
	}
}

public function goback(ev:MouseEvent):void {
	navigator.popView();
}
public function tOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function tOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
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



public function backOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("backgroundColor",0xecf9f7);
}
public function backDown(ev:MouseEvent):void {
	ev.currentTarget.setStyle("backgroundColor",0xecf9f7);
}
public function backOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("backgroundColor",0xFFFFFF);
}


public function profDown(ev:MouseEvent):void {
	ev.currentTarget.alpha = 0.5;
}
public function profUp(ev:MouseEvent):void {
	ev.currentTarget.alpha = 1;
}
protected function viewspecials(event:MouseEvent):void
{
	navigator.pushView(StoreSpecials, {id:data.id,
		locationid:data.id,
		business_picture:data.business_picture,
		emailGo:emailGo,
		business_name:data.business_name,
		amount:data.amount});
}	

protected function descriptionclick(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	if (descriptiontext.maxDisplayedLines == 4){
		descriptiontext.maxDisplayedLines = 30;
	}
	else {
		descriptiontext.maxDisplayedLines = 4;
	}
	
}
public function afterGetTopRated(ev:ResultEvent):void {
	busy = false;
	storetoprateddata = new ArrayCollection();
	try{			
		storetoprateddata = ev.result[0].results.result;		
	}
	catch(e:Error){
		try{
			
			storetoprateddata.addItem(ev.result[0].results.result);
		}
		catch(e:Error){
		}
	}
	
	
}
public function afterGetMerchReviews(ev:ResultEvent):void {
	busy = false;
	topreviews = new ArrayCollection();
	recentreviews = new ArrayCollection();
	try{			
		topreviews = ev.result[0].results.result;	
		recentreviews = ev.result[0].results2.result2;	
	}
	catch(e:Error){
		try{
			
			topreviews.addItem(ev.result[0].results.result);
			recentreviews.addItem(ev.result[0].results2.result2);
		}
		catch(e:Error){
		}
	}
	
	
	
	reviewlist.dataProvider = topreviews;
	
}

public function topratedrecentclick(event:MouseEvent):void
{
	if (topratedrecentval == 1){
		topratedrecentval = 2;
		topratedrecentimg.source = topratedrecent2;
		reviewlist.dataProvider = recentreviews;
	}
	else {
		topratedrecentval = 1;
		topratedrecentimg.source = topratedrecent1;
		reviewlist.dataProvider = topreviews;
	}
	
	
}
public function seemoreclick():void {
	navigator.pushView(StoreReviews,{id:data.id});
}
public function menuitemclick():void {
	if (topratedlist.selectedIndex != -1){
		navigator.pushView(MenuDescription, storetoprateddata[topratedlist.selectedIndex]);	
	}
}

public function ratingitemclick():void {
	if (reviewlist.selectedIndex != -1){
		if (topratedrecentval == 1){
			navigator.pushView(ViewReview, topreviews[reviewlist.selectedIndex]);	
		}
		else {
			navigator.pushView(ViewReview, recentreviews[reviewlist.selectedIndex]);	
		}
		
	}
}