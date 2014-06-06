import com.adobe.nativeExtensions.maps.LatLng;
import com.adobe.nativeExtensions.maps.Map;
import com.adobe.nativeExtensions.maps.MapEvent;
import com.adobe.nativeExtensions.maps.MapMouseEvent;
import com.adobe.nativeExtensions.maps.overlays.Marker;
import com.adobe.nativeExtensions.maps.overlays.MarkerStyles;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.GeolocationEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.sensors.Geolocation;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;

import spark.effects.Fade;
import spark.events.IndexChangeEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.managers.PersistenceManager;
import spark.primitives.Rect;
import spark.transitions.CrossFadeViewTransition;
import spark.transitions.FlipViewTransition;
import spark.transitions.FlipViewTransitionMode;
import spark.transitions.ViewTransitionDirection;

protected var g2:Geolocation = new Geolocation();    
protected var sqlConnection2:SQLConnection;
public var didupdate:Boolean = false;
[Bindable]
public var mapData:ArrayCollection = new ArrayCollection();
[Bindable]
public var viewPortMap:Rectangle;
public var fullscreenmap:Map;
public var overlayarray:Array = new Array();
[Bindable]
public var alphatitle:String = "Map";
[Bindable]
public var mylat:Number = 53.59221;
[Bindable]
public var mylong:Number = -113.54009;
public function createMap():void {
	try{
		if (Geolocation.isSupported)
		{
			g2.addEventListener(GeolocationEvent.UPDATE, onUpdate);
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
	var _applicationDPI:int = 160;
	var _runtimeDPI:int;
	var statusheight:uint = 0;
	if(Capabilities.screenDPI < 200){
		_runtimeDPI = 160;
		statusheight = 20;
	}
	else if(Capabilities.screenDPI >=200 && Capabilities.screenDPI < 280){
		_runtimeDPI = 240
		statusheight = 30;
	}
	else if (Capabilities.screenDPI >=320){
		_runtimeDPI = 320;
		statusheight = 40;
	}
	else if (Capabilities.screenDPI >=480){
		_runtimeDPI = 480;
		statusheight = 60;
	}
	else if (Capabilities.screenDPI >=640){
		_runtimeDPI = 640;
		statusheight = 80;
	}
	else {
		_runtimeDPI = 320;
		statusheight = 40;
	}
	
	var heightremoval:uint = mainNavigator.actionBar.height+statusheight;
	fullscreenmap = new Map();
	viewPortMap = new Rectangle(0,heightremoval,this.width,this.height);
//	fullscreenmap.visible = false;	
	fullscreenmap.viewPort = viewPortMap;
	fullscreenmap.setSize(new Point (this.width,this.height));
	fullscreenmap.setMapType(0);
    fullscreenmap.addEventListener("mapevent_click", mapClick);
	fullscreenmap.setZoom(20);
	fullscreenmap.setCenter(new LatLng(53.526526,-113.495207));
//	fullscreenmap.addEventListener(
}
protected function onUpdate(event:GeolocationEvent):void
{
	
}	
public function mapClick(ev:MapEvent):void {
	
	
}
protected function onRemove(event:ViewNavigatorEvent):void
{
	g2.removeEventListener(GeolocationEvent.UPDATE, onUpdate);                
}
public var destonce:Boolean = false;
protected function showMap():void
{
	if (destonce){
		createMap();
	}
	var stmt:SQLStatement = new SQLStatement();
	sqlConnection2 = new SQLConnection();
	sqlConnection2.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	if (overlayarray.length <= 0){
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
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT * FROM merchusers";
		stmt.execute();
		var merchData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (merchData.length != 0){
			removeallpoints();
			mapData = merchData;
			mapData.refresh();
			for (var i:uint = 0; i < mapData.length; i++){
				addpoint(mapData[i].id,mapData[i].business_name,mapData[i].business_description,
					mapData[i].lat,mapData[i].longa)
			}
		}
	}
	fullscreenmap.setZoom(20);
	fullscreenmap.visible = true;
	fullscreenmap.setCenter(new LatLng(53.526526,-113.495207));

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
protected function hideMap():void
{
	destonce = true;
	try{
		fullscreenmap.viewPort = null;
		fullscreenmap.dispose();
		fullscreenmap.visible = false;
	}
	catch(e:Error){
		
	}
	
}
protected function addpoint(id:String,title:String,subtitle:String,
							lat:Number,long:Number):void
{

	var m:Marker = new Marker(new LatLng(lat,long));
	m.title=title;
	//m.detailBtn = 1;
	m.subtitle=subtitle;
	m.fillColor=MarkerStyles.MARKER_COLOR_GREEN;
	overlayarray.push(m);
	fullscreenmap.addOverlay(overlayarray[overlayarray.length-1]);
}
protected function removeallpoints():void
{
	if (overlayarray.length > 0){
		for (var i:uint = 0; i < overlayarray.length; i++){
			fullscreenmap.removeOverlay(overlayarray[i]);
		}
		overlayarray = new Array();
	}
}
