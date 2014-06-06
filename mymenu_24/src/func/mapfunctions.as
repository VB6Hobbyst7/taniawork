import com.mapquest.*;
import com.mapquest.mobile.TextUtil;
import com.mapquest.services.traffic.Traffic;
import com.mapquest.tilemap.*;
import com.mapquest.tilemap.controls.shadymeadow.SMZoomControl;
import com.mapquest.tilemap.pois.*;

public function makeMap():void {
	this.map = new TileMap(this.key,this.mapStartZoomLevel,new LatLng(38.134557, -98.4375),this.mapStartType);
	this.map.size = new Size(this.width,100);
	this.map.mapFriction = this.mapFriction;
	this.map.name = "myMap";
	if (this.mapUseZoomControl) this.addZoomControl();
}

/*
function to resize the map when the app resizes
*/
private function onResize(e:ResizeEvent):void {
	//resize the map when the app does
	//if (this.map) this.map.size = new Size(this.width,100);
}
/*
function to remove all shapes (pois,routes,traffic,overlays) from the map
*/
public function removeShapesFromMap():void {
	//trace("Removing shapes from map");
	
	if (this.map.getShapeCollection("routeRibbon")) {
		this.removeShapesAndColls(this.map.getShapeCollection("routeRibbon"));
		this.map.removeShapeCollection(this.map.getShapeCollection("routeRibbon"));
	}
	if (this.map.getShapeCollection("searchShapeCollection")) {
		this.removeShapesAndColls(this.map.getShapeCollection("searchShapeCollection"));
		this.map.removeShapeCollection(this.map.getShapeCollection("searchShapeCollection"));
	}
	if (this.traffic) {
		this.disableTraffic();
	}
	
	this.removeShapesAndColls(this.map.getShapeCollection());
}
/*
since we're mobile, do this to free up memory faster instead of waiting for gc
*/
private function removeShapesAndColls(coll:ShapeCollection):void {
	var s:IShape;
	
	for (var i:int = 0; i < coll.length; i++) {
		s = coll.getShapeAtIndex(i);
		coll.remove(s);
		s = null;
	}
	
	coll = null;
}	

protected function onDisplayStateChange(e:NativeWindowDisplayStateEvent):void
{
	trace("Display State Changed from " + e.beforeDisplayState + " to " + e.afterDisplayState);
}

// The application is now in the foreground and active, restore the frameRate to the default
protected function onActivate(event:Event):void
{
	trace("Handling application activate event");
	stage.frameRate=60; 
}

// Handle the application being sent to the background, garbage collect and lower frame rate to use less resources
protected function onDeactivate(event:Event):void 
{
	trace("Handling application deactivate event");
	System.gc();
	stage.frameRate=2;
}

// Called when application is first invoked
protected function onInvoke(invokeEvt:InvokeEvent):void 
{
	trace("Handling invoke event");
}

// Handle Global Errors


protected function onError(e:UncaughtErrorEvent):void
{
	e.preventDefault();
	trace("An error has occurred and been caught by the global error handler: " + e.error.toString(), "My Global Error Handler");
}

// Called when application exits
protected function onAppExiting(e:Event):void
{
	trace("Handling application exit event");
}

// Called when application is about to persist data (can call cancel if this is not desired)
protected function onPersisting(e:FlexEvent):void
{
	trace("Handling persisting event");
}

// Called when application is about to restore data (can call cancel if this is not desired)
protected function onRestoring(e:FlexEvent):void
{
	trace("Handling restoring event");
	//
}