package com.RTMPmessenger
{
	import flash.media.Video;
	import flash.media.Camera;
	import flash.net.NetStream;	
	import mx.core.UIComponent;

	public class VidComp extends UIComponent{
		
		private var Vid:Video
		private var init:Boolean=false;
		
		public function attachCamera(camera:Camera):void{			
			Vid.attachCamera(camera);
		}
		
		public function attachNetStream(ns:NetStream):void{
			if(ns!=null && init)return;				//prevent multiple attachNetStream
			Vid.attachNetStream(ns);
			init=(ns==null?false:true);
		}
		
		public function VidComp(){		
			this.setActualSize(85,82);
			Vid = new Video(85,82);
			this.addChild(Vid);
			Vid.x=0;
			Vid.y=0;
		 }
		 		 			
	}
}