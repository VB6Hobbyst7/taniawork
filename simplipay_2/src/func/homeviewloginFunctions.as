import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.events.MouseEvent;
import flash.filesystem.File;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import flash.display.Bitmap;
import flash.display.Sprite;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import org.qrcode.QRCode;
import spark.events.ViewNavigatorEvent;

protected var sqlConnection:SQLConnection;
public function loginClick(event:MouseEvent):void
{	
	loginReg.visible = true;
	createNew.visible = false;
	newlogWarning.visible = false;
}
public function createNewClick(event:MouseEvent):void {
	loginReg.visible = false;
	createNew.visible = true;
	newlogWarning.visible = false;
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
			ev.result[0].res.country,
			ev.result[0].res.gender,
			ev.result[0].res.birthday,
			ev.result[0].res.birthmonth,
			ev.result[0].res.birthyear);
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
	stmt.text = "SELECT email, name, country, gender, birthday, birthmonth, birthyear FROM localuser";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);

	if (resData.length != 0){
		//good login
		var samp:String = resData[0].birthday;
		var stop2:String = "";
		profileMgt.visible = true;
		loginCont.visible = false;
		createNew.visible = false;
		logWarning.visible = false;
		newlogWarning.visible = false;
		
		currentName.text = resData[0].name;
		currentEmail.text = resData[0].email;
		currentCountry.text = resData[0].country;
		if (resData[0].gender == 'M'){
			currentGender.text = resData[0].gender;
		}
		else if (resData[0].gender == 'F'){
			currentGender.text = resData[0].gender;
		}
		currentBirthday.text = resData[0].birthday + "/" + resData[0].birthmonth + "/" + resData[0].birthyear
	
		var sp:Sprite = new Sprite();
		var qr:QRCode = new QRCode();
		qr.encode(resData[0].email);
		var img:Bitmap = new Bitmap(qr.bitmapData);
		img.width = 150;
		img.height = 150;
		sp.addChild(img);
		var u:UIComponent = new UIComponent();
		u.addChild(sp);
		u.horizontalCenter = 0;
		u.verticalCenter = 0;
		u.width = 150;
		u.height = 150;
		qrholder.addElement(u);	
		
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
	navigator.popToFirstView();
	
	loginCont.visible = true;
	createNew.visible = false;
	profileMgt.visible = false;
	logWarning.visible = false;
	loginReg.visible = true;
	
}
public function AddNewLocalUser(email:String,name:String,country:String,
								   gender:String,birthday:String,
								   birthmonth:String,birthyear:String):void
{
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "INSERT into localuser values(:email,:name,:country,:gender,:birthday,:birthmonth,:birthyear)";
	stmt.parameters[":email"] = email;
	stmt.parameters[":name"] = name;
	stmt.parameters[":country"] = country;
	stmt.parameters[":gender"] = gender;
	stmt.parameters[":birthday"] = birthday;
	stmt.parameters[":birthmonth"] = birthmonth;
	stmt.parameters[":birthyear"] = birthyear;
	stmt.execute();
	getLocalUsers();
}
public function checkAvailability(username:String,userpassword:String):void {	
	if ((newEmail.text != "")&&(newEmail.text.indexOf("@") != -1)&&(newPassword.text != "")&&
		(newName.text != "")&&(newBirthday.selectedDate != null)&&(newCountry.selectedIndex != -1)){
		newlogWarning.visible = false;
		newEmail2 = newEmail.text;
		newPassword2 = newPassword.text;
		newName2 = newName.text;
		newBirthday2 = newBirthday.selectedDate.day.toString();
		newBirthmonth2 = newBirthday.selectedDate.month.toString();
		newBirthyear2 = newBirthday.selectedDate.fullYear.toString();
		newGender2 = newGendergroup.selectedValue.toString().charAt(0);
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
			ev.result[0].res.country,
			ev.result[0].res.gender,
			ev.result[0].res.birthday,
			ev.result[0].res.birthmonth,
			ev.result[0].res.birthyear);
	}
	else {
		//bad login
		newlogWarning.visible = true;
		newlogWarning.text = ev.result[0].res.message;
	}
}
