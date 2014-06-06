package com.RTMPmessenger
{
	
	//EVENT START
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.NetConnection;
    import flash.net.ObjectEncoding;
    
    import mx.collections.ArrayCollection;
    import mx.messaging.config.ServerConfig;
    
    
   

   public class WorbConManager
	{
		//############################
		//Static
		//############################
		//singleton stuff
		private static var _instance:WorbConManager;		
		private static var clientID:String;
		
		public static function getInstance():WorbConManager{
		if (WorbConManager._instance==null)
				WorbConManager._instance= new WorbConManager(arguments.callee);			
			return WorbConManager._instance;	
		}
		
		public static function get _nc():NetConnection{
			return WorbConManager._instance.wOrb_nc;
		}
		
		public static function get _uName():String{
			return WorbConManager._instance.uName;
		}
		
		public static function get uID():String{
			return clientID;
		}
		public function get _buds ():ArrayCollection{
			return buddyList;
		}
		//############################
		//Private VARS
		//############################
		private var wOrb_nc:NetConnection;
		private var buddyList:ArrayCollection=new ArrayCollection();
		private var uName:String;
		private var _parent:Radar;
	
		
		//singleton stuff
		public function WorbConManager(caller:Function = null):void{
			if (caller != WorbConManager.getInstance)
				throw new Error ("ImWinManager is a singleton class, use getInstance()");
			if (WorbConManager._instance != null)
				throw new Error ("Only one ImWinManager instance should be instantiated");
				//this.ddEventListener(WorbEvents.CONTROL_TYPE, eventHandler);			
		}
		
		
		
			//create connection to weborb//
		public function InitConnection(usrName:String,pwd:Radar) : void
	      {
	      	_parent=pwd;
	        uName=usrName.toLowerCase();
	       	var uri:String = ServerConfig.getChannel( "weborb-rtmp" ).endpoint;
	        wOrb_nc = new NetConnection();
	        wOrb_nc.client = this;
	        wOrb_nc.objectEncoding = ObjectEncoding.AMF0;          
	        wOrb_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
	       	wOrb_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);	
	       	//uri="rtmp://kucydwor01:2037";
	        wOrb_nc.connect( uri + "/CallbackDemo",usrName); 
	        //uList.value="Welcome "+uName;
	      }
		 private function netStatusHandler(event:NetStatusEvent):void {
	  	  	trace("-(Worb-nc)-"+event.info.code)
	        switch (event.info.code) {
	            case "NetConnection.Connect.Success":
	                //connectStream();
	                break;	            
	        }
	     }
	     
	     
		 private function securityErrorHandler(event:SecurityErrorEvent):void {
	           trace("securityErrorHandler: " + event);
	      }
	
	     public function setClientID( myID:String,budList:Object):void{      	 
		  	 for (var i:String in budList)buddyList.addItem(budList[i]);  
	         WorbConManager.clientID = myID; 
	     }
	
	    public function clientConnected( uName:String,Stat:String,clientID:String ) : void
	      {
	      	var tot:Number=buddyList.length;
	      	for (var i:Number=0;i<tot;++i){
	      		if (uName==buddyList[i].uname){
		      		buddyList[i].stat=Stat;
		      		buddyList[i].value=clientID;
	      			notify(buddyList[i].uname,Stat);
		      		break;
	      		}      	
	      	}
	      	_parent.userlist_dg.invalidateList();
	      }

	      public function clientDisconnected( clientID:String ) : void
	      { //output.text = "Client disconnected - " + clientID + "\n" + output.text;
	         	var tot:Number=buddyList.length;
	         	var uname:String;
	         	var Stat:String="offline";
	      	for (var i:Number=0;i<tot;++i){	      		
	      		if (clientID==buddyList[i].value){
	      		buddyList[i].stat=Stat;
	      		buddyList[i].value=-1;
	      		notify(buddyList[i].uname,Stat);
	      		break;
	      		}      	
	      	}
	      	_parent.userlist_dg.invalidateList();
	     }
	     
	     public function notify(uname:String,stat:String):void {
	     	//notify when user status
	     	
	     }
	
		///////////////////////////////
		//MSMQ setup below
		//////////////////////////////
		
		
		public function messageRequestIN(fromuser:String, MSMQname:String, textout:String):void{
			//requesting to create a new msg window
			
			_parent.server2Parent("createWindow",{user:fromuser,queue:MSMQname,text:textout});		
		}
	    
	    
	    public function messageRequestOUT(args:Object):void{
	    	//confirming window is open
	    	var touser:String=args.user;
	    	var MSMQname:String=args.queue;	     
	    	//trace("==>"+WorbConManager._uName+","+touser+","+MSMQname) 
			_parent.server2Parent("addMyText",{me:WorbConManager._uName,queue:MSMQname, text:_parent.winMnge.aWins[MSMQname].inputMain.text});
	   		wOrb_nc.call("CreateMSMessage",null, WorbConManager._uName,  touser,  MSMQname, _parent.winMnge.aWins[MSMQname].inputMain.text);
	     }
	
	
	
	//END CLASS	
	}
}