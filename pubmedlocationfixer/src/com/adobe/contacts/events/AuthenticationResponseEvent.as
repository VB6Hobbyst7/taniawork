package com.adobe.contacts.events
{
	import flash.events.Event;

	public class AuthenticationResponseEvent extends Event
	{
		public static const GMAIL_AUTHENTICATION_SUCCESS_RESPONSE:String = "Gmail Authentication Success Response";
		public static const GMAIL_AUTHENTICATION_FAILURE_RESPONSE:String = "Gmail Authentications Failure Response";
		
		public function AuthenticationResponseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}