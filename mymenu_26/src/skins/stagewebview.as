package skins
{ 
	import flash.display.Bitmap; 
	import flash.display.BitmapData; 
	import flash.display.Sprite; 
	import flash.events.*; 
	import flash.geom.Rectangle; 
	import flash.media.StageWebView; 
	import flash.net.*; 
	import flash.text.TextField; 
	public class stagewebview extends Sprite 
	{ 
		public var webView:StageWebView=new StageWebView(); 
		public var textGoogle:TextField=new TextField(); 
		public var textFacebook:TextField=new TextField(); 
		public function stagewebview() 
		{ 
			textGoogle.htmlText="<b>Google</b>"; 
			textGoogle.x=300; 
			textGoogle.y=-80;         
			addChild(textGoogle); 
			textFacebook.htmlText="<b>Facebook</b>"; 
			textFacebook.x=0; 
			textFacebook.y=-80; 
			addChild(textFacebook); 
			textGoogle.addEventListener(MouseEvent.CLICK,goGoogle); 
			textFacebook.addEventListener(MouseEvent.CLICK,goFaceBook); 
			webView.stage = this.stage; 
			webView.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight); 
		} 
		public function goGoogle(e:Event):void 
		{ 
			webView.loadURL("http://www.google.com"); 
			webView.stage = null; 
			webView.addEventListener(Event.COMPLETE,handleLoad); 
		} 
		
		public function goFaceBook(e:Event):void 
		{ 
			webView.loadURL("http://www.facebook.com"); 
			webView.stage = null; 
			webView.addEventListener(Event.COMPLETE,handleLoad); 
		} 
		public function handleLoad(e:Event):void 
		{ 
			var bitmapData:BitmapData = new BitmapData(webView.viewPort.width, webView.viewPort.height); 
			webView.drawViewPortToBitmapData(bitmapData); 
			var webViewBitmap:Bitmap=new Bitmap(bitmapData); 
			addChild(webViewBitmap); 
		} 
	} 
}