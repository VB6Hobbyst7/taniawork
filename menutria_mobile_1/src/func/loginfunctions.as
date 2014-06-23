import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.effects.Move;
import mx.events.DragEvent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;
import spark.effects.Fade;
import spark.effects.Scale;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.managers.PersistenceManager;
import spark.transitions.FlipViewTransition;
import spark.transitions.FlipViewTransitionMode;
import spark.transitions.ViewTransitionDirection;
import views.SpecialsAll;
[Bindable]
public var currentBalance:String = "$0.00";	
public var profileShown:Boolean = false;
public var chosenMenuOption:uint = 1;
public var profWaiting:Boolean = false;
public var profDraging:Boolean = false;
import spark.core.ContentCache;
[Bindable]
public var busy:Boolean = true;
public function create():void
{	busy = true;
	showloading();
	var stmt:SQLStatement = new SQLStatement();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
		"email varchar(255)," +
		"name varchar(255)," +
		"country varchar(255)," +
		"active varchar(255))";
	stmt.execute();
	getLocalUsers();
}	
public function loginClick(event:MouseEvent):void
{	
	this.currentState = 'login';
	logWarning.visible = false;
}
public function guestSignIn(event:MouseEvent):void {
	authorizeLogin("guest@guest.com","guest");
}
public function createNewClick(event:MouseEvent):void {
	this.currentState = 'create';
	newlogWarning.visible = false;
}
public function backToLoginOptions():void {
	this.currentState = 'welcome';
	try{
		logWarning.visible = false;
	}
	catch(e:Error){
		
	}
	try{
		newlogWarning.visible = false;
	}
	catch(e:Error){
		
	}
}
public function authorizeLogin(username:String,userpassword:String):void{	
	busy = true;
	userid = username;
	passid = userpassword;
	checkLogin.send();
}
public function afterCheckLogin(ev:ResultEvent):void {
	busy = false;
	if (ev.result[0].res.message == "ok"){
		AddNewLocalUser(ev.result[0].res.email,
			ev.result[0].res.name,
			ev.result[0].res.country);
	}
	else {
		//bad login
		logWarning.text = ev.result[0].res.message;
		logWarning.visible = true;
	}
}
protected function getLocalUsers():void
{
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT email, name, country, active FROM localuser";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	
	if (resData.length != 0){
		//good login
		var foundactive:Boolean = false;
		for (var i:uint = 0; i < resData.length; i++){
			if (resData[i].active == "yes"){
				foundactive = true;
				try{
					logWarning.visible = false;
				}
				catch(e:Error){
					
				}
				
				try{
					newlogWarning.visible = false;
				}
				catch(e:Error){
					
				}
				try{
					var saveManager:PersistenceManager = new PersistenceManager();
					saveManager.setProperty("useremail", resData[i].email);
					navigator.pushView(Home);	
				}
				catch(e:Error){}
			}
		}			
	}
	else {
	}
	busy = false;
	hideloading();
}

public function AddNewLocalUser(email:String,name:String,country:String):void
{
	busy = true;
	showloading();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "delete FROM localuser;";
	stmt.execute();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "INSERT into localuser values(:email,:name,:country,:active)";
	stmt.parameters[":email"] = email;
	stmt.parameters[":name"] = name;
	stmt.parameters[":country"] = country;
	stmt.parameters[":active"] = "yes";
	stmt.execute();
	getLocalUsers();
	
}
public function checkAvailability(username:String,userpassword:String):void {	
	busy = true;
	showloading();
	if ((nemail.text != "")
		&&(nemail.text.indexOf("@") != -1)
		&&(nname.text != "")
		&&(nname2.text != "")
		&&(npassword.text != "")
		&&(npassword2.text != "")
		&&(city.text != "")
		&&(npassword.text == npassword2.text)){
		newlogWarning.visible = false;
		oemail = nemail.text;
		opassword = npassword.text;
		oname1 = nname.text;
		oname2 = nname2.text;
		ocity = city.text;
		oprovince = province.selectedItem.name;
		obirthday = String(dt.selectedDate.day);
		obirthmonth = String(dt.selectedDate.month);
		obirthyear = String(dt.selectedDate.fullYear);
		ogender = gender.selectedValue.toString();
		createNewUser.send();
	}
	else {
		newlogWarning.visible = true;
		busy = false;
		hideloading();
	}	
}
public function afterCreateNewUser(ev:ResultEvent):void {
	busy = false;
	hideloading();
	if (ev.result[0].res.message == "ok"){
		AddNewLocalUser(oemail,
			oname1,
			'canada'
		);
	}
	else {
		newlogWarning.visible = true;
		busy = false;
		newlogWarning.text = ev.result[0].res.message;
	}
}
protected function view1_viewActivateHandler(event:ViewNavigatorEvent):void
{
	
	navigator.visible = true;
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
		"email varchar(255)," +
		"name varchar(255)," +
		"country varchar(255)," +
		"active varchar(255))";
	stmt.execute();
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT email, name, country, active FROM localuser where active = 'yes'";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	var loadManager:PersistenceManager = new PersistenceManager();
		
	if (resData.length != 0){
		navigator.pushView(Home);
	}
	else {
		busy = false;
		//hideloading();	
	}
}
protected function userPasswordInput_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 13){
		authorizeLogin(userNameInput.text,userPasswordInput.text);	
	}
}
public function facebookLogin():void
{		
	this.parentApplication.facebookloging();
}