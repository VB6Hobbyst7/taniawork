package skins 
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class SwitcherSkin extends MobileSkin
	{
		protected var background:DisplayObject;
		protected var thumb:DisplayObject;
		
		override protected function commitCurrentState():void
		{ 
			super.commitCurrentState();
			invalidateDisplayList();
		}
		override protected function createChildren():void
		{
			background = addElement( "background" );
			thumb = addElement( "thumb" );
		}
		
		protected function addElement( style:String ):DisplayObject
		{
			var elementAsset:Class = getStyle( style );
			var element:DisplayObject;
			if( elementAsset )
			{
				element = new elementAsset();
				addChild( element );
			}
			return element;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if( currentState == "up" )
			{
				Tweener.removeTweens( thumb );
				Tweener.addTween( thumb, { time:0.4, x:0 } );
			}
			if( currentState == "upAndSelected" )
			{
				Tweener.removeTweens( thumb );
				Tweener.addTween( thumb, { time:0.4, x:unscaledWidth - thumb.width } );
			}
		}
	}
}