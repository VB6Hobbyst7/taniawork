public function redoUsedArray():void {
	usedArray = new Array();
	for (var i:uint = 0; i < maxNumOfVars; i++){
		usedArray.push(false);
	}
	var stroke1:SolidColorStroke = vvar1.getStyle("lineStroke");
	var stroke2:SolidColorStroke = vvar2.getStyle("lineStroke");
	var stroke3:SolidColorStroke = vvar3.getStyle("lineStroke");
	var stroke4:SolidColorStroke = vvar4.getStyle("lineStroke");
	var stroke5:SolidColorStroke = vvar5.getStyle("lineStroke");
	var stroke6:SolidColorStroke = vvar6.getStyle("lineStroke");
	var stroke7:SolidColorStroke = vvar7.getStyle("lineStroke");
	var stroke8:SolidColorStroke = vvar8.getStyle("lineStroke");
	var stroke9:SolidColorStroke = vvar9.getStyle("lineStroke");
	var stroke10:SolidColorStroke = vvar10.getStyle("lineStroke");
	var stroke11:SolidColorStroke = vvar11.getStyle("lineStroke");
	var stroke12:SolidColorStroke = vvar12.getStyle("lineStroke");
	var stroke13:SolidColorStroke = vvar13.getStyle("lineStroke");
	
	colorArray = new Array();
	colorArray.push(stroke1.color);
	colorArray.push(stroke2.color);
	colorArray.push(stroke3.color);
	colorArray.push(stroke4.color);
	colorArray.push(stroke5.color);
	colorArray.push(stroke6.color);
	colorArray.push(stroke7.color);
	colorArray.push(stroke8.color);
	colorArray.push(stroke9.color);
	colorArray.push(stroke10.color);
	colorArray.push(stroke11.color);
	colorArray.push(stroke12.color);
	colorArray.push(stroke13.color);
	
	rotationArray = new ArrayCollection();
	for (var j:uint = 0; j < 45; j++){
		rotationArray.addItem({angle:j});
	}
	
}
public function display():void {
	var endCounter:uint = 0;
	do {
		endCounter++;
	}while ((usedArray[endCounter] != false)&&(endCounter < maxNumOfVars));
	if (endCounter != maxNumOfVars){
		usedArray[endCounter] = true;
		currentlySearching = endCounter;
		legendArray.addItem({name:searchTitle.text,curSearch:endCounter,usedIndex:endCounter,colorc:colorArray[endCounter-1]});
		legendList.dataProvider = legendArray;
		var text:String = searchText.text.toString();
		var termArray:Array = new Array();
		if (text != ""){
			if (text.indexOf("\n") != -1){
				do {
					termArray.push(text.substring(0,text.indexOf("\n")));
					text = text.substring(text.indexOf("\n")+1,text.length);	
				}while (text.indexOf("\n") != -1);
			}
			termArray.push(text);
		}
		var andorchoice:String = andorgroup.selectedValue.toString();
		if (datetype == "Year"){
			var query:String = "select "+datecolumn+" AS year, count(*) as frequency from "+tablename+" where";
			for (var i:uint = 0; i < termArray.length; i++){
				if (i == termArray.length-1){
					query = query + " "+searchcolumn+" like '%"+termArray[i]+"%'";
				}
				else {
					query = query + " "+searchcolumn+" like '%"+termArray[i]+"%' "+andorchoice+" ";
				}
			}
			query = query + " group by year order by count(*) desc";
			s1 = query;
			s2 = databasename;
			s3 = serveraddress;
			s4 = serveruser;
			s5 = serverpass;
			searchDatabase.send();
		}
		else if (datetype == "Month"){
			var query:String = "select "+datecolumn+" AS month, year AS year, count(*) as frequency from "+tablename+" where";
			for (var i:uint = 0; i < termArray.length; i++){
				if (i == termArray.length-1){
					query = query + " "+searchcolumn+" like '%"+termArray[i]+"%'";
				}
				else {
					query = query + " "+searchcolumn+" like '%"+termArray[i]+"%' "+andorchoice+" ";
				}
			}
			query = query + " group by month, year order by count(*) desc";
			s1 = query;
			s2 = databasename;
			s3 = serveraddress;
			s4 = serveruser;
			s5 = serverpass;
			searchDatabase2.send();
		}
		
	}
}
public function setVal(p:uint,curSearch:uint,val:uint):void {
	if (curSearch == 1){
		displayArray[p].val1 = val;
	}
	else if (curSearch == 2){
		displayArray[p].val2 = val;
	}
	else if (curSearch == 3){
		displayArray[p].val3 = val;
	}
	else if (curSearch == 4){
		displayArray[p].val4 = val;
	}
	else if (curSearch == 5){
		displayArray[p].val5 = val;
	}
	else if (curSearch == 6){
		displayArray[p].val6 = val;
	}
	else if (curSearch == 7){
		displayArray[p].val7 = val;
	}
	else if (curSearch == 8){
		displayArray[p].val8 = val;
	}
	else if (curSearch == 9){
		displayArray[p].val9 = val;
	}
	else if (curSearch == 10){
		displayArray[p].val10 = val;
	}
	else if (curSearch == 11){
		displayArray[p].val11 = val;
	}
	else if (curSearch == 12){
		displayArray[p].val12 = val;
	}
	else if (curSearch == 13){
		displayArray[p].val13 = val;
	}
}
public function addBlankYear(year:uint):void {
	displayArray.addItem({year:year,val1:0,val2:0,val3:0,val4:0,
		val5:0,val6:0,val7:0,val8:0,
		val9:0,val10:0,val11:0,val12:0,val13:0});
}
public function addBlankYearMonth(year:uint,month:String,monthVal:uint):void {
	displayArray.addItem({monthyear:month+"-"+year.toString(),year:year,month:month,monthVal:monthVal,yearmonth:year.toString()+month,val1:0,val2:0,val3:0,val4:0,
		val5:0,val6:0,val7:0,val8:0,
		val9:0,val10:0,val11:0,val12:0,val13:0});
}
public function afterSearchDatabase(ev:ResultEvent):void {
	linechart.seriesFilters = [];
	var i:uint = 0;
	areachart.seriesFilters = [];
	freqArray = new ArrayCollection();
	if (ev.result != null){
		try{
			if (datetype == "Year"){
				a1.categoryField = "year";
				a2.categoryField = "year";
				freqArray = ev.result[0].lists.list;
				var dataSortField:SortField = new SortField();
				dataSortField.name = "year";
				dataSortField.numeric = true;
				var numericDataSort:Sort = new Sort();
				numericDataSort.fields = [dataSortField];
				freqArray.sort = numericDataSort;
				freqArray.refresh();
				var p:uint = 0;
				var lastYear:uint = 0;
				var proc:Boolean = false;
				for (i = 0; i < freqArray.length; i++){
					if ((freqArray[i].year != 0)&&(freqArray[i].year < 2011)){
						if (lastYear == 0){
							lastYear = freqArray[i].year;
						}
						else {
							if (freqArray[i].year > lastYear+1){
								do {
									lastYear++;
									proc = false;
									for (p = 0; p < displayArray.length; p++){
										if (displayArray[p].year == lastYear){
											setVal(p,currentlySearching,0);	
											proc = true;
										}
									}
									if (proc == false){
										addBlankYear(lastYear);
									}	
								}while (freqArray[i].year > lastYear+1);
							}
							proc = false;
							for (p = 0; p < displayArray.length; p++){
								if (displayArray[p].year == freqArray[i].year){
									setVal(p,currentlySearching,freqArray[i].frequency);
									proc = true;
								}
							}
							if (proc == false){
								addBlankYear(freqArray[i].year);
								setVal(displayArray.length-1,currentlySearching,freqArray[i].frequency);
							}	
							lastYear = freqArray[i].year;
						}
					}
				}
				var dataSortField:SortField = new SortField();
				dataSortField.name = "year";
				dataSortField.numeric = true;
				var numericDataSort:Sort = new Sort();
				numericDataSort.fields = [dataSortField];
				displayArray.sort = numericDataSort;
				displayArray.refresh();
			}
			else if (datetype == "Month"){
				a1.categoryField = "yearmonth";
				a2.categoryField = "yearmonth";
				freqArray = new ArrayCollection();
				var tempfreqArray:ArrayCollection = new ArrayCollection();
				tempfreqArray = ev.result[0].lists.list;
				var dataSortField:SortField = new SortField();
				dataSortField.name = "year";
				dataSortField.numeric = true;
				var numericDataSort:Sort = new Sort();
				numericDataSort.fields = [dataSortField];
				tempfreqArray.sort = numericDataSort;
				tempfreqArray.refresh();
				
				for (i = 2009; i < 2011; i++){
					freqArray.addItem({year:i,monthVal:1,month:"jan",frequency:0});
					freqArray.addItem({year:i,monthVal:2,month:"feb",frequency:0});
					freqArray.addItem({year:i,monthVal:3,month:"mar",frequency:0});
					freqArray.addItem({year:i,monthVal:4,month:"apr",frequency:0});
					freqArray.addItem({year:i,monthVal:5,month:"may",frequency:0});
					freqArray.addItem({year:i,monthVal:6,month:"jun",frequency:0});
					freqArray.addItem({year:i,monthVal:7,month:"jul",frequency:0});
					freqArray.addItem({year:i,monthVal:8,month:"aug",frequency:0});
					freqArray.addItem({year:i,monthVal:9,month:"sept",frequency:0});
					freqArray.addItem({year:i,monthVal:10,month:"oct",frequency:0});
					freqArray.addItem({year:i,monthVal:11,month:"nov",frequency:0});
					freqArray.addItem({year:i,monthVal:12,month:"dec",frequency:0});
				}
				for (i = 0; i < freqArray.length; i++){
					//trace (freqArray[i].year.toString() + ", " + freqArray[i].month);
				}
				for (i = 0; i < tempfreqArray.length; i++){
					for (var j:uint = 0; j < freqArray.length; j++){
						if ((freqArray[j].month == tempfreqArray[i].month)&&
							(freqArray[j].year == tempfreqArray[i].year)){
							freqArray[j].frequency = tempfreqArray[i].frequency
							//trace (freqArray[j].year.toString() + ", " + freqArray[j].month+ ", " + freqArray[j].frequency);
						}
					}
				}
				
				var dataSortField4:SortField = new SortField();
				dataSortField4.name = "year";
				dataSortField4.numeric = true;
				var dataSortField2:SortField = new SortField();
				dataSortField2.name = "monthVal";
				dataSortField2.numeric = true;
				dataSortField2.descending = false;
				var numericDataSort2:Sort = new Sort();
				numericDataSort2.fields = [dataSortField4,dataSortField2];
				freqArray.sort = numericDataSort2;
				freqArray.refresh();
				
				proc = false;
				for (i = 0; i < freqArray.length; i++){
					for (p = 0; p < displayArray.length; p++){
						if ((displayArray[p].year == freqArray[i].year)&&
							(displayArray[p].month == freqArray[i].month)){
							setVal(p,currentlySearching,freqArray[i].frequency);
							proc = true;
						}
					}
					if (proc == false){
						addBlankYearMonth(freqArray[i].year,freqArray[i].month,freqArray[i].monthVal);
						setVal(displayArray.length-1,currentlySearching,freqArray[i].frequency);
					}	
				}
				var dataSortField4:SortField = new SortField();
				dataSortField4.name = "year";
				dataSortField4.numeric = true;
				var dataSortField2:SortField = new SortField();
				dataSortField2.name = "monthVal";
				dataSortField2.numeric = true;
				dataSortField2.descending = false;
				var numericDataSort2:Sort = new Sort();
				numericDataSort2.fields = [dataSortField4,dataSortField2];
				displayArray.sort = numericDataSort2;
				displayArray.refresh();
				
				for (i = 0; i < displayArray.length; i++){
					trace (displayArray[i].year.toString() + ", " + displayArray[i].month+ ", " + 
						displayArray[i].frequency);
				}
			}
			
		}
		catch(e:Error){
			var stop98:String = "";
		}
	}
	
	linechart.dataProvider = displayArray;
	areachart.dataProvider = displayArray;
	/*	am1.dataProvider = displayArray;
	am2.dataProvider = displayArray;
	chartsa.dataProvider = displayArray;
	chartsbc.dataProvider = displayArray;*/
}
protected function loadExsistingSource():void
{
	getDatasetList.send();
	showstep(2);
}
protected function loadMysqlDatabase():void
{
	showstep(31);
}
protected function loadCSVFile():void
{
	showstep(32);
}

public function insertDataSet():void {
	serveraddress = t1.text;
	serveruser = t2.text;
	serverpass = t3.text;
	databasename = t4.text;
	tablename = t5.text;
	searchcolumn = t6.text;
	datecolumn = t7.text;
	datasetname = t8.text;
	datetype = dateRadioGroup.selectedValue.toString();
	
	s1 = t1.text;
	s2 = t2.text;
	s3 = t3.text;
	s4 = t4.text;
	s5 = t5.text;
	s6 = t6.text;
	s7 = t7.text;
	s8 = dateRadioGroup.selectedValue.toString();
	s9 = t8.text;
	insertDataset.send();
	
	
}
public function afterInsert(ev:ResultEvent):void {
	var stop:String = "";
	this.currentState = 'viz';
}
public function afterGetDatasetlist(ev:ResultEvent):void {
	var stop:String = "";
	datasetArray = new ArrayCollection();
	datasetArray = ev.result[0].lists.list;
	
}
public function loaddatasource():void {
	showstep(41);
	redoUsedArray();
	if (exsistlist.selectedIndex != -1){
		serveraddress = exsistlist.selectedItem.serveraddress;
		serveruser = exsistlist.selectedItem.username;
		serverpass = exsistlist.selectedItem.userpassword;
		databasename = exsistlist.selectedItem.databasename;
		tablename = exsistlist.selectedItem.tablename;
		searchcolumn = exsistlist.selectedItem.columntosearch;
		datecolumn = exsistlist.selectedItem.datecolumn;
		datasetname = exsistlist.selectedItem.name;
		datetype = exsistlist.selectedItem.datetype;
		eraseAll();
	}
	
}

public function deleteSearch():void {
	if (legendList.selectedIndex != -1){
		var i:uint = 0;
		for (i = 0; i < displayArray.length; i++){
			setVal(i,legendArray[legendList.selectedIndex].curSearch,0);
		}
		usedArray[legendArray[legendList.selectedIndex].usedIndex] = false;
		legendArray.removeItemAt(legendList.selectedIndex);
		legendList.dataProvider = legendArray;
		if (datetype == "Year"){
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "year";
			dataSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			displayArray.sort = numericDataSort;
			displayArray.refresh();
		}
		else if (datetype == "Month"){
			var dataSortField4:SortField = new SortField();
			dataSortField4.name = "year";
			dataSortField4.numeric = true;
			var dataSortField2:SortField = new SortField();
			dataSortField2.name = "monthVal";
			dataSortField2.numeric = true;
			dataSortField2.descending = false;
			var numericDataSort2:Sort = new Sort();
			numericDataSort2.fields = [dataSortField4,dataSortField2];
			displayArray.sort = numericDataSort2;
			displayArray.refresh();
		}
		linechart.dataProvider = displayArray;
		areachart.dataProvider = displayArray;
		/*	chartsa.dataProvider = displayArray;
		am1.dataProvider = displayArray;
		am2.dataProvider = displayArray;
		chartsbc.dataProvider = displayArray;*/
	}	
}
public function eraseAll():void {
	displayArray = new ArrayCollection();
	legendArray = new ArrayCollection();
	searchTitle.text = "";
	searchText.text = "";
	legendList.dataProvider = legendArray;
	var dataSortField:SortField = new SortField();
	dataSortField.name = "year";
	dataSortField.numeric = true;
	var numericDataSort:Sort = new Sort();
	numericDataSort.fields = [dataSortField];
	displayArray.sort = numericDataSort;
	displayArray.refresh();
	linechart.dataProvider = displayArray;
	areachart.dataProvider = displayArray;
	/*chartsa.dataProvider = displayArray;
	am1.dataProvider = displayArray;
	am2.dataProvider = displayArray;
	chartsbc.dataProvider = displayArray;*/
}
private function myKeyUpHandler(event:KeyboardEvent):void
{
	var keycode_c:uint = 67;
	if (event.ctrlKey && event.keyCode == keycode_c)
	{
		// Separator used between Strings sent to clipboard
		// to separate selected cells.
		var separator:String = ",";
		// The String sent to the clipboard
		var dataString:String = "";
		
		// Loop over the selectedCells property.
		// Data in selectedCells is ordered so that 
		// the last selected cell is at the head of the list.
		// Process the data in reverse so
		// that it appears in the correct order in the clipboard.
		var n:int = event.currentTarget.selectedCells.length;
		for (var i:int = 0; i < n; i++)
		{
			var cell:Object = event.currentTarget.selectedCells[i];
			
			// Get the row for the selected cell.
			var data:Object = 
				event.currentTarget.dataProvider[cell.rowIndex];
			
			// Get the name of the field for the selected cell.
			var dataField:String = 
				event.currentTarget.columns[cell.columnIndex].dataField;
			
			// Get the cell data using the field name.
			dataString = data[dataField] + separator + dataString;
		}
		
		// Remove trailing separator.
		dataString = 
			dataString.substr(0, dataString.length - separator.length);
		
		// Write dataString to the clipboard.
		System.setClipboard(dataString);
	}
}
private function handleCopyClick():void
{
	System.setClipboard( leftDataGrid.getTextFromItems() );
}