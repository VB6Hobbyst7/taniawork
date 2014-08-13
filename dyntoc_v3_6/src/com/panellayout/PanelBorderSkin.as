package com.panellayout
{
	import flash.geom.Rectangle;
	
	import mx.core.EdgeMetrics;
	import mx.core.IRectangularBorder;
	import mx.skins.ProgrammaticSkin;

	public class PanelBorderSkin extends ProgrammaticSkin
	{
		
		override protected function updateDisplayList( 
			w : Number, 
			h : Number 
			) : void
		{
			super.updateDisplayList( w, h );
			
			graphics.clear();
			
			drawRoundRect( 0, 0, w, h, 0, 0x006E00, 0.0 );
			
		}
		
		
	}
}