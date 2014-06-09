import com.mapquest.tilemap.pois.PinMapIcon;


public function addGpsPoi(event:MouseEvent=null):void {
	if (this.gpsLatLng) this.gpsPoi = new Poi(this.gpsLatLng);
	
	//override defaults for high resolution devices
	if (this.applicationDPI >= 240) {
		var i:PinMapIcon = (this.gpsPoi.icon as PinMapIcon);
		i.iconWidth = 48;
		this.gpsPoi.icon = i;
	}
	
	this.gpsPoi.infoWindowTitleText = "Current Location";
	this.gpsPoi.infoContent = "LatLng: " + this.gpsPoi.latLng.toString();
	
	this.removeShapesFromMap();
	this.map.addShape(this.gpsPoi);
	this.map.bestFit(false,2,14);
}



/*
function to create the GPS object
*/
public function initGPS():void {
	this.gpsTried = true;
	
	if (Geolocation.isSupported) {
		this.gpsIsSupported = true;
		if (!this.gps) this.gps = new Geolocation();
	}
}




public function setGpsLatLng():void {
	if(!this.gpsIsSupported) return;
	
	if (!this.gps.hasEventListener(GeolocationEvent.UPDATE)) {
		this.gps.addEventListener(GeolocationEvent.UPDATE, this.onGeoUpdate,false,0,true);
	}
}



private function onGeoUpdate(e:GeolocationEvent):void {
	if (e.horizontalAccuracy < 100) {
		this.gpsLatLng = new LatLng(Number(e.latitude.toFixed(6)),Number(e.longitude.toFixed(6)));
		this.gps.removeEventListener(GeolocationEvent.UPDATE, this.onGeoUpdate);
	}
}	