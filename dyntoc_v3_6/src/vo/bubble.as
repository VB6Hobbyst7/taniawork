package vo{
	
	import mx.collections.ArrayCollection;
	import mx.controls.ToolTip;
	
	import spark.components.BorderContainer;
	
	public class bubble{
		
		public var name:String;
		public var children:ArrayCollection;
		public var sTip:String;
		public var type:uint;
		public var count:Number;
		public var boc:Array;
		public var isTool:Boolean;
		public var xmax:Number;
		public var xmin:Number;
		public var selected:Boolean;
		public var chapterIndex:Number;
		public var occurIndex:Number;
		public function bubble(_name:String,
							   _children:ArrayCollection = null,
							   _sTip:String = "",
							   _type:uint = 0,
							   _count:Number = -1,
							   _boc:Array = null,
							   _isTool:Boolean = false,
							   _xmax:Number = -1,
							   _xmin:Number = -1,
								_selected:Boolean = false,
								_chapterIndex:Number = -1,
								_occurIndex:Number = -1){
			this.type = _type;
			this.selected = _selected;
			this.count = _count;
			this.name = _name;
			this.chapterIndex = _chapterIndex;
			this.occurIndex = _occurIndex;
			sTip = _sTip;
			
			this.isTool = _isTool;
			this.xmax = _xmax;
			this.xmin = _xmin;
				this.boc = _boc
			
			if(_children != null)
				this.children = _children;
		}//end Person constructor
		
	}//end Person class
	
}//end package declaration