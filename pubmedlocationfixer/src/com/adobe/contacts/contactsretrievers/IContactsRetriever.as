package com.adobe.contacts.contactsretrievers
{
	public interface IContactsRetriever
	{
		function getContacts(userEmail:String, userPassword:String, numberOfContacts:int=25):void
	}
}