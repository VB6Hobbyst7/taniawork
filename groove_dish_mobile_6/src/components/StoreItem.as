package components
{
	import flash.system.Capabilities;
	
	import mx.events.FlexEvent;
	import mx.graphics.SolidColor;
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
	import spark.primitives.Rect;
	public class StoreItem extends ItemRenderer
	{
		static public const s_imageCache:ContentCache = new ContentCache();
		public var v1:VGroup = new VGroup();
		public var addedallitems:Boolean = false;
		public var gapo:uint = 3;
		public var subvalue:uint = 25;
		public function StoreItem()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, init);
			this.addEventListener(FlexEvent.DATA_CHANGE, dchange);
		}
		public function init(event:FlexEvent):void {
			if (data != null){
				var neededwidth:Number = this.parent.width/2-gapo;
				v1.width = neededwidth;
				v1.percentHeight = 100;
				v1.gap = 0;
				v1.mouseEnabled = false;
				this.addElement(v1);
				if (addedallitems == false){
					if (unescape(data.name) == "map"){
						this.width = this.parent.width;
						v1.width = this.parent.width;
						var bmpImg:BitmapImage = new BitmapImage();
						bmpImg.source = unescape(data.url);
						bmpImg.width = this.parent.width;
						bmpImg.height = this.parent.width/(16/7)+(gapo*6);
						v1.addElement(bmpImg);
					}
					else {
						loadrest();
					}
				}
			}
		}
		public function dchange(event:FlexEvent):void {
			if (data != null){
				var neededwidth:Number = this.parent.width/2-gapo;
				if (addedallitems == false){
					if (unescape(data.name) == "map"){
						
					}
					else {
						loadrest();
					}	
				}
				else {
					v1.removeAllElements();
					addedallitems = false;
					if (unescape(data.name) == "map"){
						this.width = this.parent.width;
						v1.width = this.parent.width;
						var bmpImg:BitmapImage = new BitmapImage();
						bmpImg.source = unescape(data.url);
						bmpImg.width = this.parent.width;
						bmpImg.height = this.parent.width/(16/7)+(gapo*6);
						v1.addElement(bmpImg);
					}
					else {
						loadrest();
					}	
					
				}
			}		
		}
		public function loadrest():void {
			var neededwidth:Number = this.parent.width/2-gapo;
			if (addedallitems == false){
				this.width = neededwidth;
				addedallitems = true;
				var bmpImg:BitmapImage = new BitmapImage();
				if ((unescape(data.business_picture) == "None")||(unescape(data.business_picture) == "")||
					(unescape(data.business_picture) == null)||(unescape(data.business_picture) == "null")){
					bmpImg.source = "assets/"+getDPIHeight().toString()+"/dish_place_wide.png";
				}
				else if (unescape(data.business_picture).indexOf("dish") != -1){
					bmpImg.source = "assets/"+getDPIHeight().toString()+"/dish_place_wide.png";
				}
				else {
					bmpImg.source = unescape(data.business_picture);
				}
				bmpImg.scaleMode = "zoom";
				bmpImg.contentLoader = s_imageCache;
				bmpImg.width = neededwidth;
				bmpImg.height = neededwidth/(3/2);
				bmpImg.bottom = 0;
				var gr5:Group = new Group();
				gr5.width = neededwidth;
				gr5.height = neededwidth*(414/622);
				gr5.addElement(bmpImg);
				var gr6:Group = new Group();
				var rc6:Rect = new Rect();
				rc6.fill = new SolidColor(0x36ccba, 0.95);
				rc6.percentHeight = 100;
				rc6.percentWidth = 100;
				rc6.radiusX =9;
				rc6.radiusY = 9;
				var l1:Label = new Label();
				l1.setStyle("textAlign","center");
				l1.horizontalCenter = 0;
				l1.verticalCenter = 3;
				l1.styleName = "textsize0";
				l1.setStyle("fontWeight","bold");
				l1.setStyle("color","#ffffff");
				l1.setStyle("paddingLeft",15);
				l1.setStyle("paddingRight",15);
				l1.setStyle("paddingBottom",5);
				l1.setStyle("paddingTop",5);
				var ratingstring:String =unescape(data.rating.toString());
				var ratingnumber:Number = Number(unescape(data.rating));
				if (ratingnumber == 0){
					l1.text = "-";
				}
				else if (ratingnumber >= 10){
					ratingnumber = 10;
					l1.text = "10";
				}
				else {
					l1.text = ratingnumber.toPrecision(2).toString();
				}
				gr6.addElement(rc6);
				gr6.addElement(l1);
				var pricelabel:String = "";
				if (data.price == 1){
					pricelabel  = "$";
				}
				else if (data.price == 2){
					pricelabel  = "$$";
				}
				else if (data.price == 3){
					pricelabel  = "$$$";
				}
				else if (data.price == 4){
					pricelabel  = "$$$$";
				}
				else if (data.price == 5){
					pricelabel  = "$$$$$";
				}
				var gr7:Group = new Group();
				var rc7:Rect = new Rect();
				rc7.radiusX = 9;
				rc7.radiusY = 9;
				rc7.fill = new SolidColor(0xc4c4c4, 0.95);
				rc7.percentHeight = 100;
				rc7.percentWidth = 100;
				var l2:Label = new Label();
				l2.setStyle("textAlign","center");
				l2.horizontalCenter = 0;
				l2.setStyle("paddingLeft",10);
				l2.setStyle("paddingRight",10);
				l2.setStyle("paddingBottom",5);
				l2.setStyle("paddingTop",5);
				l2.verticalCenter = 3;
				l2.styleName = "textsize0";
				l2.setStyle("color","#ffffff");
				l2.text = pricelabel;
				gr7.addElement(rc7);
				gr7.addElement(l2);
				
				var hg2:HGroup = new HGroup();
				hg2.paddingLeft = 15;
				hg2.gap = 15;
				hg2.addElement(gr6);
				hg2.addElement(gr7);
				hg2.bottom = 15;
				gr5.addElement(hg2)
				v1.addElement(gr5);			
				
				var v2:VGroup = new VGroup();
				v2.width = neededwidth;
				v2.gap = 8/(320/Capabilities.screenDPI);
				v2.paddingTop = 18/(320/Capabilities.screenDPI);
				v2.paddingBottom = 10/(320/Capabilities.screenDPI);
				
				var l5:Label = new Label();
				l5.width = neededwidth-(20/(320/Capabilities.screenDPI));
				l5.setStyle("paddingLeft",20/(320/Capabilities.screenDPI));
				l5.setStyle("fontWeight","bold");
				l5.horizontalCenter = 0;
				l5.verticalCenter = 0;
				l5.styleName =  "textsize0";
				l5.setStyle("color","#4d4d4d");
				l5.text = unescape(data.business_name);
				l5.maxDisplayedLines = 1;
				l5.setStyle("verticalAlign","middle");
				
				var g4:Group = new Group();
				g4.width = neededwidth;
				var newdist:String = "";
				if ((unescape(data.distance) != '')&&(unescape(data.distance) != 'null')&&(unescape(data.distance) != null)){
					var dist:Number = Number(unescape(data.distance));
					if (dist >= 1){
						newdist = dist.toFixed(1)+ " km";
					}
					else {
						dist = dist * 1000;
						newdist = dist.toFixed(0)+ " m";
					}
				}
				else {
					newdist = "";
				}
				var hg3:HGroup = new HGroup();
				hg3.gap = 0;
				hg3.paddingLeft = 20/(320/Capabilities.screenDPI);
				var l6:Label = new Label();
				l6.maxWidth = neededwidth-(20/(320/Capabilities.screenDPI));
				l6.setStyle("fontWeight","bold");
				l6.horizontalCenter = 0;
				l6.verticalCenter = 0;
				l6.left = 0;
				l6.styleName =  "textsize0";
				l6.setStyle("color","#4d4d4d");
				l6.text = unescape(data.categoryname+" •");
				l6.maxDisplayedLines = 1;
				l6.setStyle("verticalAlign","middle");
				
				var l7:Label = new Label();
				l7.horizontalCenter = 0;
				l7.verticalCenter = 0;
				l7.styleName =  "textsize0";
				l7.setStyle("color","#4d4d4d");
				l7.text = unescape(" "+newdist);
				l7.maxDisplayedLines = 1;
				l7.setStyle("verticalAlign","middle");
				
				hg3.addElement(l6);
				hg3.addElement(l7);
				
				v2.addElement(l5);
				
				
				var rc8:Rect = new Rect();
				rc8.fill = new SolidColor(0xFFFFFF, 1);
				rc8.percentHeight = 100;
				rc8.percentWidth = 100;
				this.addElement(rc8);
				g4.addElement(hg3);
				v2.addElement(g4);
				
				
				v1.addElement(v2);
			}
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