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

public class processfilenwt extends NotifyingThread
{
   public String loc;
   public String datafolder;
   @SuppressWarnings("rawtypes")
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public Statement statement = null;
   private PreparedStatement preparedStatement = null;
   public processfilenwt(String loc, String datafolder, java.util.ArrayList<String> dataArray)
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
    	   
    
    	if (datafolder == "nwt"){
			String date = "";
		try{
			rs = rs2.toString();
			rs = rs.substring(rs.indexOf("HANSARD"));
			rs = rs.substring(rs.indexOf("\r\n")+2);
			date = rs.substring(0,rs.indexOf("\r\n"));
			//String pattern2 = ",";
			//date = date.replaceAll(pattern2, ""); 
			String day = "";
			String month = "";
			String year = "";
			date = date.substring(date.indexOf(",")+2,date.length());
			month = date.substring(0,date.indexOf(" "));
			date = date.substring(date.indexOf(" ")+1,date.length());
			day = date.substring(0,date.indexOf(" ")-1);
			date = date.substring(date.indexOf(",")+2,date.length());
			year = date.substring(0,date.indexOf(" "));;
			int personalcount = 0;
			if (rs.indexOf("Members Present") != -1){
				rs = rs.substring(rs.indexOf("Members Present")+20,rs.length());
					rs = rs.substring(rs.toLowerCase().indexOf("prayer")+6,rs.length());
			
			do{
				personalcount++;
				
				
			
				
				String temprs = rs.substring(0, rs.indexOf(":"));
				int lastreturnindex = temprs.lastIndexOf("\r\n");
				
				rs = rs.substring(lastreturnindex+1,rs.length());
				//rs = rs.substring(rs.indexOf(">")+1,rs.length());
				String name = rs.substring(0,rs.indexOf(":"));
				
				String text = rs.substring(rs.indexOf(":")+1,rs.length());
					
				
				rs = rs.substring(rs.indexOf(":")+1);
				
				String temprs2 = rs.substring(0, rs.indexOf(":"));
			
				int lastreturnindex2 = temprs2.lastIndexOf("\r\n");
				text = text.substring(0,lastreturnindex2);
				rs = rs.substring(lastreturnindex2+2,rs.length());
				
				
				
			
				//	text = html2text(text);
					String pattern = "&nbsp;";
					text = text.replaceAll(pattern, ""); 
				
					text = fixText(text);
					pattern = ";";
					name = name.replaceAll(pattern, "");
					pattern = "\n";
					name = name.replaceAll(pattern, "");
					pattern = "/n";
					name = name.replaceAll(pattern, "");
					pattern = "\r";
					name = name.replaceAll(pattern, "");
					pattern = "/r";
					name = name.replaceAll(pattern, "");
					if(name.matches(".*\\d.*")){
						   // contains a number
						} else{
							if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
								dataArray.add( name+";"+day+";"+month+";"+year+";"+text+";;;;" );
							}
						}
					
					
					
			
			}while(rs.indexOf(":") != -1);
			}
			@SuppressWarnings("unused")
			String end = "";
			end = "sdfds";
			end = "sdf";
		
		}
		catch(Exception StringIndexOutOfBoundsException){
			//System.out.println("v2 used");	
			try{
				rs = rs2.toString();
			rs = rs.substring(rs.indexOf("</style>"));
			rs = rs.substring(rs.indexOf("<H4"));
			rs = rs.substring(rs.indexOf(">")+1);
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
			@SuppressWarnings("unused")
			String text = "";
			int personalcount = 0;
			do{
				personalcount++;
				rs = rs.substring(rs.indexOf("&nbsp;&nbsp;&nbsp;&nbsp;<b>")+11,rs.length());
				rs = rs.substring(rs.indexOf(">")+1,rs.length());
				String name = rs.substring(0,rs.indexOf("<"));
				if (name.indexOf(":")!= -1){
					//name = name.substring(0,name.indexOf("<"));
					text = "";
					text = rs.substring(rs.indexOf(">")+1,rs.length());
					int tempind = text.indexOf("&nbsp;&nbsp;&nbsp;&nbsp;<b>");
					if (tempind != -1){
						text = text.substring(0,tempind);
						text = text.substring(0,text.lastIndexOf(">")+1);
					}
					text = html2text(text);
					String pattern = "&nbsp;";
					text = text.replaceAll(pattern, ""); 
					if ((text.indexOf("<") != -1)&&(text.indexOf(">") != -1)){
						do{
							String beforetext = text.substring(0,text.indexOf("<"));
							String aftertext = text.substring(text.indexOf(">")+1,text.length());
							text = beforetext + " " + aftertext;
							
						}while((text.indexOf("<") != -1)&&(text.indexOf(">") != -1));
					}
					text = fixText(text);
					pattern = ";";
					name = name.replaceAll(pattern, "");
					pattern = "\n";
					name = name.replaceAll(pattern, "");
					pattern = "/n";
					name = name.replaceAll(pattern, "");
					pattern = "\r";
					name = name.replaceAll(pattern, "");
					pattern = "/r";
					name = name.replaceAll(pattern, "");
					if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
						dataArray.add( name+";"+day+";"+month+";"+year+";"+text+";;;;" );
					}
				}
				else {
					//bad
				}
			}while(rs.indexOf("&nbsp;&nbsp;&nbsp;&nbsp;<b>") != -1);
			@SuppressWarnings("unused")
			String end = "";
			end = "sdfds";
			end = "sdf";
			}
			catch(Exception StringIndexOutOfBoundsException1){
			
				try{
					rs = rs2.toString();
					rs = rs.substring(rs.indexOf("</style>"));
					rs = rs.substring(rs.indexOf("<H4"));
					rs = rs.substring(rs.indexOf(">")+1);
					rs = rs.substring(rs.indexOf("<H2"));
					rs = rs.substring(rs.indexOf(">")+1);
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
					@SuppressWarnings("unused")
					String text = "";
					int personalcount = 0;
					do{
						personalcount++;
						rs = rs.substring(rs.indexOf("&nbsp;&nbsp;&nbsp;&nbsp;<b>")+11,rs.length());
						rs = rs.substring(rs.indexOf(">")+1,rs.length());
						String name = rs.substring(0,rs.indexOf("<"));
						if (name.indexOf(":")!= -1){
							//name = name.substring(0,name.indexOf("<"));
							text = "";
							text = rs.substring(rs.indexOf(">")+1,rs.length());
							int tempind = text.indexOf("&nbsp;&nbsp;&nbsp;&nbsp;<b>");
							if (tempind != -1){
								text = text.substring(0,tempind);
								text = text.substring(0,text.lastIndexOf(">")+1);
							}
							text = html2text(text);
							String pattern = "&nbsp;";
							text = text.replaceAll(pattern, ""); 
							if ((text.indexOf("<") != -1)&&(text.indexOf(">") != -1)){
								do{
									String beforetext = text.substring(0,text.indexOf("<"));
									String aftertext = text.substring(text.indexOf(">")+1,text.length());
									text = beforetext + " " + aftertext;
									
								}while((text.indexOf("<") != -1)&&(text.indexOf(">") != -1));
							}
							text = fixText(text);
							pattern = ";";
							name = name.replaceAll(pattern, "");
							pattern = "\n";
							name = name.replaceAll(pattern, "");
							pattern = "/n";
							name = name.replaceAll(pattern, "");
							pattern = "\r";
							name = name.replaceAll(pattern, "");
							pattern = "/r";
							name = name.replaceAll(pattern, "");
							if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
								dataArray.add( name+";"+day+";"+month+";"+year+";"+text+";;;;" );
							}	
						}
						else {
							//bad
						}
						
					}while(rs.indexOf("&nbsp;&nbsp;&nbsp;&nbsp;<b>") != -1);
				}
				catch(Exception StringIndexOutOfBoundsException2){
					try{
						rs = rs2.toString();
						rs = rs.substring(rs.indexOf("Canada Flag Image PlaceHolder"));
						rs = rs.substring(rs.indexOf("<H4"));
						rs = rs.substring(rs.indexOf(">")+1);
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
						@SuppressWarnings("unused")
						String text = "";
						int personalcount = 0;
						do{
							personalcount++;
							rs = rs.substring(rs.indexOf("<P align=left><B>")+16,rs.length());
							rs = rs.substring(rs.indexOf(">")+1,rs.length());
							String name = rs.substring(0,rs.indexOf("<"));
							if (name.indexOf(":")!= -1){
								//name = name.substring(0,name.indexOf("<"));
								text = "";
								text = rs.substring(rs.indexOf(">")+1,rs.length());
								int tempind = text.indexOf("<P align=left><B>");
								if (tempind != -1){
									text = text.substring(0,tempind);
									text = text.substring(0,text.lastIndexOf(">")+1);
								}
								text = html2text(text);
								String pattern = "&nbsp;";
								text = text.replaceAll(pattern, ""); 
								if ((text.indexOf("<") != -1)&&(text.indexOf(">") != -1)){
									do{
										String beforetext = text.substring(0,text.indexOf("<"));
										String aftertext = text.substring(text.indexOf(">")+1,text.length());
										text = beforetext + " " + aftertext;
										
									}while((text.indexOf("<") != -1)&&(text.indexOf(">") != -1));
								}
								text = fixText(text);
								pattern = ";";
								name = name.replaceAll(pattern, "");
								pattern = "\n";
								name = name.replaceAll(pattern, "");
								pattern = "/n";
								name = name.replaceAll(pattern, "");
								pattern = "\r";
								name = name.replaceAll(pattern, "");
								pattern = "/r";
								name = name.replaceAll(pattern, "");
								if ((name.length() > 3)&&(day.length() != 0)&&(month.length() > 1)&&(year.length() >= 3)&&(text != "")){
									dataArray.add( name+";"+day+";"+month+";"+year+";"+text+";;;;" );
								}	
							}
							else {
								//bad
							}
							
						}while(rs.indexOf("<P align=left><B>") != -1);
					}
					catch(Exception StringIndexOutOfBoundsException3){
						System.out.println("missed one");	
					}
				}
			}
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