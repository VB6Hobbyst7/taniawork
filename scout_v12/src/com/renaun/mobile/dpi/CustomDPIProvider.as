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
		var diff1:Number = Math.abs(160-Capabilities.screenDPI);
		var diff2:Number = Math.abs(240-Capabilities.screenDPI);
		var diff3:Number = Math.abs(320-Capabilities.screenDPI);
		var diff4:Number = Math.abs(480-Capabilities.screenDPI);
		var diff5:Number = Math.abs(640-Capabilities.screenDPI);
		if ((diff1 < diff2)&&(diff1 < diff3)&&(diff1 < diff4)&&(diff1 < diff5)){
			return DPIClassification.DPI_160;
		}
		else if ((diff2 < diff1)&&(diff2 < diff3)&&(diff2 < diff4)&&(diff2 < diff5)){
			return DPIClassification.DPI_240;
		}
		else if ((diff3 < diff1)&&(diff3 < diff2)&&(diff3 < diff4)&&(diff3 < diff5)){
			return DPIClassification.DPI_320;
		}
		else if ((diff4 < diff1)&&(diff4 < diff2)&&(diff4 < diff3)&&(diff4 < diff5)){
			return DPIClassification.DPI_480;
		}
		return DPIClassification.DPI_640; 
	}
}
}