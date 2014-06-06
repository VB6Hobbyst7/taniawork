import javax.swing.*;
import javax.swing.event.*;

import java.awt.*;
import java.awt.event.*;
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
	public String dataArray[][] = new String[30000][7];
	//public int toGO = 118389;
	public int toGO = 30000;
    public int beGO = 0;
	 public int supercounter = beGO;
	public int maincounter = 0;
	public int numberofcores = 4;
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
    		getDataSet();
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
        
        
       // getDataSet();
        
        updatedatabase();
       
    }
    public void updatedatabase(){
    	String databasename = "dataset_v2-assignees";
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%llc%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%limited%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%incorperated%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%coperation%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% kk %' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%_kk%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% oy %' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%_oy%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%kenkyu kumiai%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% ab %' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%_ab%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% aps %' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%_aps%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%gesellschaft%' ");
    	doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%kenkyu kiko%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%_inc%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%inc/%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%gmbh%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%ltd%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%corp%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% co/%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% co %' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%&co%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '%&co/%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% ag/%' ");
			doQuery("update `"+databasename+"` set inf_type = 'private' where assigneefull like '% ag %' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%univ%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%us sec%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%inst%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%council%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%agency%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%lab%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%college%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '% found %' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%foundation%' ");
			doQuery("update `"+databasename+"` set inf_type = 'public' where assigneefull like '%school%' ");
	
			
    }
    public void doQuery(String s){
      	 ResultSet resultSet = null;
   		   Connection connection = null;
   		   try {
   		       String driverName = "org.gjt.mm.mysql.Driver";
   		       Class.forName(driverName);
   		       String serverName = "enactforum.org";
   		       String mydatabase = "annabelle";
   		       String url = "jdbc:mysql://" + serverName +  "/" + mydatabase;
   		       String username = "enact";
   		       String password = "Bieber77Mark";
   		       connection = DriverManager.getConnection(url, username, password);
   		       statement = connection.createStatement();
   		       statement.executeUpdate(s);
   		       connection.close();
   		   } 
   		   catch (ClassNotFoundException e) {
   			   String wait = "";
   		   } 
   		   catch (SQLException e) {
   			   String wait2 = "";
   		   }
   		   
   		  // System.exit(0); 
      }
    public void getDataSet(){
    	 ResultSet resultSet = null;
		   Connection connection = null;
		   try {
		       String driverName = "org.gjt.mm.mysql.Driver";
		       Class.forName(driverName);
		       String serverName = "enactforum.org";
		       String mydatabase = "annabelle";
		       String url = "jdbc:mysql://" + serverName +  "/" + mydatabase;
		       String username = "enact";
		       String password = "Bieber77Mark";
		       connection = DriverManager.getConnection(url, username, password);
		       statement = connection.createStatement();
		       resultSet = statement.executeQuery("select id, `Assignee - Original w/address` as asig, `Publication Number` as pubnum from dataset_v2");
		       writeResultSet(resultSet);	
		       connection.close();
		   } 
		   catch (ClassNotFoundException e) {} 
		   catch (SQLException e) {
			   String sdfsdfs = "";
		   }
		   
		   
		   writetocsvfile();
		   
		//  beginMultiThreading();    
    }
   
    @SuppressWarnings("unused")
	public void beginMultiThreading(){	
	
    	
		Thread tarray[] = new Thread[numberofcores];
		do {
			
			
			Runnable setTextRun = new Runnable() {
		        public void run() {
		          jl1.setText(Integer.toString(supercounter));	
		          jl1.validate();
		          jl3.setText(Integer.toString(numberofcores));
					f.validate();
		        }
		      };
		      try {
				SwingUtilities.invokeAndWait(setTextRun);
			} catch (InterruptedException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} catch (InvocationTargetException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
		
		for (int i = 0; i < maincounter+numberofcores; i++){
			if (tarray[i-maincounter] == null){
				NotifyingThread newThread = new findLinkage(
						dataArray[supercounter][0], 
						dataArray[supercounter][1], 
						
						dataArray,supercounter);
				tarray[i] = newThread;
				tarray[i].start();
				supercounter++;
				
			}
			else if (tarray[i-maincounter].isAlive() == false){
				NotifyingThread newThread = new findLinkage(
						dataArray[supercounter][0], 
						dataArray[supercounter][1], 
						
						dataArray,supercounter);
				tarray[i] = newThread;
				tarray[i].start();
				supercounter++;
			}
			else {
				
			}			
		}
		
		
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//maincounter = maincounter + numberofcores;
		} while (supercounter < toGO);
		//} while (supercounter < 2000);
		
		try {
			Thread.sleep(5000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String stop44 = "";
		writetocsvfile();
	}
    
    public void writetocsvfile() {
    	
    	try {
    		System.out.println("Writing file -- C:/Users/Ninja/Desktop/dataset_v2-assignees.csv");
			FileWriter writer = new FileWriter("C:/Users/Ninja/Desktop/dataset_v2-assignees.csv");
		
			
			writer.append("\"");
			writer.append("id");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("ids");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("assigneefull");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("country");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("state");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("assigneeshort");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("pubnums");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("frequency");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("inf_type");
			writer.append("\"");
			writer.append("\n");
			
			
			int tempcounter44 = 0;
			for (int i = beGO; i < toGO; i++){
				
				if (dataArray[i][0] != null){
					writer.append("\"");
					writer.append(Integer.toString(tempcounter44));
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray[i][0]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray[i][1]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					String state = "";
					if ((dataArray[i][2].length() > 2)&&(dataArray[i][2] != "No Country Listed")){
						
						String tempoo = dataArray[i][1];
						String[] parts = tempoo.split(",");
						String country = parts[parts.length-2].trim();
						
						if (country.length() > 4){
							String[] parts2 = tempoo.split(",");
							country = parts2[parts2.length-2].trim();
							String[] parts3 = country.split(" ");
							country = parts3[parts3.length-1].trim();
							
						}
						
						
						writer.append(country);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						
					
					
						 if (country.toLowerCase().compareTo("us") == 0){
							 String tempoo2 =  dataArray[i][1];
							 if (tempoo2.contains(",us")){
								 state = tempoo2.substring(0, tempoo2.indexOf(",us"));
								 String[] parts4 = state.split(",");
								 state = parts4[parts4.length-1];
							 }
							 else if (tempoo2.contains("us,")){
								 state = tempoo2.substring(0, tempoo2.indexOf("us,"));
								 String[] parts4 = state.split(",");
								 state = parts4[parts4.length-1];
								
							 }
							 else {
								 String stop = ""; 
							 }

						
						 }
					
					
					
					}
					else {
						writer.append(dataArray[i][2]);
					
						
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						
						String tempoo = dataArray[i][1];
						String[] parts = tempoo.split(",");
						String country = parts[parts.length-1].trim();
					
						 if (country.toLowerCase().compareTo("us") == 0){
							 String tempoo2 =  dataArray[i][1];
							 state = tempoo2.substring(0, tempoo2.indexOf(",us"));
							 String[] parts4 = state.split(",");
							 state = parts4[parts4.length-1];
						 }
					
					
					}
					
					
					if (state.length() > 3){
						state = "";
					}
					
					 writer.append(state); 
					
					
				
					
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray[i][3]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray[i][4]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray[i][5]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append("");
					writer.append("\"");
					writer.append("\n");
					tempcounter44++;
				}
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
		
	
		try{
		while (resultSet.next()) {
			String id = resultSet.getString("id");
			String aff = resultSet.getString("asig");
			String pubnum = resultSet.getString("pubnum");
			String assignee = "";
			if (aff == null){
				aff = "";
			}
			
			if (aff != ""){
			if (aff.contains("|")){
				String[] parts = aff.split("\\|");
				
				for (int i = 0; i < parts.length; i++){
					assignee = parts[i].toLowerCase().trim();
					
					if (assignee.contains(",")){
						assignee = assignee.substring(0, assignee.indexOf(","));
					}
					
					if (assignee.contains(" inc")){
						assignee = assignee.substring(0, assignee.indexOf(" inc"));
					}
					
					int spaceCount = 0;
					for (char c : assignee.toCharArray()) {
					    if (c == ' ') {
					         spaceCount++;
					    }
					}
					
					if (spaceCount > 1){
						String a1 = assignee.substring(0, assignee.indexOf(' '));
						assignee = assignee.substring(assignee.indexOf(' ')+1,assignee.length());
						String a2 = assignee.substring(0, assignee.indexOf(' '));
						assignee = a1+" "+a2;
						String stop222 = "";
					}
					
					assignee = assignee.trim();
					
					
					
					Boolean found1 = false;
					if (dataArray.length > 0){
						for (int j = 0; j < counter; j++){
							if (found1 == false){
								String temp1 = dataArray[j][3];
								String temp2 = assignee;
								if ((dataArray[j][3].contains("lorus"))||(assignee.contains("lorus"))){
									String stop = "";
								}
								
								if (dataArray[j][3].compareTo(assignee) == 0){
									found1 = true;
									dataArray[j][0] = dataArray[j][0] +";"+id;
									dataArray[j][4] = dataArray[j][4] + ";"+pubnum;
									dataArray[j][5] =  Integer.toString(Integer.parseInt(dataArray[j][5]) + 1);
									//counter++;
								}
							}
						
						}
					}
				
					
					if (found1 == false){
						dataArray[counter][0] = id;
						dataArray[counter][1] = parts[i].toLowerCase().trim();
						String tempassignee = "";
						if (parts[i].contains(",")){
							String tempcountry = parts[i].toLowerCase().trim().substring(parts[i].toLowerCase().trim().lastIndexOf(",")+1,parts[i].toLowerCase().trim().length());
							if (isInteger(tempcountry)){
								String tempstring = parts[i].toLowerCase().trim().substring(0,parts[i].toLowerCase().trim().lastIndexOf(","));
								tempcountry = tempstring.substring(tempstring.lastIndexOf(",")+1, tempstring.length());
							}
							
							dataArray[counter][2] = tempcountry;
							
							
							tempassignee = parts[i].toLowerCase().trim().substring(0,parts[i].toLowerCase().trim().indexOf(","));
							if (tempassignee.contains(" inc")){
								tempassignee = tempassignee.substring(0, tempassignee.indexOf(" inc"));
							}
							
							int spaceCount2 = 0;
							for (char c : tempassignee.toCharArray()) {
							    if (c == ' ') {
							         spaceCount2++;
							    }
							}
							
							if (spaceCount2 > 1){
								String a1 = tempassignee.substring(0, tempassignee.indexOf(' '));
								tempassignee = tempassignee.substring(tempassignee.indexOf(' ')+1,tempassignee.length());
								String a2 = tempassignee.substring(0, tempassignee.indexOf(' '));
								tempassignee = a1+" "+a2;
								String stop222 = "";
							}
							
							dataArray[counter][3] = tempassignee;
						}
						else {
							dataArray[counter][2] = "No Country Listed";
							tempassignee = parts[i].toLowerCase().trim();
							if (tempassignee.contains(" inc")){
								tempassignee = tempassignee.substring(0, tempassignee.indexOf(" inc"));
							}
							
							dataArray[counter][3] = tempassignee;
						
						}
						
						
						
						dataArray[counter][4] = pubnum;
						dataArray[counter][5] = "1";
						counter++;
					}
				
				}
				
			}
			else {
				assignee = aff.toLowerCase().trim();
				if (assignee.contains(",")){
					assignee = assignee.substring(0, assignee.indexOf(","));
				}
				
				if (assignee.contains(" inc")){
					assignee = assignee.substring(0, assignee.indexOf(" inc"));
				}
				
				int spaceCount = 0;
				for (char c : assignee.toCharArray()) {
				    if (c == ' ') {
				         spaceCount++;
				    }
				}
				
				if (spaceCount > 1){
					String a1 = assignee.substring(0, assignee.indexOf(' '));
					assignee = assignee.substring(assignee.indexOf(' ')+1,assignee.length());
					String a2 = assignee.substring(0, assignee.indexOf(' '));
					assignee = a1+" "+a2;
					String stop222 = "";
				}
				
				
				assignee = assignee.trim();
				
				Boolean found2 = false;
				if (dataArray.length > 0){
					for (int j = 0; j < counter; j++){
						if (found2 == false){
							String temp1 = dataArray[j][3];
							String temp2 = assignee;
							if ((dataArray[j][3].contains("lorus"))&&(assignee.contains("lorus"))){
								String stop = "";
							}
							
							if (dataArray[j][3].compareTo(assignee) == 0){
								found2 = true;
								dataArray[j][0] = dataArray[j][0] +";"+id;
								dataArray[j][4] = dataArray[j][4] + ";"+pubnum;
								dataArray[j][5] =  Integer.toString(Integer.parseInt(dataArray[j][5]) + 1);
								//counter++;	
							}
						}
						
					}
				}
				
				
				if (found2 == false){
					dataArray[counter][0] = id;
					dataArray[counter][1] = aff.toLowerCase().trim();
					String tempassignee = "";
					if (aff.contains(",")){
						
						String tempcountry = aff.toLowerCase().substring(aff.lastIndexOf(",")+1, aff.length());
						if (isInteger(tempcountry)){
							String tempstring = aff.toLowerCase().substring(0,aff.lastIndexOf(","));
							tempcountry = tempstring.substring(tempstring.lastIndexOf(",")+1, tempstring.length());
						}
						
						dataArray[counter][2] = tempcountry;
						tempassignee = aff.toLowerCase().substring(0, aff.indexOf(","));
						if (tempassignee.contains(" inc")){
							tempassignee = tempassignee.substring(0, tempassignee.indexOf(" inc"));
						}
						
						int spaceCount2 = 0;
						for (char c : tempassignee.toCharArray()) {
						    if (c == ' ') {
						         spaceCount2++;
						    }
						}
						
						if (spaceCount2 > 1){
							String a1 = tempassignee.substring(0, tempassignee.indexOf(' '));
							tempassignee = tempassignee.substring(tempassignee.indexOf(' ')+1,tempassignee.length());
							String a2 = tempassignee.substring(0, tempassignee.indexOf(' '));
							tempassignee = a1+" "+a2;
							String stop222 = "";
						}
						
						
						dataArray[counter][3] = tempassignee;
					}
					else {
						dataArray[counter][2] = "No Country Listed";
						tempassignee =  aff.toLowerCase().trim();
						if (tempassignee.contains(" inc")){
							tempassignee = tempassignee.substring(0, tempassignee.indexOf(" inc"));
						}
						dataArray[counter][3] = tempassignee;
					}
					dataArray[counter][4] = pubnum;
					dataArray[counter][5] = "1";
					counter++;
				}

			
			}
			}
		
			
		}
		}
		catch(SQLException e){}		
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
