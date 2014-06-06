
public function toggleBusyIndicator(enable:Boolean, view:View):void {
	if (enable) {
		if (!this.biBusyIndicator) this.makeBusyIndicator();
		view.addElement(this.biBusyIndicator);
	}
	else {
		try {
			view.removeElement(this.biBusyIndicator);
			this.biBusyIndicator = null;
		}
		catch(e:Error) {
			//do nothing
		}
	}
}


private function makeBusyIndicator():void {
	this.biBusyIndicator = new BusyIndicator();
	this.biBusyIndicator.width = 120;
	this.biBusyIndicator.height = 120;
	this.biBusyIndicator.horizontalCenter = 0;
	this.biBusyIndicator.verticalCenter = 0;
}