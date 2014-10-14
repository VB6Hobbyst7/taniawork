import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
public var initialamounttoadd:Number = 10;
public var incrementamounttoadd:Number = 6;
public var currentamountloaded = 0;
public var extraitemarray:ArrayCollection =  new ArrayCollection();
public var catitemarray:ArrayCollection =  new ArrayCollection();
public var addcatsep:Boolean = false;
public function startapplyingdata():void {
	currentamountloaded = 0;
	listData.refresh();
	dataList.selectedIndex = -1;
	try{
		dataList.dataProvider.removeAll();
	}
	catch(e:Error){
		dataList.dataProvider = new ArrayCollection();
	}
/*	if (dataList.dataProvider != null){
		dataList.dataProvider.removeAll();
	}
	else {
		dataList.dataProvider = new ArrayCollection();
	}*/

	var i:uint = 0;
	for (i = 0; i < extraitemarray.length; i++){
		try{
			dataList.dataProvider.addItem(extraitemarray[i]);	
		}
		catch(e:Error){}
	}
	
	if (listData.length < initialamounttoadd){
		initialamounttoadd = listData.length;
	}
	
	for (i = 0; i < initialamounttoadd; i++){
		if (listData[i].hideall != true){
			/*if (addcatsep){
				if (lastcat != listData[i].categoryname){
					lastcat = listData[i].categoryname;
					dataList.dataProvider.addItem({name:"catsep",catname:listData[i].categoryname,viz:true});
				}
			}*/
			listData[i].viz = true;
			currentamountloaded++;
			dataList.dataProvider.addItem(listData[i]);
		}	
	}	
}
protected function listComplete(ev:FlexEvent):void {
	dataList.scroller.viewport.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler );	
	
}
protected function propertyChangeHandler( event:PropertyChangeEvent ) : void {
	if ( event.property == "verticalScrollPosition" ) {
		var lastindex:Number = 	dataList.dataGroup.getItemIndicesInView().pop();
		if (lastindex >= currentamountloaded-1){
			dolistupdate();
			trace("doing update");
		}
	}
}
public function dolistupdate():void {
	var amountallreadyinlist:Number = dataList.dataGroup.numElements-extraitemarray.length;
	var amounttogoto:Number = amountallreadyinlist+incrementamounttoadd;
	if (listData.length < amounttogoto){
		amounttogoto = listData.length;
	}
	for (var i:uint = amountallreadyinlist; i < amounttogoto; i++){
		if (listData[i].hideall != true){
			/*if (addcatsep){
			if (lastcat != listData[i].categoryname){
			lastcat = listData[i].categoryname;
			dataList.dataProvider.addItem({name:"catsep",catname:listData[i].categoryname,viz:true});
			}
			}*/
			listData[i].viz = true;
			currentamountloaded++;
			dataList.dataProvider.addItem(listData[i]);
		}	
	}	
}