import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.desktop.NativeApplication;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.system.Capabilities;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

import spark.core.ContentCache;
import spark.transitions.SlideViewTransition;
import spark.transitions.SlideViewTransitionMode;
import spark.transitions.ViewTransitionDirection;

import views.Home;

static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var emailGo:String = "";
[Bindable]
public var nameGo:String = "";
[Bindable]
public var cityGo:String = "";
protected var sqlConnection:SQLConnection;
public function setLoginVars():void {
	try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT email, name, city, active FROM localuser where active = 'yes'";
		stmt.execute();
		var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (resData.length != 0){
			emailGo = resData[0].email;
			nameGo = resData[0].name;
			cityGo = resData[0].city;
		}
		else {
			emailGo = "none";
			nameGo = "none";
			cityGo = "none";
		}	
	}
	catch(e:Error) {
		emailGo = "none";
		nameGo = "none";
		cityGo = "none";
	}	
}

public function createIfNotExsist(s:String):void {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	 if (s == "merchusers"){
		stmt.text = "CREATE TABLE IF NOT EXISTS merchusers (" +
			"id int(255)," +
			"merchid int(255)," +
			"business_name varchar(255)," +
			"business_number varchar(255)," +
			"business_description longtext," +
			"business_picture varchar(255)," +
			"business_address1 varchar(255)," +
			"business_city varchar(255)," +
			"business_locality varchar(255)," +
			"business_postalcode varchar(255)," +
			"business_country varchar(255)," +
			"lat varchar(255)," +
			"longa varchar(255)," +
			"facebook varchar(255)," +
			"twitter varchar(255)," +
			"website varchar(255)," +
			"categoryname varchar(255)," +
			"email varchar(255)," +
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
			"active varchar(255))";
	}
	else if (s == "userloyalty"){
		stmt.text = "CREATE TABLE IF NOT EXISTS userloyalty (" +
			"id int(255)," +
			"business_name varchar(255)," +
			"business_picture varchar(255)," +
			"amount varchar(255)," +
			"userloyalty varchar(255))";	
	}
	else if (s == "versionhistory"){
		stmt.text = "CREATE TABLE IF NOT EXISTS versionhistory (version varchar(255))";
	}
	stmt.execute();
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
protected function donothing(event:FlexEvent):void
{
	event.preventDefault();
}

private function enableHardwareKeyListeners():void
{
	systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyDownHandler, false, 500, true);
	NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
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
