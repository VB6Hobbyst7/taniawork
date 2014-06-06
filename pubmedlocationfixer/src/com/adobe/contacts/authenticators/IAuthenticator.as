package com.adobe.contacts.authenticators
{
	public interface IAuthenticator
	{
		function authenticate(userName:String, userPassword:String):void
	}
}