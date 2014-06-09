package components
{
	import spark.components.SpinnerList;
	
	public class BindableSpinnerList extends SpinnerList
	{
		protected var _valueField:String;

		public function BindableSpinnerList()
		{
			super();
		}
		
		public function set valueField(field:String):void
		{
			_valueField = field;
		}
		
		public function get valueField():String
		{
			return _valueField;
		}
		
		public function set selectedValue(value:*):void
		{
			trace(_valueField + " " + value)
			if (selectedValue == null)
			{
				selectedIndex = -1;
				return;
			}
			for (var i:int = 0; i < dataProvider.length; i++) 
			{
				if (_valueField)
				{
					if (dataProvider.getItemAt(i)[_valueField] == value)
					{
						selectedIndex = i;
						return;
					}
				}
				else
				{
					if (dataProvider.getItemAt(i) == value)
					{
						selectedIndex = i;
						return;
					}
				}
			}
			selectedIndex = -1;
		}

		public function get selectedValue():*
		{
			return valueField ? selectedItem[valueField] : selectedItem;
		}
		
	}
}