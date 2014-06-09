// ActionScript file
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.events.UncaughtErrorEvent;
import flash.text.SoftKeyboardType;
import flash.utils.Dictionary;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.utils.ObjectUtil;

import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
import pl.mateuszmackowiak.nativeANE.NativeDialogListEvent;
import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
import pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialog;
import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextField;
import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
import pl.mateuszmackowiak.nativeANE.notification.NativeNotifiction;
import pl.mateuszmackowiak.nativeANE.progress.NativeProgress;
import pl.mateuszmackowiak.nativeANE.properties.SystemProperties;
import pl.mateuszmackowiak.nativeANE.toast.Toast;

import spark.events.IndexChangeEvent;
import spark.events.ViewNavigatorEvent;
import spark.layouts.HorizontalLayout;
import spark.layouts.VerticalLayout;




private var progressPopup:NativeProgress;
private var p:int = 0;
private var myTimer:Timer = new Timer(100);
private var multChDialog:NativeListDialog=null;
private var singleChDialog:NativeListDialog=null;
private var textInputDialog:NativeTextInputDialog=null;
private var choces:Vector.<String>=null;
private var checkedItems:Vector.<Boolean>=null;
private var selectedIndex:int = 2;


public function startnative():void {
	
}

protected function exiting(event:Event):void
{
	NativeAlert.dispose();
	SystemProperties.getInstance().dispose();
	Toast.dispose();
}
private function onError(event:*):void
{
	if(event is UncaughtErrorEvent){
		const e:UncaughtErrorEvent = event;
		if(e.error is Error){
			mess("UncaughtErrorEvent Error "+ (e.error as Error).message+"   "+(e.error as Error).toString());
		}else{
			mess("UncaughtErrorEvent ErrorEvent "+ (e.error as ErrorEvent).text+"   "+(e.error as ErrorEvent).toString());
		}
	}else{
		mess("Error "+ event.text+"   "+event.toString());
	}
}
private function traceEvent(event:*):void
{
	if(event.hasOwnProperty("text")){
		mess(event.toString()+"  "+event.text);
	}
	else{
		mess(event.toString());
	}
}
protected function view1_backKeyPressedHandler(event:FlexEvent):void
{
	event.preventDefault();
	mess("back key pressed");
	
	myTimer.removeEventListener(TimerEvent.TIMER,updateProgress);
	myTimer.stop();
	p = 0;
	if(progressPopup){
		progressPopup.hide();
	}
}








public function listAllPropertiesFromSystemProperties():void
{
	if(SystemProperties.isSupported){
		var dictionary:Dictionary = SystemProperties.getInstance().getSystemProperites();//SystemProperties.getProperites();
		if(!dictionary){
			mess("return null dictionary");
			return;
		}
		
		mess("--------------------");
		for (var key:String in dictionary) 
		{ 
			var readingType:String = key; 
			var readingValue:String = dictionary[key]; 
			mess(readingType + "=" + readingValue); 
		} 
		mess("--------------------");
		dictionary = null;
	}else{
		mess("SystemProperties is NOT supported on this platform!!");
	}
}



protected function callAlert(event:MouseEvent):void
{
	NativeAlert.show("Text1","Text2","Text3", "Text4"
		, function closeFun(event:NativeDialogEvent):void
		{
			var n:NativeAlert = event.target as NativeAlert;
			//event.preventDefault();
			//n.show();
			mess(event.toString());
		}
		,true,themesIOS[0]);
	
	
	
	NativeAlert.show("Text1","Text2","Text3", "Text4"
		, function closeFun(event:NativeDialogEvent):void
		{
			var n:NativeAlert = event.target as NativeAlert;
			//event.preventDefault();
			//n.show();
			mess(event.toString());
		}
		,true,themesIOS[0]);
	
	/*var n2:NativeAlert = NativeAlert.show(messageInput.text,titleInput.text,closeLabelInput.text, otherLabels.text
	,null
	,canclebleCheckbox.selected,ThemeSelector.selectedItem.data);
	n2.addEventListener(NativeDialogEvent.CLOSED,function(event:NativeDialogEvent):void{
	var n:NativeAlert = event.target as NativeAlert;
	//event.preventDefault();
	//n.show();
	mess(event.toString());
	});*/
}







//---------------------------------------------------------------------
//
// NativeProgress.
//
//---------------------------------------------------------------------
protected function openProgressPopup(style:int):void
{
	try{
		progressPopup = new NativeProgress(style);
		progressPopup.setSecondaryProgress(45);
		progressPopup.addEventListener(NativeDialogEvent.CANCELED,closeNativeProgressHandler);
		progressPopup.addEventListener(NativeDialogEvent.OPENED,traceEvent);
		progressPopup.addEventListener(NativeDialogEvent.CLOSED,closeNativeProgressHandler);
		progressPopup.addEventListener(ErrorEvent.ERROR,onError);
		progressPopup.androidTheme = themesIOS[0];
		progressPopup.iosTheme = themesIOS[0];
		progressPopup.setMax(50);
		progressPopup.setTitle("Text1");
		progressPopup.setMessage("Text2");
		progressPopup.show(true,true);
		myTimer.addEventListener(TimerEvent.TIMER, updateProgress);
		myTimer.start();
	}catch(e:Error){
		mess("Error "+ e.message+"   "+e.toString());
	}
}
private function closeNativeProgressHandler(event:NativeDialogEvent):void
{
	mess(event.toString());
	
	progressPopup.removeEventListener(NativeDialogEvent.CANCELED,closeNativeProgressHandler);
	progressPopup.removeEventListener(NativeDialogEvent.CLOSED,closeNativeProgressHandler);
	progressPopup.removeEventListener(NativeDialogEvent.OPENED,traceEvent);
	progressPopup.removeEventListener(ErrorEvent.ERROR,onError);
	progressPopup.dispose();
	
	myTimer.removeEventListener(TimerEvent.TIMER,updateProgress);
	myTimer.stop();
	p = 0;
}
private function updateProgress(event:TimerEvent):void
{
	p++;
	if(p>=50){
		p = 0;
		progressPopup.hide("with some message",true);
		(event.target as Timer).stop();
	}
	else{
		if(p>=25){
			progressPopup.setMessage("some message changed in between");
			progressPopup.setTitle("some title changed in between");
		}
		try{
			if(progressPopup.indeterminate==false)
				progressPopup.setProgress(p);
		}catch(e:Error){
			mess("Error "+ e.message+"   "+e.toString());
		}
	}
}



//---------------------------------------------------------------------
//
// Toast
//
//---------------------------------------------------------------------
public function showToast(event:MouseEvent):void
{
	Toast.show("text1",Toast.LENGTH_LONG);
}

public function showCenteredToast(event:MouseEvent):void
{
	var randX:int = Math.random()*600;
	var randY:int = Math.random()*600;
	Toast.showWithDifferentGravit("Text 1",Toast.LENGTH_SHORT,Toast.GRAVITY_LEFT,randX,randY);
}



//---------------------------------------------------------------------
//
// TextInputDialog
//
//---------------------------------------------------------------------
public function openTextInputDialog(event:MouseEvent):void{
	textInputDialog = new NativeTextInputDialog();
	textInputDialog.theme = "0x00000004";
	
	textInputDialog.addEventListener(NativeDialogEvent.CANCELED,onCancleTextInputDialogHandler);
	textInputDialog.addEventListener(NativeDialogEvent.OPENED,traceEvent);
	textInputDialog.addEventListener(ErrorEvent.ERROR,onError);
	textInputDialog.addEventListener(NativeDialogEvent.CLOSED,onCloseTextInputDialogHandler);
	
	var v:Vector.<NativeTextField> = new Vector.<NativeTextField>();
	
	var message:NativeTextField = new NativeTextField(null);
	message.text = "pleas enter adress";
	message.editable = false;
	v.push(message);
	
	var serverAdressTextInput:NativeTextField = new NativeTextField("serverAdress");
	serverAdressTextInput.displayAsPassword = true;
	serverAdressTextInput.prompText = "192.168.0.1:8080";
	serverAdressTextInput.softKeyboardType = SoftKeyboardType.URL;
	serverAdressTextInput.addEventListener(Event.CHANGE,traceEvent);
	v.push(serverAdressTextInput);
	
	var a:Array = new Array();
	a.push("yes");
	a.push("no");
	var buttons:Vector.<String> = new Vector.<String>();
	if(a==null || a.length==0)
		buttons.push("OK");
	else{
		a.unshift("OK");
		for each (var button:String in a) 
		{
			buttons.push(button);
		}
	}
	
	textInputDialog.setTitle("ENTER_SERVER_ADRESS");
	textInputDialog.show(v,buttons,true);
}

private function onCloseTextInputDialogHandler(event:NativeDialogEvent):void
{
	event.preventDefault();
	for each (var n:NativeTextField in NativeTextInputDialog(event.target).textInputs) 
	{
		if(n.name)
			mess("  "+n.name+":  "+n.text);
	}
	mess(event.toString());
	
	textInputDialog.removeEventListener(NativeDialogEvent.CANCELED,onCancleTextInputDialogHandler);
	textInputDialog.removeEventListener(NativeDialogEvent.CLOSED,onCloseTextInputDialogHandler);
	textInputDialog.removeEventListener(NativeDialogEvent.OPENED,traceEvent);
	textInputDialog.removeEventListener(ErrorEvent.ERROR,onError);
	
}
public function onCancleTextInputDialogHandler(event:NativeDialogEvent):void
{
	event.preventDefault();
	mess(event.toString());
	
	textInputDialog.removeEventListener(NativeDialogEvent.CANCELED,onCancleTextInputDialogHandler);
	textInputDialog.removeEventListener(NativeDialogEvent.CLOSED,onCloseTextInputDialogHandler);
	textInputDialog.removeEventListener(NativeDialogEvent.OPENED,traceEvent);
	textInputDialog.removeEventListener(ErrorEvent.ERROR,onError);
	
}


public function mess(message:String):void
{
	//returnText.appendText(message+"\n");
	trace(message+"\n");
	try{
		SystemProperties.getInstance().console(message);
	}catch(error:Error){
		trace(error);
	}
}




//---------------------------------------------------------------------
//
// NativeListDialog
//
//---------------------------------------------------------------------
public function openSingleChoiceDialog(event:MouseEvent):void
{
	singleChDialog = new NativeListDialog();
	singleChDialog.theme =themesIOS[0];
	
	singleChDialog.addEventListener(NativeDialogEvent.CANCELED,closeNativeDialogHandler);
	
	singleChDialog.addEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);
	singleChDialog.addEventListener(ErrorEvent.ERROR,onError);
	singleChDialog.addEventListener(NativeDialogListEvent.LIST_CHANGE,onListChange);
	
	var a:Array = new Array();
	a.push("yes");
	a.push("no");
	var buttons:Vector.<String> = new Vector.<String>();
	if(a==null || a.length==0)
		buttons.push("ok");
	else{
		a.unshift("ok");
		for each (var button:String in a) 
		{
			buttons.push(button);
		}
	}
	singleChDialog.buttons = buttons;
	singleChDialog.setTitle("Text1");
	singleChDialog.setCancelable(true);
	singleChDialog.showSingleChoice(choces,selectedIndex);
	
}


protected function openMultiChoiceDialog(event:MouseEvent):void
{
	multChDialog = new NativeListDialog();
	multChDialog.theme = themesIOS[0];
	
	multChDialog.addEventListener(NativeDialogEvent.CANCELED,closeNativeDialogHandler);
	
	multChDialog.addEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);
	multChDialog.addEventListener(ErrorEvent.ERROR,onError);
	multChDialog.addEventListener(NativeDialogListEvent.LIST_CHANGE,onListChange);
	var a:Array =new Array();
	a.push("yes");
	a.push("no");
	var buttons:Vector.<String> = new Vector.<String>();
	if(a==null || a.length==0)
		buttons.push("OK");
	else{
		a.unshift("Ok");
		for each (var button:String in a) 
		{
			buttons.push(button);
		}
	}
	multChDialog.buttons = buttons;
	multChDialog.setTitle("Text1");
	multChDialog.setCancelable(true);
	multChDialog.showMultiChoice(choces,checkedItems);
	
}

private function onListChange(event:NativeDialogListEvent):void
{
	
	var dialog:NativeListDialog = (event.target as NativeListDialog)
	mess(event.toString());
	const a:Vector.<String> = dialog.selectedLabels;
	mess("selectedLabels :");
	if(a.length>0){
		for (var i:int = 0; i < a.length; i++) 
		{
			mess("   "+a[i]);
		}
	}
	
}
public function closeNativeDialogHandler(event:NativeDialogEvent):void
{
	event.preventDefault();
	mess(event.toString());
	var dialog:NativeListDialog = (event.target  as NativeListDialog);
	
}

protected function togglebutton1_changeHandler(event:Event):void
{
	//NativeProgress.showNetworkActivityIndicator(ToggleSwitch(event.target).selected);
}

protected function spinner1_changeHandler(event:IndexChangeEvent):void
{
	//NativeAlert.badge = event.newIndex;
	SystemProperties.getInstance().badge = event.newIndex;
	mess(" setting the badge:  "+event.newIndex);
	
	
}

protected function showNotification(event:MouseEvent):void
{
	NativeNotifiction.notifi("Text1",new Date());
}
public function testNot():void{
	NativeNotifiction.notifi("test");
}