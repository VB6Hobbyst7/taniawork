////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package skins
{
import assets.interfaceimages.multi.Blank;

import assets.dpi160.TabbedViewNavigatorTabBarTab_selected;

import assets.dpi240.TabbedViewNavigatorTabBarTab_selected;

import assets.dpi320.TabbedViewNavigatorTabBarTab_selected;

import flash.display.DisplayObject;

import mx.core.DPIClassification;
import mx.core.mx_internal;

import spark.skins.mobile.supportClasses.ButtonBarButtonSkinBase;

use namespace mx_internal;

/**
 *  ButtonBarButton skin base class for TabbedViewNavigator ButtonBarButtons.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5 
 *  @productversion Flex 4.5
 */
public class TabbedViewNavigatorTabBarTabSkin extends ButtonBarButtonSkinBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    private var colorized:Boolean;
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function TabbedViewNavigatorTabBarTabSkin()
    {
        super();
        
        useCenterAlignment = false;
        
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                selectedBorderSkin = assets.dpi320.TabbedViewNavigatorTabBarTab_selected;
                measuredDefaultHeight = 98;
                layoutPaddingTop = 6;
                layoutPaddingBottom = 10;
                maxWidth = 152;
                
                break;
            }
            case DPIClassification.DPI_240:
            {
                selectedBorderSkin = assets.dpi240.TabbedViewNavigatorTabBarTab_selected;
                measuredDefaultHeight = 74;
                layoutPaddingTop = 4;
                layoutPaddingBottom = 8;
                maxWidth = 114;
                
                break;
            }
            default:
            {
                // default DPI_160
                selectedBorderSkin = assets.dpi160.TabbedViewNavigatorTabBarTab_selected;
                measuredDefaultHeight = 49;
                layoutPaddingTop = 3;
                layoutPaddingBottom = 4;
                maxWidth = 76;
                
                break;
            }
        }
        
        // Can't have a borderless button
        // http://bugs.adobe.com/jira/browse/SDK-29434
        upBorderSkin = assets.interfaceimages.multi.Blank;
        downBorderSkin = assets.interfaceimages.multi.Blank;
        
        layoutBorderSize = 1;
        layoutPaddingLeft = 0;
        layoutPaddingRight = 0;
        layoutGap = 1;
    }
    
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);
        
        // just for the tutorial...
        // force bottom edge alignment of text, even when there's no icon
        var labelHeight:Number = labelDisplay.getLayoutBoundsHeight();
        var labelY:Number = unscaledHeight - layoutPaddingBottom - labelHeight;
        
        setElementPosition(labelDisplay, labelDisplay.getLayoutBoundsX(), labelY);
        setElementPosition(labelDisplayShadow, labelDisplay.getLayoutBoundsX(), labelY + 1);
    }
    
    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        var isSelected:Boolean = currentState.indexOf("Selected") >= 0;
        var iconDisplay:DisplayObject = getIconDisplay();
        
        if (iconDisplay)
        {
            if (isSelected)
            {
                //applyColorTransform(getIconDisplay(), 0xFFFFFF, getStyle("chromeColor"));
                colorized = true;
            }
            else if (colorized)
            {
              //  applyColorTransform(getIconDisplay(), getStyle("chromeColor"), 0xFFFFFF);
                colorized = false;
            }
        }
        
        // omit super.drawBackground(), draw hit zone
       // graphics.beginFill(0, 1);
		graphics.lineStyle(1,0xce601a);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
		graphics.lineStyle(1,0xe5a82f);
		graphics.drawRect(-1, 0, unscaledWidth, unscaledHeight);
		graphics.endFill();
    }
}
}