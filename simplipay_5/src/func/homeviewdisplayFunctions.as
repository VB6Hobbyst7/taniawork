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


public var profileShown:Boolean = false;
public var chosenMenuOption:uint = 1;
public var profWaiting:Boolean = false;
public function screenAdjust():void {
	if ((this.width >= 640)&&(this.height >= 870)){
		//menuCont.width = 600;
		//menuCont.height = 800;
		//menuCont.horizontalCenter = 0;
		//menuCont.verticalCenter = 0;
		
	}
	else if ((this.height > 300)&&(this.width > 900)){
		//menuCont.width = 300;
		//menuCont.height = 300;
		//menuCont.horizontalCenter = 0;
		//menuCont.verticalCenter = 0;
		
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
	//stmt.sqlConnection = sqlConnection;
	////stmt.text = "Drop TABLE localuser";
	//stmt.execute();
	
	
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
		"email varchar(255)," +
		"name varchar(255)," +
		"country varchar(255))";
	stmt.execute();
	
	
	getLocalUsers();
}	
