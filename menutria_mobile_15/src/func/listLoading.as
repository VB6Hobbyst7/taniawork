import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
public var addvalue:Number = 6;
public var originaladd:Number = 4;
public var lastindex:Number = 0;
public var moving:Boolean = false;
[Bindable]
public var datafull:Boolean = false;
public var visibleindexes:Array = new Array();
public var previousindexes:Array = new Array();
public var ti:Timer = new Timer(750,0);
public var extraitemarray:ArrayCollection =  new ArrayCollection();
public function startapplyingdata():void {
	datafull = false;
	lastindex = 0;
	menuList.dataProvider = new ArrayCollection();
	addsomedata();
}

public function addsomedata():void {
	if (datafull == false){
		if (menuList.dataProvider.length <= 0){
			menuList.dataProvider = new ArrayCollection();
		}
		var showinital:Boolean = false;
		var startindex:Number = lastindex;
		var endindex:Number = lastindex+addvalue;
		if (lastindex == 0){
			showinital = true;
			endindex = endindex + originaladd;
			for (var i:uint = 0; i < extraitemarray.length; i++){
				try{
					menuList.dataProvider.addItem(extraitemarray[0]);	
				}
				catch(e:Error){}
			}
		}
		else {
			//menuList.dataProvider.removeItemAt(menuList.dataProvider.length-1);
		}
		
		if (endindex > listData.length){
			endindex = listData.length-1;
			lastindex = endindex;
		}
		else {
			lastindex = endindex;
		}
		for (var i:uint = startindex; i < endindex; i++){
			if (listData[i].hideall != true){
				listData[i].viz = showinital;
				menuList.dataProvider.addItem(listData[i]);
			}	
		}
		//menuList.dataProvider.addItem({name:"Loading More Items",viz:true});
		if (lastindex <= listData.length-1){
			datafull = false;
		}
		else {
			datafull = true;
		}
	}
	
}

protected function list_creationCompleteHandler( event : FlexEvent ) : void {
	menuList.scroller.viewport.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler );
}
protected function propertyChangeHandler( event:PropertyChangeEvent ) : void {
	if ( event.property == "verticalScrollPosition" ) {
		visibleindexes =  menuList.dataGroup.getItemIndicesInView().toString().split(",");
		if (ti.running == false){
			ti = new Timer(1000,0);
			ti.addEventListener(TimerEvent.TIMER, afterti);
			ti.start();
		}
		if ( event.newValue >= ( event.currentTarget.measuredHeight - event.currentTarget.height-50 )) {
			addsomedata();
		}
	}
}



public function afterti(ev:TimerEvent):void {
	ti.stop();
	for (var i:uint = 0; i < previousindexes.length; i++){
		var foundo:Boolean = false;
		for (var j:uint = 0; j < visibleindexes.length; j++){
			if (visibleindexes[j] == previousindexes[i]){
				foundo = true;
			}
		}
		menuList.dataProvider.getItemAt(previousindexes[i]).viz = foundo;
	} 
	
	var maxindex:Number = -1;
	var minindex:Number = 80000000
	for (var i:uint = 0; i < visibleindexes.length; i++){
		
		if (visibleindexes[i] > maxindex){
			maxindex = visibleindexes[i];
		}
		
		if (visibleindexes[i] < minindex){
			minindex = visibleindexes[i];
		}
		
		if (menuList.dataProvider.getItemAt(visibleindexes[i]).viz == false){
			menuList.dataProvider.getItemAt(visibleindexes[i]).viz = true;
		}
	}
	
	
	if (minindex < 16){
		minindex = 16;
	}
	
	if (maxindex > listData.length-17){
		maxindex = listData.length-17;
	}
	
	var j:uint = 0;
	for (j = minindex; j > minindex-16; j--){
		menuList.dataProvider.getItemAt(j).viz = true;
	}
	
	for (j = maxindex; j < maxindex+16; j++){
		menuList.dataProvider.getItemAt(j).viz = true;
	}
	
	previousindexes = visibleindexes;
}