import flash.geom.ColorTransform;
import flash.sensors.Geolocation;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.events.ResizeEvent;
import mx.rpc.events.ResultEvent;

import spark.components.supportClasses.StyleableTextField;
import spark.core.ContentCache;
import spark.events.IndexChangeEvent;
import spark.events.ListEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.primitives.Graphic;

import components.modItem;

static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var googleTravelUrl:String = "";
import spark.filters.GlowFilter;
import flash.data.SQLStatement;
import flash.events.MouseEvent;
import flash.data.SQLConnection;
import flash.filesystem.File;
import flash.display.Sprite;
import flash.media.StageWebView;
import flash.display.Graphics;
import flash.display.Bitmap;
import flash.events.Event;

[Bindable]
public var picture:String = "";
protected var sqlConnection:SQLConnection;
[Bindable]
public var emailGo:String = "bieber@ualberta.ca";
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
public var topreviews:ArrayCollection = new ArrayCollection();
[Bindable]
public var topratedrecentval:uint = 1;
[Bindable]
public var recentreviews:ArrayCollection = new ArrayCollection();
[Bindable]
public var modifications:ArrayCollection = new ArrayCollection();
[Bindable]
public var reviewPopupStage:uint = 0;
[Bindable]
public var globalradious:uint = 200;
[Bindable]
public var currentpercentage:Number = 100;
public var circleToMask:Graphic = new Graphic();
public var circleMask:Graphic = new Graphic();
public var circleToMask2:Graphic = new Graphic();
public var circleMask2:Graphic = new Graphic();
[Bindable]
public var nameGo:String = "";
[Bindable]
public var actualRateValue:Number = 0;
[Bindable]
public var shareType:uint = 0;
[Bindable]
public var eatenstatus:uint = 0;
public function view1_activateHandler(event:Event):void
{
	
	showloading();
	busy = true;
	/*try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT email, name, country, active FROM localuser where active = 'yes'";
		stmt.execute();
		var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (resData.length != 0){
			emailGo = resData[0].email;
			nameGo = resData[0].name;
		}
		else {
			emailGo = "none";
		}	
	}
	catch(e:Error) {
		emailGo = "none";
	}		*/			
	scroller.visible = true;
	getMenuItemInformation.send();
	
	var ratingstring:String = "";
	var ratingnumber:Number = 0;
	
	ratingstring = "10";//data.rating.toString();
	ratingnumber = 10;
	
	if (ratingnumber == 0){
		ratinglabel.text = "-";
	}
	else if (ratingnumber >= 10){
		ratingnumber = 10;
		ratinglabel.text = "10";
	}
	else if (ratingstring.length > 3){
		ratingstring = ratingstring.substring(0,3);
		ratinglabel.text = ratingstring;
	}
	img1.source = "assets/dish_place_wide.png";	
	/*if ((data.picture == "None")||(data.picture == "")||(data.picture == null)||(data.picture == "null")){
		img1.source = "assets/dish_place_wide.png";	
	}*/
	img1.visible = true;
	
}

private function onViewDeactivate():void {
	//hide the map's infowindow
	this.parentApplication.map.infoWindow.hide();
	this.parentApplication.disableTraffic();
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
public function afterGetMenuInformation(ev:ResultEvent):void {
	hideloading();
	busy = false;
	topreviews = new ArrayCollection();
	recentreviews = new ArrayCollection();
	modifications = new ArrayCollection();

	
	
	
	
	
	try{			
		topreviews = ev.result[0].results.result;	
	}
	catch(e:Error){
		try{
			
			topreviews.addItem(ev.result[0].results.result);
		}
		catch(e:Error){
		}
	}
	
	try{			
		recentreviews = ev.result[0].results2.result2;	
	}
	catch(e:Error){
		try{
			
			recentreviews.addItem(ev.result[0].results2.result2);
		}
		catch(e:Error){
		}
	}
	
	try{			
		modifications = ev.result[0].results4.result4;	
		modList.dataProvider = modifications;
	}
	catch(e:Error){
		try{
			
			modifications.addItem(ev.result[0].results4.result4);
		}
		catch(e:Error){
		}
	}
	
	//	modList.dataProvider = modifications;
	reviewList.dataProvider = topreviews;
}
public function topratedrecentclick(event:MouseEvent):void
{
	if (topratedrecentval == 1){
		topratedrecentval = 2;
		topratedrecentimg.source = 'assets/topratedrecent2.png';
		reviewList.dataProvider = recentreviews;
	}
	else {
		topratedrecentval = 1;
		topratedrecentimg.source = 'assets/topratedrecent1.png';
		reviewList.dataProvider = topreviews;
	}
	
	
}
public function seemoreclick():void {
	//navigator.pushView(MenuReviews,{id:data.id});
}

