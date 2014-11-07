package components
{
	import flash.events.MouseEvent;
	import spark.components.Group;
	import spark.components.Image;
	public class CheckButton extends Group
	{
		include "../func/global.as";
		public function CheckButton()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, gDown);
			this.addEventListener(MouseEvent.MOUSE_UP, gOut);
			this.addEventListener(MouseEvent.MOUSE_OVER, gOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, gOut);
			var bmg:Image = new Image();
			bmg.source = "../assets/"+getDPIHeight().toString()+"/checkwhite.png";
			bmg.verticalCenter = 0;
			bmg.horizontalCenter = 0;
			this.addElement(bmg);
		}
	}
}