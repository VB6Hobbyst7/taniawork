// ActionScript file
import flash.display.IBitmapDrawable;
import flash.filters.DropShadowFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.core.IUIComponent;
import mx.graphics.ImageSnapshot;
import mx.rpc.events.ResultEvent;

public function snap():void {
	if (lc.selected){
		takeSnapshot(linechart);
	}
	else if (ac.selected){
		takeSnapshot(areachart);
	}
	else if (am.selected){
	//	takeSnapshot(ballonCont);
	}
}
private function takeSnapshot(source:IBitmapDrawable):void {
	if ((saveurl.text != "")&&(saveurl.text.indexOf(".") != -1)){
		try{
			var imageSnap:ImageSnapshot = ImageSnapshot.captureImage(source);
			var imageByteArray:ByteArray = imageSnap.data as ByteArray;
			var fr:FileReference = new FileReference();
			fr.save(imageByteArray,saveurl.text);
		}
		catch(e:Error){
			
		}
	}
	
}