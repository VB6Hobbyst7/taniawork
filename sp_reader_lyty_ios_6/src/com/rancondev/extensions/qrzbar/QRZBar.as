package com.rancondev.extensions.qrzbar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExtensionContext;
	import flash.events.StatusEvent;
	
	public class QRZBar extends EventDispatcher
	{
		private static const EXTENSION_ID : String = "com.rancondev.extensions.qrzbar.QRZBar";
		private var context:ExtensionContext;

		public function QRZBar()
		{
			context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);	
			super(null);
		}
		
		public function scan():void
		{
			context.addEventListener(StatusEvent.STATUS, onScanHandler);
			context.call("scan");
		}

		private function onScanHandler(event:StatusEvent):void
		{
			if (event.code == QRZBarEvent.SCANNED)
			{
				dispatchEvent(new QRZBarEvent(event.level));
				context.removeEventListener(StatusEvent.STATUS, onScanHandler);
			}
		}
	}
}