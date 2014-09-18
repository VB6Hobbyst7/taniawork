import com.milkmangames.nativeextensions.GVFacebookFriend;
import com.milkmangames.nativeextensions.GoViral;
import com.milkmangames.nativeextensions.events.GVFacebookEvent;
import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.filesystem.File;
import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import spark.managers.PersistenceManager;
import views.Home;
import views.Login;
import views.MenuAll;
import views.StoresDescription;
public static const FACEBOOK_APP_ID:String="1461197797460743";
public function initz(event:FlexEvent):void
{
	
	//beginappnative();
	pm.load();
	try{
		loadedview = true; 
		mainNavigator.loadViewData(pm.getProperty("sviewdata"));
	}
	catch(e:Error){
		loadedview = true; 
		mainNavigator.pushView(Login,null,null,crosstrans);
	}
	try{
		GoViral.create();
		GoViral.goViral.initFacebook(FACEBOOK_APP_ID, "");
		GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN,onFacebookEvent);
		GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT,onFacebookEvent);
		GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED,onFacebookEvent);
		GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED,onFacebookEvent);
		try{
			NativeApplication.nativeApplication.autoExit = false;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.executeInBackground = true;
		}
		catch(e:Error){	
		}	
		
		
		checkfacebookin();
	}
	catch(e:Error){}
}
public function checkfacebookin():void {
	doFacebookStuff();
}
private function onFacebookEvent(e:GVFacebookEvent):void
{
	try{
		var s:String = "";
		switch(e.type)
		{
			case GVFacebookEvent.FB_LOGGED_IN:
				
				checkfacebookin();
				s = "Logged in to facebook:"+GoViral.VERSION+
				",denied: ["+GoViral.goViral.getDeclinedFacebookPermissions()+
				"], profile permission?"+GoViral.goViral.isFacebookPermissionGranted("public_profile");
				break;
			case GVFacebookEvent.FB_LOGGED_OUT:
				s = "Logged out of facebook.";
				break;
			case GVFacebookEvent.FB_LOGIN_CANCELED:
				s = "Canceled facebook login.";
				break;
			case GVFacebookEvent.FB_LOGIN_FAILED:
				s = "Login failed:"+e.errorMessage+",sn?"+e.shouldNotifyFacebookUser+",cat?"+e.facebookErrorCategoryId;
				break;
			case GVFacebookEvent.FB_PUBLISH_PERMISSIONS_FAILED:
			case GVFacebookEvent.FB_READ_PERMISSIONS_FAILED:
				s =  "perms failed:"+e.errorMessage+",sn?"+e.shouldNotifyFacebookUser+",cat?"+e.facebookErrorCategoryId+","+e.permissions;
				break;
			case GVFacebookEvent.FB_READ_PERMISSIONS_UPDATED:
			case GVFacebookEvent.FB_PUBLISH_PERMISSIONS_UPDATED:
				s = "Perms updated:"+e.permissions;
		}
	}
	catch(e:Error){}
}
public function facebookloging():void {
	if(!GoViral.goViral.isFacebookAuthenticated())
	{
		GoViral.goViral.authenticateWithFacebook("email,public_profile,user_birthday,user_location");
	}
	else {		
		doFacebookStuff();		
	}
}
public function doFacebookStuff():void {
	try{
		GoViral.goViral.requestMyFacebookProfile().addRequestListener(function(e:GVFacebookEvent):void {
			if (e.type==GVFacebookEvent.FB_REQUEST_RESPONSE)
			{
				var myProfile:GVFacebookFriend=e.friends[0];
				
				fsid = myProfile.id.toString();
				
				try{
					fsemail = myProfile.email();
				}
				catch(e:Error){}
				
				try{
					fsname = myProfile.name.toString();
				}
				catch(e:Error){}
				
				try{
					fscity = myProfile.locationName.toString().substr(
						0,
						myProfile.locationName.toString().indexOf(","));
				}
				catch(e:Error){
					try{
						fscity = myProfile.properties.user_location.toString().substr(
							0,
							myProfile.properties.user_location.toString().indexOf(","));
					}
					catch(e:Error){
						
						fscity = "";
					}
					
				}
				
				try{
					fslocality = myProfile.locationName.toString().substr(
						myProfile.locationName.toString().indexOf(",")+2, 
						myProfile.locationName.toString().length);
				}
				catch(e:Error){
					try{
						fslocality = myProfile.properties.user_location.toString().substr( 
							myProfile.properties.user_location.toString().indexOf(",")+2,
							myProfile.properties.user_location.toString().length);
					}
					catch(e:Error){
						
						fslocality = "";
					}
					
				}
				
				
				
				try{
					fsgender = myProfile.gender.toString().substr(0,1);
				}
				catch(e:Error){
					fsgender = "";
				}
				
				
				var tempBirthString:String = "";
				try{
					tempBirthString = myProfile.properties["birthday"].toString();
				}
				catch(e:Error){}
				
				
				
				try{
					fsbirthmonth = tempBirthString.substr(0,tempBirthString.indexOf("/"));
					tempBirthString = tempBirthString.substring(tempBirthString.indexOf("/")+1,tempBirthString.length);
				}
				catch(e:Error){
					fsbirthmonth = "0";
				}
				
				
				try{
					fsbirthday = tempBirthString.substr(0,tempBirthString.indexOf("/"));
					tempBirthString = tempBirthString.substring(tempBirthString.indexOf("/")+1,tempBirthString.length);
				}
				catch(e:Error){
					fsbirthday = "0";
				}
				
				
				try{
					fsbirthyear = tempBirthString;
				}
				catch(e:Error){
					fsbirthyear = "0";
				}
				
				
				syncfacebook.send();			
			}
			
		});
	}
	catch(e:Error){
		
	}
	
}
public function aftersyncfacebook(ev:ResultEvent):void {
	createIfNotExsist("localuser");
	doQuery("delete FROM localuser;");
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "INSERT into localuser values(:email,:name,:city,:picture)";
	stmt.parameters[":email"] = fsemail;
	stmt.parameters[":name"] = fsname;
	stmt.parameters[":city"] = fscity;
	stmt.parameters[":picture"] = "";
	stmt.execute();
	reloadProfInfo();
	if (mainNavigator.activeView.name.toLocaleLowerCase().indexOf('sign') != -1){
		mainNavigator.pushView(Home,{homefilterarray:[]});
	}
	
}

public function afterGetUserInfo(ev:ResultEvent):void {
	try{
		var newpicture:String = ev.result[0].ress.res.picture;
		if (newpicture.length > 1){
			profimage.source = newpicture;
			profimage.scaleMode = "zoom";
			profimage.visible = true;
			doQuery("update localuser set picture = '"+newpicture+"';");
		}
	}
	catch(e:Error){}
}