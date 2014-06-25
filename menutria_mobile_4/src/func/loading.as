public var loadingimage:Image;
public var ti:Timer;
public var loadingcounter:Number = 0;
public var go:Group;
public var isloading:Boolean = false;
public function showloading():void {
	if (isloading == false){
		isloading = true;
		loadingcounter = 0;
		loadingimage = new Image();
		loadingimage.source = "assets/loading/"+getDPIHeight()+"/l"+loadingcounter.toString()+".png";
		go = new Group();
		go.percentHeight = 100;
		go.percentWidth = 100;
		loadingimage.horizontalCenter = 0;
		loadingimage.verticalCenter = 0;
		go.addElement(loadingimage);
		this.addElement(go);
		ti = new Timer(500,0);
		ti.addEventListener(TimerEvent.TIMER, afterLoadingTimer);
		ti.start();
	}
}
public function afterLoadingTimer(ev:TimerEvent):void {
	loadingcounter++;
	if (loadingcounter > 30){
		loadingcounter = 0;
	}
	loadingimage.source = "assets/loading/"+getDPIHeight()+"/l"+loadingcounter.toString()+".png";
}
public function hideloading():void {	
	isloading = false;
	try{
		
		ti.removeEventListener(TimerEvent.TIMER,afterLoadingTimer);
		ti.stop();
		this.removeElement(go);
	}
	catch(e:Error){
		
	}
	
}