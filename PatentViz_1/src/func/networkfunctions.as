import com.adobe.serialization.json.JSON;

import data.GrapheLibrary;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import fr.kapit.actionscript.lang.ApplicationContext;
import fr.kapit.actionscript.lang.command.CommandEvent;
import fr.kapit.actionscript.net.command.BaseDataLoaderCommand;
import fr.kapit.actionscript.net.command.INetLoaderCommand;
import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.lab.demo.ui.components.popupLogger.PopupLogger;
import fr.kapit.logging.FlexConsoleTarget;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.logging.Log;
import mx.logging.targets.TraceTarget;
import mx.rpc.events.ResultEvent;

[Bindable]
public var cus1:String = "";
[Bindable]
public var cus2:String = "";

/**
 * Creation complete: builds up the log targets
 *
 * 
 * serveraddress = exsistlist.selectedItem.serveraddress;
		serveruser = exsistlist.selectedItem.username;
		serverpass = exsistlist.selectedItem.userpassword;
		databasename = exsistlist.selectedItem.databasename;
		tablename = exsistlist.selectedItem.tablename;
		searchcolumn = exsistlist.selectedItem.columntosearch;
		datecolumn = exsistlist.selectedItem.datecolumn;
		datasetname = exsistlist.selectedItem.name;
		datetype = exsistlist.selectedItem.datetype;
		 * 
		 * 
 * @param event
 */
protected function this_creationCompleteHandler(event:FlexEvent):void
{
	new PopupLogger();
	createLogTargets();
}

/**
 * @private
 * Builds up the log targets.
 */
private function createLogTargets():void
{
	var traceTarget:TraceTarget = new TraceTarget();
	traceTarget.filters = [ "fr.kapit.lab.demo.*" ];
	Log.addTarget(traceTarget);
	
	
	// to use with the FlexConsole AIR application
	var consoleTarget:FlexConsoleTarget = new FlexConsoleTarget();
	consoleTarget.includeDate = true;
	consoleTarget.includeTime = true;
	consoleTarget.includeCategory = true;
	consoleTarget.includeLevel = true;
	consoleTarget.filters = [ "fr.kapit.lab.demo.*" ];
	Log.addTarget(consoleTarget);
}
public function publicationCitationNetworkCreator():void {
	cus1 = databasename;
	cus2 = "SELECT `Publication Number`,  `Cited Patents - DPCI`, `Citing Patents` FROM `"+tablename+"`;";
	customquery.addEventListener(ResultEvent.RESULT, afterpublicationCitationNetworkCreator);
	customquery.send();
}
public function afterpublicationCitationNetworkCreator(ev:ResultEvent):void {
	var dataArray:ArrayCollection = ev.result[0].lists.list;
	var dataArray2:ArrayCollection = new ArrayCollection();
	var graphstring:String = "";
	/*var edgestring:String = '<graphml>
	<node id="n1" label="group1" layout="hierarchicalTree">
		<graph id="n1:" edgedefault="undirected">';*/
	for (var i:Number = 0; i <dataArray.length; i++){	
			var publication_number:String = dataArray[i].PublicationNumber;
			var cited_refs:String = dataArray[i].CitedPatentsDPCI;
			var citing_refs:String = dataArray[i].CitingPatents;
			var cited_refs_parts:Array = cited_refs.split(" | ");
			var citing_refs_parts:Array = citing_refs.split(" | ");
			var j:Number = 0;
			for (j = 0; j < cited_refs_parts.length; j++){
				if (cited_refs_parts[j].length > 4){
					dataArray2.addItem({
						pub1:publication_number,
						pub2:cited_refs_parts[j],
						direction:"forward"});
				}
			}
			for (j = 0; j < citing_refs_parts.length; j++){
				if (citing_refs_parts[j].length > 4){
					dataArray2.addItem({
						pub1:publication_number,
						pub2:citing_refs_parts[j],
						direction:"backward"});
				}
			}	
		}
	var stop:String = "";
}


