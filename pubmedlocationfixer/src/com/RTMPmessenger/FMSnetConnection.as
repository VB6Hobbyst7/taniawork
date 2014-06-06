package com.RTMPmessenger
{
	import flash.net.NetConnection;
	public class FMSnetConnection extends NetConnection
	{


	
		public function FMSnetConnection(){
			super();
		}

	
		public function initUser(args:Array):void{    		
    		//dispatch event to listening objects
    		var init:CustomDispatcher = new CustomDispatcher(CustomDispatcher.INIT_USER,args);
 			dispatchEvent(init);
    	  }
    	  
    	
    	  
///END CLASS
	}
}