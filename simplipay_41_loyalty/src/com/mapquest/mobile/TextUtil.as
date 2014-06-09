package com.mapquest.mobile {
	
	
	
	
	
	public class TextUtil {
		
	
	
		public function removeSpaces(s:String):String {
			var a:Array = s.split(" ");
			
			return(a.join(""));
		}
	
		
		
		public function formatPhone(ph:String):String {
			if (ph.length == 10) {
				ph = ph.replace("-","");
				ph = ph.substr(0,3) + "." + ph.substr(3,3) + "." + ph.substr(6,4);
			}
			
			return ph + "    ";				
		}
		
		
		
	
	}  //end class

}  //end package