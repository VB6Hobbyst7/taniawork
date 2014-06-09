package  {
	import com.rancondev.extensions.qrzbar.QRZBar;
	import com.rancondev.extensions.qrzbar.QRZBarEvent;
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class qrreader extends MovieClip {
		
		private var qr:QRZBar;
		
		public function qrreader()
		{
		}
		
		protected function test(event:MouseEvent):void
		{
			trace("button clicked");
			qr = new QRZBar();
			qr.scan();
			qr.addEventListener( QRZBarEvent.SCANNED, scannedHandler );
		}
		
		protected function scannedHandler( event : QRZBarEvent ) : void
		{
			qr.removeEventListener( QRZBarEvent.SCANNED, scannedHandler );
			chosenlabel.text = event.result;
		}
	}
	
}