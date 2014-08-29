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
					menuList.dataProvider.addItem(extraitemarray[i]);	
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
public var addingdatamode:Boolean = false;
protected function propertyChangeHandler( event:PropertyChangeEvent ) : void {
	if ( event.property == "verticalScrollPosition" ) {
		visibleindexes =  menuList.dataGroup.getItemIndicesInView().toString().split(",");
		trace("new val: "+event.newValue.toString()+
			"  ||| mesured height: "+event.currentTarget.measuredHeight.toString()+
			"  || cont height: "+event.currentTarget.height.toString()+
			" ||| scroll pos: "+menuList);
		if ( event.newValue >=  (event.currentTarget.measuredHeight+event.currentTarget.height)) {
			if (addingdatamode == false){
				addingdatamode = true;
				trace("doingit");
				addsomedata();
				if (ti.running == false){
					ti = new Timer(1000,0);
					ti.addEventListener(TimerEvent.TIMER, afterti);
					ti.start();
				}
			}
			
		}
	}
}


public var beforeaftervar:Number = 10
public function afterti(ev:TimerEvent):void {
	ti.stop();
	ti.removeEventListener(TimerEvent.TIMER, afterti);
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
	
	
	if (minindex < beforeaftervar){
		minindex = beforeaftervar;
	}
	
	if (maxindex > listData.length-(beforeaftervar+1)){
		maxindex = listData.length-(beforeaftervar+1);
	}
	
	try{
		for (j = minindex; j > minindex-beforeaftervar; j--){
			menuList.dataProvider.getItemAt(j).viz = true;
		}	
	}
	catch(e:Error){}
	var j:uint = 0;
	
	try{
		for (j = maxindex; j < maxindex+beforeaftervar; j++){
			menuList.dataProvider.getItemAt(j).viz = true;
		}
	}
	catch(e:Error){}
	
	
	previousindexes = visibleindexes;
	addingdatamode = false;
}