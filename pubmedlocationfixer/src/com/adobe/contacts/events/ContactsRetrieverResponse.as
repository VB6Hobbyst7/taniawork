package com.adobe.contacts.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class ContactsRetrieverResponse extends Event
	{
		public static const GMAIL_RETRIEVE_CONTACTS_SUCCESS:String = "Gmail Retrieve Contacts Success";
		public static const GMAIL_RETRIEVE_CONTACTS_FAILURE:String = "Gmail Retrieve Contacts Failure";
		
		public var errorMessage:String;
		public var contacts:ArrayCollection;
		
		public function ContactsRetrieverResponse(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}