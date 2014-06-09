import com.mapquest.services.traffic.Traffic;

public function addTraffic():void {
	if (this.traffic) return;
	this.traffic = new Traffic(this.map);
}


public function disableTraffic():void {
	//trace("Disabling traffic");
	this.trafficEnabled = false;
	if (!this.traffic) return;
	
	this.traffic.removeFlow();
	this.traffic.removeMarkets();
	this.traffic.removeIncidents();

	this.traffic = null;
}


public function enableTraffic():void {
	//trace("Enabling traffic");
	this.trafficEnabled = true;
	this.addTraffic();
	
	this.traffic.addFlow();
	this.traffic.addMarkets();
	this.traffic.addIncidents();

}
