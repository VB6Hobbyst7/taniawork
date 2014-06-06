package
{
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.graphics.IStroke;
	
	import spark.components.BorderContainer;
	import spark.components.Label;
	import spark.filters.GlowFilter;

	public class holderSquare extends BorderContainer
	{
		public var startDate:Number;
		public var endDate:Number;
		public var cato:Number;
		public var count:Number;
		public var alphaStart:String = "";
		public var alphaEnd:String = "";
		public var im:Image;
		
		public function holderSquare(width:uint,
									 height:uint,
									 count:uint,
									 startDate:uint,
									 endDate:uint,
									 cato:uint,
									alphaStart:String = "a",
									alphaEnd:String = "z",
									imageType:uint = 0,
									maxCount:Number = -1,
									minCount:Number = -1)
		{
			im = new Image();
			this.addEventListener(MouseEvent.MOUSE_OUT, outd);
			this.addEventListener(MouseEvent.MOUSE_OVER, overd);
			this.width = width;
			this.height = height;
			this.startDate = startDate;
			this.endDate = endDate;
			this.cato = cato;
			this.count = count;
			this.alphaStart = alphaStart;
			this.alphaEnd = alphaEnd;
			this.setStyle("borderAlpha",0);
			this.setStyle("backgroundAlpha",0);
			//this.setStyle("cornerRadius", 10);
			
			if (imageType == 0){
				im.source = "assets/images/heat1.jpg";
			}
			else if (imageType == 1){
				im.source = "assets/images/heat2.png";
				im.scaleContent = true;
				
			}
			
			if ((maxCount != -1)&&(minCount != -1)){
				im.height = height-((height/2)*((maxCount-count)/(maxCount-minCount)));
				im.width = width-((width/2)*((maxCount-count)/(maxCount-minCount)));
				
			
			}
			else {
				im.height = height;
				im.width = width;
			}
			
			
			var la:Label = new Label();
			la.text = count.toString();
			la.setStyle("fontSize",18);
		//	im.alpha = 0.8
			this.addElement(im);
			la.horizontalCenter = 0;
			la.verticalCenter = 0;
			im.horizontalCenter = 0;
			im.verticalCenter = 0;
			this.addElement(la);
		}
		public function overd(ev:MouseEvent):void {
			var gl:GlowFilter = new GlowFilter(999999999,1.0,4,4,3,1,false);
			ev.currentTarget.filters = [gl];
			im.filters = [gl];
			
		}
		public function outd(ev:MouseEvent):void {
			ev.currentTarget.filters = [];
			im.filters = [];
		}
	}
}