import com.mapquest.tilemap.MapCorner;
import com.mapquest.tilemap.MapCornerPlacement;
public function addZoomControl():void {
	if (this.zoomControl) return;
	
	//get the dpi to determine the scale of the zoom control
	if (this.applicationDPI < 240) {
		this.zoomControl = new SMZoomControl(40);
	}
	else {
		this.zoomControl = new SMZoomControl(64);
	}
	
	this.map.addControl(this.zoomControl,new MapCornerPlacement(MapCorner.TOP_LEFT, new Size(6,5)));
}



public function removeZoomControl():void {
	if (!this.zoomControl) return;
	this.map.removeControl(this.zoomControl);
	this.zoomControl = null;
}