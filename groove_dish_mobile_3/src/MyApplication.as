package
{
	import com.distriqt.extension.application.Application;
	import com.distriqt.extension.application.IOSStatusBarStyles;
	import com.distriqt.extension.application.events.ApplicationEvent;
	import flash.display.Sprite;
	public class MyApplication extends Sprite
	{
		public static const DEV_KEY : String = "848fb2389a815c1a2510fe347d605b8b831e2d49DVyHgWM3LYeOe1hkwvUUIn5aMnL2C85puPNxYeaeMIEoKCdN/M9wXWmJ/TJ5jjwrSqarnPDn99CcldJn+yVS4sMQ2k/CMWknkY97LSTSEaSXFwy04DKEpydA8ew1bERInFiNW05dl+mJmhIyJGb1iI+m7Aqc7Ov+x/Bo+/31R0Vstl+/vNwcgrgcMo5PzCl+mBe5dAGSLxycnDsJ2iw4JKGELkw8N0L4uWKyvY9bPODfpvW6CLDu5Pfda5uUSinxHecp1CTxEiKUSGdCbIK8IV4QJgHjbZfhX5pyH/4XFtwbr8U0P40+sAv+q3TekoqjSurYoNNOJB/JUWA7DgI/tQ==";
		public function MyApplication( devKey:String = DEV_KEY )
		{
			super();
			_devKey = devKey;
			init();
		}
		private var _devKey				: String;
		private var _autoStartEnabled 	: Boolean = false;
		private function init():void
		{
			try
			{
				Application.init( _devKey );
				Application.service.addEventListener( ApplicationEvent.UI_NAVIGATION_CHANGED, application_uiNavigationChangedHandler, false, 0, true );
				Application.service.setStatusBarHidden( false );
				Application.service.setStatusBarStyle( IOSStatusBarStyles.IOS_STATUS_BAR_LIGHT );
			}
			catch (e:Error){}
		}
		private function application_uiNavigationChangedHandler( event:ApplicationEvent ):void
		{
			Application.service.setStatusBarHidden( false );
			Application.service.setStatusBarStyle( IOSStatusBarStyles.IOS_STATUS_BAR_LIGHT );
		}	
	}
}

