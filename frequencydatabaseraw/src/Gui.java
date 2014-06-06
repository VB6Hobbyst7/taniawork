import javax.swing.*;
import javax.swing.event.*;

import java.awt.*;
import java.awt.event.*;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
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
public class Gui implements ThreadCompleteListener{
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
	public String dataArray[][][] = new String[100][54][3];
	//public int toGO = 118389;
	protected int stepsize = 20000;
	public int toGO = stepsize;
    public int beGO = 0;
 
    public int supercounter = beGO;
	public int maincounter = 0;
	public int numberofcores = 4;
	public Thread tarray[] = new Thread[numberofcores];
	public Boolean closingmode = false;
	public int closingcount = 0;
	public Stack<String[][]> stack = new Stack<String[][]>();
	public int querycounter = 0;
	public String querylabel = "";
	public  String querymine = "";
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
        queryDatabase(getFile("C:/Users/Ninja2/Desktop/Bone Marrow Caroline/Carolines Thesauri/psychosocial_thesaurusInput.csv"));
        
        
    }
    @SuppressWarnings("resource")
	public String getFile(String tempfile){
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
    	   
		
		return rs2.toString();
		
    }
    public void queryDatabase(String filetext){
    	 int totalcount = 0;
    	
		   do {
			   querymine = "Select Year, count(*) as frequency from scopus4 where";
			   String line = filetext.substring(0, filetext.indexOf("\r\n"));
			   String[] parts = line.split(",");
			   
			   for (int i = 0; i < parts.length; i++){
				   if (i == 0){
					   querylabel = parts[i];
					   querymine = querymine + " Abstract like '%"+parts[i]+"%'";
				   }
				   else {
					   querymine = querymine + " or Abstract like '%"+parts[i]+"%'";
				   }
			   }
			   querymine = querymine + " group by Year order by year ASC";
			   
			   
			   ResultSet resultSet = null;
			   Connection connection = null;
			   
			   try {
				  // if (totalcount < 2){
			       String driverName = "org.gjt.mm.mysql.Driver";
			       Class.forName(driverName);
			       String serverName = "enactforum.org";
			       String mydatabase = "caroline";
			       String url = "jdbc:mysql://" + serverName +  "/" + mydatabase;
			       String username = "enact";
			       String password = "Bieber77Mark";
			       connection = DriverManager.getConnection(url, username, password);
			     
			    	   statement = connection.createStatement();
			    	   System.out.println("Doing query # "+Integer.toString(querycounter));
			    	   String tempquery = querymine;
				       resultSet = statement.executeQuery(tempquery);
				       writeResultSet(resultSet);
				       querycounter++;
				       connection.close();
			       //}   
			      
				   totalcount++;
			      
			   } 
			   catch (ClassNotFoundException e) {} 
			   catch (SQLException e) {}
			   filetext = filetext.substring(filetext.indexOf("\r\n")+2,filetext.length());
		   }while (filetext.contains("\r\n"));
		   
		   
		   String stop = "";
		 
		   writetocsvfile();
    }
   
  
	
    
	@Override
	public void notifyOfThreadComplete(Thread thread,int threadindex) {
		
	    	closingmode = true;
	    	closingcount++;
	    	if (closingcount == numberofcores){
	    		//writetocsvfile();
	    	}
	    
	}   
	
    
    public void writetocsvfile() {
    	
    	try {
    		System.out.println("Writing file -- C:/Users/Ninja2/Desktop/psycosocialresult.csv");
			FileWriter writer = new FileWriter("C:/Users/Ninja2/Desktop/psycosocialresult.csv");
			
			writer.append("\"");
			writer.append("label");
			writer.append("\"");
			for (int j = 0; j < dataArray[0].length; j++){
				writer.append(",");
				writer.append("\"");
				writer.append(dataArray[0][j][0]);
				writer.append("\"");				
			}
			writer.append("\n");
			
			for (int i = 0; i < dataArray.length; i++){
				writer.append("\"");
				writer.append(dataArray[i][0][2]);
				writer.append("\"");
				for (int j = 0; j < dataArray[i].length; j++){
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray[i][j][1]);
					writer.append("\"");
								
				}
				writer.append("\n");	
			}
			writer.close();
			
    	} catch (IOException e) {
			e.printStackTrace();
		}
    	System.exit(0);
    }
    
	@SuppressWarnings("unused")
	public void writeResultSet(ResultSet resultSet) {
		int counter = 0;
		Boolean juststarted = true;
		try{
			String lastyearsaw = "";
		while (resultSet.next()) {
			String year = resultSet.getString("Year");
			String freq = resultSet.getString("frequency");
			
			if (year == null){
				year = "";
			}
			
			if (year.length() == 4){
			
				
				if (juststarted){
					if (year.compareTo("1960") != 0){
						int startyear = 1960;	
						do {
							dataArray[querycounter][counter][0] = Integer.toString(startyear);
							dataArray[querycounter][counter][1] = "0";
							dataArray[querycounter][counter][2] = querylabel;
							counter++;
							startyear = startyear+1;
						}while (Integer.toString(startyear).compareTo(year) != 0);
					}
					juststarted = false;
				}
				else {
					if (year.compareTo(Integer.toString(Integer.parseInt(lastyearsaw)+1)) != 0){
					
						int startyear = Integer.parseInt(lastyearsaw)+1;	
						do {
							dataArray[querycounter][counter][0] = Integer.toString(startyear);
							dataArray[querycounter][counter][1] = "0";
							dataArray[querycounter][counter][2] = querylabel;
							counter++;
							startyear = startyear+1;
						}while (Integer.toString(startyear).compareTo(year) != 0);
					}
				}
				
				
				if (freq == null){
					freq = "0";
				}		
				
				dataArray[querycounter][counter][0] = year;
				dataArray[querycounter][counter][1] = freq;
				dataArray[querycounter][counter][2] = querylabel;
				counter++;
				lastyearsaw = year;
			}
			
			
			
			
		}
		}
		catch(SQLException e){}	
		String stop  = "";
		
	}
	
	

	
    public static void main(String args[]){
        Gui gui = new Gui();
        gui.launchFrame();
    }
}
