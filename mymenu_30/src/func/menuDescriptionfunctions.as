import com.facebook.graph.FacebookMobile;
import com.facebook.graph.data.FacebookAuthResponse;

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
public var actions:ArrayCollection;
[Bindable]
private var _data:Object;
[Bindable]
private var _addrString:String;
[Bindable]
private var _distString:String;
private var mapIcon:Class;
[Bindable]
public var googleTravelUrl:String = "";
import spark.filters.GlowFilter;
import flash.data.SQLStatement;
import flash.events.MouseEvent;
import flash.data.SQLConnection;
import views.ViewReview;
import flash.filesystem.File;
import flash.display.Sprite;
import flash.media.StageWebView;
import flash.display.Graphics;
import flash.display.Bitmap;
import views.MenuReviews;
import flash.events.Event;

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



//FACEBOOK STUFF
private const APP_ID:String = "277005535795275";
//App origin URL
private const FACEBOOK_APP_ORIGIN:String = "http://mymenuapp.ca/facebook";
//Permissions Array
private const PERMISSIONS:Array = ["email","user_birthday","user_location","basic_info",'read_stream', 'publish_stream'];





public function init():void{
	
}
public function view1_activateHandler(event:Event):void
{
	
	showloading();
	if (data.name.length > 20){
		data.name = data.name.substring(0,20)+"...";
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
			nameGo = resData[0].name;
		}
		else {
			emailGo = "none";
		}	
	}
	catch(e:Error) {
		emailGo = "none";
	}					
	scroller.visible = true;
	getMenuItemInformation.send();
	
	var ratingstring:String = "";
	var ratingnumber:Number = 0;
	
	ratingstring = data.rating.toString();
	ratingnumber = Number(data.rating);
	
	if (ratingnumber == 0){
		ratinglabel.text = "-";
	}
	else if (ratingnumber >= 10){
		ratingnumber = 10;
		ratinglabel.text = "10";
	}
	else if (ratingstring.length > 3){
		ratingstring = ratingstring.substring(0,2);
		ratinglabel.text = ratingstring;
	}
	
	
	
	// Store sprites
	var container:UIComponent = new UIComponent();
	gr.addElementAt(container, 0);
	// Draw the full circle with colors
	circleToMask.graphics.beginFill(0x8eddce,1);
	circleToMask.graphics.drawCircle(0, 0, globalradious);
	circleToMask.graphics.endFill();
	
	circleToMask2.graphics.beginFill(0x43c7ae,1);
	circleToMask2.graphics.drawCircle(0, 0, globalradious);
	circleToMask2.graphics.endFill();
	
	// Add the circle
	container.addChildAt(circleToMask, 0);
	container.addChildAt(circleToMask2, 0);
	
	
	
	circleMask.width = 400;
	circleMask.height = 400
	circleMask.verticalCenter = 0;
	circleMask.horizontalCenter = 0;
	
	circleMask2.width = 400;
	circleMask2.height = 400
	circleMask2.verticalCenter = 0;
	circleMask2.horizontalCenter = 0;
	// Add the mask
	container.addChild(circleMask);
	container.addChild(circleMask2);
	
	
	//Set the position of the circle
	circleToMask.x = (circleMask.x = 100);
	circleToMask.y = (circleMask.y = 100);
	circleToMask.mask = circleMask;
	circleToMask.width = 400;
	circleToMask.height = 400
	circleToMask.verticalCenter = 0;
	circleToMask.horizontalCenter = 0;
	
	circleToMask2.x = (circleMask2.x = 100);
	circleToMask2.y = (circleMask2.y = 100);
	circleToMask2.mask = circleMask2;
	circleToMask2.width = 400;
	circleToMask2.height = 400
	circleToMask2.verticalCenter = 0;
	circleToMask2.horizontalCenter = 0;
	
	
	// Draw the circle at 100%
	renderChart(currentpercentage/100);
	//	container.setStyle("mouseEnabledWhereTransparent",true);
	gr.addEventListener(MouseEvent.MOUSE_MOVE, circleMove);
	
	
	
	
}

public function circleMove(ev:MouseEvent):void {
	var angleRadians:Number=Math.abs(Math.atan2(ev.localY-0,ev.localX-0)-Math.atan2(-200-0,0-0));
	if (angleRadians>0.5*Math.PI) angleRadians=Math.PI-angleRadians;
	var degreeso:Number = angleRadians* 180/Math.PI;
	
	if ((ev.localX >= 0)&&(ev.localY >= 0)) {
		degreeso = degreeso+180;
		
	}
	else if (ev.localX >= 0){
		degreeso = 270+(90-Math.abs(degreeso));
	}
	else if (ev.localY >= 0){
		degreeso = 90+(90-Math.abs(degreeso));
	}
	
	var precentageofcircle:Number = (1-(degreeso/360));
	renderChart(precentageofcircle);
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
	reviewText.text = "";
	hideloading();
	busy = false;
	topreviews = new ArrayCollection();
	recentreviews = new ArrayCollection();
	modifications = new ArrayCollection();
	if (ev.result[0].eatinthis == 0){
		eatenimage.source = eatenthis2;
		eatenstatus = 0;
	}
	else {
		eatenimage.source = eatenthis1;
		eatenstatus = 1;
	}
	eatenimage.visible = true;
	
	
	
	
	
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
	navigator.pushView(MenuReviews,{id:data.id});
}
public function startReview():void {
	check.visible = false;
	forward.visible = true;
	
	reviewPopupStage = 1;
	writeholder.visible = false;
	grholder.visible = true;
	reviewPopupGroup.visible = true;
}
public function backOnMenu():void {
	if (reviewPopupStage == 0){
		reviewseq1.visible = true;
		reviewseq2.visible = false;
	}
	else if (reviewPopupStage == 1){
		reviewPopupGroup.visible = false;
		reviewPopupStage = 0;
		reviewseq1.visible = true;
		reviewseq2.visible = false;
		writeholder.visible = false;
		renderChart(0.6);
	}
	else if (reviewPopupStage == 2){
		check.visible = false;
		forward.visible = true;
		grholder.visible = true;
		reviewseq1.visible = true;
		reviewseq2.visible = false;
		writeholder.visible = false;
		reviewPopupStage = 1;
		renderChart(0.4);
		
	}
	
	
}
public function forwardOnMenu():void {
	if (reviewPopupStage == 0){
		reviewseq1.visible = true;
		reviewseq2.visible = false;
	}
	else if (reviewPopupStage == 1){
		reviewseq1.visible = false;
		reviewseq2.visible = true;
		check.visible = true;
		forward.visible = false;
		grholder.visible = false;
		writeholder.visible = true;
		reviewPopupStage = 2;
		
	}
	else if (reviewPopupStage == 2){
		reviewPopupGroup.visible = false;
		writeholder.visible = false;
		reviewseq1.visible = true;
		reviewseq2.visible = false;
		check.visible = false;
		forward.visible = true;
		reviewPopupStage = 0;
		//Commit review
		busy = true;
		sendReview.send();
		
	}
}



public function renderChart(percentage:Number):void
{
	
	circleMask2.graphics.clear();
	circleMask2.graphics.beginFill(0);
	
	
	circleMask.graphics.clear();
	circleMask.graphics.beginFill(0);
	
	if (percentage <= 0.1){
		percentage = 0.1;
	}
	
	ratevalue.text = Math.round(percentage*10).toString();
	actualRateValue =  Math.round(percentage*10);
	
	// Draw the circle at the given percentage            /------ set the begin at the middle top
	drawPieMask(circleMask2.graphics, 1, globalradious, -1.57, 8);
	drawPieMask(circleMask.graphics, percentage, globalradious, -1.57, 8);
	circleMask2.graphics.endFill();
	circleMask.graphics.endFill();
}

// Function from flassari (a little simplified)
private function drawPieMask(graphics:Graphics, percentage:Number, radius:Number = 200, rotation:Number = 0, sides:int = 6):void {
	radius /= Math.cos(1/sides * Math.PI);
	var lineToRadians:Function = function(rads:Number):void {
		graphics.lineTo(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
	};
	var sidesToDraw:int = Math.floor(percentage * sides);
	for (var i:int = 0; i <= sidesToDraw; i++)
		lineToRadians((i / sides) * (Math.PI * 2) + rotation);
	if (percentage * sides != sidesToDraw)
		lineToRadians(percentage * (Math.PI * 2) + rotation);
}

public function ratingitemclick():void {
	if (reviewList.selectedIndex != -1){
		if (topratedrecentval == 1){
			navigator.pushView(ViewReview, topreviews[reviewList.selectedIndex]);	
		}
		else {
			navigator.pushView(ViewReview, recentreviews[reviewList.selectedIndex]);	
		}
		
	}
}
public function startShare():void {
	var gl:spark.filters.GlowFilter = new spark.filters.GlowFilter(0x43c7ae,1,20,20,5,1,true);
	shareType = 0;
	sharefacebook.filters = [gl];
	sharetwitter.filters = [];
	shareText.text = "";
	sharePopup.visible = true;
	
}
public function eatenClick():void {
	busy = true;
	if (eatenstatus == 0){
		eatenimage.source = eatenthis1;
		eatenstatus = 1;
	}
	else {
		eatenimage.source = eatenthis2;
		eatenstatus = 0;
	}
	sendEatenThis.send();
	
}
public function backOnShare():void {
	sharePopup.visible = false;
}
public function forwardOnShare():void {
	sharePopup.visible = false;
	if (shareType == 0){
		var params:Object =
			{
				message:shareText.text,
					picture:data.picture,
					link:'http://www.mymenuapp.ca',
					name:data.name,
					caption:'',
					description:data.description,
					source:''
			};
		
		FacebookMobile.api('/me/feed', afterpost, params, "POST");  
	}
	else {
		//share twitter
	
		//navigateToURL(new URLRequest("https://twitter.com/home?status="+data.name+" - "+shareText.text))
	}
}
public function switchShare(u:uint):void{
	shareType = u;
	var gl:spark.filters.GlowFilter = new spark.filters.GlowFilter(0x43c7ae,1,20,20,15,1,true);
	if (u == 0){
		sharefacebook.filters = [gl];
		sharetwitter.filters = [];
	}
	else {
		sharefacebook.filters = [];
		sharetwitter.filters = [gl];
	}
}
public function afterGetEatenThis(ev:ResultEvent):void {
	busy = false;
	eatenimage.visible = true;
}



private function afterpost(result:Object, fail:Object):void{
	var stop:String = "";
}

