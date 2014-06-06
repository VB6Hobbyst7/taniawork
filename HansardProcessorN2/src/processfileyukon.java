import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;
import com.sun.xml.internal.bind.v2.schemagen.xmlschema.List;

public class processfileyukon extends NotifyingThread
{
   public String loc;
   public String datafolder;
   @SuppressWarnings("rawtypes")
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public Statement statement = null;
   private PreparedStatement preparedStatement = null;
   public processfileyukon(String loc, String datafolder, java.util.ArrayList<String> dataArray)
   {
      this.loc = loc;
      this.datafolder = datafolder;
      this.dataArray = dataArray;
   }
   @Override
   public void doRun() {   
	   process(this.loc);	
   }
	public void process(String tempfile){
		Boolean atleastonce = false;
    	String rs = "";
    	StringBuilder rs2 = new StringBuilder();
    	 BufferedReader reader;
		try {
		
			reader = new BufferedReader( new FileReader (tempfile));
			 String         line = null;
	    	    String ls = System.getProperty("line.separator");

	    	    try {
					while( ( line = reader.readLine() ) != null ) {
					    rs2.append( line );
					    rs2.append( ls );
					}
					
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		} 
		catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	   
    
    	Boolean special = false;
		String date = "";
		try{
			rs = rs2.toString();
			
			String filename = tempfile.substring(tempfile.lastIndexOf("/")+1, tempfile.length());
			String day = "";
			String month = "";
			String year = "";
			String datesection = "";
			if ((filename.contains("hansard"))||(filename.contains(".txt"))){
				
				if (filename.indexOf(".html") != -1){
					special = true;
					rs = rs.substring(rs.indexOf("begin content"),rs.length());
				}
				else {
					
					//rs = rs.substring(rs.indexOf("begin content"),rs.length());
				}
					
				if (filename.indexOf("out3") != -1){
					int adsfsd3 = 2;
				}
				
				
				datesection = rs.substring(0, 300);
				Boolean weekdayfound = false;
				if (datesection.toLowerCase().contains("monday")){
					weekdayfound = true;
					datesection = datesection.substring(datesection.toLowerCase().indexOf("monday"));
				}
				else if (datesection.toLowerCase().contains("tuesday")){
					weekdayfound = true;
					datesection = datesection.substring(datesection.toLowerCase().indexOf("tuesday"));
				}
				else if (datesection.toLowerCase().contains("wednesday")){
					weekdayfound = true;
					datesection = datesection.substring(datesection.toLowerCase().indexOf("wednesday"));			
				}
				else if (datesection.toLowerCase().contains("thursday") ){
					weekdayfound = true;
					datesection = datesection.substring(datesection.toLowerCase().indexOf("thursday"));
				}
				else if (datesection.toLowerCase().contains("friday") ){
					weekdayfound = true;
					datesection = datesection.substring(datesection.toLowerCase().indexOf("friday"));
				}
				else if (datesection.toLowerCase().contains("saturday") ){
					weekdayfound = true;
					datesection = datesection.substring(datesection.toLowerCase().indexOf("saturday"));
				}
				else if (datesection.toLowerCase().contains("sunday") ){
					weekdayfound = true;
					datesection = datesection.substring(datesection.toLowerCase().indexOf("sunday"));
				}
				
				
				date = datesection;
				date = date.replaceAll(",", " ");
				date =  date.replaceAll("^ +| +$|( )+", " ");
				if (weekdayfound){
					date = date.substring(date.indexOf(" ")+1,date.length());
				}
			
				month = date.substring(0,date.indexOf(" "));
				date = date.substring(date.indexOf(" ")+1,date.length());
				day = date.substring(0,date.indexOf(" "));
				date = date.substring(date.indexOf(" ")+1,date.length());
				year = date;
				if (year.length() > 4){
					year = year.substring(0, 4);
				}
			}
			else {
				date = filename;
				
				date = date.substring(date.indexOf("_")+1,date.length());
				month = date.substring(0,date.indexOf("_"));
				date = date.substring(date.indexOf("_")+1,date.length());
				day = date.substring(0,date.indexOf("_"));
				date = date.substring(date.indexOf("_")+1,date.length());
				year = date;
				if (year.length() > 4){
					year = year.substring(0, 4);
				}
				
			}
		
			
			
			
			
			
			int personalcount = 0;
			int contextid = 0;
			System.out.println(filename);
			if (filename.indexOf(".txt") != -1){
				rs = rs.replaceAll("[0-9]:", "");
				rs = rs.substring(rs.toLowerCase().indexOf("yukon")+5,rs.length());
				//rs = rs.substring(rs.toLowerCase().indexOf("prayer")+6,rs.length());
				do{
					String temprs = rs;
					String name = "";
					//starting point looping through all colons till name is found
					do{
						String temprs2 = temprs.substring(0, temprs.indexOf(":"));
						int lastreturnindex = temprs2.lastIndexOf("\r\n");		
						temprs = temprs.substring(lastreturnindex+1,temprs.length());
						name = temprs.substring(0,temprs.indexOf(":"));
						temprs = temprs.substring(temprs.indexOf(":")+1, temprs.length());
						
					}while (isGoodName(name) == false);
					
					//ending point. looping through following colons till next name is found
					String text = temprs;
					String temprs3 = temprs;
					String name2 = "";
					do{
						String temprs2 = temprs3.substring(0, temprs3.indexOf(":"));
						int lastreturnindex = temprs2.lastIndexOf("\r\n");		
						temprs3 = temprs3.substring(lastreturnindex+1,temprs3.length());
						name2 = temprs3.substring(0,temprs3.indexOf(":"));
						temprs3 = temprs3.substring(temprs3.indexOf(":")+1, temprs3.length());
						
					}while (isGoodName(name2) == false);
					
					text = text.substring(0, text.length()-temprs3.length()- name2.length());
					
					
					
					String pattern = "&nbsp;";
					text = text.replaceAll(pattern, ""); 				
					text = fixText(text).toLowerCase();
					name = fixText(name).toLowerCase();
					year = fixText(year).toLowerCase();
					month = fixText(month);
					day = fixText(day).toLowerCase();
					
					if ((day.length() < 1)){
						
						String stopsdf = "";
					}
				
					if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
						dataArray.add(contextid+";"+ name+";"+day+";"+month+";"+year+";"+text+";none" );
						atleastonce = true;
					}
					else if (name.length() <= 3){
						dataArray.add(contextid+";"+ "none"+";"+day+";"+month+";"+year+";"+text+";none" );
					}
					else {
					String asdfsdf = "";	
					}

					contextid++;
					rs = temprs;
				}while(rs.indexOf(":") != -1);
			}
			else if (filename.indexOf(".html") != -1){
				if (special){
					
					
				}
				
				
				
				
				
				if (rs.contains("Yukon</")){
					rs = rs.substring(rs.indexOf("Yukon</"));
				}
				else if (rs.contains("Yukon </")){
					rs = rs.substring(rs.indexOf("Yukon </"));
				}
				else {
					int y = 0;
				}
				
				rs = rs.toLowerCase();
				rs = rs.replaceAll("<span>", "");
				rs = rs.replaceAll("</span>", "");
				rs = rs.replaceAll(": </b>", ":</b>");
				Whitelist wi = new Whitelist();
				wi.addTags("b");
			
				rs = Jsoup.clean(rs, wi);
				rs = rs.replaceAll("<b></b>", "");
				rs = rs.replaceAll("<b> </b>", "");
				rs = rs.replaceAll("<b>  </b>", "");
				rs = rs.replaceAll("<b>  </b>", "");
				rs = rs.replaceAll("<b>:</b>", "");
				 rs = rs.replaceAll("^ +| +$|( )+", "$1");
				
				/*rs = rs.replaceAll("<p class=CAPTION-ALLCAPS style='text-indent:0in'>", "");
				rs = rs.replaceAll("<font size=2>", "");
				rs = rs.replaceAll("<font face=\"arial\" size=2>", "");
				rs = rs.replaceAll("<p>", "");
				rs = rs.replaceAll("<font face=\"arial\">", "");
				rs = rs.replaceAll("<font face=\"arial\" size=3>", "");
				rs = rs.replaceAll("<p align=\"justify\">", "");
				rs = rs.replaceAll("<P>", "");
				rs = rs.replaceAll("<i>", "");
				rs = rs.replaceAll("</i>", "");
				rs = rs.replaceAll("<I>", "");
				rs = rs.replaceAll("</I>", "");
				rs = rs.replaceAll("</p>", "");
				rs = rs.replaceAll("</P>", "");
				rs = rs.replaceAll("</font>", "");
				rs = rs.replaceAll("</FONT>", "");
				rs = rs.replaceAll("<FONT>", "");
				
				rs = rs.replaceAll("<p", "");
				rs = rs.replaceAll("<span lang=EN-CA", "");
				
				rs = rs.replaceAll("<font size=\"0\">", "");
				rs = rs.replaceAll("<font size=\"1\">", "");
				rs = rs.replaceAll("<font size=\"2\">", "");
				rs = rs.replaceAll("<FONT SIZE=\"2\">", "");
				rs = rs.replaceAll("<font size=\"3\">", "");
				rs = rs.replaceAll("<font size=\"4\">", "");
				rs = rs.replaceAll("<span", "");
				rs = rs.replaceAll("lang=EN-CA>", "");
				rs = rs.replaceAll("B>", "b>");
				rs = rs.replaceAll("&#8195;", "");
				rs = rs.replaceAll("&#8194;", "");*/
				if (rs.contains("<b>")){
					rs = rs.substring(rs.indexOf("<b>")+3);
				
				}
				else {
					rs = rs2.toString();
					rs = rs.replaceAll("[0-9]:", "");
					rs = rs.replaceAll("<p", "<b");
					rs = rs.replaceAll("p>", "b>");
					rs = rs.toLowerCase();
					rs = rs.replaceAll("<span>", "");
					rs = rs.replaceAll("</span>", "");
					rs = rs.replaceAll(": </b>", ":</b>");
					Whitelist wi2 = new Whitelist();
					wi2.addTags("b");
				
					rs = Jsoup.clean(rs, wi2);
					rs = rs.replaceAll("<b></b>", "");
					rs = rs.replaceAll("<b> </b>", "");
					rs = rs.replaceAll("<b>  </b>", "");
					rs = rs.replaceAll("<b>  </b>", "");
					rs = rs.replaceAll("<b>:</b>", "");
					rs = rs.replaceAll("<b><b>", "<b>");
					rs = rs.replaceAll("</b></b>", "</b>");
					
					
					 rs = rs.replaceAll("^ +| +$|( )+", "$1");
					
					rs = rs.substring(rs.indexOf("<b>")+3);
				}
			
				
				
				
				
				
				
				do{
					
					if (filename.compareTo("104_May_10_1994") == 0){
						int af3 = 2;
					}
					personalcount++;
					String temp1 ="";
					String magicchar = "";
					if ((rs.toLowerCase().contains(":</b>"))&&(rs.toLowerCase().contains("</b>:"))){
						if (rs.toLowerCase().indexOf(":</b>") < rs.toLowerCase().indexOf("</b>:")){
							magicchar = ":</b>";
						}
						else {
							magicchar = "</b>:";
						}
						
					}
					else if (rs.toLowerCase().contains(":</b>")){
						magicchar = ":</b>";	
					}
					else if (rs.toLowerCase().contains("</b>:")){
						magicchar = "</b>:";	
					}
					else if (rs.toLowerCase().contains(": </b>")){
						magicchar = ": </b>";	
					}
					else {
						magicchar = "</b>";	
					}
					
					temp1 = rs.substring(0,rs.toLowerCase().indexOf(magicchar));
					
					int index1 = temp1.lastIndexOf("<b>")+3;
					
					if (index1 <= 2){
						index1 = temp1.lastIndexOf("\n")+1;
					
					}
					rs = rs.substring(index1,rs.length());
					String name = rs.substring(0,rs.indexOf("<"));
					
					String text = rs.substring(rs.indexOf(">")+2,rs.length());
					try{
						text = text.substring(0, text.indexOf(":</b>"));
						text = text.substring(0, text.lastIndexOf("<b>"));
					}
					catch(Exception StringIndexOutOfBoundsException){
						
					}
				
					
					if (text.indexOf("<h") != -1){
						text = text.substring(0, text.indexOf("<h"));
					}
					
				//	text = html2text(text);
					text = fixText(text).toLowerCase();
					name = fixText(name).toLowerCase();
					year = fixText(year);
					month = fixText(month);
					
					
					if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
						dataArray.add(contextid+";"+ name+";"+day+";"+month+";"+year+";"+text+";none" );
						atleastonce = true;
					}
					else if (name.length() <= 3){
						dataArray.add(contextid+";"+ "none"+";"+day+";"+month+";"+year+";"+text+";none" );
					}
					else {
					String asdfsdf = "";	
					}
					//System.out.println(personalcount);
					if (personalcount == 83){
						String en33 = "";
					}
					rs = rs.substring(rs.indexOf(":</b>")+5,rs.length());
					contextid++;
				}while(rs.indexOf(":</b>") != -1);
				
			}
			
			
			
			
			
		
		}
		catch(Exception StringIndexOutOfBoundsException){
		if (atleastonce == false){
			
			System.out.println("FILE FAILE : "+tempfile);
		}
			
		}
	
    	
    	
		
		
		
    }
	public static Boolean isGoodName(String name){
		
		if ((name.toLowerCase().indexOf(")") != -1)||
				(name.toLowerCase().indexOf("(") != -1)||
				(name.toLowerCase().indexOf("mr") != -1)||
				(name.toLowerCase().indexOf("the") != -1)||
				(name.toLowerCase().indexOf(")") != -1)||
				(name.toLowerCase().indexOf(")") != -1)||
				(name.toLowerCase().indexOf(")") != -1)||
				(name.toLowerCase().indexOf(")") != -1)){
			
		return true;
		}
		return false;
		
	}
    public static String fixText(String s){
    	
    	
    	String pattern = "\r";
		s = s.replaceAll(pattern, " ");
		pattern = "\n";
		s = s.replaceAll(pattern, " ");
		
		
		pattern = " It ";
		s = s.replaceAll(pattern, " ");
		pattern = " it ";
		s = s.replaceAll(pattern, " ");
		pattern = " is ";
		s = s.replaceAll(pattern, " ");
		pattern = " at ";
		s = s.replaceAll(pattern, " ");
		pattern = " of ";
		s = s.replaceAll(pattern, " ");
		pattern = " the ";
		s = s.replaceAll(pattern, " ");
		pattern = " we ";
		s = s.replaceAll(pattern, " ");
		pattern = " We ";
		s = s.replaceAll(pattern, " ");
		pattern = " The ";
		s = s.replaceAll(pattern, " ");
		pattern = " but ";
		s = s.replaceAll(pattern, " ");
		pattern = " am ";
		s = s.replaceAll(pattern, " ");
		pattern = " in ";
		s = s.replaceAll(pattern, " ");
		pattern = " have ";
		s = s.replaceAll(pattern, " ");
		pattern = " not ";
		s = s.replaceAll(pattern, " ");
		pattern = " that ";
		s = s.replaceAll(pattern, " ");
		pattern = " I ";
		s = s.replaceAll(pattern, " ");
		pattern = " to ";
		s = s.replaceAll(pattern, " ");
		pattern = " and ";
		s = s.replaceAll(pattern, " ");
		pattern = " for ";
		s = s.replaceAll(pattern, " ");
		pattern = " by ";
		s = s.replaceAll(pattern, " ");
		pattern = " not ";
		s = s.replaceAll(pattern, " ");
		pattern = " too ";
		s = s.replaceAll(pattern, " ");
		pattern = " my ";
		s = s.replaceAll(pattern, " ");
		pattern = " my ";
		s = s.replaceAll(pattern, " ");
		
		
		
		pattern = ";";
		s = s.replaceAll(pattern, " ");
		pattern = ",";
		s = s.replaceAll(pattern, " ");
		pattern = ">";
		s = s.replaceAll(pattern, " ");
		pattern = "<";
		s = s.replaceAll(pattern, " ");
		pattern = "/";
		s = s.replaceAll(pattern, " ");
		pattern = "'s";
		s = s.replaceAll(pattern, " ");
		pattern = "'";
		s = s.replaceAll(pattern, " ");
		pattern = ":";
		s = s.replaceAll(pattern, " ");
		pattern = "&nbsp;";
		s = s.replaceAll(pattern, " ");
		pattern = "-";
		s = s.replaceAll(pattern, " ");
		pattern = "/n";
		s = s.replaceAll(pattern, " ");
		pattern = "\r";
		s = s.replaceAll(pattern, " ");
		pattern = "\\.";
		s = s.replaceAll(pattern, " ");
		pattern = "\"";
		s = s.replaceAll(pattern, " ");
		pattern = "\\?";
		s = s.replaceAll(pattern, " ");
		pattern = "\\)";
		s = s.replaceAll(pattern, " ");
		pattern = "\\(";
		s = s.replaceAll(pattern, " ");
		pattern = "Monday";
		s = s.replaceAll(pattern, " ");
		s = s.replaceAll("[-+.^:,]"," ");
		s = s.replaceAll("[\\-\\+\\.\\^:,]"," ");
		
		s = s.replaceAll("[^\\x20-\\x7e]", " ");
		
		
		s = s.replaceAll("^ +| +$|( )+", "$1");

		return s;
    }
    
	public static String html2text(String html) {
	    return Jsoup.parse(html).text();
	}
	
  
  
}