import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
public var addvalue:Number = 6;
public var originaladd:Number = 4;
public var moving:Boolean = false;
public var visibleindexes:Array = new Array();
public var previousindexes:Array = new Array();
public var ti:Timer = new Timer(750,0);
public var extraitemarray:ArrayCollection =  new ArrayCollection();
public var beforeaftervar:Number = 6;
public function startapplyingdata():void {
	menuList.dataProvider = new ArrayCollection();
	previousindexes = new Array();
	visibleindexes = new Array();
	var i:uint = 0;
	for (i = 0; i < extraitemarray.length; i++){
		try{
			menuList.dataProvider.addItem(extraitemarray[i]);	
		}
		catch(e:Error){}
	}
	for (i = 0; i < listData.length; i++){
		if (listData[i].hideall != true){
			if (i < 9){
				listData[i].viz = true;
			}
			else {
				listData[i].viz = false;
			}
			
			menuList.dataProvider.addItem(listData[i]);
		}	
	}
	listData.refresh();
}
protected function list_creationCompleteHandler( event : FlexEvent ) : void {
	menuList.scroller.viewport.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler );
}
public var previousval:Number = 0;
public var freetoload:Boolean = true;
protected function propertyChangeHandler( event:PropertyChangeEvent ) : void {
	if ( event.property == "verticalScrollPosition" ) {
		/*
		trace("new val: "+event.newValue.toString()+
			"  ||| mesured height: "+event.currentTarget.measuredHeight.toString()+
			"  || cont height: "+event.currentTarget.height.toString()+
			" ||| scroll pos: "+menuList.dataGroup.getItemIndicesInView());
		
		*/
		if (Math.round(Number(event.newValue)-previousval) != 0){
			//trace("difference val: "+Math.round(Number(event.newValue)-previousval).toString());
			if (Math.round(Number(event.newValue)-previousval) < 3){
				if (freetoload){
					dolistupdate();
					freetoload = false;
				}
			
			}
		}
		previousval = Number(event.newValue);
	}
}
public function dolistupdate():void {
	trace("updateing list");
	var i:uint = 0;
	var j:uint = 0;
	
	visibleindexes = new Array();
	visibleindexes =  menuList.dataGroup.getItemIndicesInView().toString().split(",");
	
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
	
	if (maxindex > listData.length){
		maxindex = listData.length;
	}
	
	visibleindexes = new Array();
	for (i = minindex; i <= maxindex; i++){
		if (menuList.dataProvider.getItemAt(i).viz == false){
			setTimeout(vizwait,15*(i+1),i);
		}
		visibleindexes.push(i);
	}
	
	
	for (i = newminindex; i < minindex; i++){
		if (menuList.dataProvider.getItemAt(i).viz == false){
			setTimeout(vizwait,(50*(i+1))+500,i);
		}
		visibleindexes.push(i);
	}
	
	for (i = maxindex+1; i <= newmaxindex; i++){
		if (menuList.dataProvider.getItemAt(i).viz == false){
			setTimeout(vizwait,(50*(i+1))+500,i);
		}
		visibleindexes.push(i);
	}
	
	
	for (i = 0; i < previousindexes.length; i++){
		var foundo:Boolean = false;
		for (j = 0; j < visibleindexes.length; j++){
			if (visibleindexes[j] == previousindexes[i]){
				foundo = true;
			}
		}
		
		if (menuList.dataProvider.getItemAt(previousindexes[i]).viz != foundo){
			if (foundo == true){
				setTimeout(vizwait,(10*(i+1)),previousindexes[i]);
			}
			else {
				setTimeout(vizwait2,(10*(i+1)),previousindexes[i]);
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
	menuList.dataProvider.getItemAt(index).viz = true;
}

public function vizwait2(index:uint):void {
	menuList.dataProvider.getItemAt(index).viz = false;
}