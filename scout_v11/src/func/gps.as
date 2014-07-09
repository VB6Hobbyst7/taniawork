import flash.events.GeolocationEvent;
import flash.sensors.Geolocation;
import mx.collections.ArrayCollection;
import spark.events.ViewNavigatorEvent;
import flash.events.GeolocationEvent;
import flash.sensors.Geolocation;
public var g:Geolocation = new Geolocation();    
public function onactivate(event:Event):void
{
	initGPS();
}
public function initGPS():void {
	try{
		if (Geolocation.isSupported){
			g.addEventListener(GeolocationEvent.UPDATE, onUpdate);
			this.addEventListener(ViewNavigatorEvent.REMOVING,onRemove);
		}
		else {
			updateGPS(53.493252,-113.502231);
		}
	}
	catch(e:Error){
		updateGPS(53.493252,-113.502231);
	}
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
protected function onRemove(event:ViewNavigatorEvent):void
{
	g.removeEventListener(GeolocationEvent.UPDATE, onUpdate);                
}