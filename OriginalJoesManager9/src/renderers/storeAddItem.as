package renderers
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	import mx.events.StateChangeEvent;
	import mx.graphics.SolidColorStroke;
	
	import spark.components.Label;
	import spark.components.LabelItemRenderer;
	import spark.components.ToggleSwitch;
	import spark.formatters.CurrencyFormatter;
	import spark.formatters.DateTimeFormatter;
	
	public class storeAddItem extends LabelItemRenderer
	{
		public var labelField:String;
		public var dateField:String;
		public var amountField:String;
		public var selectedvalField:String;
		
		protected var dateLabel:Label;
		protected var totalLabel:Label;
		protected var selectedval:Boolean;
		protected var togswitch:ToggleSwitch = new ToggleSwitch();
		
		protected var dtf:DateTimeFormatter;
		protected var cf:CurrencyFormatter;
		
		public function storeAddItem()
		{
			super();
			dtf = new DateTimeFormatter();
			//dtf.dateTimePattern = "EEEE, MMM dd yyyy";
			dtf.dateTimePattern = "dd/MM/yy HH:mm:ss ";
			cf = new CurrencyFormatter();
			cf.useCurrencySymbol = true;
		
			this.height = 50;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			labelDisplay.text = value[labelField];
			selectedval = Boolean(value[selectedvalField]);
			dateLabel.text = dtf.format(value[dateField]);
			totalLabel.text = cf.format(value[amountField]);
		} 
		
		override protected function createChildren():void
		{
			super.createChildren();

			dateLabel = new Label();
			dateLabel.styleName = "expenseDate";
			addChild(dateLabel);

			totalLabel = new Label();
			totalLabel.styleName = "expenseAmount";
			addChild(totalLabel);
			
			togswitch = new ToggleSwitch();
			togswitch.addEventListener(Event.CHANGE, togchange);
			addChild(togswitch);
		}
		public function togchange(ev:Event):void {
			selectedval = togswitch.selected;
			//value[selectedval] = togswitch.selected;
		}
		override protected function measure():void
		{
			var horizontalPadding:Number = getStyle("paddingLeft") + getStyle("paddingRight");
			var verticalPadding:Number = getStyle("paddingTop") + getStyle("paddingBottom");
			measuredWidth = getElementPreferredWidth(labelDisplay) + horizontalPadding;
			measuredHeight = getElementPreferredHeight(labelDisplay) + getElementPreferredHeight(dateLabel) + verticalPadding + 8; 
			measuredMinWidth = 0;
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var paddingLeft:Number   = getStyle("paddingLeft"); 
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var verticalAlign:String = getStyle("verticalAlign");
			
			var labelWidth:Number = unscaledWidth - paddingLeft - paddingRight;
			var labelHeight:Number = getElementPreferredHeight(labelDisplay);
			setElementSize(labelDisplay, labelWidth, labelHeight);    
			setElementPosition(labelDisplay, paddingLeft, (this.height/2)-(labelHeight/2));
			
		
			
			var totalLabelWidth:Number = getElementPreferredWidth(togswitch);
			var totalLabelHeight:Number = getElementPreferredHeight(togswitch);
			setElementSize(togswitch, totalLabelWidth, totalLabelHeight);
			setElementPosition(togswitch, unscaledWidth - paddingRight - totalLabelWidth, (this.height/2)-(totalLabelHeight/2));
		}
		
	}
}