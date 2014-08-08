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

static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var emailGo:String = "none";
[Bindable]
public var merchid:String = "-1";
[Bindable]
public var locationid:String = "-1";
[Bindable]
public var locationname:String = "none";
[Bindable]
public var busy:Boolean = false;
[Bindable]
public var VERSIONID:Number = 1;
public var sqlConnection:SQLConnection;
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
	var _runtimeDPI:int = 320;
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
public function setLoginVars():void {
	try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT email, merchid, locationid, locationname  FROM localuser";
		stmt.execute();
		var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (resData.length != 0){
			emailGo = resData[0].email;
			merchid = resData[0].merchid.toString();
			locationid = resData[0].locationid.toString();
			locationname = resData[0].locationname;
		}
		else {
			emailGo = "none";
			merchid = "-1";
			locationid = "-1";
			locationname = "none";
		}	
	}
	catch(e:Error) {
		emailGo = "none";
		merchid = "-1";
		locationid = "-1";
		locationname = "none";
	}	
}
protected function donothing(event:FlexEvent):void
{
	event.preventDefault();
}
public function createIfNotExsist(s:String):void {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
    if (s == "localuser"){
		stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
			"email varchar(255)," +
			"merchid varchar(255)," +
			"locationid varchar(255)," +
			"locationname varchar(255))";
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
	catch(e:Error){}
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