import com.milkmangames.nativeextensions.events.CMDialogEvent;
public var _devKey:String = "848fb2389a815c1a2510fe347d605b8b831e2d49DVyHgWM3LYeOe1hkwvUUIn5aMnL2C85puPNxYeaeMIEoKCdN/M9wXWmJ/TJ5jjwrSqarnPDn99CcldJn+yVS4sMQ2k/CMWknkY97LSTSEaSXFwy04DKEpydA8ew1bERInFiNW05dl+mJmhIyJGb1iI+m7Aqc7Ov+x/Bo+/31R0Vstl+/vNwcgrgcMo5PzCl+mBe5dAGSLxycnDsJ2iw4JKGELkw8N0L4uWKyvY9bPODfpvW6CLDu5Pfda5uUSinxHecp1CTxEiKUSGdCbIK8IV4QJgHjbZfhX5pyH/4XFtwbr8U0P40+sAv+q3TekoqjSurYoNNOJB/JUWA7DgI/tQ==";
public function beginappnative():void {
	try{
		var ma:MyApplication = new MyApplication("848fb2389a815c1a2510fe347d605b8b831e2d49DVyHgWM3LYeOe1hkwvUUIn5aMnL2C85puPNxYeaeMIEoKCdN/M9wXWmJ/TJ5jjwrSqarnPDn99CcldJn+yVS4sMQ2k/CMWknkY97LSTSEaSXFwy04DKEpydA8ew1bERInFiNW05dl+mJmhIyJGb1iI+m7Aqc7Ov+x/Bo+/31R0Vstl+/vNwcgrgcMo5PzCl+mBe5dAGSLxycnDsJ2iw4JKGELkw8N0L4uWKyvY9bPODfpvW6CLDu5Pfda5uUSinxHecp1CTxEiKUSGdCbIK8IV4QJgHjbZfhX5pyH/4XFtwbr8U0P40+sAv+q3TekoqjSurYoNNOJB/JUWA7DgI/tQ==");
	}
	catch(e:Error){
		CoreMobile.mobile.showModalYesNoDialog(e.getStackTrace(),"", "Yes", "No").
			addDismissListener(function(e:CMDialogEvent):void 
			{
				if (e.selectedButtonLabel=="Yes")
				{
					
				}
				else {
					
				}
			});
	
	}
}