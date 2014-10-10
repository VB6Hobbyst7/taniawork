package components 
{ 
	import flash.system.Capabilities;
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import spark.preloaders.SplashScreen;
	use namespace mx_internal
	public class MultiDPISplashScreen extends SplashScreen 
	{ 
		[Embed(source="/assets/splash/oj_1024x600.png")] 
		private var splash1:Class; 

		public function MultiDPISplashScreen() 
		{ 
			super(); 
		} 
		override mx_internal function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class 
		{ 
			return splash1;
		} 
	} 
}

