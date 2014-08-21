import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class findLinkage extends NotifyingThread
{
   private int number;
   public String id;
   private String aff;
   private String ti;
   private String cr;
   private String py;
   private int superid;
   private String dataArray[][];
   public Statement statement = null;
   private PreparedStatement preparedStatement = null;
   
   public findLinkage(String id, String aff, String dataArray[][], int superid)
   {
      this.id = id;
      this.aff = aff;
     
      this.superid = superid;
      this.dataArray = dataArray;
      
   }
   @Override
   public void doRun() {
	   String authorWithComma = "";
	   String authorWithOutComma = "";
	   String tempstring = "";
	   if (aff != ""){
		   if (aff.contains(",")){
			   tempstring= aff.substring(aff.lastIndexOf(",")+1, aff.length());
			   aff = aff.substring(0, aff.lastIndexOf(","));
			   tempstring= aff.substring(aff.lastIndexOf(",")+1, aff.length())+" "+tempstring;
			   dataArray[superid][2] = tempstring;    
		   }
		   else {
			   dataArray[superid][2] = aff; 
		   }
		   
	   }
	   else {
		   dataArray[superid][2] = ""; 
	   }
	  
   	
   }
 
   public static boolean isNumeric(String str)
   {
     return str.matches("-?\\d+(\\.\\d+)?");  //match a number with optional '-' and decimal.
   }
}