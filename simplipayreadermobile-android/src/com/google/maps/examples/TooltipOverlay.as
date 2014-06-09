/*
* Licensed under the Apache License, Version 2.0 (the "License"):
*    http://www.apache.org/licenses/LICENSE-2.0
*/
package com.google.maps.examples {

import com.google.maps.LatLng;
import com.google.maps.MapEvent;
import com.google.maps.PaneId;
import com.google.maps.interfaces.IMap;
import com.google.maps.interfaces.IPane;
import com.google.maps.overlays.OverlayBase;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class TooltipOverlay extends OverlayBase {
  private var latLng:LatLng;
  private var label:String;
  private var textField:TextField;
  private var dropShadow:Sprite;

  public function TooltipOverlay(latLng:LatLng, label:String) {
    super();
    this.latLng = latLng;
    this.label = label;
    
    this.addEventListener(MapEvent.OVERLAY_ADDED, onOverlayAdded);
    this.addEventListener(MapEvent.OVERLAY_REMOVED, onOverlayRemoved);
  }

  public override function getDefaultPane(map:IMap):IPane {
  	return map.getPaneManager().getPaneById(PaneId.PANE_FLOAT);
  }
  
  private function onOverlayAdded(event:MapEvent):void {
    this.textField = new TextField();
    this.textField.text = this.label;
    this.textField.selectable = false;
    this.textField.background = true;
    this.textField.multiline = false;
    this.textField.autoSize = TextFieldAutoSize.CENTER;
    this.textField.backgroundColor = 0xFFCC00;
    this.textField.filters = [new DropShadowFilter()];    
    this.addChild(textField);
  }

  private function onOverlayRemoved(event:MapEvent):void {
    this.removeChild(textField);
    this.textField = null;
  }

  public override function positionOverlay(zoomChanged:Boolean):void {
    var point:Point = this.pane.fromLatLngToPaneCoords(this.latLng);
    this.textField.x = point.x - this.textField.width / 2;
    this.textField.y = point.y - this.textField.height / 2;
  }
}
}