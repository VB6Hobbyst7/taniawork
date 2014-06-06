package com.adobe.contacts.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class ContactsSelectionComponentEvent extends Event
	{
		public static const CONTACTS_SELECTION_COMPLETED:String = "Selected Contacts For Inviting";
		public var selectedContacts:ArrayCollection;
		
		public function ContactsSelectionComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}