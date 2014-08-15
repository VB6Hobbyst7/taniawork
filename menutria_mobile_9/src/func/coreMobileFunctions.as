import com.milkmangames.nativeextensions.CoreMobile;
import com.milkmangames.nativeextensions.events.CMNetworkEvent;

public function startCoreMobile():void {
	if(CoreMobile.isSupported())
	{
		CoreMobile.create();
		CoreMobile.mobile.addEventListener(CMNetworkEvent.NETWORK_REACHABILITY_CHANGED, onNetworkChanged);
		recheckInternet();
	}
	else {}	
	
}
public function onNetworkChanged(e:CMNetworkEvent):void{
	recheckInternet();
}
public function recheckInternet():void {
	try{
		var networkAvailable:Boolean=CoreMobile.mobile.isNetworkReachable();
		if (networkAvailable){
			internetwarn.visible = false;
		}
		else {
			internetwarn.visible = true;
		}
	}
	catch(e:Error) {
		internetwarn.visible = true;	
	}
}