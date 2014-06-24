import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.system.Capabilities;

import mx.collections.ArrayCollection;

import spark.core.ContentCache;
static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var emailGo:String = "";
[Bindable]
public var nameGo:String = "";
[Bindable]
public var idGo:String = "";
[Bindable]
protected var sqlConnection:SQLConnection;
public function setLoginVars():void {
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
	stmt.execute();
}
public function getDatabaseArray(query:String):ArrayCollection {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	
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