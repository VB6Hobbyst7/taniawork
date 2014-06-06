
/*
function to resize the map when the app resizes
*/
private function onResize(e:ResizeEvent):void {
	//resize the map when the app does
	//if (this.map) this.map.size = new Size(this.width,100);
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