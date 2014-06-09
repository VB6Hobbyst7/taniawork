package com.renaun.caltrain.components 
{ 
	import flash.system.Capabilities;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	
	import spark.preloaders.SplashScreen;
	
	use namespace mx_internal
	
	public class MultiDPISplashScreen extends SplashScreen 
	{ 
		[Embed(source="/assets/interfaceimages/multi/splashlogoHigh.png")] 
		private var SplashImage160:Class; 
		[Embed(source="/assets/interfaceimages/multi/splashlogoHigh.png")] 
		private var SplashImage240:Class; 
		[Embed(source="/assets/interfaceimages/multi/splashlogoHigh.png")] 
		private var SplashImage320:Class; 
		
		public function MultiDPISplashScreen() 
		{ 
			super(); 
		} 
		
		override mx_internal function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class 
		{ 
			
			//this.stageHeight = 1000;
			
			
			
			
			if (dpi == DPIClassification.DPI_160)
			{
				if (Capabilities.screenResolutionX < 512 && Capabilities.screenResolutionY < 512
					|| Capabilities.cpuArchitecture == "x86")
					return SplashImage160;
				else
					return SplashImage320;
			}
			else if (dpi == DPIClassification.DPI_240) 
				return SplashImage240; 
			else if (dpi == DPIClassification.DPI_320) 
				return SplashImage320; 
			return null; 
		} 
	} 
}