import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Set;
import java.util.Stack;
import java.util.concurrent.CopyOnWriteArraySet;

public class findLinkage extends Thread 
{
   private int number;
   public String id;
   public String au;
   public int superid;
   public int threadindex;
   public String ti;
   public String py;
   private String dataArray[][];
   private int numberofcores;
   public Statement statement = null;
   private int toGO;
   private PreparedStatement preparedStatement = null;
	private Stack<String[][]> stack = new Stack<String[][]>();

   public findLinkage(String id, String au, String ti, 
		    String py, String dataArray[][], int superid, 
		   int threadindex, int numberofcores, int toGO, Stack<String[][]> stack2)
   {
	   		this.id = id;
	      this.au = au;
	      this.ti = ti;
	      this.toGO = toGO;
	      this.stack = stack2;
	      this.numberofcores = numberofcores;
	      this.threadindex = threadindex;
	      this.py = py;
	      this.superid = superid;
	      this.dataArray = dataArray;
      
   }
   
   private final Set<ThreadCompleteListener> listeners = new  CopyOnWriteArraySet<ThreadCompleteListener>();
   public final void addListener(final ThreadCompleteListener listener) {
     listeners.add(listener);
   }

   public final void removeListener(final ThreadCompleteListener listener) {
     listeners.remove(listener);
   }

   private final void notifyListeners() {
     for (ThreadCompleteListener listener : listeners) {
       listener.notifyOfThreadComplete(this,threadindex);
     }
   }

   @Override
   public final void run() {
     try {
       doRun();
     } finally {
       //notifyListeners();
     }
   }
   
 
   public void doRun() {
	   
	   String[] parts = au.split(";");
	   for (int i = 0; i < parts.length; i++){
		   for (int j = 0; j < parts.length; j++){
			   if (parts[i] != parts[j]){			   
				   String temp1 = parts[i];
				   String temp2 = parts[j];
				   String author1 = "";
				   String author2 = "";
				   String country1 = "";
				   String country2 = "";
				   
				   if ((temp1.length() > 5)&&(temp2.length() > 5)){
					   if (temp1.charAt(0) == ' '){
						   temp1 = temp1.substring(1, temp1.length());
					   }
					   
					   if (temp2.charAt(0) == ' '){
						   temp2 = temp2.substring(1, temp2.length());
					   }
					   
					   if (temp1.contains(".,")){
						   author1 = temp1.substring(0,temp1.indexOf(".,"));
						   country1 = temp1.substring(temp1.lastIndexOf(",")+1, temp1.length());  
						   if (country1.charAt(0) == ' '){
							   country1 = country1.substring(1, country1.length());
						   }
					   }
					   else {
						   author1 = temp1;
						   country1 = "none";
					   }
					 
					   
					   
					   if (temp2.contains(".,")){
						   author2 = temp2.substring(0,temp2.indexOf(".,"));
						   country2 = temp2.substring(temp2.lastIndexOf(",")+1, temp2.length());
						   
						   if (country2.charAt(0) == ' '){
							   country2 = country2.substring(1, country2.length());
						   }
					   }
					   else {
						   author2 = temp2;
						   country2 = "none";
					   }
					
					   
					   
					   
					   stack.push(new String[][] {{author1}, {author2}, {country1}, {country2},{this.id}, {ti}, {py}}); 
				   }
				  
			   } 
		   } 
	   }
	  
	   
	   
		  int newsuperid = this.superid+this.numberofcores;		  
		  if (newsuperid < toGO){
			  this.id = dataArray[newsuperid][0];
		      this.au = dataArray[newsuperid][1];
		      this.ti = dataArray[newsuperid][2];
		      this.py = dataArray[newsuperid][4];
		      this.superid = newsuperid; 
		      doRun();
		  }
		  else {
			  notifyListeners();
		  }
		  
	 
   	
   }
   public static boolean isNumeric(String str)
   {
     return str.matches("-?\\d+(\\.\\d+)?");  //match a number with optional '-' and decimal.
   }
}