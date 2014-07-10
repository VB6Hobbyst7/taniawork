import flash.events.GeolocationEvent;
import flash.sensors.Geolocation;
import mx.collections.ArrayCollection;
import spark.events.ViewNavigatorEvent;
import flash.events.GeolocationEvent;
import flash.sensors.Geolocation;
public var g:Geolocation = new Geolocation();    
public function onactivate(event:Event):void
{
	
	try{
	stage.frameRate=30; 
	}
	catch(e:Error){}
	
	try{
	initGPS();
	}
	catch(e:Error){}
}
public function initGPS():void {
	try{
		if (Geolocation.isSupported){
			g = new Geolocation();    
			g.addEventListener(GeolocationEvent.UPDATE, onUpdate);
		}
	}
	catch(e:Error){}
}
protected function onUpdate(event:GeolocationEvent):void
{
	updateGPS(event.latitude,event.longitude);	
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
protected function ondeactivate():void
{
	try{
	stage.frameRate=2;
	}
	catch(e:Error){}
	try{
	g.removeEventListener(GeolocationEvent.UPDATE, onUpdate);  
	}
	catch(e:Error){}
}