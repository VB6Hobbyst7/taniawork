// ActionScript file
package
{
	import flash.events.MouseEvent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import spark.components.BorderContainer;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.TextArea;
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
	
	public class citeTextBox extends BorderContainer
	{
		public var citedAU:String = "";
		public var citedTI:String = "";
		public var citedID:String = "";
		private var _backgroundFill:IFill;
		private var _borderStroke:IStroke;
		private var _borderAlpha:Number;
		private var _borderVisible:Boolean;
		private var _borderColor:uint;
		private var _cornerRadius:uint;
		public var citeType:Number = -1;
		//public var la:spark.components.Label = new spark.components.Label();
		public var t1:TextArea = new TextArea();
		public var t2:TextArea = new TextArea();
		public function citeTextBox(w:uint,h:uint)
		{
		/*	this.borderVisible = true;
			this.borderAlpha = 1;
			this.borderColor = 000000;
			this.cornerRadius(10);
			this.width = w;
			this.height = h;*/
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
		public function set cornerRadius(u:uint):void {
			_cornerRadius = u;
			if (skin)
				skin.invalidateDisplayList();
		}
		public function setTitleLabel(u:String,w:Number):void {
			t2 =  new TextArea();
			t2.editable = false;
			t2.setStyle("borderAlpha",0);
			t2.width = w-8;
			t2.text = u;
			t2.setStyle("fontSize","12");
			t2.horizontalCenter = 0;
			t2.top = 0;
			t2.height = (this.height*(0.5));
			this.addElement(t2);
		}
		public function setAuthorLabel(u:String,w:Number):void {	
			t1 = new TextArea();
			t1.editable = false;
			t1.setStyle("borderAlpha",0);
			t1.text = u;
			t1.width = w-8;
			t1.setStyle("fontSize","12");
			t1.horizontalCenter = 0;
			t1.bottom = this.height*0.25;
			t1.height = (this.height*(0.25));
			this.addElement(t1);	
		}
	}
}