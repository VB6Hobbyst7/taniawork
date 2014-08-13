/* These functions perform the highlighting requests
when a tag item (from the chapter menu) is selected */
public function highlightText(name:String,occurCount:Number):void {
	highlightTexto = name;
	highlightOccur = occurCount;
}
public function highlight(text:String, query:String, occurence:Number):Vector.<FlowElement> {  
	var result:Vector.<FlowElement> = new Vector.<FlowElement>();
	// since we need to compare ignore-case we can not use split()   
	// and have to collect indexes of "query" matches in "text"   
	
	
	//remove unwanted features from the query
	query = removeUnwanted(query);
	if (query.indexOf("jutlan") != -1){
		var solksjdf:String = "";
	}
	
	
	
	var indexes:Vector.<int> = new Vector.<int>();   
	var index:int = 0;    
	var textLowerCase:String = text.toLowerCase();  
	var queryLowerCase:String = query.toLowerCase();  
	var queryLength:int = query.length;     
	while (true){         
		index = textLowerCase.indexOf(queryLowerCase, index);   
		if (index == -1)             
			break;         
		indexes.push(index);         
		index += queryLength;     
	}    
	// now add SpanElement for each part of text. E.g. if we have    
	// text="aBc" and query is "b" then we add "a" and "c" as simple  
	// span and "B" as highlighted span.  
	
	
	//specia
	
	if (occurence > indexes.length){
		occurence = 1;
	}
	
	
	
	//special
	
	
	
	var backgroundColor:uint = 0xE2752B;   
	var n:int = indexes.length;     
	if (n == 0){         
		addSpan(result, text);     
	}  
	else{    
		var startIndex:int = 0;   
		for (var i:int = 0; i < n; i++){      
			if (startIndex != indexes[i]){
				addSpan(result, text.substring(startIndex, indexes[i]));  
			}
			
			//this is so multiple terms of the same name dont get highlighted
			if (i == (occurence-1)){
				addSpan(result, text.substr(indexes[i], queryLength),              
					backgroundColor);
			}
			else {
				addSpan(result, text.substr(indexes[i], queryLength));
			}
			
			startIndex = indexes[i] + queryLength;         
		}         
		if (startIndex != text.length)            
			addSpan(result, text.substr(startIndex));   
	}
	return result; 
}

public function addSpan(vector:Vector.<FlowElement>, text:String, backgroundColor:* = "transparent"):void {     
	var span:SpanElement = new SpanElement();     
	span.text = text;
	if (backgroundColor != "transparent"){
		span.color = backgroundColor;     
		//span.backgroundColor = backgroundColor;  
	}
	vector.push(span); 
} 
public function removeUnwanted(s:String):String {	
	var text:String = s;
	
	var j:RegExp =new RegExp("\n","g");
	text = text.replace(j, "");
	var j:RegExp =new RegExp("\r","g");
	text = text.replace(j, "");
	
	return text;
}