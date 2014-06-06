import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;

import model.Smurf;

import mx.collections.ArrayCollection;
import mx.effects.Move;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;

import spark.effects.Scale;
import spark.events.ViewNavigatorEvent;

import views.itemList;

public var profileShown:Boolean = false;
public var chosenMenuOption:uint = 1;
public var profWaiting:Boolean = false;
public function screenAdjust():void {
	if ((this.width >= 640)&&(this.height >= 870)){
		menuCont.width = 600;
		menuCont.height = 800;
		menuCont.horizontalCenter = 0;
		menuCont.verticalCenter = 0;
		
	}
	else if ((this.height > 300)&&(this.width > 900)){
		menuCont.width = 300;
		menuCont.height = 300;
		menuCont.horizontalCenter = 0;
		menuCont.verticalCenter = 0;
		
	}
	else {
		//menuCont.left = 0;
		//menuCont.right = 0;
		//menuCont.top = 0;
		//menuCont.bottom = 0;
	}
}
public function initHomeView(event:FlexEvent):void
{
	screenAdjust();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
		"email varchar(255)," +
		"name varchar(255)," +
		"country varchar(255)," +
		"gender varchar(1)," +
		"birthday varchar(2)," +
		"birthmonth varchar(20)," +
		"birthyear varchar(4))";
	stmt.execute();
	getLocalUsers();
}	
public function menu(i:uint):void{
	chosenMenuOption = i; 
	navigator.pushView(itemList, {locationType:i});
	menuCont.visible = true;
}
public function activateProfile():void {
	profWaiting = true;
	profileCont.visible = true;
	var mv2:Move = new Move();
	var mv:Move = new Move();
	if (profileShown == false){
		mv2.yTo = 44;
		mv2.addEventListener(EffectEvent.EFFECT_END, afterScale);
		mv2.duration = 1000;
		mv2.target = profileCont;	
		mv.yTo = -20;
		mv.duration = 1000;
		mv.target = profileBtn;
		mv2.play();
		mv.play();
		profileShown = true;
		logWarning.visible = false;
	}
	else {
		profileShell.visible = false;
		mv2.yTo = this.height;
		mv2.duration = 1000;
		mv2.addEventListener(EffectEvent.EFFECT_END, afterScale2);
		mv2.target = profileCont;
		mv.yTo = this.height-56;
		mv.duration = 1000;
		mv.target = profileBtn;
		mv2.play();
		mv.play();
		profileShown = false;
		logWarning.visible = false;
	}
}
public function afterScale(ev:EffectEvent):void {
	profileShell.visible = true;
	profWaiting = false;
}
public function afterScale2(ev:EffectEvent):void {
	profWaiting = false;
}