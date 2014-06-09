import com.adobe.serialization.json.JSON;
import flash.filters.DropShadowFilter;
import flash.net.FileFilter;
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.Alert;
import mx.core.IUIComponent;
import mx.graphics.ImageSnapshot;
import mx.graphics.Stroke;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.ObjectUtil;
public var searchArray:ArrayCollection = new ArrayCollection();
private const textFilter:FileFilter = new FileFilter("Text Files (txt, html, htm)","*.txt;*.html;*.csv;*.htm;");
public function parseDocument(s:String):void {			
	var tempString:String = "";
	searchArray = new ArrayCollection();
	tempString = s;
	do {
		var line:String = tempString.substring(0,tempString.indexOf("\r\n"));
		if (line.indexOf("...") != -1){
			searchArray.addItem({label:line.substring(line.indexOf("...")+3,line.length),searches:new ArrayCollection});
		}
		else {
			var labelHead:String = "";
			var subSearches:Array = new Array();
			if (line.indexOf(",") != -1){
				//multi term search
				do {
					var templine:String = line.substring(0,line.indexOf(","));
					if ((line != "")&&(line.length > 2)){
						if (labelHead == ""){
							labelHead = templine;
						}
						subSearches.push(templine);
						//searchArray.getItemAt(searchArray.length-1).searches.push(templine);
					}
					line = line.substring(line.indexOf(",")+1,line.length);
				}while (line.indexOf(",") != -1);
				if ((line != "")&&(line.length > 2)){
					subSearches.push(line);
					//searchArray.getItemAt(searchArray.length-1).searches.push(templine);
				}
			}
			else {
				//sing term serach
				if ((line != "")&&(line.length > 2)){
					labelHead = line;
					subSearches.push(line);
					//searchArray.getItemAt(searchArray.length-1).searches.push(line);
				}
			}
			searchArray.getItemAt(searchArray.length-1).searches.addItem({label:labelHead,searches:subSearches});
		}
		tempString = tempString.substring(tempString.indexOf("\r\n")+2,tempString.length);
	}while(tempString.length > 4);
	var stop:String = "";
	getDatalist.send();
}
