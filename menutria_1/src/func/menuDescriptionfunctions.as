import components.modItem;
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
import spark.events.IndexChangeEvent;
import spark.events.ListEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.primitives.Graphic;
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
import events.ActionEvent;
import flash.system.Capabilities;
[Bindable]
public var picture:String = "";
protected var sqlConnection:SQLConnection;
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
	this.title = data.selectedData.name;
	busy = true;	
	scroller.visible = true;
	getMenuItemInformation.send();
	
	var ratingstring:String = "";
	var ratingnumber:Number = 0;
	
	ratingstring = data.selectedData.rating.toString();
	ratingnumber = Number(data.selectedData.rating.toString());
	
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
	else {
		ratinglabel.text = ratingstring;
	}
	if ((data.selectedData.picture == "None")||(data.selectedData.picture == "")||(data.selectedData.picture == null)||(data.selectedData.picture == "null")){
		img1.source = "assets/"+getDPIHeight().toString()+"/dish_place_wide.png";	
	}
	img1.visible = true;
}
private function onViewDeactivate():void {
	this.parentApplication.map.infoWindow.hide();
	this.parentApplication.disableTraffic();
}
public function goback(ev:MouseEvent):void {
	navigator.popView();
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
protected function descriptionclick(event:MouseEvent):void
{
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
	var tempModifications:ArrayCollection = new ArrayCollection();
	
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT * FROM resvalues";
	stmt.execute();
	var resvaluesData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	
	
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
		tempModifications = ev.result[0].results4.result4;	
		
	}
	catch(e:Error){
		try{
			
			tempModifications.addItem(ev.result[0].results4.result4);
		}
		catch(e:Error){
		}
	}
	
	for (var i:uint = 0; i < tempModifications.length; i++){
		for (var j:uint = 0; j<resvaluesData.length; j++){
			if ((tempModifications[i].restrictid == resvaluesData[j].id)&&(resvaluesData[j].chosen == 'yes')){
				modifications.addItem(tempModifications[i]);
			}
		}
	}
	modList.dataProvider = modifications;
}

