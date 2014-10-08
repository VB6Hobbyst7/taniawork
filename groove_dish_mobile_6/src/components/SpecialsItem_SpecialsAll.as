package components
{
	import flash.system.Capabilities;
	import mx.events.FlexEvent;
	import mx.graphics.SolidColorStroke;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.components.supportClasses.ItemRenderer;
	import spark.core.ContentCache;
	import spark.primitives.BitmapImage;
	import spark.primitives.Line;
	public class SpecialsItem_SpecialsAll extends ItemRenderer
	{
		static public const s_imageCache:ContentCache = new ContentCache();
		public var v1:VGroup = new VGroup();
		public var addedallitems:Boolean = false;
		public function SpecialsItem_SpecialsAll()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, init);
			this.addEventListener(FlexEvent.DATA_CHANGE, dchange);
		}
		public function init(event:FlexEvent):void {
			var neededwidth:Number = this.parent.width;
			v1.width = neededwidth;
			v1.percentHeight = 100;
			v1.gap = 0;
			v1.mouseEnabled = false;
			this.addElement(v1);
			
		public function dchange(event:FlexEvent):void {
			
		}
		public function loadrest():void {
			
		}
		public function getDPIHeight():Number {
			var _runtimeDPI:int;
			if(Capabilities.screenDPI < 200){
				_runtimeDPI = 160;
			}
			else if(Capabilities.screenDPI >=200 && Capabilities.screenDPI <= 240){
				_runtimeDPI = 240
			}
			else if (Capabilities.screenDPI < 480){
				_runtimeDPI = 320;
			}
			else if (Capabilities.screenDPI < 640){
				_runtimeDPI = 480;
			}
			else if (Capabilities.screenDPI >=640){
				_runtimeDPI = 640;
			}
			return(_runtimeDPI);
		}
	}
}