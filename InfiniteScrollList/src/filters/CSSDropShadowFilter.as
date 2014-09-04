package filters
{
	import flash.filters.DropShadowFilter;
	public class CSSDropShadowFilter
	{
		public var filter:DropShadowFilter;
		protected var properties:Array = [ "distance", "angle","color", "alpha", "blurX", "blurY", "strength", "quality", "inner", "knockout", "hideObject" ];
		
		public var distance:Number = 4;
		public var angle:Number = 45;
		public var color:uint = 0;
		public var alpha:Number = 1;
		public var blurX:Number = 4;
		public var blurY:Number = 4;
		public var strength:Number = 1;
		public var quality:int = 1;
		public var inner:Boolean = false;
		public var knockout:Boolean = false;
		public var hideObject:Boolean = false;
			
		private var _values:Array;
		public function set values( value:Array ):void
		{
			var equal:Boolean = false;
			if( _values && _values.length == value.length)
			{
				// compare all values
				equal = true;
				for (var i:int = 0; i < value.length; i++) 
				{
					if( _values[ i ] != value[ i ] )
					{
						equal = false;
						break;
					}
				}
			}
			if( !equal )
			{
				for (var n:int = 0; n < value.length; n++) 
				{
					this[ properties[ n ] ] = value[ n ];
				}
				updateFilter();
			}
		}
		public function get values():Array
		{
			return _values;
		}
		public function CSSDropShadowFilter( values:Array )
		{
			this.values = values;
		}
		
		protected function updateFilter():void
		{
			filter  =  new DropShadowFilter( distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject );
		}
	}
}