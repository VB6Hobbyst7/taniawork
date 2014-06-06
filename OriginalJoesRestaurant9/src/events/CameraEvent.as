package events
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class CameraEvent extends Event
	{
		public static const FILE_READY:String = "fileReady";
		
		public var file:File;
		
		public function CameraEvent(type:String, file:File=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.file = file;
		}
	}
}