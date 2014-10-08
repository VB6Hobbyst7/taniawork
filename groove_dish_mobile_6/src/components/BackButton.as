package components
{
	import flash.events.MouseEvent;
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	public class BackButton extends Group
	{
		include "../func/global.as";
		public function BackButton()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, gDown);
			this.addEventListener(MouseEvent.MOUSE_UP, gOut);
			this.addEventListener(MouseEvent.MOUSE_OVER, gOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, gOut);
			var bmg:BitmapImage = new BitmapImage();
			bmg.source = "../assets/"+getDPIHeight().toString()+"/back.png";
			bmg.contentLoader = s_imageCache;
			bmg.verticalCenter = 0;
			bmg.horizontalCenter = 0;
			this.addElement(bmg);
		}
	}
}