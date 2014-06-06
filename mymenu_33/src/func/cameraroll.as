import flash.events.ErrorEvent;
import flash.events.MediaEvent;
import flash.events.MouseEvent;
import flash.media.CameraRoll;
import flash.media.MediaPromise;

public var cameraRoll:CameraRoll;
public function editImageClick(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	//if(CameraRoll.supportsBrowseForImage){
		cameraRoll = new CameraRoll();
		cameraRoll.addEventListener(MediaEvent.SELECT,
			mediaSelected);
		cameraRoll.addEventListener(ErrorEvent.ERROR, onError);
	//} 
}
private function browseGallery(event:MouseEvent):void {
	cameraRoll.browseForImage();
}
private function onError(event:ErrorEvent):void {
	trace("error has occurred");
}
private function mediaSelected(event:MediaEvent):void{
	var mediaPromise:MediaPromise = event.data;
	//status.text = mediaPromise.file.url;
	mainprofimage.source = mediaPromise.file.url;
	mainprofimage.visible = true;
	defaultimggroup.visible = false;
	
}