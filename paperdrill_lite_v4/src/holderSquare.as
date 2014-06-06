package
{
	import com.brian.RoundedImage;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.effects.Glow;
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
		public var im:RoundedImage;
		
		public function holderSquare(width:uint,
									 height:uint,
									 count:uint,
									 startDate:uint,
									 endDate:uint,
									 cato:uint,
									alphaStart:String = "a",
									alphaEnd:String = "z",
									showHeat:Number = 0,
									squareType:Number = 1,
									maxCount:Number = -1,
									minCount:Number = -1,
									heatImageVal:String = ""
									)
		{
			im = new RoundedImage();
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
			var bs:BorderContainer = new BorderContainer();
			//this.setStyle("cornerRadius",10);
			//this.setStyle("cornerRadius", 10);
			var la:Label = new Label();
			la.text = count.toString();
			var gl:GlowFilter = new GlowFilter(0xFFFFFF,1,2,2,2,1);
			la.filters = [gl];
			la.setStyle("fontSize",18);
			la.setStyle("textAlign","center");
			la.horizontalCenter = 0;
			im.horizontalCenter = 0;
			im.verticalCenter = 0;
			
			if (showHeat == 0){
				if (squareType == 1){
					im.visible = false;
					bs.percentHeight = 100;
					bs.percentWidth = 100;
					bs.setStyle("borderAlpha",0.6);
					
					if ((maxCount != -1)&&(minCount != -1)){
						bs.height = height-((height/2)*((maxCount-count)/(maxCount-minCount)));
						bs.width = width-((width/2)*((maxCount-count)/(maxCount-minCount)))-20;
						la.width = bs.width;
						la.horizontalCenter = 0;
						
					}
					bs.horizontalCenter = 0;
					bs.verticalCenter = 0;
					this.addElement(bs);
				}
				else if (squareType == 2){
					im.visible = false;
					bs.percentHeight = 100;
					bs.percentWidth = 100;
					bs.setStyle("borderAlpha",0.6);
					bs.horizontalCenter = 0;
					bs.verticalCenter = 0;
					la.horizontalCenter = 0;
					this.addElement(bs);
				}
				
			}
			else if (showHeat == 1){
				if (squareType == 1){
					im.source = "assets/images/heat1.png";
					if ((maxCount != -1)&&(minCount != -1)){
						im.height = height-((height/2)*((maxCount-count)/(maxCount-minCount)));
						im.width = width-((width/2)*((maxCount-count)/(maxCount-minCount)))-20;
						//im.percentHeight = 100;
						//im.percentWidth = 100;
						la.percentWidth = 100;
						//la.horizontalCenter = 20;
						im.scaleContent = true;
					}
					this.addElement(im);
				}
				else if (squareType == 2){
					im.source = "assets/images/heat2.png";
					im.percentHeight = 100;
					im.percentWidth = 100;
					im.scaleContent = true;
					la.horizontalCenter = 0;
					im.cornerRadius = 20;
					this.addElement(im);
				}
			}
			
			
			
			
			
		
			//else {
			//	im.height = height;
			//	im.width = width;
			//}
			

		
			
			la.verticalCenter = 0;	
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