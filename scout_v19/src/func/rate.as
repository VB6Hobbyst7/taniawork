import com.milkmangames.nativeextensions.*;
import com.milkmangames.nativeextensions.events.*;
public function startRate():void {
	if (RateBox.isSupported())
	{
		RateBox.create("730533771","Rate This App","If you like this app, please rate it!","Rate Now","Ask Me Later","Don't ask again",0,3,0);
	}
}
