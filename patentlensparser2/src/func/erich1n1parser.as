import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;

public var superArray:ArrayCollection = new ArrayCollection();
public var superArray2:ArrayCollection = new ArrayCollection();


import mx.rpc.events.ResultEvent;
public var ericcounter:uint = 0;
// ActionScript file
public function init4():void {
	pArray = new Array();
	var file4:File = new File("app:/data/ericdata.xml");
	var fs2:FileStream = new FileStream();
	fs2.open(file4, FileMode.READ);
	var temp:String = fs2.readUTFBytes(fs2.bytesAvailable);
	var array1:Array = new Array();
	var array2:Array = new Array();
	pArray = new Array();
	if (temp != null){
		var textString:String = temp;
		
		
		do {
			var source:String = stripTags(textString.substring(
				textString.indexOf("<Source>")+8,
				textString.indexOf("</Source>")));
			
			
			var sourceid:String = stripTags(textString.substring(
				textString.indexOf("<sourceID>")+10,
				textString.indexOf("</sourceID>")));
			
			var comments:String = stripTags(textString.substring(
				textString.indexOf("<comments>")+10,
				textString.indexOf("</comments7>")));
			//comments = fixBodyText2(comments);
			
			
			textString = textString.substring(textString.indexOf("</Source>")+9,textString.length);
			textString = textString.substring(textString.indexOf("<Source>"),textString.length);
			superArray.addItem({source:source,sourceid:sourceid,
				comments:comments});
		}while (textString.indexOf("<Source>") != -1);
		
		
	}
	
	ericcounter = 1;
	updateEricData();
}
public function updateEricData():void {
	var stop:String = "";
	
	for (var i:uint = 0; i < superArray.length; i++){
		var commentsText:String = "";
		var chunk:String = "";
		if (superArray[i].source == "cbc.ca"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Report abuse\r\n"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Report abuse\r\n")+14,commentsText.length);
			}while(commentsText.length > 15);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			var stop2:String = "";
		}
		else if (superArray[i].source == "abcnews.com"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Mark As Violation"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Mark As Violation")+17,commentsText.length);
			}while(commentsText.indexOf("Mark As Violation") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "about.com"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("—"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("—")+1,commentsText.length);
				commentsText = commentsText.substring(commentsText.indexOf("\r")+1,commentsText.length);
			}while(commentsText.indexOf("—") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "calgarysun.com"){
			commentsText = superArray[i].comments;
			commentsText = commentsText.substring(commentsText.indexOf("Report Comment")+14,commentsText.length);
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Report Comment"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Report Comment")+14,commentsText.length);
			}while(commentsText.indexOf("Report Comment") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if ((superArray[i].source == "ctv.ca")&&(superArray[i].sourceid != "180")){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("\r\n\r\n\r\n"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("\r\n\r\n\r\n")+6,commentsText.length);
			}while(commentsText.indexOf("\r\n\r\n\r\n") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "ctvbc.ctv.ca"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("\r\n\r\n\r\n"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("\r\n\r\n\r\n")+6,commentsText.length);
			}while(commentsText.indexOf("\r\n\r\n\r\n") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "edmonton.ctv.ca"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("\r\n\r\n"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("\r\n\r\n")+4,commentsText.length);
			}while(commentsText.indexOf("\r\n\r\n") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "edmontonsun.com"){
			commentsText = superArray[i].comments;
			commentsText = commentsText.substring(commentsText.indexOf("Report Comment")+14,commentsText.length);
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Report Comment"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Report Comment")+14,commentsText.length);
			}while(commentsText.indexOf("Report Comment") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "newmomsneed.marchofdimes.com"){
			commentsText = superArray[i].comments;
			commentsText = commentsText.substring(commentsText.indexOf("Says:")+5,commentsText.length);
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Says:"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Says:")+5,commentsText.length);
			}while(commentsText.indexOf("Says:") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "theglobeandmail.com"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Report Abuse"));
					superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Report Abuse")+12,commentsText.length);
			}while(commentsText.indexOf("Report Abuse") != -1);
			stop = superArray2.length.toString();
		}
		else if (superArray[i].source == "thestar.com"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Alert a Moderator"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Alert a Moderator")+17,commentsText.length);
			}while(commentsText.indexOf("Alert a Moderator") != -1);
			stop = superArray2.length.toString();
		}
		else if (superArray[i].source == "torontosun.com"){
			commentsText = superArray[i].comments;
			commentsText = commentsText.substring(commentsText.indexOf("Report Comment")+14,commentsText.length);
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Report Comment"));
					superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Report Comment")+14,commentsText.length);
			}while(commentsText.indexOf("Report Comment") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "tsn.ca"){
			commentsText = superArray[i].comments;
			commentsText = commentsText.substring(commentsText.indexOf("Yeah!Boo!")+9,commentsText.length);
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("Yeah!Boo!"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("Yeah!Boo!")+9,commentsText.length);
			}while(commentsText.indexOf("Yeah!Boo!") != -1);
			superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:commentsText});
			stop = "";
		}
		else if (superArray[i].source == "www.virology.ws"){
			commentsText = superArray[i].comments;
			do {
				chunk = commentsText.substring(0,commentsText.indexOf("•\tFlag"));
				superArray2.addItem({source:superArray[i].source,sourceid:superArray[i].sourceid,comments:chunk});
				commentsText = commentsText.substring(commentsText.indexOf("•\tFlag")+6,commentsText.length);
			}while(commentsText.indexOf("•\tFlag") != -1);
			stop = "";
		}
		
		
		
		
	}
	createCSVFILE3();
}
public function createCSVFILE3():void {
	var csvString:String = "";
	var file:File = File.documentsDirectory;
	file = file.resolvePath("c:/ericDataOut.txt");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	csvString = csvString + "source" + "@";	
	csvString = csvString + "sourceid" + "@";	
	csvString = csvString + "comments" + "\r\n";	
	for (var i:uint = 0; i < superArray2.length; i++){
		csvString = csvString + fixBodyText2(superArray2[i].source) + "@";	
		csvString = csvString + fixBodyText2(superArray2[i].sourceid) + "@";		
		csvString = csvString + fixBodyText2(superArray2[i].comments) + "\r\n";	
	}
	fileStream.writeUTFBytes(csvString);
	fileStream.close();
	var jo:String = "";
}
public function fixBodyText2(s:String):String {
	
	var j:RegExp;
	var b:String = stripTags(s);	
	j =/\r/gi;
	b = b.replace(j, "");
	j =/\>/gi;
	b = b.replace(j, "");
	j =/\</gi;
	b = b.replace(j, "");
	j =/\r/gi;
	b = b.replace(j, "");
	j =/$/gi;
	b = b.replace(j, "");
	b = b.replace(/[,$]/, "") 
	j =/@/gi;
	b = b.replace(j, "");
	b = b.replace(/[,@]/, "") 
	j =/\t/gi;
	b = b.replace(j, "");
	j =/\n/gi;
	b = b.replace(j, "");
	j =/,/gi;
	b = b.replace(j, "");
	j = new RegExp("<p>","g");
	b = b.replace(j,"");	
	j = new RegExp("</p>","g");
	b = b.replace(j,"");
	return b;
}
public function removeSpaces(s:String):String {
	var newString:String = "";
	var j:uint = 0;
	for (j=0; j<s.length; j++) {
		if (s.charAt(j)!=" ") {
			newString += s.charAt(j);
		}
	}
	return newString;
}
public static function stripTags(html:String, tags:String = ""):String
{
	var tagsToBeKept:Array = new Array();
	if (tags.length > 0)
		tagsToBeKept = tags.split(new RegExp("\\s*,\\s*"));
	
	var tagsToKeep:Array = new Array();
	for (var i:int = 0; i < tagsToBeKept.length; i++)
	{
		if (tagsToBeKept[i] != null && tagsToBeKept[i] != "")
			tagsToKeep.push(tagsToBeKept[i]);
	}
	
	var toBeRemoved:Array = new Array();
	var tagRegExp:RegExp = new RegExp("<([^>\\s]+)(\\s[^>]+)*>", "g");
	
	var foundedStrings:Array = html.match(tagRegExp);
	for (i = 0; i < foundedStrings.length; i++) 
	{
		var tagFlag:Boolean = false;
		if (tagsToKeep != null) 
		{
			for (var j:int = 0; j < tagsToKeep.length; j++)
			{
				var tmpRegExp:RegExp = new RegExp("<\/?" + tagsToKeep[j] + "( [^<>]*)*>", "i");
				var tmpStr:String = foundedStrings[i] as String;
				if (tmpStr.search(tmpRegExp) != -1) 
					tagFlag = true;
			}
		}
		if (!tagFlag)
			toBeRemoved.push(foundedStrings[i]);
	}
	for (i = 0; i < toBeRemoved.length; i++) 
	{
		var tmpRE:RegExp = new RegExp("([\+\*\$\/])","g");
		var tmpRemRE:RegExp = new RegExp((toBeRemoved[i] as String).replace(tmpRE, "\\$1"),"g");
		html = html.replace(tmpRemRE, "");
	} 
	return html;
}
