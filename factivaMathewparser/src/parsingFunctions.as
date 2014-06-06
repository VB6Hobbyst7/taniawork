
import flash.events.*;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.html.*;
import flash.html.HTMLLoader;
import flash.html.HTMLPDFCapability;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.*;
import flash.utils.*;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.utils.ArrayUtil;

public var superArray:ArrayCollection = new ArrayCollection();
public var putCount:uint = 0;
public var senderCount:int = 0;
public var senderCount2:int = 0;
public var proFinished:Boolean = false;
public var tlist:String = "";
[Bindable]
public var counter:uint = 0;
private var html:HTMLLoader;
public var filesLimit:uint = 4;
public var datafolderstring:String = "";
[Bindable]
public var xm:XML = <Articles></Articles>;
public function init():void {
	databaseReload();
}
public function databaseReload():void {
	
	senderCount = 1;
	filesLimit = 135;
	filePath = "data/"+senderCount.toString()+".xml";
	parseFile.send();
	
}

public function gotFile(ev:ResultEvent):void {
	if (ev.result != null){
		var textString:String = ev.result.toString();
		
		
		do {
			var articleString:String = textString.substring(
				textString.indexOf("<ppsarticle>")+12,
				textString.indexOf("</ppsarticle>"));
			
			var dateString:String = stripTags(articleString.substring(
				articleString.indexOf("<publicationDate>")+17,
				articleString.indexOf("</publicationDate>")));
			dateString = removeSpaces(dateString);
			dateString = fixBodyText(dateString);
			
			var sourceName:String = stripTags(articleString.substring(
				articleString.indexOf("<sourceName>")+12,
				articleString.indexOf("</sourceName>")));
			sourceName = fixBodyText(sourceName);
			
			var sectionName:String = stripTags(articleString.substring(
				articleString.indexOf("<sectionName>")+13,
				articleString.indexOf("</sectionName>")));
			sectionName = fixBodyText(sectionName);
			
			if (sectionName.indexOf("<") != -1){
				sectionName = "none";
			}
			
			var wordCount:String = stripTags(articleString.substring(
				articleString.indexOf("<wordCount>")+11,
				articleString.indexOf("</wordCount>")));
			wordCount = fixBodyText(wordCount);
			
			var headline:String = stripTags(articleString.substring(
				articleString.indexOf("<headline>")+10,
				articleString.indexOf("</headline>")));
			headline = fixBodyText(headline);
			
			var tailParagraphs:String = stripTags(articleString.substring(
				articleString.indexOf("<tailParagraphs>")+16,
				articleString.indexOf("</tailParagraphs>")));
			tailParagraphs = fixBodyText(tailParagraphs);
			
			
			
			var byline:String = stripTags(articleString.substring(
				articleString.indexOf("<byline>")+8,
				articleString.indexOf("</byline>")));
			byline = fixBodyText(byline);
			
			var leadParagraph:String = stripTags(articleString.substring(
				articleString.indexOf("<leadParagraph>")+15,
				articleString.indexOf("</leadParagraph>")));
			leadParagraph = fixBodyText(leadParagraph);
			tailParagraphs = leadParagraph + " " + tailParagraphs;
			
			textString = textString.substring(textString.indexOf("</ppsarticle>")+13,textString.length);
			superArray.addItem({headline:headline,tailParagraphs:tailParagraphs,
				sourceName:sourceName,sectionName:sectionName,dateString:dateString,
				byline:byline,wordCount:wordCount});
		}while (textString.indexOf("<ppsarticle>") != -1);
		
		
	}
	
	
	if (senderCount < filesLimit){
		senderCount++;
		filePath = "data/"+senderCount.toString()+".xml";
		parseFile.send();
	}
	else {
		createCSVFILE4();
		//putToDatabase();
		//getfreq();
	}
}

public function putToDatabase():void {
	senderCount = 0;
	s1 = superArray[senderCount].headline;
	s2 = superArray[senderCount].tailParagraphs;
	s3 = superArray[senderCount].sourceName;
	s4 = superArray[senderCount].sectionName;
	s5 = superArray[senderCount].dateString;
	s6 = superArray[senderCount].byline;
	s7 = superArray[senderCount].wordCount;
	putit.send();
	
}
protected function putit_resultHandler(event:ResultEvent):void
{
	if (senderCount < superArray.length-1){
		senderCount++;
		s1 = superArray[senderCount].headline;
		s2 = superArray[senderCount].tailParagraphs;
		s3 = superArray[senderCount].sourceName;
		s4 = superArray[senderCount].sectionName;
		s5 = superArray[senderCount].dateString;
		s6 = superArray[senderCount].byline;
		s7 = superArray[senderCount].wordCount;
		putit.send();
	}
	else {
		var stop:String = "";
	}
}
public function getfreq():void {
	var csvString:String = "";
	for (var i:uint = 0; i < superArray.length; i++){	
		csvString = csvString + fixBodyText(superArray[i].tailParagraphs) + " ";	
	}
	buildTagCloud(csvString);
}
public function createCSVFILE2():void {
	var csvString:String = "";
	var file:File = File.documentsDirectory;
	file = file.resolvePath("c:/mathewSearchOut.txt");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	csvString = csvString + "daheadlinee" + "@";	
	csvString = csvString + "tailParagraphs" + "@";	
	csvString = csvString + "sourceName" + "@";	
	csvString = csvString + "sectionName" + "@";	
	csvString = csvString + "dateString" + "@";	
	csvString = csvString + "byline" + "@";	
	csvString = csvString + "wordCount" + "\r\n";	
	for (var i:uint = 0; i < superArray.length; i++){
		csvString = csvString + fixBodyText(superArray[i].headline) + "@";	
		csvString = csvString + fixBodyText(superArray[i].tailParagraphs) + "@";	
		csvString = csvString + fixBodyText(superArray[i].sourceName) + "@";	
		csvString = csvString + fixBodyText(superArray[i].sectionName) + "@";	
		csvString = csvString + fixBodyText(superArray[i].dateString) + "@";	
		csvString = csvString + fixBodyText(superArray[i].byline) + "@";	
		csvString = csvString + fixBodyText(superArray[i].wordCount) + "\r\n";	
	}
	fileStream.writeUTFBytes(csvString);
	fileStream.close();
	var jo:String = "";
}
public function createCSVFILE4():void {
	var csvString:String = "";
	var file:File = File.documentsDirectory;
	file = file.resolvePath("c:/matTabFormat.txt");
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	csvString = csvString + "id" + "\t";	
	csvString = csvString + "tailParagraphs" + "\r\n";	
	
	for (var i:uint = 0; i < superArray.length; i++){
		csvString = csvString + i.toString() + "\t";	
		csvString = csvString + superArray[i].tailParagraphs + "\r\n";	
			
	}
	fileStream.writeUTFBytes(csvString);
	fileStream.close();
	var jo:String = "";
}
public var freqArray:ArrayCollection = new ArrayCollection();

private function buildTagCloud(so:String):void
{
	var a:ArrayCollection = new ArrayCollection();
	var s:String = "";
	var last:String = "";
	var n:int = 1;
	var max:int = 1;
	var tempso:String = so;
	do {
		var tt:String = tempso.substring(0,tempso.indexOf(" "));
		if (tt.length > 4){
			a.addItem(tt);
		}
		tempso = tempso.substring(tempso.indexOf(" ")+1,tempso.length);
		
	}while(tempso.indexOf(" ") != -1);
	
	
	
	
	// sort alphabetically
	var sort:Sort = new Sort();
	a.sort = sort;
	a.refresh();
	
	var i:uint = 0;
	// Figure out how many times each word appears
	for(i = 0; i < a.length; i++){
		if(i > 0) // no comparison to do on the first one
		{
			s = a[i].toString();
			
			if(last == s)
			{
				n++;
			}
			else
			{
				// whatever term was last appears n times then reset n
				freqArray.addItem({name:last,count:n});
				n = 1;
			}
		}
		
		last = a[i].toString();   
	}
	
	var stop:String = "";
}
public function fixBodyText(s:String):String {
	
	var j:RegExp;
	var b:String = stripTags(s);	
	j =/\r/gi;
	b = b.replace(j, "");
	j =/'s/gi;
	b = b.replace(j, " ");
	j =/-/gi;
	b = b.replace(j, " ");
	j =/s'/gi;
	b = b.replace(j, " ");
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
	b = b.replace(j, " ");
	
	j =/\t/g;
	b = b.replace(j, " ");
	j =/\n/g;
	b = b.replace(j, " ");
	do {
		b = b.replace(/\s+/g, ' ');
	}while (b.indexOf("  ") != -1);
	
	//j =/ing /gi;
//	b = b.replace(j, " ");
	
//	j =/ed /gi;
	//b = b.replace(j, " ");
	
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
