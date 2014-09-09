package com.renaun.mobile.dpi
{
	import flash.system.Capabilities;
	
	import mx.core.DPIClassification;
	import mx.core.RuntimeDPIProvider;
	public class CustomDPIProvider extends RuntimeDPIProvider
	{
		override public function get runtimeDPI():Number 
		{
			var screenX:Number = Capabilities.screenResolutionX;
			var screenY:Number = Capabilities.screenResolutionY;
			var pixelCheck:Number = screenX * screenY;
			var pixels:Number = (screenX*screenX) + (screenY*screenY);
			var screenSize:Number = Math.sqrt(pixels)/Capabilities.screenDPI;
			if (Capabilities.screenDPI < 200)
				return DPIClassification.DPI_160;
			
			if (Capabilities.screenDPI <= 280)
				return DPIClassification.DPI_240;
			
			if (Capabilities.screenDPI <= 326)
				return DPIClassification.DPI_320;
			
			if (Capabilities.screenDPI <= 480)
				return DPIClassification.DPI_480;
			
			return DPIClassification.DPI_640; 
		}
	}
}

