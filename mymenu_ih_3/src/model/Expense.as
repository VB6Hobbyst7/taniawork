package model
{
	[Bindable]
	public class Expense
	{
		public var id:int;
		public var reportId:int;
		public var date:Date = new Date();			
		public var category:String;
		public var location:String;
		public var longitude:Number;
		public var latitude:Number;
		public var description:String;
		public var receiptURL:String;
		public var amount:Number = 0;
		
		public function Expense(reportId:int = NaN)
		{
			this.reportId = reportId;
		}
		
	}
}