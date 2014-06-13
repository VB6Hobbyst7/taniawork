import events.ActionEvent;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.filesystem.File;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;

import spark.components.SplitViewNavigator;
import spark.components.ViewNavigator;
import spark.core.ContentCache;

static public const s_imageCache:ContentCache = new ContentCache();
protected var sqlConnection:SQLConnection;
[Bindable]
public var nameVAR:String = '';
[Bindable]
public var idVAR:String = '';
[Bindable]
public var addressVar:String = '';
[Bindable]
public var cityVAR:String = '';
[Bindable]
public var localityVAR:String = '';
[Bindable]
public var postalcodeVAR:String = '';
[Bindable]
public var pictureVAR:String = '';
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
public function setLoginVars():void {
	var stmt:SQLStatement = new SQLStatement();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS resuser (" +
		"id int," +
		"name varchar(255)," +
		"address varchar(255)," +
		"city varchar(255)," +
		"locality varchar(255)," +
		"postalcode varchar(255)," +
		"picture varchar(255))";
	stmt.execute();
	
	try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		stmt = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT * FROM resuser";
		stmt.execute();
		var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (resData.length != 0){
			idVAR = resData[0].id;
			nameVAR = resData[0].name;
			addressVar = resData[0].address;
			cityVAR = resData[0].city;
			localityVAR = resData[0].locality;
			postalcodeVAR = resData[0].postalcode;
			pictureVAR = resData[0].picture;
		}
		else {
			idVAR = "";
			nameVAR = "";
			addressVar ="";
			cityVAR ="";
			localityVAR = "";
			postalcodeVAR = "";
			pictureVAR = "";
		}	
	}
	catch(e:Error) {
		idVAR = "";
		nameVAR = "";
		addressVar ="";
		cityVAR ="";
		localityVAR = "";
		postalcodeVAR = "";
		pictureVAR = "";
	}	
	
	
	
	
	
}