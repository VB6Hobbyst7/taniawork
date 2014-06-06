package com.RTMPmessenger
{
	import flash.events.Event;
	public class ImWinManager
	{
		//############################
		//Static
		//############################
		//singleton stuff
		private static var _instance:ImWinManager;	
		
      private static var allowInstantiation:Boolean;
	 public static function getInstance():ImWinManager {
         if (_instance == null) {
            allowInstantiation = true;
            _instance = new ImWinManager();
            allowInstantiation = false;
          }
         return _instance;
       }
		//############################
		//Private VARS
		//############################
		public var aWins:Object;		
		
		//singleton stuff
		public function ImWinManager() {
         if (!allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use ImWinManager.getInstance() instead of new.");
          }     		
			aWins={};
		}
		
		
		private function closeWinCall(e:Event):void{	
			removeWin(e.target._id,e.target._buddy,true);
		}
		
		
		public function getWin(queue:String,owner:Radar):WinIM{		
			//does the current window exist?
			if (this.aWins[queue]==null){
				//doesn't exist so create	//create window
				var win:WinIM = new WinIM();
				//win.visible = vis;
				win.init(queue,owner);
				aWins[queue]=win;
				win.open();
				win.addEventListener(Event.CLOSING,closeWinCall);//
				return win;
			}
			else {
				//this.aWins[queue].visible = vis;
				return this.aWins[queue];
				
			}
			//exists so return reference
			return null;
			/*if (this.aWins[queue]==null){
				//doesn't exist so create	//create window
				var win:WinIM = new WinIM();
				win.init(queue,owner);
				aWins[queue]=win;
			    win.open();
     			win.addEventListener(Event.CLOSING,closeWinCall);//
			    return win;
			}
			//exists so return reference
			return null;*/
		}
		public function setVisibility(queue:String,owner:Radar,vis:Boolean = true):void{		
			//does the current window exist?
			try{
				this.aWins[queue].visible = vis;	
			}
			catch(e:Error){
				
			}
		}
		public function getVisibility(queue:String,owner:Radar):Boolean{		
			//does the current window exist?
			try{
				return this.aWins[queue].visible;	
			}
			catch(e:Error){
				
			}
			return false;
		}
		public function queName(user1:String,user2:String):String{
			var aName:Array=[user1,user2];
			aName.sort();
			return aName.join("");
		}
		
		public function removeWin(title:String,buddy:String,closed:Boolean):void{
			if (this.aWins[title]==null){
				trace("(E) could not find window ("+title+") delete failed");
				return;
			}
			FmsConManager.getInstance().delete_NS(buddy+"_in");
			FmsConManager.getInstance().delete_NS(this.aWins[title]._myName+"_out");
			FmsConManager.getInstance().delete_NC(title);	
			if (!closed)this.aWins[title].close();
			this.aWins[title]=null;	
		}
		
		public function _returnWin(title:String):WinIM{
			return this.aWins[title];		
		}
		
		public function clearWins():void {
			for(var i:String in this.aWins) removeWin(i,this.aWins[i]._buddy,false);		
		}
		
		
		
		
		
	//END CLASS	
	}
}