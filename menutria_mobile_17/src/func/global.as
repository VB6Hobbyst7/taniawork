import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.system.Capabilities;
import flash.ui.Keyboard;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.core.DPIClassification;
import mx.events.EffectEvent;
import mx.events.FlexEvent;

import spark.core.ContentCache;
import spark.effects.Fade;
static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var emailGo:String = "";
[Bindable]
public var nameGo:String = "";
[Bindable]
public var cityGo:String = "";
[Bindable]
public var pictureGo:String = "";
[Bindable]
public var idGo:String = "";
public var mylat:Number = 53.536979;
public var mylong:Number = -113.296852;
[Bindable]
public var slideduration:Number = 150;
public var sqlConnection:SQLConnection;
public function setLoginVars():void {
	try{
		var resData:ArrayCollection = getDatabaseArray("SELECT * FROM localuser");
		if (resData.length != 0){
			emailGo = resData[0].email;
			nameGo = resData[0].name;
			cityGo = resData[0].city;
			pictureGo = resData[0].picture;
		}
	}
	catch(e:Error) {}
	
	try{
		createIfNotExsist("gps");
		var gpstemparray:ArrayCollection = new ArrayCollection();
		gpstemparray = getDatabaseArray("select * from gps");
		if (gpstemparray.length > 0){
			mylat = gpstemparray[0].lat;
			mylong = gpstemparray[0].longa;	
		}
	}
	catch(e:Error) {}
}
public function createIfNotExsist(s:String):void {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	if (s == "resvalues"){
		stmt.text = "CREATE TABLE IF NOT EXISTS resvalues (" +
			"id int(255)," +
			"name longtext," +
			"chosen  varchar(255))";							
	}
	else if (s == "dishes"){
		stmt.text = "CREATE TABLE IF NOT EXISTS dishes (" +
			"id int(255)," +
			"locationid int(255)," +
			"business_name longtext," +
			"business_postalcode longtext," +
			"categoryid int," +
			"categoryname longtext," +
			"cost float," +
			"description longtext," +
			"lat varchar(255)," +
			"longa varchar(255)," +
			"name longtext," +
			"picture longtext," +
			"rating double," +
			"divtype int," +
			"distance varchar(255)," +
			"goodforme varchar(255))";							
	}
	else if (s == "merchusers"){
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
	}
	else if (s == "gps"){
		stmt.text = "CREATE TABLE IF NOT EXISTS gps (" +
			"lat varchar(255)," +
			"longa varchar(255))";
	}
	else if (s == "localuser"){
		stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
			"email varchar(255)," +
			"name varchar(255)," +
			"city varchar(255)," +
			"picture varchar(255))";
	}
	else if (s == "specials"){
		stmt.text = "CREATE TABLE IF NOT EXISTS specials (" +
			"id int(255)," +
			"locationid int(255)," +
			"name longtext," +
			"weekday longtext," +
			"description longtext," +
			"lat varchar(255)," +
			"longa varchar(255)," +
			"business_name longtext," +
			"business_postalcode longtext," +
			"business_picture longtext," +
			"categoryname longtext, distance varchar(255))";
	}
	else if (s == "versionhistory"){
		stmt.text = "CREATE TABLE IF NOT EXISTS versionhistory (version varchar(255))";
	}
	stmt.execute();
}
public function getDatabaseArray(query:String):ArrayCollection {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = query;
	stmt.execute();
	return new ArrayCollection(stmt.getResult().data);
}
public function doQuery(query:String):void {
	try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = query;
		stmt.execute();
	}
	catch(e:Error){
		
	}
}
public function updateGPS(lat:Number,long:Number):void {
	createIfNotExsist("gps");
	var gpstemparray:ArrayCollection = new ArrayCollection();
	gpstemparray = getDatabaseArray("select * from gps");
	if (gpstemparray.length == 0){
		doQuery("insert into gps values ('"+lat.toString()+"','"+long.toString()+"')");
	}
	else {
		doQuery("update gps set lat = '"+lat.toString()+"', longa = '"+long.toString()+"'");
	}
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
protected function donothing(event:FlexEvent):void
{
	event.preventDefault();
}
private function keyDown(event:KeyboardEvent):void
{
	var key:uint = event.keyCode;
	if (key == Keyboard.BACK && !systemManager.numModalWindows==0)
		event.preventDefault();
}

public function stageKeyDownHandler(event:KeyboardEvent):void {
	var key:uint = event.keyCode;
	if (key == Keyboard.BACK && !systemManager.numModalWindows==0)
		event.preventDefault();
}
public function menupress(event:FlexEvent):void
{
	this.parentApplication.menuButtonClick();
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
public function getDPIHeight():Number {
	var _runtimeDPI:int;
	if(Capabilities.screenDPI < 200){
		_runtimeDPI = 160;
	}
	else if(Capabilities.screenDPI >=200 && Capabilities.screenDPI <= 240){
		_runtimeDPI = 240
	}
	else if (Capabilities.screenDPI < 480){
		_runtimeDPI = 320;
	}
	else if (Capabilities.screenDPI < 640){
		_runtimeDPI = 480;
	}
	else if (Capabilities.screenDPI >=640){
		_runtimeDPI = 640;
	}
	return(_runtimeDPI)
}
public function getActionBarHeight():Number{
	switch (getDPIHeight())
	{
		case 640:
		{
			return(172);
			break;
		}
		case 480:
		{
			return(129);
			break;
		}
		case 320:
		{
			return(86);
			break;
		}
		case 240:
		{
			return(65);
			break;
		}
		default:
		{
			return(43);
			break;
		}
	}
	return(43);
}
public function hidekeyboard():void {
	try{
		stage.focus = null;
	}catch(e:Error){}

}