package com.renaun.caltrain.components 
{ 
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import spark.preloaders.SplashScreen;
	use namespace mx_internal
	public class MultiDPISplashScreen extends SplashScreen 
	{ 
		[Embed(source="/assets/160home.png")] 
		private var SplashImage160:Class; 
		
		[Embed(source="/assets/240home.png")] 
		private var SplashImage240:Class; 
		
		[Embed(source="/assets/320home.png")] 
		private var SplashImage320:Class;
		
		[Embed(source="/assets/480home.png")] 
		private var SplashImage480:Class; 
		
		[Embed(source="/assets/640home.png")] 
		private var SplashImage640:Class; 
	
		public function MultiDPISplashScreen() 
		{ 
			super(); 
		} 
		override mx_internal function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class 
		{ 
			if (dpi >= DPIClassification.DPI_640) 
				return SplashImage640; 
			else if (dpi >= DPIClassification.DPI_480) 
				return SplashImage480; 
			else if (dpi >= DPIClassification.DPI_320) 
				return SplashImage320; 
			else if (dpi >= DPIClassification.DPI_240) 
				return SplashImage240; 
			else if (dpi >= DPIClassification.DPI_160) 
				return SplashImage160; 
			return SplashImage320; 
		} 
	} 
}