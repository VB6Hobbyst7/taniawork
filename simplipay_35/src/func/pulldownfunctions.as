protected function onPropertyChange(event:PropertyChangeEvent):void
{
	if (event.source == event.target && event.property == "verticalScrollPosition")
	{
		var vScroll:Number = storeList.dataGroup.verticalScrollPosition;
		if(vScroll < -20){
			//	trace(vScroll);
			if(!loadingGroup.visible){
				loadingGroup.visible = true;
				fadeIn.play();
			}
			loadingGroup.y = vScroll*-1 - 60;
			
			if(vScroll < -90){
				//	trace(arrowImage.rotation);
				if(arrowImage.rotation == 0)  {
					arrowImage.rotation = 180;
				}
				loadText.text = "Release to refesh...";
				
			}else{
				if(arrowImage.rotation == 180)  {
					arrowImage.rotation = 0;
				}
				loadText.text = "Pull down to refresh";
			}
			
		}else{
			loadingGroup.visible = false;
		}
	}
}
protected function list_mouseUpHandler(event:MouseEvent):void
{
	key.text = "";
	try{
		//trace(storeList.scroller.verticalScrollBar.value);
		if(storeList.scroller.verticalScrollBar.value < -90){
			loadingGroup.visible = false;
			//listData.addItemAt({text:"loading...", name:"aaaaaa", distance :0},0);
			locationType = "1";
			if (Geolocation.isSupported)
			{
				g.addEventListener(GeolocationEvent.UPDATE, onUpdate);
				addEventListener(ViewNavigatorEvent.REMOVING,onRemove);	
			}
			else
			{	
				mylat = 53.59221+Math.random();
				mylong = -113.54009+Math.random();
				getLocations.send();
				trace ("Updating List");
			}		
		} 
	}
	catch(e:Error){
		trace ("mouse up on list refresh error");
	}
}

protected function list_mouseMoveHandler(event:MouseEvent):void
{ 
	try{
		var vScroll:Number = storeList.scroller.verticalScrollBar.value;
		if(vScroll < -20){
			//trace(vScroll);
			if(!loadingGroup.visible){
				loadingGroup.visible = true;
				fadeIn.play();
			}
			loadingGroup.y = vScroll*-1 - 60;
			
			if(vScroll < -90){
				//trace(arrowImage.rotation); 
				if(arrowImage.rotation == 0)  {
					arrowImage.rotation = 180;
				}
				loadText.text = "Release to refesh...";
				
			}else{
				if(arrowImage.rotation == 180)  {
					arrowImage.rotation = 0;
				}
				loadText.text = "Pull down to refresh";
			}
			
		}else{
			loadingGroup.visible = false;
		}
	}
	catch(e:Error){
		
	}
}