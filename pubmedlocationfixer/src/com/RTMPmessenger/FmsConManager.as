package com.RTMPmessenger
{
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetStream;
	import flash.net.Responder;
	import flash.net.SharedObject;
	

	public class FmsConManager
	{
		//############################
		//Static
		//############################
		
		public static function get_nc(title:String):FMSnetConnection{
			return _instance.a_NC[title];
		}
		
		public static function serverCall(nc:FMSnetConnection,method:String,resultObj:Responder,args:Array):void{
			nc.call("serverCall",resultObj,method,args);
		
		}
		
		private static var _instance:FmsConManager;		
		
		
		public static function getInstance():FmsConManager{
		if (FmsConManager._instance==null)
				FmsConManager._instance= new FmsConManager(arguments.callee);
			
			return FmsConManager._instance;	
		}
		//############################
		//Private VARS
		//############################
		
		
		private var a_NC:Object;
		private var a_NS:Object;
		
		//singleton stuff
		public function FmsConManager(caller:Function = null){
			if (caller != FmsConManager.getInstance)
				throw new Error ("FmsConManager is a singleton class, use getInstance()");
			if (FmsConManager._instance != null)
				throw new Error ("Only one FmsConManager instance should be instantiated");				
				a_NS={};		
				a_NC={};
		}
		
		public function get_NC(title:String	):FMSnetConnection{
			//does NC already exist? if so return it			
			if (a_NC[title]!=null)return a_NC[title];		
			var _nc:FMSnetConnection = new FMSnetConnection();	

            _nc.objectEncoding = flash.net.ObjectEncoding.AMF0;
	        _nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
	       	_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            //you will want to use a specific instance for your chat
            //change localhost to your FMSServer
			_nc.connect("rtmp://31.222.177.156/OpenMessenger/"+title,WorbConManager._uName); 
            a_NC[title]=_nc;                   
            return _nc;
		}
		
		public function get_SO(_nc:FMSnetConnection):SharedObject{
			//TODO check to see if RSO already created
			var so:SharedObject=SharedObject.getRemote("public/vid",_nc.uri,false);				
			return so;
		}
		
		
		
		private function netStatusHandler(event:NetStatusEvent):void {
	  	  	trace("-(FMS-nc)-"+event.info.code)	  	  
	        switch (event.info.code) {
	            case "NetConnection.Connect.Success":
	                //connectStream();
	                break;	
	            case "NetConnection.Connect.Failed":
	            break ;           
	        }
	     }
	     
		private function netStatusStreamHandler(event:NetStatusEvent):void {
	  	  	trace("-(FMS-ns)-"+event.info.code)	
	  	  	  switch (event.info.code) {
				case "NetStream.Play.Reset":
	            break ; 
				case "NetStream.Play.Start":
	            break ; 
				case "NetStream.Play.Stop":
	            break ; 
				case "NetStream.Buffer.Empty":
	            break ; 
				case "NetStream.Buffer.Full":
	            break ; 
	            case "NetStream.Seek.Notify":
	             break ;           
	            case "NetStream.Play.Failed":
	             break;	
	        }
		}
	     
	     
        private function securityErrorHandler(event:SecurityErrorEvent):void {
           trace("FMS securityErrorHandler: " + event.toString());
        }
		

		
		public function get_NS(nsTitle:String,nc:FMSnetConnection):NetStream{	
			if (a_NS[nsTitle]!=null)return a_NS[nsTitle];		
			var _ns:NetStream = new NetStream(nc);	
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusStreamHandler);	
          	 a_NS[nsTitle]=_ns;	
            return _ns
		}
		
		public function delete_NC(title:String):void{
			if (a_NC[title]!=null){
				a_NC[title].close();
				a_NC[title]=null;
			}		
		}
		
		public function delete_NS(buddy:String):void{
			if (a_NS[buddy]!=null){
				a_NS[buddy].close();
				a_NS[buddy]=null;
			}		
		}
		
		
	//END CLASS	
	}
}