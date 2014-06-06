import javax.swing.*;
import javax.swing.event.*;

import java.awt.*;
import java.awt.event.*;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Set;
import java.util.Stack;
import java.util.concurrent.CopyOnWriteArraySet;
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
	public String dataArray[][] = new String[1000000][13];
	public String dataArray2[][] = new String[1000000][13];
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
		       resultSet = statement.executeQuery("select `Publication Number` as publication_number,  "
		       		+ "`Cited Refs - Patent` as cited_refs, "
		       		+ "`Count of Cited Refs - Patent` as count_cited_refs, "
		       		+ "`Citing Patents` as citing_refs,"
		       		+ " `Count of Citing Patents` as count_citing_refs, "
		       		+ "`Publication Year` as pub_year, "
		       		+ "contains_fule, "
		       		+ "contains_yeast, "
		       		+ "contains_plant, "
		       		+ "contains_treatment, "
		       		+ "contains_bacteria, "
		       		+ "contains_microorganism "
		       		+ " from companies_v2");
		       writeResultSet(resultSet);	
		       connection.close();
		   } 
		   catch (ClassNotFoundException e) {
			   String stop1 = "";
			   
		   } 
		   catch (SQLException e) {
			   String stop2 = "";
			   
		   }
		  beginMultiThreading();    
    }
   
	public void beginMultiThreading(){	
    	int mainindexofarray2 = 0;
    	for (int i = 0; i <dataArray.length; i++){	
    		
    		if ( dataArray[i][0] != null){
    			String publication_number = dataArray[i][0];
        		String cited_refs = dataArray[i][1];
        		String citing_refs = dataArray[i][3];
        		//cited_refs.replaceAll("\\s+","");
        		//citing_refs.replaceAll("\\s+","");
        		String[] cited_refs_parts = cited_refs.split(" | ");
        		String[] citing_refs_parts = citing_refs.split(" | ");
        		int j = 0;
        		
        		for (j = 0; j < cited_refs_parts.length; j++){
        			if (cited_refs_parts[j].length() > 4){
        				dataArray2[mainindexofarray2][0] = publication_number;
            			dataArray2[mainindexofarray2][1] = cited_refs_parts[j];
            			dataArray2[mainindexofarray2][2] = "forward";
            			dataArray2[mainindexofarray2][3] = dataArray[i][5];
            			dataArray2[mainindexofarray2][4] = "";
            			dataArray2[mainindexofarray2][5] = dataArray[i][6];
            			dataArray2[mainindexofarray2][6] = dataArray[i][7];
            			dataArray2[mainindexofarray2][7] = dataArray[i][8];
            			dataArray2[mainindexofarray2][8] = dataArray[i][9];
            			dataArray2[mainindexofarray2][9] = dataArray[i][10];
            			dataArray2[mainindexofarray2][10] = dataArray[i][11];
            			mainindexofarray2++;
        			}
        			
        		}
        		
        		for (j = 0; j < citing_refs_parts.length; j++){
        			if (citing_refs_parts[j].length() > 4){
        				/*dataArray2[mainindexofarray2][0] = citing_refs_parts[j];
    	    			dataArray2[mainindexofarray2][1] = publication_number;
    	    			dataArray2[mainindexofarray2][2] = "backward";
    	    			dataArray2[mainindexofarray2][3] = "";
            			dataArray2[mainindexofarray2][4] = dataArray[i][5];
            			dataArray2[mainindexofarray2][5] = dataArray[i][6];
            			dataArray2[mainindexofarray2][6] = dataArray[i][7];
            			dataArray2[mainindexofarray2][7] = dataArray[i][8];
            			dataArray2[mainindexofarray2][8] = dataArray[i][9];
            			dataArray2[mainindexofarray2][9] = dataArray[i][10];
            			dataArray2[mainindexofarray2][10] = dataArray[i][11];
    	    			mainindexofarray2++;*/
        				
        				dataArray2[mainindexofarray2][0] = publication_number;
            			dataArray2[mainindexofarray2][1] = citing_refs_parts[j];
            			dataArray2[mainindexofarray2][2] = "backward";
            			dataArray2[mainindexofarray2][3] = dataArray[i][5];
            			dataArray2[mainindexofarray2][4] = "";
            			dataArray2[mainindexofarray2][5] = dataArray[i][6];
            			dataArray2[mainindexofarray2][6] = dataArray[i][7];
            			dataArray2[mainindexofarray2][7] = dataArray[i][8];
            			dataArray2[mainindexofarray2][8] = dataArray[i][9];
            			dataArray2[mainindexofarray2][9] = dataArray[i][10];
            			dataArray2[mainindexofarray2][10] = dataArray[i][11];
            			mainindexofarray2++;
        			}
        		}	
    		}
    	
		}	
    	writetocsvfile();
	}
 
	
    public void writetocsvfile() {
    	
    	try {
    		System.out.println("Writing file -- C:/Users/mark/Desktop/companies_v2-pubnumnetwork.csv");
			FileWriter writer = new FileWriter("C:/Users/mark/Desktop/companies_v2-pubnumnetwork.csv");
			writer.append("\"");
			writer.append("pub_1");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("pub_2");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("type");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("year_1");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("year_2");
			writer.append("\"");
			
			
			
			writer.append(",");
			writer.append("\"");
			writer.append("contains_fule_a");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_yeast_a");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_plant_a");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_treatment_a");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_bacteria_a");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_microorganism_a");
			writer.append("\"");
			
		/*	writer.append(",");
			writer.append("\"");
			writer.append("contains_fule_b");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_yeast_b");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_plant_b");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_treatment_b");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_bacteria_b");
			writer.append("\"");
			writer.append(",");
			writer.append("\"");
			writer.append("contains_microorganism_b");
			writer.append("\"");*/
			
			
			writer.append(",");
			writer.append("\"");
			writer.append("weight");
			writer.append("\"");
			
			
			writer.append("\n");
			
			
		
       		
       		
			
			for (int i = 0; i < dataArray2.length; i++){
				if (dataArray2[i][0] != null){
					writer.append("\"");
					writer.append(dataArray2[i][0]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][1]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][2]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][3]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][4]);
					writer.append("\"");
					
					
					
					/*if (dataArray2[i][2] == "forward"){
						
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][5]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][6]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][7]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][8]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][9]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][10]);
						writer.append("\"");
						
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						
						
					}
					else {
						
						
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append("0");
						writer.append("\"");
						
						
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][5]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][6]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][7]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][8]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][9]);
						writer.append("\"");
						writer.append(",");
						writer.append("\"");
						writer.append(dataArray2[i][10]);
						writer.append("\"");
						
					}*/
					
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][5]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][6]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][7]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][8]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][9]);
					writer.append("\"");
					writer.append(",");
					writer.append("\"");
					writer.append(dataArray2[i][10]);
					writer.append("\"");
						
					
	
					
					writer.append(",");
					writer.append("\"");
					writer.append("1");
					writer.append("\"");
					
					
					writer.append("\n");
				}
			}
			writer.close();
			
    	} catch (IOException e) {
			e.printStackTrace();
		}
    	System.exit(0);
    }
	public void writeResultSet(ResultSet resultSet) {
		int counter = 0;
		try{
			while (resultSet.next()) {
				String publication_number = resultSet.getString("publication_number");
				String cited_refs = resultSet.getString("cited_refs");
				String count_cited_refs = resultSet.getString("count_cited_refs");
				String citing_refs = resultSet.getString("citing_refs");
				String count_citing_refs = resultSet.getString("count_citing_refs");
				String pub_year = resultSet.getString("pub_year");
				dataArray[counter][0] = publication_number;
				dataArray[counter][1] = cited_refs;
				dataArray[counter][2] = count_cited_refs;
				dataArray[counter][3] = citing_refs;
				dataArray[counter][4] = count_citing_refs;
				dataArray[counter][5] = pub_year;
				dataArray[counter][6] = resultSet.getString("contains_fule");
				dataArray[counter][7] = resultSet.getString("contains_yeast");
				dataArray[counter][8] = resultSet.getString("contains_plant");
				dataArray[counter][9] = resultSet.getString("contains_treatment");
				dataArray[counter][10] = resultSet.getString("contains_bacteria");
				dataArray[counter][11] = resultSet.getString("contains_microorganism");
				
				
			
	       		
				dataArray[counter][12] = "";
				counter++;
			}
		}
		catch(SQLException e){}		
	}
    public static void main(String args[]){
        Gui gui = new Gui();
        gui.launchFrame();
    }
}
