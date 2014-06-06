package com.brian
{
	import mx.controls.Image;
	import mx.core.UIComponent;
	
	/**
	 * Rounded Image
	 * 
	 * Extended Image component to allow rounded corners by using a mask
	 * 
	 * @author Brian Raymes
	 */
	public class RoundedImage extends Image
	{
		protected var roundedMask:UIComponent;
		protected var cornerRad:int;
		
		public function RoundedImage()
		{
			super();
		}
		
		public function get cornerRadius():int
		{
			return cornerRad;
		}
		
		public function set cornerRadius(radius:int):void
		{
			cornerRad = radius;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.roundedMask = new UIComponent();
			this.addChild(roundedMask);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			roundedMask.graphics.clear();
			roundedMask.graphics.beginFill(0x000000);
			roundedMask.graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight,
				cornerRad, cornerRad);
			roundedMask.graphics.endFill();
			
			this.mask = roundedMask;
		}
	}
}