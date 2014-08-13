package vo
{
	public class MyVO
	{
		[Bindable]
		public var label:String;
		public function MyVO(str:String)
		{
			this.label=str;
		}
	}
}