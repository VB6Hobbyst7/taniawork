package com.RTMPmessenger
{
	import flash.events.Event;

	public class CustomDispatcher extends Event
	{
		////////////////////////
		///Public vars
		////////////////////////
		public static const INIT_USER:String = "INIT_USER_EVENT";
		
		////////////////////////
		///Private vars
		////////////////////////
		private var args:Array;
		
		//
		public function CustomDispatcher(type:String, arguments:Array=null){
			super(type,false, false);
			args=arguments;		
		}
		
		
		public function get _args():Array{
			return this.args;
		}
	
		
		public override function clone():Event{
			return new CustomDispatcher(type, args);
		}
	}
}