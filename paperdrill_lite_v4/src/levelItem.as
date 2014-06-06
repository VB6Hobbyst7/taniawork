package
{
	import flash.events.MouseEvent;
	
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import spark.components.BorderContainer;
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
	public class levelItem extends BorderContainer
	{
		public var authorName:String = "";
		public var title:String = "";
		public var date:String = "";
		public var heatcount:Number = -1;
		public var magicVarx:uint = 0;
		public var magicVary:uint = 0;
		public var indexID:Number = 0;
		private var _backgroundFill:IFill;
		private var _borderStroke:IStroke;
		private var _borderAlpha:Number;
		private var _borderVisible:Boolean;
		private var _borderColor:uint;
		public var la:spark.components.Label = new spark.components.Label();
		public function levelItem()
		{
		
			this.borderVisible = true;
			//la = new spark.components.Label();
			this.borderAlpha = 1;
			//this.borderColor = FFFFFF;
			
			//this.backgroundColor = "000000";
			this.buttonMode = true;
			super();
		}
		public function setView(u:uint,h:uint,w:uint):void {
			if (u == 1){
				this.width = w;
				this.height = h;
			}
			else if (u == 2){
				
			}
		}
		public function vizo():void {
			//	la = new spark.components.Label();
			if (this.la.visible){
				this.la.visible = false;}
			else {
				this.la.visible = true;
				this.visible = true;
			}
		}
	
		public function setLabel(u:uint):void {
			la = new spark.components.Label();
			la.text = u.toString();
			la.setStyle("fontSize","25");
			la.horizontalCenter = 0;
			la.verticalCenter = 0;
			this.addElement(la);
			
			
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
		
	}

	
}