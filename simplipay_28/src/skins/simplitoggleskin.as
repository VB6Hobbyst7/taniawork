package skins
	// components\mobile\skins\MyToggleSwitchSkin.as
{
	import spark.skins.mobile.ToggleSwitchSkin;
	
	public class simplitoggleskin extends ToggleSwitchSkin
	{
		public function simplitoggleskin()
		{
			super();
			// Set properties to define the labels 
			// for the selected and unselected positions.
			selectedLabel="Available Deals";
			unselectedLabel="Purchased Deals"; 
		}
	}
}