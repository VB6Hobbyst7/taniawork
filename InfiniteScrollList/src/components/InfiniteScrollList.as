package components
{
	import model.InfiniteListModel;
	import model.LoadingVO;
	import mx.core.ClassFactory;
	import mx.events.PropertyChangeEvent;
	import views.itemRenderer.normItemRenderer;
	import spark.components.List;
	import flow.FlowLayout4;
	import  renderers.TweetGridRenderer;
	import views.itemRenderer.LoadingItemRenderer;
	public class InfiniteScrollList extends List
	{
		
		public function InfiniteScrollList()
		{
			super();
		}
	
		override protected function createChildren():void
		{
			super.createChildren();
			layout = new FlowLayout4();
			scroller.viewport.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler );
			itemRendererFunction = itemRendererFunctionImpl;
		
		}	
	
		protected function propertyChangeHandler( event : PropertyChangeEvent ) : void 
		{
			//trace( event.property, event.oldValue, event.newValue );
			
			if ( event.property == "verticalScrollPosition" ) 
			{
				if ( event.newValue == ( event.currentTarget.measuredHeight - event.currentTarget.height )) 
				{
					fetchNextPage();
				}
			}
		}
		
		protected function fetchNextPage() : void
		{
			if ( dataProvider is InfiniteListModel )
				InfiniteListModel( dataProvider ).getNextPage();
		}
		
		private function itemRendererFunctionImpl(item:Object):ClassFactory 
		{
			var cla:Class = TweetGridRenderer;
			if ( item is LoadingVO )
				cla = LoadingItemRenderer;
			return new ClassFactory(cla);
		}
		
	}
}