package com.RTMPmessenger
{
	
    import com.RTMPmessenger.FmsConManager;
    import flash.events.Event;
    import flash.media.Camera;
    import flash.media.Microphone;
    import flash.net.NetStream;
    import flash.net.SharedObject;
    
    import mx.controls.Alert;
    
    
	public class MediaManager
	{
		private var FMS:FmsConManager;
		private var nc:FMSnetConnection;
		private var camera:Camera;
		private var mic:Microphone;
		
		public function MediaManager (title:String,mainIM:WinIM){		
     		FMS=FmsConManager.getInstance();
     		nc=FMS.get_NC(title);//called when IM window is created
            nc.addEventListener(CustomDispatcher.INIT_USER,mainIM.initUser);
           var so:SharedObject = FMS.get_SO(nc);
           so.client = mainIM;
           so.connect(nc);
		}
		
		
		

		
		
		public function stopCamera(vid:VidComp,myName:String):void{
			//stop streaming camera OUT  out_ns + myname
			vid.attachCamera(null);
			var out_ns:NetStream=FMS.get_NS(myName+"_out", nc);
            out_ns.attachCamera(null);
            out_ns.attachAudio(null);
		    FmsConManager.serverCall(nc,"updateVid",null,[{isVcasting:false}]);
		}
		
		
		private function CameraStatus(event:Event):void{
			trace("camera status"+event.toString());
		
		}
		
		
		public function startCamera(vid:VidComp,myName:String):void{
			//start streaming camera OUT  out_ns+myname
			//create netstream
			try {
	            camera = Camera.getCamera();
	            camera.addEventListener("status",CameraStatus);
	            mic = Microphone.getMicrophone();
		        vid.attachCamera(camera);
			}catch (e:Object){
				Alert.show("Check WebCamera, it may be incorrectly installed.", "(E)WebCamera Error");
				return;	
			}
		       publishStream (myName);
		       FmsConManager.serverCall(nc,"updateVid",null,[{isVcasting:true}]);
		}
		
		
		private function publishStream(myName:String):void{
			//attach to netstream
			trace("Publishing "+myName);
			var out_ns:NetStream=FMS.get_NS(myName+"_out",nc);
            out_ns.attachCamera(camera);
            out_ns.attachAudio(mic);
            out_ns.publish(myName);
		}
		
		public function subscribeStream(buddy:String,vid:VidComp):void{
			//attach to local camera
			//create a stream in_ns+buddyname
			var ns:NetStream=FMS.get_NS(buddy+"_in",nc);
			vid.attachNetStream(ns);
			ns.play(buddy,-1);			
		}
		
		public function subscribeStop(buddy:String,vid:VidComp):void{
			//attach to local camera
			//create a stream in_ns+buddyname
			var ns:NetStream=FMS.get_NS(buddy+"_in",nc);
			vid.attachNetStream(null);
			ns.close();		
		}
		
		
	}
}