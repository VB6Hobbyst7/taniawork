package fr.kapit.lab.demo.ui.renderers
{
	import flash.display.Graphics;
	
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	import fr.kapit.visualizer.Visualizer;
	
	public class CircleEditorRenderer extends DefaultEditorRenderer
	{
		public function CircleEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			graphics.lineStyle(getThickness(),getColor(),_borderAlpha,false,'none');
			graphics.drawEllipse(0,0,w,h);
		}
		private function getColor():uint
		{
			var lC:uint;
			if(_isHighlighted && _highlightMode == Visualizer.RECTANGULAR_BASED_HIGHLIGHT)
				lC = _highlightLineColor;
			else if (_isSelected && _selectionMode == Visualizer.RECTANGULAR_BASED_HIGHLIGHT)
				lC = _selectionLineColor;
			else
				lC = _borderColor;
			
			return lC;
		}
		private function getThickness():uint
		{
			var lC:uint;
			var lT:uint;
			if(_isHighlighted && _highlightMode == Visualizer.RECTANGULAR_BASED_HIGHLIGHT)
				lT = _borderThickness+1;
			else if (_isSelected && _selectionMode == Visualizer.RECTANGULAR_BASED_HIGHLIGHT)
				lT = _borderThickness+1;
			else
				lT = _borderThickness;
			
			return lT;
		}
	}
}