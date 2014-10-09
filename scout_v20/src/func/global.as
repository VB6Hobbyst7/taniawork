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
import spark.transitions.SlideViewTransition;
import spark.transitions.SlideViewTransitionMode;
import spark.transitions.ViewTransitionDirection;
import views.Home;
[Bindable]
public var email:String = "";
[Bindable]
public var nameGo:String = "";
[Bindable]
public var cityGo:String = "";
[Bindable]
public var password:String = "";
[Bindable]
public var slideduration:Number = 250;
public var mylat:Number = 53.536979;
public var mylong:Number = -113.296852;
protected var sqlConnection:SQLConnection;
[Bindable]
public var actionbarheight:Number = 0;
[Bindable]
public var statusbuffertop:Number = 0;
[Bindable]
public var VERSIONID:Number = 12;
public function setLoginVars():void {
	try{
		sqlConnection = new SQLConnection();
		sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = sqlConnection;
		stmt.text = "SELECT * from localuser";
		stmt.execute();
		var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
		if (resData.length != 0){
			email = unescape(resData[0].email);
			nameGo = unescape(resData[0].name);
			cityGo = unescape(resData[0].city);		
			cityGo = cityGo.substr(0,1).toUpperCase()+cityGo.substr(1,cityGo.length);
		}
		else {
			email = "none";
			nameGo = "none";
			cityGo = "none";
		}	
	}
	catch(e:Error) {
		email = "none";
		nameGo = "none";
		cityGo = "none";
	}	
	
	
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
	 if (s == "merchusers"){
		stmt.text = "CREATE TABLE IF NOT EXISTS merchusers (" +
			"id int(255)," +
			"merchid int(255)," +
			"business_name varchar(255)," +
			"business_number varchar(255)," +
			"business_description longtext," +
			"business_picture varchar(255)," +
			"business_picture2 varchar(255)," +
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
			"loyaltyval varchar(255)," +
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
	else if (s == "facebookcallback"){
		stmt.text = "CREATE TABLE IF NOT EXISTS facebookcallback (" +
			"id int(255))";	
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
public function getActionBarHeight():Number{
	switch (getDPIHeight2())
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
public function getDPIHeight2():Number {
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
public function calculateActionbarVals():void {
	if (getDPIHeight2() == 640){
		actionbarheight = 172;	
	}
	else if (getDPIHeight2() == 480){
		actionbarheight = 129;		
	}
	else if (getDPIHeight2() == 320){
		actionbarheight = 86;
	}
	else if (getDPIHeight2() == 240){
		actionbarheight = 65;
	}
	else {
		actionbarheight = 43;
	}
	
	
	if (Capabilities.version.indexOf('IOS') > -1){
		if (getDPIHeight2() == 320){
			statusbuffertop = 40;
		}
		else if (getDPIHeight2() == 160){
			statusbuffertop = 20;
		}
	}
}