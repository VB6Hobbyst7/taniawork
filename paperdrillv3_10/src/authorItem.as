package
{
	import flash.events.MouseEvent;
	
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.effects.Scale;
	import spark.filters.GlowFilter;
	[Style(name="backgroundImage", type="Object", format="File", inherit="no")]
	[Style(name="backgroundImageFillMode", type="String", enumeration="scale,clip,repeat", inherit="no")]
	[Style(name="borderAlpha", type="Number", inherit="no")]
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]
	[Style(name="borderStyle", type="String", enumeration="inset,solid", inherit="no")]
	[Style(name="borderVisible", type="Boolean", inherit="no")]
	[Style(name="borderWeight", type="Number", format="Length", inherit="no")]
	[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]
	[Style(name="dropShadowVisible", type="Boolean", inherit="no")]
	public class authorItem extends SkinnableContainer
	{
		public var id1:uint = 0;
		public var id2:String = "";
		public var title:String = "";
		public var author:String = "";
		public var date:uint = 0;
		public var date2:String = "";
		public var type:String = "";
		public var publisher:String = "";
		public var sourceo:String = "";
		public var fileLoc:String = "";
		public var indexid:uint = 0;
		private var _backgroundFill:IFill;
		private var _borderStroke:IStroke;
		private var _borderAlpha:Number;
		private var _borderVisible:Boolean;
		private var _borderColor:uint;
		public var citeType:Number = -1;
		public function authorItem()
		{
			this.borderVisible = true;
			this.borderAlpha = 1;
			this.borderColor = 000000;
			this.buttonMode = true;
			super();
		}
		public function set borderAlpha(u:Number):void {
			_borderAlpha = u;
			if (skin)
				skin.invalidateDisplayList();
		}
		public function set borderVisible(u:Boolean):void {
			_borderVisible = u;
			if (skin)
				skin.invalidateDisplayList();
		}
		public function set borderColor(u:uint):void {
			_borderColor = u;
			if (skin)
				skin.invalidateDisplayList();
		}
	public function get backgroundFill():IFill
	{
		return _backgroundFill;
	}
	public function set backgroundFill(value:IFill):void
	{
		if (value == _backgroundFill)
			return;
		_backgroundFill = value;
		if (skin)
			skin.invalidateDisplayList();
	}
	public function get borderStroke():IStroke
	{
		return _borderStroke;
	}
	public function set borderStroke(value:IStroke):void
	{
		if (value == _borderStroke)
			return;
		_borderStroke = value;
		if (skin)
			skin.invalidateDisplayList();
	}
}

}