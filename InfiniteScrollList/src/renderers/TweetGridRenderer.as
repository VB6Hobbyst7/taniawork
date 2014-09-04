package renderers
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	
	import utils.TextUtil;
	
	public class TweetGridRenderer extends BaseRenderer
	{
		protected var userField:TextField;
		protected var nameField:TextField;
		protected var contentField:TextField;
		protected var background:DisplayObject;
		protected var backgroundClass:Class;
		protected var separator:DisplayObject;
		protected var lineCanvas:Shape;
		protected var columnWidth:int
		
		protected var paddingLeft:int;
		protected var paddingRight:int;
		protected var paddingBottom:int;
		protected var paddingTop:int;
		protected var gap:int;
		
		//--------------------------------------------------------------------------
		//  Contructor
		//--------------------------------------------------------------------------
		
		public function TweetGridRenderer()
		{
			percentWidth = 100;
		}
		
		//--------------------------------------------------------------------------
		//  Override Protected Methods
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			readStyles();
			
			setBackground();
			
			var separatorAsset:Class = getStyle( "separator" );
			if( separatorAsset )
			{
				separator = new separatorAsset();
				addChild( separator );
			}
			
			userField  = TextUtil.createSimpleTextField( this );
			addChild( userField );
			
			nameField  = TextUtil.createSimpleTextField( this )
			addChild( nameField );
			
			contentField  = TextUtil.createSimpleTextField( this );
			addChild( contentField );
			
			lineCanvas = new Shape();
			addChild( lineCanvas );
			
			// if the data is not null, set the text
			if( data )
				setValues();
			
		}
		
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			var oldColumnWidth:int = columnWidth;
			columnWidth = Math.floor( unscaledWidth / 3 );
			
			if( columnWidth != oldColumnWidth )
				setValues();
			
			var textWidth:int = columnWidth - paddingLeft - paddingRight;
			background.width = unscaledWidth;
			background.height = unscaledHeight;
			
			var textY:int = ( unscaledHeight - userField.textHeight ) / 2;
			userField.x = paddingLeft;
			userField.y = textY;
			TextUtil.adjustTextSize( userField, textWidth );
			
			nameField.x = columnWidth + paddingLeft;
			nameField.y = textY;
			TextUtil.adjustTextSize( nameField, textWidth );
			
			contentField.x = columnWidth * 2 + paddingLeft;
			contentField.y = textY;
			TextUtil.adjustTextSize( contentField, textWidth );
			
			separator.width = unscaledWidth;
			separator.y = layoutHeight - separator.height;
			
			var g:Graphics = lineCanvas.graphics;
			g.clear();
			g.lineStyle( 1, getStyle( "verticalGridLineColor" ) );
			g.moveTo( columnWidth, 0 );
			g.lineTo( columnWidth, unscaledHeight );
			g.moveTo( columnWidth * 2, 0 );
			g.lineTo( columnWidth * 2, unscaledHeight );
		}
		
		override protected function measure():void
		{
			measuredHeight = getStyle( "minHeight" );
		}
		
		protected function setBackground():void
		{
			var backgroundAsset:Class = getStyle( "background" );
			if( backgroundAsset && backgroundClass != backgroundAsset )
			{
				if( background && contains( background ) )
					removeChild( background );
				
				backgroundClass = backgroundAsset;
				background = new backgroundAsset();
				addChildAt( background, 0 );
				if( layoutHeight && layoutWidth )
				{
					background.width = layoutWidth;
					background.height = layoutHeight;
				}
			}
		}
		
		override protected function setValues():void
		{
			var arr:Array = String( data.name ).split("(");
			var user:String = String( data.business_name )
			userField.text = arr[0];
			nameField.text =  String( arr[ 1 ] ).replace( ")", "" );
			contentField.htmlText = data.categoryname;
		}
		
		override protected function updateSkin():void
		{
			currentCSSState = ( selected ) ? "selected" : "up";
			setBackground();
		}
		
		protected function readStyles():void
		{
			paddingLeft = getStyle( "paddingLeft" );
			paddingRight = getStyle( "paddingRight" );
			gap = getStyle( "gap" );
		}
	}
}