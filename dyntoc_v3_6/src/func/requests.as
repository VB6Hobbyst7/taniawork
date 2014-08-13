import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.net.FileReference;

import mx.events.ListEvent;

public function refreshList():void {
	mainWarn.visible = false;
	getMain.send();
	fileRef = new FileReference();
	
	fileRef.addEventListener(Event.SELECT, fileRef_select);
	fileRef.addEventListener(ProgressEvent.PROGRESS, fileRef_progress);
	fileRef.addEventListener(Event.COMPLETE, fileRef_complete);
	dynTool.bubbleTree.addEventListener(ListEvent.ITEM_CLICK, clickBubble);
	dynTool.bubbleTree.addEventListener(ListEvent.ITEM_ROLL_OVER, rollBubble);	
	dynTool.bubbleSearch.textInput.addEventListener(KeyboardEvent.KEY_DOWN, bubbleEnterKey);
	dynTool.addBubbleButton.addEventListener(MouseEvent.CLICK, addBubble);
}
//Used to import a document from a users computer to the server
public function importDocument():void {
	lastFileName = "";
	lastFileUrl = "";
	var xmlTypes:FileFilter = new FileFilter("XML Files (*.xml)", "*.xml");
	var Types:Array = new Array(xmlTypes);
	fileRef.browse(Types);
	message.text = "";
}
private function fileRef_select(evt:Event):void {
	try {
		lastFileName = fileRef.name;
		message.text = "size (bytes): " + numberFormatter.format(fileRef.size);
	//	fileRef.upload(new URLRequest(FILE_UPLOAD_URL));
	} 
	catch (err:Error){
		message.text = "ERROR: zero-byte file";
	}
}
private function fileRef_progress(evt:ProgressEvent):void {
	progressBar.visible = true;
}
private function fileRef_complete(evt:Event):void {
	message.text += " (complete)";
	progressBar.visible = false;
	if (lastFileName != ""){
		//lastFileUrl = serverLocation + "/fileref/" + lastFileName;
		parseFile.send();
	}
	showWarn("File Complete");
}
