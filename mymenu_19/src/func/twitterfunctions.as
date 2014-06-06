import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.LocationChangeEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.media.CameraRoll;
import flash.media.StageWebView;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.IDataInput;

import mx.events.FlexEvent;

import org.iotashan.oauth.OAuthConsumer;
import org.iotashan.oauth.OAuthRequest;
import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
import org.iotashan.oauth.OAuthToken;
import org.iotashan.utils.OAuthUtil;
import org.iotashan.utils.URLEncoding;
public const TWITTER_CONSUMER_KEY:String = "9LKqhNwDKDQSuD67YpkQ";
public const TWITTER_CONSUMER_SECRET:String = "Eb7j2P0gWr1nxyWbBGdznmTeEPJ60Ih1a5nIv44QM";
// API URLs
public const VERIFY_CREDENTIALS:String = "https://api.twitter.com/1.1/account/verify_credentials.json";
private var twitterRequestURL:String = "https://api.twitter.com/oauth/request_token";
private var twitterAuthURL:String = "https://api.twitter.com/oauth/authorize";
private var twitterTokenURL:String = "https://api.twitter.com/oauth/access_token";
public var twitterAccessObj:Object = {};
private var requestToken:OAuthToken;
private var accessToken:OAuthToken;
private var oAuthConsumer:OAuthConsumer;
private var twitterWebView:StageWebView;
private var webViewStartLocation:int;
private var accessRequest:OAuthRequest;
private var thisProfile:Object = {};
private var cameraRoll:CameraRoll;
private var imageLoader:Loader;
private var mpLoaderInfo:LoaderInfo;
private var dataSource:IDataInput;
protected var signature:OAuthSignatureMethod_HMAC_SHA1 = new OAuthSignatureMethod_HMAC_SHA1();


private function startTwitter():void
{
	//Read details from any existing file
	readTwitterAccess();
	
	//Check if the Access Key and Access Token already Exist
	if(twitterAccessObj.accessKey && twitterAccessObj.accessSecret)
	{
		verifyAccessToken();
	}
	else
	{
		oAuthConsumer = new OAuthConsumer(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET);
		var oauth:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_MEHTOD_GET, twitterRequestURL, null, oAuthConsumer);
		var request:URLRequest = new URLRequest(oauth.buildRequest(new OAuthSignatureMethod_HMAC_SHA1()));
		var loader:URLLoader = new URLLoader(request);
		loader.addEventListener(Event.COMPLETE,onLoaderComplete);
		loader.addEventListener(IOErrorEvent.IO_ERROR, errorevent);
	}
}

public function errorevent(ev:IOErrorEvent):void {
	var stop:String = "";
}
//Loaded Twitter Access Token Request URL
private function onLoaderComplete(e:Event):void
{
	requestToken = OAuthUtil.getTokenFromResponse(e.currentTarget.data);
	var authRequest:URLRequest = new URLRequest('http://api.twitter.com/oauth/authorize?oauth_token=' + requestToken.key);
	
	// StageWebView to Authorize the App
	twitterWebView = new StageWebView();
	twitterWebView.viewPort = new Rectangle(0, navigator.actionBar.height, width, height);
	twitterWebView.stage = this.stage;
	twitterWebView.assignFocus();
	twitterWebView.loadURL(authRequest.url);
	twitterWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChange);
	//The LOCATION_CHANGE doesn't gets fired for me sometimes, so using this
	twitterWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange);
}

// Web View Location Change
private function onLocationChange(e:LocationChangeEvent):void
{
	var location:String = e.location;
	
	//Here we need to extract the oAuth Verifier URL from the redirect URL
	if(location.search("rjdesignz") != -1)
	{
		var oAuthVerifier:String = location.substr(location.search("oauth_verifier") + 15);
		onPin(oAuthVerifier);
	}
}

// We now have the PIN, use this
private function onPin(oAuthVerifier:String):void
{
	var params:Object = new Object();
	params.oauth_verifier = oAuthVerifier;
	
	accessRequest = new OAuthRequest(OAuthRequest.HTTP_MEHTOD_GET, twitterTokenURL, params, oAuthConsumer, requestToken);
	var accessUrlRequest:URLRequest = new URLRequest(accessRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1()));
	var accessLoader:URLLoader = new URLLoader(accessUrlRequest);
	accessLoader.addEventListener(Event.COMPLETE, onAccessRequestComplete);
}

// Got the required details. Dispose the web view and write details to local storage.
private function onAccessRequestComplete(e:Event):void
{
	accessToken = OAuthUtil.getTokenFromResponse(e.currentTarget.data);
	twitterAccessObj.accessKey = accessToken.key;
	twitterAccessObj.accessSecret = accessToken.secret;
	
	twitterWebView.dispose();
	//postConainer.includeInLayout = true;
	//postConainer.visible = true;
	
	writeTwitterAccess();
}

// Post the message on Twitter
private function onPostToTwitter():void
{
	busy = true;
	var params:Object = {};
	params.status = shareText.text;
	var consumer:OAuthConsumer = new OAuthConsumer(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET);
	var token:OAuthToken = new OAuthToken(twitterAccessObj.accessKey, twitterAccessObj.accessSecret);
	var postRequest:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_MEHTOD_POST, "https://api.twitter.com/1.1/statuses/update.json", {status:shareText.text}, consumer, token);
	
	var urlRequest:URLRequest = new URLRequest(postRequest.buildRequest(new OAuthSignatureMethod_HMAC_SHA1()));
	urlRequest.method = URLRequestMethod.POST;
	urlRequest.url = urlRequest.url.replace("&status=" + URLEncoding.encode(params.status), "");
	urlRequest.data = new URLVariables("status=" + shareText.text );
	var loader:URLLoader = new URLLoader(urlRequest);
	loader.addEventListener(Event.COMPLETE, onTwitterPostComplete);
	loader.addEventListener(IOErrorEvent.IO_ERROR, onTwitterIOError);
	loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onTwitterHttpStatus);
}

// Credentials already exist, verify these 
public function verifyAccessToken() : void
{
	busy = true;
	trace("verify access token");
	var consumer:OAuthConsumer = new OAuthConsumer(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET);
	var token:OAuthToken = new OAuthToken(twitterAccessObj.accessKey, twitterAccessObj.accessSecret);
	var oauthRequest:OAuthRequest = new OAuthRequest( "GET", VERIFY_CREDENTIALS, null, consumer, token );
	var request:URLRequest = new URLRequest( oauthRequest.buildRequest( signature, OAuthRequest.RESULT_TYPE_URL_STRING ) );
	request.method = "GET";
	
	var loader:URLLoader = new URLLoader( request );
	loader.addEventListener( Event.COMPLETE, verifyAccessTokenHandler );
	loader.addEventListener(IOErrorEvent.IO_ERROR, onTwitterIOError);
	loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onTwitterHttpStatus);
}

//Successfully Posted on Twitter
private function onTwitterPostComplete(e:Event):void
{
	busy = false;
	shareText.text = "";
	trace("Tweet Success!");
}

// Twitter IO Error
private function onTwitterIOError(e:IOErrorEvent):void
{
	busy = false;
	trace("Tweet IOError!");
}

// Twitter HTTP Status Error
private function onTwitterHttpStatus(e:HTTPStatusEvent):void
{
	trace("Tweet HttpStatus!");
}

// Access Token Exists
protected function verifyAccessTokenHandler(event:Event):void
{
	trace("Valid Access Data Exists");
	
	busy = false;
	//postConainer.includeInLayout = true;
	//postConainer.visible = true;
}

public function readTwitterAccess():void
{
	var file:File = File.applicationStorageDirectory.resolvePath("tw.file");
	var fileStream:FileStream = new FileStream();
	if(file.exists)
	{
		fileStream.open(file, FileMode.READ);
		var obj:Object = fileStream.readObject() as Object;
		twitterAccessObj.accessKey = obj.twitterAccessKey;
		twitterAccessObj.accessSecret = obj.twitterAccessSecret;
		fileStream.close();
	}
	else
	{
		trace("No File Present");
	}
}

public function writeTwitterAccess():void
{
	var file:File = File.applicationStorageDirectory.resolvePath("tw.file");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	var obj:Object = {};
	obj.twitterAccessKey = twitterAccessObj.accessKey;
	obj.twitterAccessSecret = twitterAccessObj.accessSecret;
	fileStream.writeObject(obj);
	fileStream.close();
}
