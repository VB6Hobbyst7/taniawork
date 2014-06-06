package com.adobe.contacts.objects
{
	public class Contact
	{
		public var emailAddress:String;
		public var photoUrl:String;	
		//this variable is for handling selecting contacts
		//this variable will not be returned from server
		public var selectedForInvite:Boolean;	
		public function Contact()
		{
		}

	}
}