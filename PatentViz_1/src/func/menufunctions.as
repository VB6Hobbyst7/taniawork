// Program Functions
import com.hillelcoren.components.FieldMapper;
import com.hillelcoren.events.FieldMapperEvent;
import com.hillelcoren.utils.DataGridUtils;
import com.hillelcoren.vos.Person;
import flash.filters.DropShadowFilter;
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.Alert;
import mx.core.IUIComponent;
import mx.graphics.ImageSnapshot;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;
private var fileToDownload:FileReference;
public var serveraddress:String = "";
public var serveruser:String = "";
public var serverpass:String = "";
public var databasename:String = "";
public var tablename:String = "";
public var searchcolumn:String = "";
public var datecolumn:String = "";
public var datasetname:String = "";
public var datetype:String = "";
[Bindable]
public var legendArray:ArrayCollection = new ArrayCollection();
[Bindable]
public var seriesArray:Array = new Array();
[Bindable]
public var datasetArray:ArrayCollection = new ArrayCollection();
[Bindable]
private var shadow:DropShadowFilter = new DropShadowFilter(2,45,0,0.5);
[Bindable]
public var displayType:String = "segment";
[Bindable]
public var s1:String = "";
[Bindable]
public var s2:String = "";
[Bindable]
public var s3:String = "";
[Bindable]
public var s4:String = "";
[Bindable]
public var s5:String = "";
[Bindable]
public var s6:String = "";
[Bindable]
public var s7:String = "";
[Bindable]
public var s8:String = "";
[Bindable]
public var s9:String = "";
[Bindable]
public var s10:String = "";
[Bindable]
public var freqArray:ArrayCollection = new ArrayCollection();
[Bindable]
private var displayArray:ArrayCollection = new ArrayCollection();
public var maxNumOfVars:uint = 13;
public var currentlySearching:Number = -1;
public var usedArray:Array = new Array();
[Bindable]
public var rotationArray:ArrayCollection = new ArrayCollection();
[Bindable]
public var colorArray:Array = new Array();
public var lastviewedstep:String = "";
public function init():void {
	//sets all the views visibility properly 
	step1.visible = true;
	step2.visible = false;
	step3_1.visible = false;
	step3_2.visible = false;
	step4_1.visible = false;
	step4_2.visible = false;
	step4_3.visible = false;
	step4_4.visible = false;
	graphCont.visible = false;
	mapCont.visible = false;
	networkCont.visible = false;
	sidebarbackbtn.visible = false;
	
	
	query.geometry = myMap.extent;
	query.outSpatialReference = myMap.spatialReference;
	queryTask.execute(query, new AsyncResponder(onResult, onFault));
	
	
	new PopupLogger();
	createLogTargets();
	
	
}

public function showstep(u:uint):void {
	
	
	if (step1.visible){
		lastviewedstep = 'step1';
	}
	else if (step2.visible){
		lastviewedstep = 'step2';
	}
	else if (step3_1.visible){
		lastviewedstep = 'step3_1';
	}
	else if (step3_2.visible){
		lastviewedstep = 'step3_2';
	}
	else if (step4_1.visible){
		lastviewedstep = 'step4_1';
	}
	else if (step4_2.visible){
		lastviewedstep = 'step4_2';
	}
	else if (step4_2.visible){
		lastviewedstep = 'step4_3';
	}
	else if (step4_2.visible){
		lastviewedstep = 'step4_4';
	}
	
	
	
	
	if (u == 1){
		//inital what to do step
		step1.visible = true;
		step2.visible = false;
		step3_1.visible = false;
		step3_2.visible = false;
		step4_1.visible = false;
		step4_2.visible = false;
		step4_3.visible = false;
		step4_4.visible = false;
		sidebarbackbtn.visible = false;
		graphCont.visible = false;
		mapCont.visible = false;
		networkCont.visible = false;
		
	}
	else if (u == 2){
		//chose pre loaded data set step
		step1.visible = false;
		step2.visible = true;
		step3_1.visible = false;
		step3_2.visible = false;
		step4_1.visible = false;
		step4_2.visible = false;
		step4_3.visible = false;
		step4_4.visible = false;
		sidebarbackbtn.visible = true;
		graphCont.visible = false;
		mapCont.visible = false;
		networkCont.visible = false;
	}
	else if (u == 31){
		//sql chose step
		step1.visible = false;
		step2.visible = false;
		step3_1.visible = true;
		step3_2.visible = false;
		step4_1.visible = false;
		step4_2.visible = false;
		step4_3.visible = false;
		step4_4.visible = false;
		sidebarbackbtn.visible = true;
		graphCont.visible = false;
		mapCont.visible = false;
		networkCont.visible = false;
	}
	else if (u == 32){
		//sql chose step
		step1.visible = false;
		step2.visible = false;
		step3_1.visible = false;
		step3_2.visible = true;
		step4_1.visible = false;
		step4_2.visible = false;
		step4_3.visible = false;
		step4_4.visible = false;
		sidebarbackbtn.visible = true;
		graphCont.visible = false;
		mapCont.visible = false;
		networkCont.visible = false;
	}
	else if (u == 41){
		//graphing tools step
		step1.visible = false;
		step2.visible = false;
		step3_1.visible = false;
		step3_2.visible = false;
		step4_1.visible = true;
		step4_2.visible = false;
		step4_3.visible = false;
		step4_4.visible = false;
		sidebarbackbtn.visible = true;
		graphCont.visible = false;
		mapCont.visible = false;
		networkCont.visible = false;
	}
	else if (u == 42){
		//graphing tools step
		step1.visible = false;
		step2.visible = false;
		step3_1.visible = false;
		step3_2.visible = false;
		step4_1.visible = false;
		step4_2.visible = true;
		step4_3.visible = false;
		step4_4.visible = false;
		sidebarbackbtn.visible = true;
		graphCont.visible = true;
		mapCont.visible = false;
		networkCont.visible = false;
	}
	else if (u == 43){
		//graphing tools step
		step1.visible = false;
		step2.visible = false;
		step3_1.visible = false;
		step3_2.visible = false;
		step4_1.visible = false;
		step4_2.visible = false;
		step4_3.visible = true;
		step4_4.visible = false;
		sidebarbackbtn.visible = true;
		graphCont.visible = false;
		mapCont.visible = true;
		networkCont.visible = false;
	}
	else if (u == 44){
		//graphing tools step
		step1.visible = false;
		step2.visible = false;
		step3_1.visible = false;
		step3_2.visible = false;
		step4_1.visible = false;
		step4_2.visible = false;
		step4_3.visible = false;
		step4_4.visible = true;
		sidebarbackbtn.visible = true;
		graphCont.visible = false;
		mapCont.visible = false;
		networkCont.visible = true;
	}
}
public function sidebarBackClick():void {
	if (step2.visible){
		showstep(1);
	}
	else if (step3_1.visible){
		showstep(1);
	}
	else if (step3_2.visible){
		showstep(1);
	}
	else if (step4_1.visible){
		if (lastviewedstep == 'step1'){
			showstep(1);
		}
		else if (lastviewedstep == 'step2'){
			showstep(2);
		}
		else if (lastviewedstep == 'step3_1'){
			showstep(31);
		}
		else if (lastviewedstep == 'step3_2'){
			showstep(32);
		}
		else if (lastviewedstep == 'step4_1'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_2'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_3'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_4'){
			showstep(41);
		}
	}
	else if (step4_2.visible){
		if (lastviewedstep == 'step1'){
			showstep(1);
		}
		else if (lastviewedstep == 'step2'){
			showstep(2);
		}
		else if (lastviewedstep == 'step3_1'){
			showstep(31);
		}
		else if (lastviewedstep == 'step3_2'){
			showstep(32);
		}
		else if (lastviewedstep == 'step4_1'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_2'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_3'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_4'){
			showstep(41);
		}
	}
	else if (step4_3.visible){
		if (lastviewedstep == 'step1'){
			showstep(1);
		}
		else if (lastviewedstep == 'step2'){
			showstep(2);
		}
		else if (lastviewedstep == 'step3_1'){
			showstep(31);
		}
		else if (lastviewedstep == 'step3_2'){
			showstep(32);
		}
		else if (lastviewedstep == 'step4_1'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_2'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_3'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_4'){
			showstep(41);
		}
	}
	else if (step4_4.visible){
		if (lastviewedstep == 'step1'){
			showstep(1);
		}
		else if (lastviewedstep == 'step2'){
			showstep(2);
		}
		else if (lastviewedstep == 'step3_1'){
			showstep(31);
		}
		else if (lastviewedstep == 'step3_2'){
			showstep(32);
		}
		else if (lastviewedstep == 'step4_1'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_2'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_3'){
			showstep(41);
		}
		else if (lastviewedstep == 'step4_4'){
			showstep(41);
		}
	}
}
public function useFreqGrapher():void {
	showstep(42);
}
public function useGeoMapper():void {
	showstep(43);
}
public function useNetowrkTool():void {
	showstep(44);
}
public function tOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function tOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}