package com.adobe.contacts.contactsretrievers
{
	import com.adobe.contacts.authenticators.GmailAuthenticator;
	import com.adobe.contacts.events.AuthenticationResponseEvent;
	import com.adobe.contacts.events.ContactsRetrieverResponse;
	import com.adobe.contacts.objects.Contact;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class GmailContactsRetriever extends EventDispatcher implements IContactsRetriever
	{
		private var gmailAuthenticator:GmailAuthenticator;
		private var httpSrv:HTTPService;
		
		private var _userEmail:String;
		private var _numberOfContacts:int;
		
		public function GmailContactsRetriever()
		{
		}

		public function getContacts(userEmail:String, userPassword:String, numberOfContacts:int=25):void
		{
			gmailAuthenticator = new GmailAuthenticator();
			gmailAuthenticator.addEventListener(
			AuthenticationResponseEvent.GMAIL_AUTHENTICATION_SUCCESS_RESPONSE,
			handleAuthenticationResponse);
			gmailAuthenticator.addEventListener(
			AuthenticationResponseEvent.GMAIL_AUTHENTICATION_FAILURE_RESPONSE,
			handleAuthenticationResponse);
			gmailAuthenticator.authenticate(userEmail,userPassword);
			_userEmail = userEmail;
			_numberOfContacts= numberOfContacts;
		}
		
		private function handleAuthenticationResponse(event:AuthenticationResponseEvent):void
		{
			gmailAuthenticator.removeEventListener(
			AuthenticationResponseEvent.GMAIL_AUTHENTICATION_FAILURE_RESPONSE,
			handleAuthenticationResponse);
			gmailAuthenticator.removeEventListener(
			AuthenticationResponseEvent.GMAIL_AUTHENTICATION_SUCCESS_RESPONSE,
			handleAuthenticationResponse);
			
			if(event.type == AuthenticationResponseEvent.GMAIL_AUTHENTICATION_SUCCESS_RESPONSE)
			{
				getContactsFromServer();
			}
			else
			{
				var respEvent:ContactsRetrieverResponse = new ContactsRetrieverResponse(
				ContactsRetrieverResponse.GMAIL_RETRIEVE_CONTACTS_FAILURE);
				respEvent.errorMessage = "Authentication failed, please " + 
						"try again";
				dispatchEvent(respEvent);
			}
		}
		
		private function getContactsFromServer():void
		{
			httpSrv = new HTTPService();
			httpSrv.url = "http://www.google.com/m8/feeds/contacts/"+ _userEmail +
			"/thin?max-results=" + _numberOfContacts +"&showdeleted=false";
			httpSrv.method = "POST";
			httpSrv.resultFormat = "object";
			httpSrv.headers['Authorization'] = "GoogleLogin auth=" + GmailAuthenticator.authKey;
			httpSrv.addEventListener(ResultEvent.RESULT,handleGetContactsFromServer);
			httpSrv.addEventListener(FaultEvent.FAULT,handleFault);
			httpSrv.send();
		}
		
		private function handleGetContactsFromServer(event:ResultEvent):void
		{
			if(event.result != null && event.result.feed.entry is ArrayCollection)
			{
				var contacts:ArrayCollection = new ArrayCollection();
				var contact:Contact;
				var entries:ArrayCollection = event.result.feed.entry as ArrayCollection;
				for(var i:int = 0 ; i < entries.length ; i++)
				{
					contact = new Contact();
//we are not using Images for contacts
//					var links:ArrayCollection = entries[i].link;
//					var temp:String;
//					
//					for(var j:int = 0 ; j < links.length ; j++)
//					{
//						temp = String(links[j].rel);
//						if(temp.indexOf("#photo") >=0)
//						{
//							contact.photoUrl = links[j].href;
//						}
//					}
					contact.emailAddress = entries[i].email.address;
					contacts.addItem(contact);
				}
				var respEvent:ContactsRetrieverResponse = new ContactsRetrieverResponse(
				ContactsRetrieverResponse.GMAIL_RETRIEVE_CONTACTS_SUCCESS);
				respEvent.contacts = contacts;
				dispatchEvent(respEvent);	
			}
			else
			{
				var respFailEvent:ContactsRetrieverResponse = new ContactsRetrieverResponse(
				ContactsRetrieverResponse.GMAIL_RETRIEVE_CONTACTS_FAILURE);
				respFailEvent.contacts = null;
				respFailEvent.errorMessage = "No contacts found";
				dispatchEvent(respFailEvent);					
			}			
		}
		
		private function handleFault(event:FaultEvent):void
		{
			var respFailEvent:ContactsRetrieverResponse = new ContactsRetrieverResponse(
			ContactsRetrieverResponse.GMAIL_RETRIEVE_CONTACTS_FAILURE);
			respFailEvent.contacts = null;
			respFailEvent.errorMessage = "We faced problem retrieving your " + 
					"contacts from Gmail";
			dispatchEvent(respFailEvent);					
		}
	}
}