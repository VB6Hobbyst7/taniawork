package skins{
	import mx.core.DPIClassification;
	import skins.ActionBarNew;

	public class SolidActionBarSkin extends ActionBarNew {	
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {	
			var chromeColor:uint = getStyle("chromeColor");
			var backgroundAlphaValue:Number = getStyle("backgroundAlpha");
			// border size is twice as big on 320
			var borderSize:int = 0;
			if (applicationDPI == DPIClassification.DPI_320)
				borderSize = 0;
			
			graphics.beginFill(chromeColor, backgroundAlphaValue);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight - (borderSize * 2));
		graphics.endFill();
		}
	}
}