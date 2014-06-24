package utils
{
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;
	
	/**
	The target can support the followinf states:
	<s:states>
		<s:State name="iosPhoneportrait" stateGroups="ios,phone,portrait,phoneportrait"/>
		<s:State name="iosPhonelandscape" stateGroups="ios,phone,landscape,phonelandscape"/>
		<s:State name="iosTabletportrait" stateGroups="ios,tablet,portrait,tabletportrait"/>
		<s:State name="iosTabletlandscape" stateGroups="ios,tablet,landscape,tabletlandscape"/>
		<s:State name="androidPhoneportrait" stateGroups="android,phone,portrait,phoneportrait"/>
		<s:State name="androidPhonelandscape" stateGroups="android,phone,landscape,phonelandscape"/>
		<s:State name="androidTabletportrait" stateGroups="android,tablet,portrait,tabletportrait"/>
		<s:State name="androidTabletlandscape" stateGroups="android,tablet,landscape,tabletlandscape"/>
		<s:State name="qnxTabletportrait" stateGroups="qnx,tablet,portrait,tabletportrait"/>
		<s:State name="qnxTabletlandscape" stateGroups="qnx,tablet,landscape,tabletlandscape"/>
	</s:states>
	*/
	public class StatesUtil
	{
		public static const PLATFORM_IOS:String = "ios";
		public static const PLATFORM_ANDROID:String = "android";
		public static const PLATFORM_QNX:String = "qnx";

		public static const PORTRAIT:String = "portrait";
		public static const LANDSCAPE:String = "landscape";
		
		public static var platform:String;

		protected var _target:UIComponent;
		
		/* static initializer */
		{
			switch (Capabilities.version.substr(0, 3).toLowerCase()) 
			{
				case "ios": 
				{
					platform = PLATFORM_IOS;
					break;
				}
				case "and": 
				{
					platform = PLATFORM_ANDROID;
					break;
				}
				case "qnx":
				{
					platform = PLATFORM_QNX;
					break;
				}
			}
			trace("Platform: " + platform);
		}
		
		public function set target(target:UIComponent):void
		{
			if (target == null) return;
			_target = target;
			_target.addEventListener(Event.RESIZE, 
				function(event:Event):void
				{
					updateState();	
				});
		}
		
		public function get isTablet():Boolean 
		{
			return _target.height > 960 || _target.width > 960;
		}
		
		public function get orientation():String
		{
			return _target.width > _target.height ? LANDSCAPE : PORTRAIT;
		}
		
		public function updateState():void 
		{
			var newState:String;
			if (platform != null) 
			{
				newState = platform + (isTablet ? "Tablet" : "Phone") + orientation;
				if (_target.hasState(newState))
				{
					_target.currentState = newState;
					trace(_target.currentState);
					return;
				}
			}
			newState = (isTablet ? "Tablet" : "Phone") + orientation;
			if (_target.hasState(newState))
			{
				_target.currentState = newState;
				trace(_target.currentState);
				return;
			}
			newState = orientation;
			if (_target.hasState(newState))
			{
				_target.currentState = newState;
				trace(_target.currentState);
				return;
			}
			trace("can't set new state");
		}
		
	}
}