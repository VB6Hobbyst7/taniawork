import flash.events.KeyboardEvent;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;

public function parseDocument(o:Object):void {
	var max:Number = -1;
	var min:Number = 9999999999;
	if (o != null){
		textFlowArray = new ArrayCollection();
		dynTool.bubbleContents = new ArrayCollection();
		var count:uint = 0;
		var tempTexto:String = o.toString();
		tempTexto = fixBodyText(tempTexto);
		var bookName:String = tempTexto.substring(
			tempTexto.indexOf(">",tempTexto.indexOf("<head"))+1,
			tempTexto.indexOf("</head>"));
		tempTexto = tempTexto.substring(tempTexto.indexOf("</head>")+7,tempTexto.length);	
		var contents:Array = new Array;
		var bubbs:Array = new Array();
		do{
			var chapterIndex:String = tempTexto.substring(
				tempTexto.indexOf(">",tempTexto.indexOf("<head"))+1,
				tempTexto.indexOf("</head>"));
			var bubIndex:String = chapterIndex;
			chapterIndex = str_replace("Chapter","Ch",chapterIndex);
			var temps:String = tempTexto.substring(
				tempTexto.indexOf("</head>")+7,tempTexto.length);
			
			var chapterName:String = temps.substring(
				temps.indexOf(">",temps.indexOf("<head"))+1,
				temps.indexOf("</head>"));
			if ((chapterName.indexOf("<") != -1)||(chapterName.indexOf(">") != -1)){
				chapterName = "";
			}
			
			var chapterText:String = tempTexto.substring(0,tempTexto.indexOf("</div>")+6);
			tempTexto = tempTexto.substring(tempTexto.indexOf("</div>")+6,tempTexto.length);
				textFlowArray.addItem({cindex:chapterIndex,
					cname:chapterName,
					ctext:chapterText});
			if (chapterText.length > max){
				max = chapterText.length;
			}
			if (chapterText.length < min){
				min = chapterText.length;
			}
			contents.push(new chapter(chapterIndex + " " + chapterName,null,"Click to View",0,count));
			bubbs.push(new bubble(bubIndex,null,"Click to View",chapterText.length,count));
			count++;
		} while(tempTexto.indexOf("<head") != -1);
		chapterMax = max;
		chapterMin = min;
		//below code is if you cant the chapters contained withen the book as a node itself. 
		//chapterContents = new ArrayCollection([new chapter(bookName,new ArrayCollection(contents))]);
		chapterContents = new ArrayCollection(contents);
		dynTool.bubbleContents = new ArrayCollection(bubbs);
		displayChapter(1);
		parseTags();
		bookHolder.visible = true;
	}
}
private function str_replace( replace_with:String, replace:String, original:String ):String
{
	var array:Array = original.split(replace_with);
	return array.join(replace);
}
public function parseTags():void {
	bubbleSearchOptions = new ArrayCollection();
	var textLoss:uint = 0;
	for (var i:uint = 0; i < textFlowArray.length; i++){
		
		//s = Chapter text of chapter i
		var chapterText:String = textFlowArray[i].ctext;
		//Length of chapter text, with tags included.
		var textLength:uint = chapterText.length;
		
		
		
		do{
			var marker:uint = textLength-chapterText.length;
			var s2:String = chapterText.substring(0,chapterText.indexOf("<"));
			var beforeTagText:String = s2.substring(s2.lastIndexOf(" "),s2.length);
			if (beforeTagText == " "){
				s2 = s2.substring(0,s2.length-1);
				beforeTagText = s2.substring(s2.lastIndexOf(" "),s2.length); 
			}
			
			/* NOTE ALL TAGS WITH LENGTH >= 4 THAT YOU DONT WANT CHECKED MUST BE REMOVED*/
			
			
			/*tag with no space  
			term rend="slant(italic)" = term
			placeName = placeName
			*/
			var tagNoSpace:String = chapterText.substring(chapterText.indexOf("<")+1,chapterText.indexOf(">"));
			if (tagNoSpace.indexOf(" ") != -1){
				tagNoSpace = tagNoSpace.substring(0,tagNoSpace.indexOf(" "));
			}
			/* tag with space 
			term rend="slant(italic)" = term rend="slant(italic)" 
			placeName = placeName
			*/
			var tagWithSpace:String = chapterText.substring(chapterText.indexOf("<")+1,chapterText.indexOf(">"));
			/*removes tags with length less than 4 and removes specific ones i know are bad. */
			if (properTag(tagNoSpace)){
				if (endTag(tagWithSpace) == false){
					if (tagNoSpace == "action")
					{
						var stop3234:String = "";
					}
					/*FIXTEXT
					this might be causing probelms with text index,
					but will try to remove the fixes before getting here
					*/
					//trimText is text encapulated by the tag
					var trimText:String = fixText(chapterText.substring(
						chapterText.indexOf(">")+1,
						chapterText.indexOf("</"+tagNoSpace)));
					if (trimText.length > 50){
						trimText = trimText.substring(0,50);
					}
					//chunker is the text surounding the tag
					var chunkStart:uint = 0;
					var chunkEnd:uint = 0;
					
					if (((chapterText.indexOf(">")+1)) < 0){
						chunkStart = 0;
					}
					else {
						chunkStart = ((chapterText.indexOf(">")+1));
					}
					
					if ((chapterText.indexOf("</"+tagNoSpace)+200) > (chapterText.length-1)){
						chunkEnd = chapterText.length-1;//might not need the minus one, check this out. 
					}
					else {
						chunkEnd = (chapterText.indexOf("</"+tagNoSpace)+200);
					}
					//FIX TEXT PROBLEM
					var chunker:String = fixText(chapterText.substring(chunkStart,chunkEnd));
					
					
					if ((trimText == "l")||(trimText == " l")){
						if ((beforeTagText != "")&&(beforeTagText != " ")&&(beforeTagText != "  ")){
						tagArray.addItem({cindex:i,
							ttype:tagNoSpace,
							ttext:beforeTagText,
							chunkText:chunker,
							mark:marker,
							tot:textLength});
						}
					}
					else {
						if ((trimText != "")&&(trimText != " ")&&(trimText != "  ")){
					tagArray.addItem({cindex:i,
						ttype:tagNoSpace,
						ttext:trimText,
						chunkText:chunker,
						mark:marker,
						tot:textLength});
						}
					}
					if (marker > textLength){
						var weird:String = "stop";
					}
				}
			}
			
			chapterText = chapterText.substring(chapterText.indexOf(">")+1,chapterText.length);
		}while(chapterText.indexOf(">") != -1);//No More Tags To Parse Out
	}
	organizeTags();
}
public function organizeTags():void {
	if (tagArray.length > 0){
		var typeSortField:SortField = new SortField();
		typeSortField.name = "ttype";
		typeSortField.numeric = false;
		typeSortField.caseInsensitive = true;
		
		var chapSortField:SortField = new SortField();
		chapSortField.name = "cindex";
		chapSortField.numeric = true;
		
		
		
		var termSortField:SortField = new SortField();
		termSortField.name = "ttext";
		termSortField.numeric = false;
		termSortField.caseInsensitive = true;
		
		var textIndexSortField:SortField = new SortField();
		textIndexSortField.name = "mark";
		textIndexSortField.numeric = true;
		
		var termSort:Sort = new Sort();
		termSort.fields = [typeSortField,chapSortField,textIndexSortField];
		tagArray.sort = termSort;
		tagArray.refresh();
		
		var termIncounter:Boolean = false;
		var lastTag:String = "";
		var lastTagIndex:Number = -1;
		var lastTerm:String = "";
		var occurCount:uint = 1;
		var lastChapter:Number = -1;
		for (var i:uint = 0; i < tagArray.length; i++){
			if (lastTag != tagArray[i].ttype){
				//new start of tag type
				lastTagIndex++;
				lastTag = tagArray[i].ttype;
				lastTerm = tagArray[i].ttext;
				lastChapter = tagArray[i].cindex;
				occurCount = 1;
				var tempArray:ArrayCollection = new ArrayCollection();
				tempArray.addItem({
					cindex:tagArray[i].cindex,
					ttext:tagArray[i].ttext,
					chunkText:tagArray[i].chunkText,
					mark:tagArray[i].mark,
					tot:tagArray[i].tot,
					occurindex:1
				});
				tagCollection.addItem({ttype:tagArray[i].ttype,
					chunkText:tagArray[i].chunkText,
					tarray:tempArray});
			}
			else {
				//add on
				
				if ((lastTerm != tagArray[i].ttext)||(lastChapter != tagArray[i].cindex)){
					//new term
					lastTerm = tagArray[i].ttext;
					lastChapter = tagArray[i].cindex;
					occurCount = 1;
				}
				else {
					occurCount++;
					// old term incremend occur count
				}
				tagCollection[lastTagIndex].tarray.addItem({
					cindex:tagArray[i].cindex,
					ttext:tagArray[i].ttext,
					chunkText:tagArray[i].chunkText,
					mark:tagArray[i].mark,
					tot:tagArray[i].tot,
					occurindex:occurCount
				});
			}
			
		}
	}
	displayCuratorTags();
}
public function fixText(s:String):String {
	var b:String = s;
	//if (b.indexOf("\r") != -1){
		
	//}
	var tFlow:TextFlow;
	var importer:ITextImporter = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT);
	tFlow = importer.importToFlow(b);
	b = TextConverter.export(tFlow,
		TextConverter.PLAIN_TEXT_FORMAT,
		ConversionType.STRING_TYPE).toString();
	var j:RegExp =/\r/g;
	b = b.replace(j, "");
	//}
	//if (b.indexOf("\n") != -1){
	var k:RegExp =/\n/g;
	b = b.replace(k, "");
	return b;
}
public function endTag(s:String):Boolean {
	if (s.indexOf("/") != -1){
		return true;
	}
	return false;
}
public function properTag(s:String):Boolean {
	if (s == "TextFlow"){
		return false;
	}
	if (s == "head"){
		return false;
	}
	
	if (s.length < 4){
		return false;
	}
	return true;
}
public function removeHead(s:String):String {
	var newText:String = s;
	var j:RegExp =/<head/gi;
	newText = newText.replace(j, "<p");
	j =/<\/head/gi;
	newText = newText.replace(j, "</p");
	return newText;
}
public function fixBodyText(s:String):String {
	/* TO DO : 
	REMOVE EVERYTHING BETWEEN 
	<mw type="sig" rend="align(center)"> AND </mw> INLCUDING TAGS
	<milestone... AND </mw> INCLUDING TAGS
	ever tag with length > 3 must be checked
	*/

	var j:RegExp;
	var b:String = s;
	
	j = new RegExp("<q>","g");
	b = b.replace(j,"\t    \t");	
	j = new RegExp("</head>","g");
	b = b.replace(j,"</head><p></p>");
	
	j = new RegExp("</q>","g");
	b = b.replace(j,"\t    \t");	
	
	if (b.indexOf("\r") != -1){
		j =/\r/gi;
		b = b.replace(j, "");
	}
	//if (b.indexOf("\t") != -1){
	//	j =/\t/gi;
	//	b = b.replace(j, "\t\t\t  ");
	//}
	/*if (b.indexOf("\n") != -1){
		j =/\n/gi;
		b = b.replace(j, "");
	}*/
	j = new RegExp("&shy;<lb ></lb>","g");
	b = b.replace(j,"");	
	j = new RegExp("&shy;<lb />","g");
	b = b.replace(j,"");
	j = new RegExp("&shy; <lb />","g");
	b = b.replace(j,"");
	j = new RegExp("&shy;  <lb />","g");
	b = b.replace(j,"");
	j = new RegExp("&shy; ","g");
	b = b.replace(j,"");	
	j = new RegExp("&shy;","g");
	b = b.replace(j,"");	

	j =/<lb \/>/gi;
	b = b.replace(j, " ");// space or no space

	j = new RegExp("&mdash;","g");
	b = b.replace(j,"");	
	j = new RegExp(">l<","g");
	b = b.replace(j,">£<");
	j = />A</gi;
	b = b.replace(j,"><");	
	j = />\d*</gi;
	b = b.replace(j,"><");	
	return b;
}