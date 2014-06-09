import com.mapquest.tilemap.TileMapEvent;



/*
event handler called when an infowindow is opened
*/
private function onIWOpen(e:TileMapEvent):void {
	//if we're using the zoom control, hide it when the iw opens
	if (this.mapUseZoomControl) this.zoomControl.visible = false;
}



/*
event handler for an infowindow close event
*/
private function onIWClose(e:TileMapEvent):void {
	//show the zoom control when the iw closes
	if (this.mapUseZoomControl) this.zoomControl.visible = true;
}