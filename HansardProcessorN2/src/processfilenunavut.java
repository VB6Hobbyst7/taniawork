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

import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;
import com.sun.xml.internal.bind.v2.schemagen.xmlschema.List;

public class processfilenunavut extends NotifyingThread
{
   public String loc;
   public String datafolder;
   @SuppressWarnings("rawtypes")
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public Statement statement = null;
   private PreparedStatement preparedStatement = null;
   public processfilenunavut(String loc, String datafolder, java.util.ArrayList<String> dataArray)
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
    	   
    
    	if (datafolder == "nunavut"){
			String date = "";
		try{
			rs = rs2.toString();
			rs = rs.substring(rs.indexOf("HANSARD"));
			//rs = rs.substring(rs.indexOf("\r\n")+2);
			//rs = rs.substring(rs.indexOf("\r\n")+2);
			//rs = rs.substring(rs.indexOf("\r\n")+2);
			
			
			
			String datesection = rs.substring(0, 300);
			
			if (datesection.toLowerCase().contains("monday")){
				datesection = datesection.substring(datesection.toLowerCase().indexOf("monday"));
			}
			else if (datesection.toLowerCase().contains("tuesday")){
				datesection = datesection.substring(datesection.toLowerCase().indexOf("tuesday"));
			}
			else if (datesection.toLowerCase().contains("wednesday")){
				datesection = datesection.substring(datesection.toLowerCase().indexOf("wednesday"));			
			}
			else if (datesection.toLowerCase().contains("thursday") ){
				datesection = datesection.substring(datesection.toLowerCase().indexOf("thursday"));
			}
			else if (datesection.toLowerCase().contains("friday") ){
				datesection = datesection.substring(datesection.toLowerCase().indexOf("friday"));
			}
			else if (datesection.toLowerCase().contains("saturday") ){
				datesection = datesection.substring(datesection.toLowerCase().indexOf("saturday"));
			}
			else if (datesection.toLowerCase().contains("sunday") ){
				datesection = datesection.substring(datesection.toLowerCase().indexOf("sunday"));
			}
			
			
			date = datesection;
			
			
			
			//date = rs.substring(0,rs.indexOf("\r\n"));
			//String pattern2 = ",";
			//date = date.replaceAll(pattern2, ""); 
			String day = "";
			String month = "";
			String year = "";
			date = date.substring(date.indexOf(" ")+1,date.length());
			month = date.substring(0,date.indexOf(" "));
			date = date.substring(date.indexOf(" ")+1,date.length());
			day = date.substring(0,date.indexOf(" ")-1);
			date = date.substring(date.indexOf(",")+2,date.length());
			year = date;
			if (year.length() > 4){
				year = year.substring(0, 4);
			}
			int personalcount = 0;
			if (rs.indexOf("Nunavut Hansard") != -1){
				rs = rs.substring(rs.indexOf("Nunavut Hansard ")+15,rs.length());
					rs = rs.substring(rs.toLowerCase().indexOf("prayer")+6,rs.length());
			int contextid = 0;
			do{
			
				
				/*personalcount++;
				String temprs = rs.substring(0, rs.indexOf(":"));
				int lastreturnindex = temprs.lastIndexOf("\r\n");
				rs = rs.substring(lastreturnindex+1,rs.length());
				String name = rs.substring(0,rs.indexOf(":"));
				String text = rs.substring(rs.indexOf(":")+1,rs.length());
				rs = rs.substring(rs.indexOf(":")+1);
				String temprs2 = rs.substring(0, rs.indexOf(":"));
				int lastreturnindex2 = temprs2.lastIndexOf("\r\n");
				text = text.substring(0,lastreturnindex2);
				rs = rs.substring(lastreturnindex2+2,rs.length());				
			*/
				
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
			
				//if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
					dataArray.add(contextid+";"+ name+";"+day+";"+month+";"+year+";"+text+";none" );
				//}
					
				
				
				
				contextid++;
				rs = temprs;
			}while(rs.indexOf(":") != -1);
			}
			@SuppressWarnings("unused")
			String end = "";
			end = "sdfds";
			end = "sdf";
		
		}
		catch(Exception StringIndexOutOfBoundsException){
		
			System.out.println("error");
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