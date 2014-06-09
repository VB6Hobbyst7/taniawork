package utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.GeolocationEvent;
	import flash.sensors.Geolocation;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	[Event(name="locationUpdate", type="flash.events.Event")]
	public class GeolocationUtil extends EventDispatcher
	{
		protected var geo:Geolocation;
		public var updateCount:int;
		protected var service:HTTPService = new HTTPService();
		
		public var location:String;
		public var longitude:Number;
		public var latitude:Number;
		
		public function GeolocationUtil()
		{
			service.url = "https://maps.googleapis.com/maps/api/geocode/xml";
		}
		
		public function geoCodeAddress(address: String):AsyncToken
		{
			return service.send({address: address, sensor: Geolocation.isSupported});
		}
		
		public function getLocation():void
		{
			if (Geolocation.isSupported)
			{
				geo = new Geolocation();
				geo.setRequestedUpdateInterval(500);   
				updateCount = 0;
				geo.addEventListener(GeolocationEvent.UPDATE, locationUpdateHandler);                   
			}	
		}
		
		protected function locationUpdateHandler(event:GeolocationEvent):void
		{
			// Throw away the first location event because it's almost always the last known location, not current location
			updateCount++;
			if (updateCount == 1) return; 
			
			if (event.horizontalAccuracy <= 150)
			{
				trace("lat:" + event.latitude + " long:" + event.longitude + " horizontalAccuracy:" + event.horizontalAccuracy);
				geo.removeEventListener(GeolocationEvent.UPDATE, locationUpdateHandler);
				geo = null;
			}
			
			longitude = event.longitude;
			latitude = event.latitude;

			var token:AsyncToken = service.send({latlng: latitude+","+longitude, sensor: Geolocation.isSupported});
			token.addResponder(new AsyncResponder(
				function(event:ResultEvent, token:AsyncToken):void
				{
					// Map the location to city and state from the response address component
					location = event.result.GeocodeResponse.result[0].address_component[3].long_name + ', '+ event.result.GeocodeResponse.result[0].address_component[5].long_name;
					dispatchEvent(new Event("locationUpdate"));
				},
				function (event:FaultEvent, token:AsyncToken):void
				{
					// fail silently
					trace("Reverse geocoding error: " + event.fault.faultString);
				}));
		}
		
	}
}