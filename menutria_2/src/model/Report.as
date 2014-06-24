package model
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Report
	{
		public var id:int;
		public var date:Date = new Date();
		public var title:String;
		public var description:String;
		public var total:Number;
		[Bindable]
		public var doupdate:Boolean = false;
	}
}