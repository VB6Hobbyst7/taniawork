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

public class processfileyukonhtml extends NotifyingThread
{
   public String loc;
   public String datafolder;
   @SuppressWarnings("rawtypes")
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public Statement statement = null;

   private PreparedStatement preparedStatement = null;
   public processfileyukonhtml(String loc, String datafolder, java.util.ArrayList<String> dataArray)
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
    	   
		
    
    	if (datafolder == "yukon"){
			String date = "";
		try{
			rs = rs2.toString();
			rs = rs.substring(rs.indexOf("Yukon</"));
			rs = rs.substring(rs.indexOf("<b>")+3);
			//rs = rs.substring(rs.indexOf("<b>")+3);
			date = rs.substring(0,rs.indexOf("<"));
			String day = "";
			String month = "";
			String year = "";
			date = date.substring(date.indexOf(",")+2,date.length());
			month = date.substring(0,date.indexOf(" "));
			date = date.substring(date.indexOf(" ")+1,date.length());
			day = date.substring(0,date.indexOf(" ")-1);
			date = date.substring(date.indexOf(" ")+1,date.length());
			year = date;
			if (year.indexOf(" ")!= -1){
				year = year.substring(0, year.indexOf(" "));
			}
			
			int personalcount = 0;
			do{
				personalcount++;
				
				String temp1 = rs.substring(0,rs.indexOf(":</b>"));
				int index1 = temp1.lastIndexOf("<b>")+3;
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
				text = html2text(text);
				text = fixText(text);
				
				
				if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
					dataArray.add( name+";"+day+";"+month+";"+year+";"+text );
				}
				//System.out.println(personalcount);
				if (personalcount == 83){
					String en33 = "";
				}
				rs = rs.substring(rs.indexOf(":</b>")+5,rs.length());
			}while(rs.indexOf(":</b>") != -1);
			String end = "";
			end = "sdfds";
			end = "sdf";
		
		}
		catch(Exception StringIndexOutOfBoundsException){
			//System.out.println("HUGE ERROR!!! CHECK NOW");	
			String end44 = "";
		}
		}
    	
    	
		
		
		
    }
    public static String fixText(String s){
    	
    	String pattern = "\r";
		s = s.replaceAll(pattern, "");
		pattern = "\n";
		s = s.replaceAll(pattern, "");
		pattern = ";";
		s = s.replaceAll(pattern, "");
		pattern = ",";
		s = s.replaceAll(pattern, "");
		pattern = ">";
		s = s.replaceAll(pattern, "");
		pattern = "<";
		s = s.replaceAll(pattern, "");
		pattern = "/";
		s = s.replaceAll(pattern, "");
		pattern = "'s";
		s = s.replaceAll(pattern, "");
		pattern = "'";
		s = s.replaceAll(pattern, "");
		pattern = ":";
		s = s.replaceAll(pattern, "");
		pattern = "&nbsp;";
		s = s.replaceAll(pattern, "");
		return s;
    }
	public static String html2text(String html) {
	    return Jsoup.parse(html).text();
	}
	
  
  
}