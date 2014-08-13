package vo{
	
	import mx.collections.ArrayCollection;
	import mx.controls.ToolTip;
	
	public class chapter{
		
		public var name:String;
		public var children:ArrayCollection;
		public var sTip:String;
		public var type:uint;
		public var count:Number;
		public var occurindex:Number;
		
		public function chapter(_name:String,
								_children:ArrayCollection = null,
								_sTip:String = "",
								_type:uint = 0,
								_count:Number = -1,
								_occurindex:Number = 0){
			this.type = _type;
			this.count = _count;
			this.name = _name;
			if (_occurindex != -1){
				this.occurindex = _occurindex;
			}
			
			sTip = _sTip;
			if(_children != null)
				this.children = _children;
		}//end Person constructor
		
	}//end Person class
	
}//end package declaration