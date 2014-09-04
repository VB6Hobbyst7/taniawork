package views.itemRenderer
{
	import spark.components.Label;
	import renderers.BaseRenderer;
	public class normItemRenderer extends BaseRenderer
	{
		public var la:Label;
		public function normItemRenderer()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			la = new Label();
			la.height = 150;
			addChild(la);
			
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			if (data != null){
				la.text = data+"test";
			}
			super.updateDisplayList(w,h);
		}
	}
}