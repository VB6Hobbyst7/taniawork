package events
{
	import model.Report;
	
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const ADD_REPORT:String = "report_add";
		public static const ADD_EXPENSE:String = "report_add_expense";
		public static const EDIT_EXPENSE:String = "report_edit_expense";
		public static const EDIT_REPORT:String = "report_edit";
		public static const REPORT_SAVED:String = "report_saved";
		public static const EXPENSE_SAVED:String = "expense_saved";
		public static const VIEW_EXPENSES:String = "view_expenses";
		
		public var data:Object;
		
		public function MenuEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}