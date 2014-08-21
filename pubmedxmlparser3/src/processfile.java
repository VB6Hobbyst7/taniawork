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
		do{
			rs = rs.substring(rs.indexOf("PubmedArticle>")+14, rs.length());
			String section = rs.substring(0,rs.indexOf("/PubmedArticle>"));
			rs = rs.substring(rs.indexOf("/PubmedArticle>")+15, rs.length());
			section = section.substring(section.indexOf("<PMID")+5,section.length());
			section = section.substring(section.indexOf(">")+1,section.length());
			String pmid = section.substring(0,section.indexOf("<"));
			
			String pattern = "</PublicationType>";
			section = section.substring(section.indexOf("<PublicationTypeList>")+("<PublicationTypeList>").length(),section.length());
			String pubtypes = section.substring(0,section.indexOf("</PublicationTypeList>"));
			pubtypes = pubtypes.replaceAll(pattern, "</PublicationType>,");
			pubtypes = html2text(pubtypes);
			pubtypes = pubtypes.substring(0, pubtypes.length()-1);
			String mesh = "";
			try {
			section = section.substring(section.indexOf("<MeshHeadingList>")+("<MeshHeadingList>").length(),section.length());
			mesh = section.substring(0,section.indexOf("</MeshHeadingList>"));
			mesh = mesh.replaceAll("</MeshHeading>", "</MeshHeading>,");
			mesh = mesh.replaceAll("</DescriptorName>", "</DescriptorName>,");
			mesh = mesh.replaceAll("</QualifierName>", "</QualifierName>,");
			mesh = html2text(mesh);
			mesh = mesh.replaceAll(", , ", ",");
			mesh = mesh.replaceAll(", ", ",");
			mesh = mesh.substring(0, mesh.length()-2);
			}
			catch(Exception e){}
			dataArray.add("\""+pmid+"\","+"\""+ pubtypes+"\","+"\""+mesh+"\"");	
			counter++;
			
		}while (rs.indexOf("<PubmedArticle>") != -1);
		System.out.println("Pulled : "+Integer.toString(counter)+" articles from "+loc);
    }
	public static String html2text(String html) {
	    return Jsoup.parse(html).text();
	}
}