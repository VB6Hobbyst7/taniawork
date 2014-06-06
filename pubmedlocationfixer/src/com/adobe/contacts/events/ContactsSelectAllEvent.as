package com.adobe.contacts.events
{
	import flash.events.Event;

	public class ContactsSelectAllEvent extends Event
	{
		public static const ALL_CONTACTS_SELECTION_CHANGED:String = "All Contacts Change Event";
		public var selectAll:Boolean;
		
		public function ContactsSelectAllEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}