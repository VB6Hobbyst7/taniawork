import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.messaging.channels.StreamingAMFChannel;

public var addvalue:Number = 6;
public var originaladd:Number = 4;
public var moving:Boolean = false;
public var visibleindexes:Array = new Array();
public var previousindexes:Array = new Array();
public var ti:Timer = new Timer(750,0);
public var extraitemarray:ArrayCollection =  new ArrayCollection();
public var catitemarray:ArrayCollection =  new ArrayCollection();
public var beforeaftervar:Number = 6;
public var hurrymode:Boolean = false;
public var addcatsep:Boolean = false;
public function startapplyingdata():void {
	if (storeList.dataProvider != null){
		storeList.dataProvider.removeAll();
	}
	else {
		storeList.dataProvider = new ArrayCollection();
	}
	previousindexes = new Array();
	visibleindexes = new Array();
	var i:uint = 0;
	for (i = 0; i < listData.length; i++){
			listData[i].viz = false;
			storeList.dataProvider.addItem(listData[i]);
	}	
	
	var visibleindexestemp:Array =  storeList.dataGroup.getItemIndicesInView().toString().split(",");
	if (visibleindexestemp.length > 2){
		for (i = 0; i < visibleindexestemp.length; i++){
			vizwait(visibleindexestemp[i]);
		}
	}
	else {
		for (i = 0; i < 10; i++){
			vizwait(i);
		}
	}
	listData.refresh();
}
protected function list_creationCompleteHandler( event : FlexEvent ) : void {
	storeList.scroller.viewport.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler );	
	
}
public var previousval:Number = 0;
public var freetoload:Boolean = true;
public var previousIndicesInView:String = "";
protected function propertyChangeHandler( event:PropertyChangeEvent ) : void {
	if ( event.property == "verticalScrollPosition" ) {
		if (previousIndicesInView != storeList.dataGroup.getItemIndicesInView().toString()){
			previousIndicesInView = storeList.dataGroup.getItemIndicesInView().toString();
			if (freetoload){	
				dolistupdate();
				freetoload = false;
			}
		}
	}
}
public function dolistupdate():void {
	var i:uint = 0;
	var j:uint = 0;
	
	visibleindexes = new Array();
	visibleindexes =  storeList.dataGroup.getItemIndicesInView().toString().split(",");
	
	var maxindex:Number = -1;
	var minindex:Number = 80000000
	for (i = 0; i < visibleindexes.length; i++){	
		if (visibleindexes[i] > maxindex){
			maxindex = visibleindexes[i];
		}
		
		if (visibleindexes[i] < minindex){
			minindex = visibleindexes[i];
		}
	}
	
	
	var newminindex:uint = minindex - beforeaftervar;
	if (newminindex < 0){
		newminindex = 0;
	}
	
	if (minindex < 0){
		minindex = 0;
	}
	
	var newmaxindex:uint = maxindex = maxindex + beforeaftervar;
	if (newmaxindex > listData.length){
		newmaxindex = listData.length;
	}
	
	if (maxindex >= listData.length){
		maxindex = listData.length-1;
	}
	
	visibleindexes = new Array();
	for (i = minindex; i <= maxindex; i++){
		if (storeList.dataProvider.getItemAt(i).viz == false){
			setTimeout(vizwait,30*(i+1),i);
		}
		visibleindexes.push(i);
	}
	
	
	for (i = newminindex; i < minindex; i++){
		if (storeList.dataProvider.getItemAt(i).viz == false){
			setTimeout(vizwait,(100*(i+1))+500,i);
		}
		visibleindexes.push(i);
	}
	
	for (i = maxindex+1; i <= newmaxindex; i++){
		try{
			if (storeList.dataProvider.getItemAt(i).viz == false){
				setTimeout(vizwait,(100*(i+1))+500,i);
			}
			visibleindexes.push(i);
		}
		catch(e:Error){}
	}
	
	
	for (i = 0; i < previousindexes.length; i++){
		var foundo:Boolean = false;
		for (j = 0; j < visibleindexes.length; j++){
			if (visibleindexes[j] == previousindexes[i]){
				foundo = true;
			}
		}
		
		if (storeList.dataProvider.getItemAt(previousindexes[i]).viz != foundo){
			if (foundo == true){
				setTimeout(vizwait,(30*(i+1)),previousindexes[i]);
			}
		}	
	} 
	previousindexes = new Array();
	previousindexes = visibleindexes;
	
	ti = new Timer(250,0);
	ti.addEventListener(TimerEvent.TIMER, afterti);
	ti.start();
	
}
public function afterti(ev:TimerEvent):void {
	ti.stop();
	ti.removeEventListener(TimerEvent.TIMER, afterti);
	freetoload = true;
}
public function vizwait(index:uint):void {
	storeList.dataProvider.getItemAt(index).viz = true;
}
