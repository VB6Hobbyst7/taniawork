package skins {
	import spark.components.ButtonBar;
	import spark.components.Group;
	import spark.skins.mobile.TabbedViewNavigatorSkin;
	import skins.ButtonBarSkin;
	
	public class MySkin extends TabbedViewNavigatorSkin {
		
		public function MySkin() {
			super();
		}
		
		
		protected override function createChildren():void{
			contentGroup = new Group();
			contentGroup.id = "contentGroup";
			
			tabBar = new ButtonBar();
			tabBar.id = "tabBar";
			tabBar.requireSelection = true;
			tabBar.setStyle("skinClass", ButtonBarSkin);
			tabBar.height = 112;
			addChild(tabBar);
			addChild(contentGroup);
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var tabBarHeight:Number = 0; 
			
			if (tabBar.includeInLayout)
			{
				tabBarHeight = Math.min(tabBar.getPreferredBoundsHeight(), unscaledHeight);
				tabBar.setLayoutBoundsSize(unscaledWidth, tabBarHeight);
				
				tabBarHeight = tabBar.getLayoutBoundsHeight(); 
			}
			
			if (currentState == "portraitAndOverlay" || currentState == "landscapeAndOverlay")
			{
				tabBar.alpha = .6;
				
				if (contentGroup.includeInLayout)
				{
					contentGroup.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
					contentGroup.setLayoutBoundsPosition(0, 0);
				}
			}
			else
			{
				tabBar.alpha = 1.0;
				
				if (contentGroup.includeInLayout)
				{
					var contentGroupHeight:Number = Math.max(unscaledHeight - tabBarHeight, 0);
					
					contentGroup.setLayoutBoundsSize(unscaledWidth, contentGroupHeight);
					contentGroup.setLayoutBoundsPosition(0, 0);
				}
				if (tabBar.includeInLayout){
					tabBar.setLayoutBoundsPosition(0, contentGroupHeight);
				}
			}
		}
		
	}
}