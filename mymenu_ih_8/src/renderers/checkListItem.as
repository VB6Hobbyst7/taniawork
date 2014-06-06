package renderers
{
	import events.ActionEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	import model.Report;
	
	import mx.graphics.SolidColorStroke;
	
	import spark.components.Label;
	import spark.components.LabelItemRenderer;
	import spark.formatters.CurrencyFormatter;
	import spark.formatters.DateTimeFormatter;
	
	public class checkListItem extends LabelItemRenderer
	{
		public var labelField:String;
		public var dateField:String;
		public var amountField:String;
		
		protected var dateLabel:Label;
		protected var totalLabel:Label;
		
		protected var dtf:DateTimeFormatter;
		protected var cf:CurrencyFormatter;
		
		public function checkListItem()
		{
			super();
			dtf = new DateTimeFormatter();
			//dtf.dateTimePattern = "EEEE, MMM dd yyyy";
			dtf.dateTimePattern = "dd/MM/yy HH:mm:ss ";
			cf = new CurrencyFormatter();
			cf.useCurrencySymbol = true;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			labelDisplay.text = "CheckList";//value[labelField];
		
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
			setElementPosition(labelDisplay, paddingLeft, paddingTop);
			
			var dateLabelWidth:Number = getElementPreferredWidth(dateLabel);
			var dateLabelHeight:Number = getElementPreferredHeight(dateLabel);
			setElementSize(dateLabel, dateLabelWidth, dateLabelHeight);
			setElementPosition(dateLabel, paddingLeft, paddingTop + labelHeight + 8);
			
			var totalLabelWidth:Number = getElementPreferredWidth(totalLabel);
			var totalLabelHeight:Number = getElementPreferredHeight(totalLabel);
			setElementSize(totalLabel, totalLabelWidth, totalLabelHeight);
			setElementPosition(totalLabel, unscaledWidth - paddingRight - totalLabelWidth, paddingTop + labelHeight + 8);
		}
		
	}
}