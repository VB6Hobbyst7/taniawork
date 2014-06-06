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

public class processLargeCsv extends NotifyingThread
{
   public String loc;
  
   @SuppressWarnings("rawtypes")
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public Statement statement = null;
   private PreparedStatement preparedStatement = null;
   public processLargeCsv(String loc, String datafolder, java.util.ArrayList<String> dataArray)
   {
      this.loc = loc;
      
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
    	   
		
    
    
			String date = "";
		try{
			rs = rs2.toString();
			
		}
		catch(Exception StringIndexOutOfBoundsException3){
				System.out.println("missed one");	
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