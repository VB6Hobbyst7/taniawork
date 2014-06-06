import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
public class Gui{
	// Initialize all swing objects.
    private JFrame f = new JFrame("Basic GUI"); //create Frame
    private JPanel pnlStart = new JPanel(); // North quadrant 
	// Buttons some there is something to put in the panels
    private JButton startBtn = new JButton("Start");
    // Menu
    private JMenuBar mb = new JMenuBar(); // Menubar
    private JMenu mnuFile = new JMenu("File"); // File Entry on Menu bar
    private JMenuItem mnuItemQuit = new JMenuItem("Quit"); // Quit sub item
    private JMenu mnuHelp = new JMenu("Help"); // Help Menu entry
    public JTextField jl1 = new JTextField("000000000");
    public JLabel jl2 = new JLabel("Updating ");
    public JTextField jl3 = new JTextField("Loading DB");
    public JLabel jl4 = new JLabel("# Simultanious Threads");
    //updater items
	public static Statement statement = null;
	public PreparedStatement preparedStatement = null;
	public String dataArray[][] = new String[8790][7];
	public String dataArray2[][] = new String[50000][7];
	//public int toGO = 118389;
	public int toGO = 30000;
    public int beGO = 0;
	 public int supercounter = beGO;
	public int maincounter = 0;
	public int numberofcores = 4;
	public 	int addcount = 0;
	public String currentid = "";
	public String currentcodetext = "";
	
    /** Constructor for the GUI */
    public Gui(){
        f.setJMenuBar(mb);
        mnuFile.add(mnuItemQuit);  // Create Quit line
        mb.add(mnuFile);        // Add Menu items to form
        mb.add(mnuHelp);
        startBtn.addActionListener(new startPress());
        f.getContentPane().setLayout(new BorderLayout());
		f.getContentPane().add(pnlStart, BorderLayout.NORTH);
        jl2.setBounds(20, 20, 100, 20);
        jl1.setBounds(20, 40, 100, 20);
        jl4.setBounds(20, 60, 100, 20);
        jl3.setBounds(20, 80, 100, 20);
        pnlStart.add(jl2);
        pnlStart.add(jl1);
        pnlStart.add(jl4);
        pnlStart.add(jl3);
		pnlStart.setBounds(50, 50, 100, 200);
		f.getContentPane().setBounds(50, 50, 100, 200);
        f.addWindowListener(new ListenCloseWdw());
        mnuItemQuit.addActionListener(new ListenMenuQuit());
    }
    public class ListenMenuQuit implements ActionListener{
        public void actionPerformed(ActionEvent e){
            System.exit(0);         
        }
    }
    public class startPress implements ActionListener{
    	public void actionPerformed(ActionEvent e){
    	
    	}
    }
    public class ListenCloseWdw extends WindowAdapter{
        public void windowClosing(WindowEvent e){
            System.exit(0);         
        }
    }
    public void launchFrame(){
        // Display Frame
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack(); //Adjusts panel to components for display
        f.setVisible(true);
        getDataSet();
      
       
    }
  
    public void getDataSet(){
   	 ResultSet resultSet = null;
		   Connection connection = null;
		   try {
		       String driverName = "org.gjt.mm.mysql.Driver";
		       Class.forName(driverName);
		       String serverName = "enactforum.org";
		       String mydatabase = "synthbio";
		       String url = "jdbc:mysql://" + serverName +  "/" + mydatabase;
		       String username = "enact";
		       String password = "Bieber77Mark";
		       connection = DriverManager.getConnection(url, username, password);
		       statement = connection.createStatement();
		       resultSet = statement.executeQuery("select id, `IPC - Current - DWPI` as ipccode from justsynth");
		       writeResultSet2(resultSet);	
		       connection.close();
		       
		       
		       connection = DriverManager.getConnection(url, username, password);
		       statement = connection.createStatement();
		       resultSet = statement.executeQuery("delete from `justsynth-ipccodesplit`");
		      
		       connection.close();
		       
		   } 
		   catch (ClassNotFoundException e) {} 
		   catch (SQLException e) {}	
		  
		   analize();
   }
    public void analize(){
    	for (int i = 0; i < dataArray2.length; i++){
    		currentid = dataArray2[i][0];
    	
    		 ResultSet resultSet = null;
  		   Connection connection = null;
  		   try {
  		       String driverName = "org.gjt.mm.mysql.Driver";
  		       Class.forName(driverName);
  		       String serverName = "enactforum.org";
  		       String mydatabase = "synthbio";
  		       String url = "jdbc:mysql://" + serverName +  "/" + mydatabase;
  		       String username = "enact";
  		       String password = "Bieber77Mark";
  		       connection = DriverManager.getConnection(url, username, password);
  		       statement = connection.createStatement();
  		       
  		       String codefull = dataArray2[i][1];
  		       String[] codes = codefull.split("\\|");
  		     String code = "";
  			currentcodetext = "";
  		       for (int j = 0; j < codes.length; j++){
  		    	   
  		    	  connection = DriverManager.getConnection(url, username, password);
  	  		       statement = connection.createStatement();
  	  		       
  	  		       
  	  		       
  		    	   code = "";
  		    	   code = codes[j];
  		    	   if (code.length() > 0){
  		    		 if (code.charAt(0) == ' '){
    		    		   code = code.substring(1, code.length());
    		    	   }
  		    		 
  		    		 
    		    	   if ((code.charAt(code.length()-1) == ' ')){
    		    		   code = code.substring(0, code.length()-1);
    		    	   }  
  		    	   }
  		    	   else {
  		    		   code = "";
  		    	   }
  		    	  
  		    	
  		    	
  		    	 
  		    	 
  		    	  int l2 = statement.executeUpdate("insert into `justsynth-ipccodesplit` values ("+currentid+",'"+code+"');");
  	  		       
  	  		       connection.close();
  		       }
  		       
  		  /*   resultSet = null;
    		   connection = null;
    		   
		       mydatabase = "synthbio";
		       url = "jdbc:mysql://" + serverName +  "/" + mydatabase;
		       username = "enact";
		       password = "Bieber77Mark";
		       connection = DriverManager.getConnection(url, username, password);
		       statement = connection.createStatement();
  		     int val1 = statement.executeUpdate("update companies set `dwpi codes translated` = '"+currentcodetext+"' where id = "+currentid);
  	
  		       connection.close();*/
  		   System.out.println("Finished "+currentid);
  		     String stop = ""; 
  		   } 
  		   catch (ClassNotFoundException e) {
  			   
  			   String stop = "";   
  		   } 
  		   catch (SQLException e) {
  			   String stop = "";   
  			   
  		   }
  		   
  		   
    	}
    }
   
 public static String fixText(String s){  
	 if (s == null){
		 s = "";
	 }
    	String pattern = "\r";
		s = s.replaceAll(pattern, " ");
		pattern = "\n";
		s = s.replaceAll(pattern, " ");
		pattern = "\t";
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
		s = s.replaceAll(pattern, "s");
		pattern = "'";
		s = s.replaceAll(pattern, "");
		pattern = ":";
		s = s.replaceAll(pattern, " ");
		pattern = "&nbsp;";
		s = s.replaceAll(pattern, " ");
	
		pattern = "/n";
		s = s.replaceAll(pattern, " ");
		pattern = "\r";
		s = s.replaceAll(pattern, " ");
		pattern = "\\.";
		s = s.replaceAll(pattern, " ");
		pattern = "\\|";
		s = s.replaceAll(pattern, " ");
		pattern = "\\?";
		s = s.replaceAll(pattern, " ");
		pattern = "\\)";
		s = s.replaceAll(pattern, " ");
		pattern = "\\(";
		s = s.replaceAll(pattern, " ");
		s = s.replaceAll(pattern, " ");
		s = s.replaceAll("[-+.^:,]"," ");
		s = s.replace("\"","");
		s = s.replaceAll("[\\-\\+\\.\\^:,]"," ");
		
		s = s.replaceAll("[^\\x20-\\x7e]", " ");
		s = s.replaceAll("^ +| +$|( )+", "$1");
	

		return s;
    }
 

    public void writetocsvfile() {
    	
    	try {
    		System.out.println("Writing file -- C:/Users/Ninja2/Desktop/IPCCODES.csv");
			FileWriter writer = new FileWriter("C:/Users/Ninja2/Desktop/IPCCODES.csv");
			writer.append("\"");
			writer.append("code");
			//Thread.sleep(10);
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("text");
			
			
			writer.append("\"");
			writer.append("\n");
			for (int i = beGO; i < toGO; i++){
				writer.append("\"");
				writer.append(dataArray[i][0]);
				//Thread.sleep(10);
				writer.append("\"");
				writer.append(",");
				writer.append("\"");
				writer.append(dataArray[i][1]);
				
				
				writer.append("\"");
				writer.append("\n");
				//writer.append(csvString);
			}
			writer.close();
			
    	} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
   
    	System.exit(0); 
    }
    public void writeResultSet(ResultSet resultSet) {
		int counter = 0;
		String desc = "";
		Boolean juststarted = true;
		try{
			String lastyearsaw = "";
		while (resultSet.next()) {
				desc = resultSet.getString("text");
				desc = fixText(desc);
				String stop  = "";
			
			}
		}
		catch(SQLException e){}	
		
		if (currentcodetext == ""){
			currentcodetext = desc;
		}
		else {
			currentcodetext =  currentcodetext + "|" + desc;
		}
		
		
		
	}
    
    public void writeResultSet2(ResultSet resultSet) {
		int counter = 0;
		Boolean juststarted = true;
		try{
			String lastyearsaw = "";
		while (resultSet.next()) {
				String code = resultSet.getString("id");
				String desc = resultSet.getString("ipccode");
				dataArray2[counter][0] = code;
				dataArray2[counter][1] = desc;
				counter++;
			
			}
		}
		catch(SQLException e){}	
		String stop  = "";
		
	}
	
	
	public boolean isInteger( String input )  
	{  
	   try  
	   {  
	      Integer.parseInt( input );  
	      return true;  
	   }  
	   catch( Exception e)  
	   {  
	      return false;  
	   }  
	} 
    public static void main(String args[]){
        Gui gui = new Gui();
        gui.launchFrame();
    }
}
