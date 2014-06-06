package valueObjects
{
	import flash.data.SQLConnection;
	
	import mx.collections.ArrayCollection;
	
	public class Model
	{
		public var connection:SQLConnection;
		[Bindable]
		public var items:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var homedata:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var storetoprateddata:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var topreviews:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var recentreviews:ArrayCollection = new ArrayCollection();
		
		public var selectedItem:Number = 0;
		
		public function Model()
		{
		}
	}
}