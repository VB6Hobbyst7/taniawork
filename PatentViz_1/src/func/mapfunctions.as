// ActionScript file
import com.esri.ags.FeatureSet;
import com.esri.ags.events.QueryEvent;
import com.esri.ags.geometry.Geometry;

import mx.collections.ArrayList;
import mx.collections.IList;
import mx.events.FlexEvent;
[Bindable]
private var listProvider:IList;
[Bindable]
public var data:Object = new Object();
public var featureSet:FeatureSet = new FeatureSet;
import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.ExtentEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.tasks.supportClasses.Query;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.AsyncResponder;
private var hashmapOfExistingGraphics:Object = new Object();
private function onExtentChange(event:ExtentEvent):void
{
	query.geometry = myMap.extent;
	query.outSpatialReference = myMap.spatialReference;
	queryTask.execute(query, new AsyncResponder(onResult, onFault));
}
private function onResult(featureSet:FeatureSet, token:Object = null):void
{
	for each (var myGraphic:Graphic in featureSet.features)
	{
		// only add features that are not already in the graphics layer
		var graphicID:String = myGraphic.attributes.CITY_NAME + "." + myGraphic.attributes.FID;
		if (!hashmapOfExistingGraphics[graphicID]) // New feature (not already added to graphics layer)
		{
			hashmapOfExistingGraphics[graphicID] = 1;
			myGraphic.id = graphicID;
			myGraphic.toolTip = myGraphic.attributes.CITY_NAME;
			myGraphicsLayer.add(myGraphic);
		}
	}
	// for fun, find out number of points within current extent
	var featuresInExtent:int = 0
	var extent:Extent = myMap.extent;
	var graphics:ArrayCollection = ArrayCollection(myGraphicsLayer.graphicProvider);
	for each (var graphic:Graphic in graphics)
	{
		if (extent.contains(MapPoint(graphic.geometry)))
		{
			featuresInExtent++;
		}
	}
}

private function onFault(info:Object, token:Object = null):void
{
	Alert.show(info.toString());
}
public function afterComplete(ev:QueryEvent):void {
	var stop:String= "";
	var newfeatures:FeatureSet = new FeatureSet();
	newfeatures.features = new Array();
	var newGR:Graphic = new Graphic();
	var attributesobject:Object = new Object();
	attributesobject = {CITY_NAME:"Paradise",FID:1456};
	var newGeometry:Geometry = new Geometry();
	/*	newGeometry.extent = null;
	newGeometry.type = "esriGeometryPoint";
	newGeometry.x = -121.60538532011876;
	newGeometry.y = 39.75629262569071;
	var newGraphicsLayer:GraphicsLayer = new GraphicsLayer();
	newGR.attributes = attributesobject;
	newGR.geometry = newGeometry;*/
	
	//newfeatures.features.push(newGR);
	//featureSet = ev.featureSet;
	/*if (ev.featureSet)
	{
	listProvider = new ArrayList(ev.featureSet.attributes);
	}*/
}

