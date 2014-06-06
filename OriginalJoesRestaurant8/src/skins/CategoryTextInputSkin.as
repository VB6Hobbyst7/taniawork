package skins
{
	import spark.components.supportClasses.SkinnableTextBase;
	import spark.skins.mobile.TextInputSkin;
	import spark.components.Image;

	public class CategoryTextInputSkin extends TextInputSkin
	{
		protected var arrowImage:Image;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!arrowImage)
			{
				arrowImage = new Image();
				arrowImage.smooth=true;
				arrowImage.width=22;
				arrowImage.height=22;
				arrowImage.source="assets/arrow_down22.png";
				addChild(arrowImage);
			}
		}
		
		
		override protected function layoutContents(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// position & size border
			if (border)
			{
				setElementSize(border, unscaledWidth, unscaledHeight);
				setElementPosition(border, 0, 0);
			}
			
			// position & size the text
			var paddingLeft:Number = getStyle("paddingLeft");
			var paddingRight:Number = getStyle("paddingRight");
			var paddingTop:Number = getStyle("paddingTop"); 
			var paddingBottom:Number = getStyle("paddingBottom");
			
			var unscaledTextWidth:Number = unscaledWidth - paddingLeft - paddingRight;
			var unscaledTextHeight:Number = unscaledHeight - paddingTop - paddingBottom;
			
			// default vertical positioning is centered
			var textHeight:Number = 25;
			var textY:Number = Math.round(0.5 * (unscaledTextHeight - textHeight)) + paddingTop;
			
			if (textDisplay)
			{	
				setElementSize(textDisplay, unscaledWidth, unscaledTextHeight);
				// set x=0 since we're using textDisplay.leftMargin = paddingLeft
				setElementPosition(textDisplay, 0, textY);
			}
			if (arrowImage)
			{
				setElementPosition(arrowImage,unscaledWidth-arrowImage.width-5,unscaledHeight/2-arrowImage.height/2);
			}
		}		
	}
}