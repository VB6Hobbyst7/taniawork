////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2011 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package skins
{
	import assets.ListContentBackground320;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.Event;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.utils.ColorUtil;
	
	import spark.components.Group;
	import spark.components.SkinnablePopUpContainer;
	import spark.core.SpriteVisualElement;
	import spark.effects.Fade;
	import spark.primitives.RectangularDropShadow;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	use namespace mx_internal;
	
	/**
	 * Used as the skin for the category list popup.
	 * */
	public class CategoryPopUpSkin extends MobileSkin
	{
		mx_internal static const BACKGROUND_GRADIENT_BRIGHTNESS_TOP:int = 15;
		
		mx_internal static const BACKGROUND_GRADIENT_BRIGHTNESS_BOTTOM:int = -60;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 3
		 *  @productversion Flex 4.5.2
		 */
		public function CategoryPopUpSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					backgroundCornerRadius = 16;
					contentBackgroundClass = assets.ListContentBackground320;
					backgroundGradientHeight = 220;
					frameSize = 20;
					arrowWidth = 88;
					arrowHeight = 52;
					contentCornerRadius = 10;
					dropShadowBlur = 80;
					dropShadowDistance = 8;
					highlightWeight = 2;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					backgroundCornerRadius = 12;
					contentBackgroundClass = assets.ListContentBackground240;
					backgroundGradientHeight = 165;
					frameSize = 15;
					arrowWidth = 66;
					arrowHeight = 39;
					contentCornerRadius = 7;
					dropShadowBlur = 60;
					dropShadowDistance = 6;
					highlightWeight = 1;
					
					break;
				}
				default:
				{
					// default DPI_160
					backgroundCornerRadius = 8;
					contentBackgroundClass = assets.ListContentBackground160;
					backgroundGradientHeight = 110;
					frameSize = 10;
					arrowWidth = 44;
					arrowHeight = 26;
					contentCornerRadius = 5;
					dropShadowBlur = 40;
					dropShadowDistance = 4;
					highlightWeight = 1;
					
					break;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/** 
		 *  @copy spark.skins.spark.ApplicationSkin#hostComponent
		 */
		public var hostComponent:SkinnablePopUpContainer;
		
		
		mx_internal var contentCornerRadius:uint;
		
		mx_internal var contentBackgroundClass:Class;
		
		mx_internal var backgroundCornerRadius:Number;
		
		mx_internal var backgroundGradientHeight:Number;
		
		mx_internal var contentBackgroundGraphic:SpriteVisualElement;
		
		mx_internal var frameSize:Number;
		
		mx_internal var arrowWidth:Number;
		
		mx_internal var arrowHeight:Number;
		
		mx_internal var backgroundFill:SpriteVisualElement;
		
		mx_internal var dropShadow:RectangularDropShadow;
		
		mx_internal var dropShadowBlur:Number;
		
		mx_internal var dropShadowDistance:Number;
		
		mx_internal var fade:Fade;
		
		mx_internal var isOpen:Boolean;
		
		mx_internal var highlightWeight:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @copy spark.components.SkinnableContainer#contentGroup
		 */
		public var contentGroup:Group;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			dropShadow = new RectangularDropShadow();
			dropShadow.angle = 90;
			dropShadow.distance = dropShadowDistance;
			dropShadow.blurX = dropShadow.blurY = dropShadowBlur;
			dropShadow.tlRadius = dropShadow.trRadius = dropShadow.blRadius = 
				dropShadow.brRadius = backgroundCornerRadius;
			addChild(dropShadow);
			
			// background fill placed above the drop shadow
			backgroundFill = new SpriteVisualElement();
			addChild(backgroundFill);
			
			contentBackgroundGraphic = new contentBackgroundClass() as SpriteVisualElement;
			addChild(contentBackgroundGraphic);
			
			contentGroup = new Group();
			contentGroup.id = "contentGroup";
			addChild(contentGroup);
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			var backgroundPadding:Number = (Math.max(backgroundCornerRadius, frameSize) * 2);
			
			var backgroundWidth:Number = contentGroup.getPreferredBoundsWidth()
				+ backgroundPadding;
			var backgroundHeight:Number = contentGroup.getPreferredBoundsHeight()
				+ backgroundPadding;
			
			measuredMinWidth = contentGroup.measuredMinWidth;
			measuredMinHeight = contentGroup.measuredMinHeight;
			
			measuredWidth = backgroundWidth;
			measuredHeight = backgroundHeight;
		}
		
		/**
		 * @private
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			
			var isNormal:Boolean = (currentState == "normal");
			var isDisabled:Boolean = (currentState == "disabled")
			
			// play a fade out 
			if (!(isNormal || isDisabled) && isOpen)
			{
				if (!fade)
				{
					fade = new Fade();
					fade.target = this;
					fade.duration = 250;
					fade.alphaTo = 0;
				}
				
				// play a short fade effect
				fade.addEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
				fade.play();
				
				isOpen = false;
			}
			else
			{
				isOpen = isNormal || isDisabled;
				
				if (isNormal)
					alpha = 1;
				else if (isDisabled)
					alpha = 0.5;
				else
					alpha = 0;
				
				stateChangeComplete();
			}
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.drawBackground(unscaledWidth, unscaledHeight);
			
			var frameEllipseSize:Number = backgroundCornerRadius * 2;
			
			var frameX:Number = Math.floor(contentBackgroundGraphic.getLayoutBoundsX() - frameSize);
			var frameY:Number = Math.floor(contentBackgroundGraphic.getLayoutBoundsY() - frameSize);
			var frameWidth:Number = contentBackgroundGraphic.getLayoutBoundsWidth() + (frameSize * 2);
			var frameHeight:Number = contentBackgroundGraphic.getLayoutBoundsHeight() + (frameSize * 2) ;
			
			var backgroundColor:Number = getStyle("backgroundColor");
			var backgroundAlpha:Number = getStyle("backgroundAlpha");
			
			// top color is brighter 
			var backgroundColorTop:Number = ColorUtil.adjustBrightness2(backgroundColor, 
				BACKGROUND_GRADIENT_BRIGHTNESS_TOP);
			var backgroundColorBottom:Number = ColorUtil.adjustBrightness2(backgroundColor, 
				BACKGROUND_GRADIENT_BRIGHTNESS_BOTTOM);
			
			// max gradient height = backgroundGradientHeight
			colorMatrix.createGradientBox(unscaledWidth, backgroundGradientHeight,
				Math.PI / 2, 0, 0);
			
			var bgFill:Graphics = backgroundFill.graphics;
			bgFill.clear();
			
			bgFill.beginGradientFill(GradientType.LINEAR,
				[backgroundColorTop, backgroundColorBottom],
				[backgroundAlpha, backgroundAlpha],
				[0, 255],
				colorMatrix);
			bgFill.drawRoundRect(frameX, frameY, frameWidth,
				frameHeight, frameEllipseSize, frameEllipseSize);
			bgFill.endFill();
			
			// draw the contentBackgroundColor
			// the shading and highlight are drawn in FXG
			var contentEllipseSize:Number = contentCornerRadius * 2;
			var contentBackgroundAlpha:Number = getStyle("contentBackgroundAlpha");
			var contentWidth:Number = contentBackgroundGraphic.getLayoutBoundsWidth();
			var contentHeight:Number = contentBackgroundGraphic.getLayoutBoundsHeight();
			
			bgFill.beginFill(getStyle("contentBackgroundColor"),
				contentBackgroundAlpha);
			bgFill.drawRoundRect(contentBackgroundGraphic.getLayoutBoundsX(),
				contentBackgroundGraphic.getLayoutBoundsY(),
				contentWidth, contentHeight, contentEllipseSize, contentEllipseSize);
			bgFill.endFill();
			
			
			contentBackgroundGraphic.alpha = contentBackgroundAlpha;
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			setElementSize(backgroundFill, unscaledWidth, unscaledHeight);
			setElementPosition(backgroundFill, 0, 0);
			
			// 1x padding of backgroundColor, 1x padding of contentBackgroundColor
			var frameX:Number = 0;
			var frameY:Number = 0;
			var frameWidth:Number = unscaledWidth;
			var frameHeight:Number = unscaledHeight;
			
			setElementSize(dropShadow, frameWidth, frameHeight);
			setElementPosition(dropShadow, frameX, frameY);
			
			var contentBackgroundAdjustment:Number = (frameSize * 2);
			
			var contentBackgroundX:Number = frameX + frameSize;
			var contentBackgroundY:Number = frameY + frameSize;
			var contentBackgroundWidth:Number = frameWidth - contentBackgroundAdjustment;
			var contentBackgroundHeight:Number = frameHeight - contentBackgroundAdjustment;
			
			setElementSize(contentBackgroundGraphic, contentBackgroundWidth, contentBackgroundHeight);
			setElementPosition(contentBackgroundGraphic, contentBackgroundX, contentBackgroundY);
			
			setElementSize(contentGroup, contentBackgroundWidth, contentBackgroundHeight);
			setElementPosition(contentGroup, contentBackgroundX, contentBackgroundY);
		}
		
		
		
		private function stateChangeComplete(event:Event=null):void
		{
			if (fade && event)
				fade.removeEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
			
			// SkinnablePopUpContainer relies on state changes for open and close
			dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_COMPLETE));
		}
	}

}