package com.adobe.contacts.authenticators
{
	import com.adobe.contacts.events.AuthenticationResponseEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class GmailAuthenticator extends EventDispatcher implements IAuthenticator 
	{
		private var httpSrv:HTTPService;
		private static var _authKey:String;
		
		public function GmailAuthenticator()
		{
		}

		public static function get authKey():String
		{
			return _authKey;
		}
		
		public function authenticate(userName:String, userPassword:String):void
		{
			
		
			
			httpSrv = new HTTPService();
			httpSrv.url = "https://www.google.com/accounts/ClientLogin";
			httpSrv.method = "POST";
			httpSrv.resultFormat = "text";
			httpSrv.addEventListener(ResultEvent.RESULT, handleAuthenticateResponse);
			httpSrv.addEventListener(FaultEvent.FAULT, handleFault);
			
			var params:Object = new Object();
			params['accountType'] = "GOOGLE";
			params['Email'] = userName;
			params['Passwd'] = userPassword;
			params['service'] = "cp";
			params['source'] = "ImportContacts-air";
			var mm:URLRequest = new URLRequest("https://www.google.com/accounts/ClientLogin");
			var urls:URLLoader = new URLLoader();
			urls.addEventListener(Event.COMPLETE, mmComplete);
			mm.requestHeaders new Array(new URLRequestHeader(params.toString()));
			//mm.requestHeaders = Array(params);
			urls.load(mm);
			
			//httpSrv.send(params);
		}
		public function mmComplete(event:Event):void {
			var stop:String = "";
		}
		private function handleAuthenticateResponse(event:ResultEvent):void
		{
			var responseStr:String = event.result as String;
			var responseArr:Array = responseStr.split("\n");
			var tempStr:String;
			for(var i:int = 0 ; i < responseArr.length; i++)
			{
				tempStr = responseArr[i] as String;
				if(tempStr.substring(0,5) === "Auth=")
				{
					_authKey = tempStr.substring(5);
				}
			}
			
			var responseEvent:AuthenticationResponseEvent = new AuthenticationResponseEvent(
			AuthenticationResponseEvent.GMAIL_AUTHENTICATION_SUCCESS_RESPONSE);
			dispatchEvent(responseEvent);
		}
		
		private function handleFault(event:FaultEvent):void
		{
			var responseEvent:AuthenticationResponseEvent = new AuthenticationResponseEvent(
			AuthenticationResponseEvent.GMAIL_AUTHENTICATION_FAILURE_RESPONSE);
			dispatchEvent(responseEvent);

		}
	}
}