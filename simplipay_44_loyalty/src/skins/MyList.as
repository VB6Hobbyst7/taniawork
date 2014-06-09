package skins {

import mx.events.FlexEvent;
import mx.events.TouchInteractionEvent;
import spark.components.List;

public class MyList extends List
{
	public function MyList()
	{
		super();
		
		//add event listeners
		addEventListener(FlexEvent.UPDATE_COMPLETE, updateCompleteHandler);
	}
	
	//update complete
	protected function updateCompleteHandler(event:FlexEvent):void
	{
		//fake touch start
		fakeTouchEvent(TouchInteractionEvent.TOUCH_INTERACTION_START);
		callLater(endTouch);
	}
	
	//quit touch event
	protected function endTouch():void {
		//fake touch end
		fakeTouchEvent(TouchInteractionEvent.TOUCH_INTERACTION_END);
	}
	
	//fake touch event
	protected function fakeTouchEvent(type:String):void {
		var evt:TouchInteractionEvent = new TouchInteractionEvent(type);
		evt.relatedObject = scroller;
		scroller.dispatchEvent(evt);
	}
}
}