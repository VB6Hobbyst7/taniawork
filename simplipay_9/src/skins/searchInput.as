package skins 
{
	import spark.components.Image;
	import spark.components.TextInput;
	import spark.skins.mobile.TextInputSkin;

	public class searchInput extends TextInputSkin
	{
		[Embed(source='../assets/search20.png')]
		private var searchIcon:Class;   
		private var searchImg:Image;        
		
		override protected function createChildren():void
		{
			super.createChildren();
			searchImg = new Image();
			searchImg.source = searchIcon;
			searchImg.width=20;
			searchImg.height=20;
			searchImg.x = 4;
			searchImg.y = 4;
			
			
			setStyle("paddingLeft",searchImg.width+2);
			addChild(searchImg);
			
		}
	
	}
}