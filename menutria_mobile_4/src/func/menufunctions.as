import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.GeolocationEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.html.HTMLLoader;
import flash.net.URLRequest;
import flash.sensors.Geolocation;
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.effects.effectClasses.FadeInstance;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;
import mx.rpc.events.ResultEvent;
import spark.collections.SortField;
import spark.components.supportClasses.StyleableTextField;
import spark.core.ContentCache;
import spark.events.IndexChangeEvent;
import spark.events.ListEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.managers.PersistenceManager;
import views.MenuDescription;

[Bindable]
public var actions:ArrayCollection;
[Bindable]
private var _addrString:String;
[Bindable]
private var _distString:String;
[Bindable]
public var googleTravelUrl:String = "";
protected var g:Geolocation = new Geolocation();    

[Bindable]
public var locationid:String = "";
[Bindable]
public var radiusOptions:ArrayCollection = new ArrayCollection();
[Bindable]
public var sortMode:Number = 0;
[Bindable]
public var reverse:Boolean = false;
[Bindable]
public var locatoinidGo:Number = -1;
[Bindable]
public var currentselectmode:Number = 1;
[Bindable]
public var listData:ArrayCollection = new ArrayCollection();
[Bindable]
public var backuplistdata:ArrayCollection = new ArrayCollection();
[Bindable]
public var ratingpriceoptionval:uint = 0;
[Bindable]
public var resData:ArrayCollection = new ArrayCollection();
[Bindable]
public var modData:ArrayCollection = new ArrayCollection();
protected function view1_activateHandler(event:Event):void
{
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS resvalues (" +
		"id int(255)," +
		"name longtext," +
		"chosen  varchar(255))";							
	stmt.execute();
	showloading();
	warn.visible = false;
	busy = true;
	setLoginVars();
	locationid = data.locationid;
	getMenu.send();
	filterarea.visible = true;
}	

public function afterGetMenu(ev:ResultEvent):void
{	busy = false;
	hideloading();
	listData = new ArrayCollection();
	modData = new ArrayCollection();
	resData = new ArrayCollection();
	try{			
		listData = ev.result[0].ress.res;		
	}
	catch(e:Error){
		try{
			
			listData.addItem(ev.result[0].ress.res);
		}
		catch(e:Error){
		}
	}
	
	try{			
		resData = ev.result[0].ress2.res2;		
	}
	catch(e:Error){
		try{	
			resData.addItem(ev.result[0].ress2.res2);
		}
		catch(e:Error){}
	}
	
	try{			
		modData = ev.result[0].ress3.res3;		
	}
	catch(e:Error){
		try{	
			modData.addItem(ev.result[0].ress3.res3);
		}
		catch(e:Error){}
	}
	
	afterGetMenuCont();
} 
public function afterGetMenuCont():void {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT * FROM resvalues";
	stmt.execute();
	var resvaluesData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	
	
	if (resvaluesData.length > 0){
		for (var j:uint = 0; j < listData.length; j++){
			var goodstatus:Number = 0;
			var permabad:Boolean = false;
			for (var k:uint = 0; k < resData.length; k++){
				if (resData[k].menuid == listData[j].id){
					for (var i:uint = 0; i<resvaluesData.length; i++){
						if ((resvaluesData[i].id == resData[k].restrictid)&&(resvaluesData[i].chosen == 'yes')){
							goodstatus = 1;
							for (var l:uint = 0; l < modData.length; l++){
								if ((resvaluesData[i].id == modData[l].restrictid)&&(modData[l].menuid == resData[k].menuid)){
									//show it but add warning
									if (resData[k].menuid == "286"){
										var stp:String = "";
									}
									goodstatus = 2;
								}
							}
							
							if (goodstatus == 1){
								permabad = true;
								if (resData[k].menuid == "286"){
									var stpre:String = "";
								}
							}
						}
					}
				}
			}
			
			
			if (permabad){
				//no mod for an item so its bad
				listData[j].hideall = true;
				listData[j].goodforme = false;
			}
			else if (goodstatus == 2){
				// a mod exsists to a restriction so just add warning
				listData[j].hideall = false;
				listData[j].goodforme = false;
			}
			else {
				//all good show away. 
				listData[j].hideall = false;
				listData[j].goodforme = true;
			}
			
			
		}
		
		listData.refresh();
		menuList.dataProvider = listData;
		
	}
	
	
	if (listData.length <= 0){
		warn.visible = true;
	}
	else {
		populatelist();
	}
	
} 
public function populatelist():void {
	var srt:Sort = new Sort();
	if (ratingpriceoptionval == 0){
		srt.fields = [new SortField("rating",true)];
		listData.sort = srt;
		listData.refresh();
	}
	else if (ratingpriceoptionval == 1){
		srt.fields = [new SortField("cost")];
		listData.sort = srt;
		listData.refresh();
	}
	menuList.dataProvider = listData;
	
}
public function storeListClick():void {	
	if (menuList.selectedIndex != -1){
		navigator.pushView(MenuDescription, listData[menuList.selectedIndex]);	
	}
}
public function searchClick():void
{
	listData.filterFunction = filterCompleted;
	listData.refresh();
	menuList.dataProvider = listData;	
}
private function filterCompleted(item:Object):Boolean{
	return true;
}
private function returnall(item:Object):Boolean{
	return true;
}
public function press(event:KeyboardEvent):void {
	searchClick();
}
public function goback(ev:MouseEvent):void {
	navigator.popView();
}
public function ratingpriceoptionclick():void {
	if (ratingpriceoptionval == 0){
		ratingpriceoptionval = 1;
		ratingpriceimage1.visible = false;
		ratingpriceimage2.visible = true;
		selectview1.visible = false
		selectview2.visible = true;
	}
	else {
		ratingpriceoptionval = 0;
		ratingpriceimage1.visible = true;
		ratingpriceimage2.visible = false;
		selectview1.visible = true
		selectview2.visible = false;
	}
	populatelist();
}