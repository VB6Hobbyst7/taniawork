package com.RTMPmessenger
{
    //
    import weborb.messaging.WeborbConsumer;
    import weborb.messaging.WeborbProducer;
    import mx.messaging.messages.AsyncMessage;    
	import mx.messaging.events.MessageEvent; 
	import flash.events.Event; 
    import mx.controls.Alert;
    import flash.net.registerClassAlias;
    import mx.messaging.ChannelSet;  
    
  import mx.messaging.config.ServerConfig;
  import weborb.messaging.WeborbMessagingChannel;
    
    
    //
	public class WorbMsgManager
	{
		
		
	    private var producer:WeborbProducer; 
		private var consumer:WeborbConsumer;		
		private var _parent:WinIM;
		
		
		
		public function WorbMsgManager(owner:WinIM){
			_parent=owner;
			connectAsProducer(_parent._id);
            connectAsConsumer(_parent._id);
            _parent.currentState='ready';
		}
		

				
		
		private function connectAsProducer( subTopic:String):void
	    {  		
	    	if( subTopic== "" ){
	            Alert.show( "Missing session name. Session identifies your producer and carries all the messages in the associated queue."
	            ,		 "Incomplete form" );
	            return;                    
	        }
	    	
	        producer = new WeborbProducer();
	        producer.destination = "ExampleDestination";
	        producer.subqueue = subTopic;
	        // send a meaningless message so the queue is created
	        producer.send( new AsyncMessage( "Hi" ) );
	       
	    }
	    
	    private function connectAsConsumer(subTopic:String):void
	    {
	    	 var cs:ChannelSet= new ChannelSet();
		     var uri:String = ServerConfig.getChannel("weborb-rtmp" ).uri;
		     //var channel:WeborbMessagingChannel = new WeborbMessagingChannel("test", uri );
		     var channel:WeborbMessagingChannel = new WeborbMessagingChannel(subTopic, uri );
		     channel.addEventListener( MessageEvent.MESSAGE, _parent.receivedMessage );
		     cs.addChannel( channel );
	    	
	        consumer = new WeborbConsumer();
	        consumer.channelSet=cs
	        consumer.destination = "ExampleDestination";
	        consumer.subqueue = subTopic;
	        consumer.addEventListener( MessageEvent.MESSAGE, _parent.receivedMessage );
	        consumer.subscribe();	    
	    }
	    
	    
	  
    
	    private function disconnectConsumer():void
	    {
	        consumer.unsubscribe();
	        consumer.removeEventListener( MessageEvent.MESSAGE, _parent.receivedMessage );	        
	    }	
	    
	    
    	public function sendMsg(txt:String,usr:String):void{
    		trace("@sendMsg="+arguments);  	
	        var evt:TextBoardEvent = new TextBoardEvent();   
	    	  evt.type = TextBoardEvent.TEXT;
	          evt.data = {text:txt,user:usr, pos:_parent.inputMain.verticalScrollPosition};
	          producer.send( new AsyncMessage( evt ) );  
	   }  

	    
	//END CLASS
	}
}