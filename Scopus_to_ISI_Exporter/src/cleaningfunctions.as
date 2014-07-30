// ActionScript file
public function clean2(s:String):String {
	var jd:RegExp;
	jd = new RegExp(";","g");
	s = s.replace(jd," ");
	jd = new RegExp(",","g");
	s = s.replace(jd," ");
	jd = new RegExp("(","g");
	s = s.replace(jd," ");
	jd = new RegExp(")","g");
	s = s.replace(jd," ");
	jd = new RegExp("-","g");
	s = s.replace(jd," ");
	jd = new RegExp("'","g");
	s = s.replace(jd," ");
	jd = new RegExp("\r","g");
	s = s.replace(jd," ");
	jd = new RegExp("\n","g");
	s = s.replace(jd," ");
	jd = new RegExp("\\","g");
	s = s.replace(jd," ");
	jd = new RegExp("\"","g");
	s = s.replace(jd,"");
	jd = new RegExp("/","g");
	s = s.replace(jd," ");
	s = removeperiods(s);
	return trim(s);
}
public function authorFixer(s:String):String {
	var jd:RegExp;
	s = trim(s);
	jd = new RegExp(", ","g");
	s = s.replace(jd,"\n   ").toUpperCase();
	jd = new RegExp("\"","g");
	s = s.replace(jd,"");
	s = removeperiods(s);
	return s;
}
public function sourcefullclean(s:String):String {
	var jd:RegExp;
	jd = new RegExp("\"","g");
	s = s.replace(jd,"");
	s = trim(s);
	s = removeperiods(s);
	s = s.toUpperCase();
	return s;
}
public function sourceabvclean1(s:String):String {
	var jd:RegExp;
	jd = new RegExp("\"","g");
	s = s.replace(jd,"");
	s = trim(s);
	s = removeperiods(s);
	s = s.toUpperCase();
	return s.toUpperCase();;
}

public function sourceabvclean2(s:String):String {
	
	var jd:RegExp;
	jd = new RegExp("\"","g");
	s = s.replace(jd,"");
	s = trim(s);
	s = removeperiods(s);
	jd = new RegExp(" ","g");
	s = s.replace(jd,". ");
	s = s+".";
	return s;
}
public function authorCitationFixer(s:String):String {
	var jd:RegExp;
	jd = new RegExp(",","g");
	s = s.replace(jd,"").toUpperCase();
	jd = new RegExp("\"","g");
	s = s.replace(jd,"");
	s = removeperiods(s);
	return trim(s);
}
public function trim( s:String ):String
{
	return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
}
public function clean(s:String):String {
	var jd:RegExp;
	jd = new RegExp(";","g");
	s = s.replace(jd," ");
	jd = new RegExp(",","g");
	s = s.replace(jd," ");
	jd = new RegExp("(","g");
	s = s.replace(jd," ");
	jd = new RegExp(")","g");
	s = s.replace(jd," ");
	jd = new RegExp("-","g");
	s = s.replace(jd," ");
	jd = new RegExp("'","g");
	s = s.replace(jd," ");
	jd = new RegExp("\r","g");
	s = s.replace(jd," ");
	jd = new RegExp("\n","g");
	s = s.replace(jd," ");
	jd = new RegExp("\\","g");
	s = s.replace(jd," ");
	jd = new RegExp("/","g");
	s = s.replace(jd," ");
	s = removeperiods(s);
	return trim(s);
}
public function abstractclean(s:String):String {
	var jd:RegExp;
	jd = new RegExp("1.","g");
	s = s.replace(jd,"");
	jd = new RegExp(":","g");
	s = s.replace(jd,"");
	jd = new RegExp("1.","g");
	s = s.replace(jd,"");
	jd = new RegExp("2.","g");
	s = s.replace(jd,"");				
	jd = new RegExp("3.","g");
	s = s.replace(jd,"");				
	jd = new RegExp("4.","g");
	s = s.replace(jd,"");				
	jd = new RegExp("5.","g");
	s = s.replace(jd,"");			
	jd = new RegExp("6.","g");
	s = s.replace(jd,"");
	jd = new RegExp("7.","g");
	s = s.replace(jd,"");
	jd = new RegExp("8.","g");
	s = s.replace(jd,"");
	jd = new RegExp("\"","g");
	s = s.replace(jd," ");
	jd = new RegExp("9.","g");
	s = s.replace(jd,"");
	jd = new RegExp("0.","g");
	s = s.replace(jd,"");
	jd = new RegExp("1","g");
	s = s.replace(jd,"");
	jd = new RegExp("2","g");
	s = s.replace(jd,"");
	jd = new RegExp("3","g");
	s = s.replace(jd,"");
	jd = new RegExp("4","g");
	s = s.replace(jd,"");
	jd = new RegExp("5","g");
	s = s.replace(jd,"");
	jd = new RegExp("6","g");
	s = s.replace(jd,"");
	jd = new RegExp("7","g");
	s = s.replace(jd,"");
	jd = new RegExp("8","g");
	s = s.replace(jd,"");
	jd = new RegExp("8","g");
	s = s.replace(jd,"");
	jd = new RegExp("0","g");
	s = s.replace(jd,"");
	jd = new RegExp(" THE ","g");
	s = s.replace(jd," ");
	jd = new RegExp(" A ","g");
	s = s.replace(jd," ");	
	jd = new RegExp(" IS ","g");
	s = s.replace(jd," ");			
	jd = new RegExp(" WHAT ","g");
	s = s.replace(jd," ");				
	jd = new RegExp(" BY ","g");
	s = s.replace(jd," ");				
	jd = new RegExp(" IN ","g");
	s = s.replace(jd," ");
	jd = new RegExp(" OF ","g");
	s = s.replace(jd," ");
	jd = new RegExp(" AND ","g");
	s = s.replace(jd," ");
	jd = new RegExp(" BUT ","g");
	s = s.replace(jd," ");
	jd = new RegExp(" OR ","g");
	s = s.replace(jd," ");
	jd = new RegExp(" THAN ","g");
	s = s.replace(jd," ");
	jd = new RegExp(" TO ","g");
	s = s.replace(jd," ");
	s = removeperiods(s);
	s = s.replace(/[~%&\\;:"',<>?#\]/g,"")
	return trim(s);
}
public function removeperiods(s:String):String{
	var temps:String = "";
	if (s.indexOf(".") != -1){
		do {
			temps = temps + s.substr(0,s.indexOf("."));
			s = s.substr(s.indexOf(".")+1,s.length);
		}while (s.indexOf(".") != -1);
	}
	else {
		temps = s;
	}
	return temps;
}
public function getIndexOfYearBrackets(s:String):Number{
	var originals:String = s;
	do {
		var tempindex:Number = s.indexOf("(");
		s = s.substring(s.indexOf("(")+1,s.length);
		var temp4:Object = s.substr(0,4);
		if (!isNaN(Number(temp4))){
			return originals.indexOf("("+temp4+")");
		}		
	}while (s.indexOf("(") != -1);
	return -1;
}
















