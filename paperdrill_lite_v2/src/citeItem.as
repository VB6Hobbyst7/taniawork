package
{
	import flash.events.MouseEvent;
	
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.effects.Scale;
	import spark.filters.GlowFilter;
	public class citeItem extends Label
	{
		public var id1:Number = 0;
		public var id2:Number = 0;
		public var title:String = "";
		public var author:String = "";
		public var date:uint = 0;
		public var date2:String = "";
		public var type:String = "";
		public var publisher:String = "";
		public var sourceo:String = "";
		public var fileLoc:String = "";
		public var indexid:Number = -1;
		public var citeType:Number = -1;
		public var seedCount:Number = 0;
		public function citeItem()
		{
			
			addEventListener(MouseEvent.MOUSE_OUT, linkOut);
			addEventListener(MouseEvent.MOUSE_OVER, linkOver);
			super();
		}
		public function linkOver(ev:MouseEvent):void {
			this.setStyle("textDecoration","underline");
		}
		public function linkOut(ev:MouseEvent):void {
			this.setStyle("textDecoration","none");
		}
		public function setText(ev:String):void {
			ev = ev.replace("\n"," ");
			ev = ev.replace("\t"," ");
			ev = ev.replace("/n"," ");
			ev = ev.replace("/t"," ");
			if (ev.length > 13){
				this.text = ev.substr(0,10)+"...";
			}
			else {
				this.text = ev+"";
			}
			this.toolTip = ev;
		}
		
		
	}
	
}

