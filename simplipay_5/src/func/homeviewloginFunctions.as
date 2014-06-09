import BarCode.Code128B;
import BarCode.Code39;
import BarCode.Code93;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filesystem.File;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;

import org.qrcode.QRCode;

import spark.events.ViewNavigatorEvent;

protected var sqlConnection:SQLConnection;
public function loginClick(event:MouseEvent):void
{	
	v1.visible = false;
	v2.visible = true;
	v3.visible = false;
	//logoutBTN.visible  = false;
	topLBL.text = "My Account";
	profileMgt.visible = false;
	newlogWarning.visible = false;
	logWarning.visible = false;
}
public function createNewClick(event:MouseEvent):void {
	v1.visible = false;
	v2.visible = false;
	v3.visible = true;
	//logoutBTN.visible  = false;
	topLBL.text = "My Account";
	profileMgt.visible = false;
	newlogWarning.visible = false;
	logWarning.visible = false;
}
public function backToLoginOptions():void {
	v1.visible = true;
	v2.visible = false;
	v3.visible = false;
	//logoutBTN.visible  = false;
	topLBL.text = "My Account";
	profileMgt.visible = false;
	newlogWarning.visible = false;
	logWarning.visible = false;
}
public function authorizeLogin(username:String,userpassword:String):void{	
	userid = username;
	passid = userpassword;

	checkLogin.send();
}
public function afterCheckLogin(ev:ResultEvent):void {
	if (ev.result[0].res.message == "ok"){
		AddNewLocalUser(ev.result[0].res.email,
			ev.result[0].res.name,
			ev.result[0].res.country);
	}
	else {
		//bad login
		logWarning.visible = true;
	}
}
protected function getLocalUsers():void
{
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT email, name, country FROM localuser";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);

	if (resData.length != 0){
		//good login
		var samp:String = resData[0].birthday;
		var stop2:String = "";
		profileMgt.visible = true;
		v1.visible = false;
		v2.visible = false;
		v3.visible = false;
		logWarning.visible = false;
		newlogWarning.visible = false;
		//logoutBTN.visible  = true;
	//	currentName.text = resData[0].name;
	//	currentEmail.text = resData[0].email;
	//	currentCountry.text = resData[0].country;
		topLBL.text = resData[0].name;
	
		var sp:Sprite = new Sprite();
		var qr:QRCode = new QRCode();
		qr.encode(resData[0].email);
		var img:Bitmap = new Bitmap(qr.bitmapData);
		img.width = 249;
		img.height = 249;
		sp.addChild(img);
		var u:UIComponent = new UIComponent();
		u.addChild(sp);
		u.horizontalCenter = 0;
		u.verticalCenter = 0;
		u.percentHeight = 100;
		u.percentWidth = 100;
		qrholder.addElement(u);	
		//<BarCode:Code39 id="BC" barCodeText="TEST" barCodeHeight="100" width="100%" 
		//height="100%" addLabel="true" labelAlign="center" x="10" y="10" />
		
		
		/*var bc:Code93 = new Code93();
		bc.percentHeight = 100;
		bc.percentWidth = 100;
		bc.addLabel = false;
		bc.labelAlign = "center";
		bc.barCodeHeight = 100;
		bc.barCodeText = resData[0].email;
		qrholder.addElement(bc);*/
	}
	else {
		//bad login or no local saved login.
		var stop:String = "";	
	}
}
public function logout():void {
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "delete from localuser";
	stmt.execute();
	//navigator.popToFirstView();
	v1.visible = true;
	v2.visible = false;
	v3.visible = false;
	topLBL.text = "My Account";
	//logoutBTN.visible  = false;
	profileMgt.visible = false;
	logWarning.visible = false;
	
}
public function AddNewLocalUser(email:String,name:String,country:String):void
{
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "INSERT into localuser values(:email,:name,:country)";
	stmt.parameters[":email"] = email;
	stmt.parameters[":name"] = name;
	stmt.parameters[":country"] = country;
	stmt.execute();
	getLocalUsers();
}
public function checkAvailability(username:String,userpassword:String):void {	
	if ((newEmail.text != "")&&(newEmail.text.indexOf("@") != -1)&&(newPassword.text != "")&&
		(newName.text != "")&&(newCountry.selectedIndex != -1)){
		newlogWarning.visible = false;
		newEmail2 = newEmail.text;
		newPassword2 = newPassword.text;
		newName2 = newName.text;
		newCountry2 = newCountry.selectedItem;
		createNewUser.send();
	}
	else {
		newlogWarning.visible = true;
	}
	
}
public function afterCreateNewUser(ev:ResultEvent):void {
	if (ev.result[0].res.message == "ok"){
		AddNewLocalUser(ev.result[0].res.email,
			ev.result[0].res.name,
			ev.result[0].res.country
			);
	}
	else {
		//bad login
		newlogWarning.visible = true;
		newlogWarning.text = ev.result[0].res.message;
	}
}
