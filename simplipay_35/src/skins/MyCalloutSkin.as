package skins
{
	import mx.core.DPIClassification;
	import spark.skins.mobile.CalloutSkin;
	import spark.skins.mobile.supportClasses.CalloutArrow;
	
	public class MyCalloutSkin extends CalloutSkin
	{
		public function MyCalloutSkin()
		{
			switch (applicationDPI)
			{
				case DPIClassification.DPI_160:
				{
					// default DPI_160
					backgroundCornerRadius = 8;
					frameThickness = 8;
					//arrowWidth = 52; default
					//arrowHeight = 26; default
					arrowWidth = 82;
					arrowHeight = 46;
					borderColor=0xAA0D0A;
					borderThickness=5;
					frameThickness=9;
					contentCornerRadius = 40;
					break;
				}
			}
		}
	}
}