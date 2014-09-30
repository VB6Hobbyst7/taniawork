package skins{
import skins.ActionBarNew;
public class SolidActionBarSkin extends ActionBarNew {	
	override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {	
		var chromeColor:uint = getStyle("chromeColor");
		var backgroundAlphaValue:Number = getStyle("backgroundAlpha");
		graphics.beginFill(chromeColor, backgroundAlphaValue);
		graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
	graphics.endFill();
	}
}
}