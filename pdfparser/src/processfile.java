import java.io.BufferedReader;
import java.io.File;
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
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
public class processfile extends NotifyingThread
{
   public String loc;
   public String datafolder;
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public Statement statement = null;
   private PreparedStatement preparedStatement = null;
   public processfile(String loc, String datafolder, java.util.ArrayList<String> dataArray)
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
		System.out.println(tempfile);
    	String rs = "";
    	int counter = 0;
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
				e.printStackTrace();
			}
		} 
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		rs = rs2.toString();
		rs2 = new StringBuilder();
		
		rs = rs.substring(rs.indexOf(">Plaintiff</span")+(">Plaintiff</span").length(), rs.length());
		//do plaintiff stuff here
		
		
		
		rs = rs.substring(rs.indexOf(">Defendant</span")+(">Defendant</span").length(), rs.length());
		//do defendant parsing here
		
		
		rs = rs.substring(rs.indexOf(">Judges</span")+(">Judges</span").length(), rs.length());
		//judges and courts

		
		
		
		String stop = "";
		
		
		
		
    }
	public static String html2text(String html) {
	    return Jsoup.parse(html).text();
	}
}