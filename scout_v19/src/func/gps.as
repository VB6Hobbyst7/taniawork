import flash.events.Event;
import flash.events.GeolocationEvent;
import flash.sensors.Geolocation;

import mx.collections.ArrayCollection;

import spark.events.ViewNavigatorEvent;
public var g:Geolocation = new Geolocation();    
public function onactivate(event:Event):void
{
	investigateFacebookCallback();
	RateBox.rateBox.onLaunch();	
	
	try{
		stage.frameRate=60; 
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

protected function ondeactivate():void
{
	pm.setProperty("sviewdata",mainNavigator.saveViewData());
	pm.save();
	try{
		stage.frameRate=2;
	}
	catch(e:Error){}
	try{
		g.removeEventListener(GeolocationEvent.UPDATE, onUpdate);  
	}
	catch(e:Error){}
}