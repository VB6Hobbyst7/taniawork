// ActionScript file
import flash.events.*;
import flash.events.MouseEvent;
import flash.net.*;
import flash.utils.Timer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import mx.events.EffectEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.events.ToolTipEvent;
import spark.effects.Move;
import spark.effects.Scale;
import spark.events.IndexChangeEvent;
import spark.filters.GlowFilter;
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.*;
import mx.controls.ColorPicker;
import mx.effects.Glow;
import mx.events.*;
import mx.events.EffectEvent;
import mx.managers.*;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.states.*;
import spark.components.BorderContainer;
import spark.components.Label;
import spark.effects.Scale;
import spark.filters.GlowFilter;
public function goSearch():void {
	if (searchText.text.length > 0){
		clearButtono.visible = true;
	}
	else {
		clearButtono.visible = false;
	}
	searchGet(searchText.text);
}
public function clearSearch():void {
	searchText.text = "";
	goSearch();
}
public function searchFilter(obj:Object):Boolean {

	if (obj.author.toLowerCase().match(searchText.text.toLowerCase()) != null){
		return true;
	}
	if (obj.title.toLowerCase().match(searchText.text.toLowerCase()) != null){
		return true;
	}
	return false;
}
public function searchGet(s:String):void {
	searchTexto = s;
	collections.filterFunction = searchFilter;
	collections.refresh();
	
}
private function fileFunctions():void {
//	panUpload.visible = true;
}
public function megaFilter(item:Object):Boolean {
	var u:uint = 0;
	var s:String = "";
	if ((dateFiltVal1 != 0)&&(item.date > dateFiltVal1)&&
		(dateFiltVal2 != 0)&&(item.date <= dateFiltVal2)){
		u++;
	}
	if ((authorFiltVal1 != "")&&(authorFiltVal2 != "")){
		s = item.author.charAt(0);
		 s = s.toLowerCase();
		if((s > authorFiltVal1.toLowerCase())&&
			(s <= authorFiltVal2.toLowerCase())){
			u++;
		}
	}
	if ((titleFiltVal1 != "")&&(titleFiltVal2 != "")){
		s = item.title.charAt(0);
		s = s.toLowerCase();
		if((s > titleFiltVal1.toLowerCase())&&
			(s <= titleFiltVal2.toLowerCase())){
			u++;
		}
	}
	if (u == 2){
		return true;
	}
	return false;
}
public function dateFilter(item:Object):Boolean {
	if ((dateFiltVal1 != 0)&&(item.date > dateFiltVal1)&&
		(dateFiltVal2 != 0)&&(item.date < dateFiltVal2)){
		return true;
	}
	return false;
}
public function authorFilter(item:Object):Boolean {
	if ((authorFiltVal1 != "")&&(authorFiltVal2 != "")){
		if((item.author.charAt(0).toLowerCase() > authorFiltVal1)&&
			(item.author.charAt(0).toLowerCase() < authorFiltVal2)){
			return true;
		}
	}
	return false;
}
public function titleFilter(item:Object):Boolean {
	if ((titleFiltVal1 != "")&&(titleFiltVal2 != "")){
		if((item.author.charAt(0).toLowerCase() > titleFiltVal1)&&
			(item.author.charAt(0).toLowerCase() < titleFiltVal2)){
			return true;
		}
	}
	return false;
}