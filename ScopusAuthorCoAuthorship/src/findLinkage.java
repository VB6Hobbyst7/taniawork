import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

public class findLinkage extends Thread 
{
   private int number;
   public String id;
   public String au;
   public int superid;
   public int threadindex;
   private String dataArray[][];
   private int numberofcores;
   public Statement statement = null;
   private int toGO;
   private PreparedStatement preparedStatement = null;
   
   public findLinkage(String id, String au, String dataArray[][], int superid, 
		   int threadindex, int numberofcores, int toGO)
   {
      this.id = id;
      this.au = au;
      this.toGO = toGO;
      this.numberofcores = numberofcores;
      this.threadindex = threadindex;
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

		  int newsuperid = this.superid+this.numberofcores;
		  
		  if (newsuperid < toGO){
			  this.id = dataArray[newsuperid][0];
		      this.au = dataArray[newsuperid][1];
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