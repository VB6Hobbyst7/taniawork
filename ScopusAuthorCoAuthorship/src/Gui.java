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
	public String dataArray[][] = new String[118389][7];
	//public int toGO = 118389;
	protected int stepsize = 8;
	public int toGO = stepsize;
    public int beGO = 0;
 
    public int supercounter = beGO;
	public int maincounter = 0;
	public int numberofcores = 4;
	public Thread tarray[] = new Thread[numberofcores];
	public Boolean closingmode = false;
	public int closingcount = 0;
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
		       String serverName = "localhost";
		       String mydatabase = "caroline";
		       String url = "jdbc:mysql://" + serverName +  "/" + mydatabase;
		       String username = "root";
		       String password = "";
		       connection = DriverManager.getConnection(url, username, password);
		       statement = connection.createStatement();
		       resultSet = statement.executeQuery("select id, Authors_with_affiliations scopus3");
		       writeResultSet(resultSet);	
		       connection.close();
		   } 
		   catch (ClassNotFoundException e) {} 
		   catch (SQLException e) {}
		  beginMultiThreading();    
    }
   
    @SuppressWarnings("unused")
	public void beginMultiThreading(){	
		for (int i = 0; i < maincounter+numberofcores; i++){
				runThread(supercounter,i);
				supercounter++;
		}
	}
    
    @SuppressWarnings("deprecation")
	public void runThread(int counterindex, int threadindex){
    	findLinkage  newThread = new findLinkage(
				dataArray[counterindex][0], 
				dataArray[counterindex][1], 
				dataArray,counterindex,threadindex,numberofcores,toGO);
		newThread.addListener((ThreadCompleteListener) this); 
		
		tarray[threadindex] = newThread;
		tarray[threadindex].start();	
    }
    
	@Override
	public void notifyOfThreadComplete(Thread thread,int threadindex) {
		
	    	closingmode = true;
	    	closingcount++;
	    	if (closingcount == numberofcores){
	    		writetocsvfile();
	    	}
	    
	}   
	
    
    public void writetocsvfile() {
    	
    	try {
    		System.out.println("Writing file -- C:/Users/Ninja2/Desktop/linkageresult" + Integer.toString(beGO)+"-"+Integer.toString(toGO)+".txt");
			FileWriter writer = new FileWriter("C:/Users/Ninja2/Desktop/linkageresult" + Integer.toString(beGO)+"-"+Integer.toString(toGO)+".txt");

		
			for (int i = beGO; i < toGO; i++){
				writer.append("\"");
				writer.append(dataArray[i][0]);
				//Thread.sleep(10);
				writer.append("\"");
				writer.append(",");
				writer.append("\"");
				writer.append(dataArray[i][1]);
				//Thread.sleep(10);
				writer.append("\"");
				writer.append(",");
				writer.append("\"");
				writer.append(dataArray[i][6]);
				//Thread.sleep(10);
				writer.append("\"");
				writer.append("\n");
				//writer.append(csvString);
			}
			writer.close();
			
    	} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    
    	beGO = beGO + stepsize;
    	toGO = toGO + stepsize;
    	if (toGO < 118389){
    		
        	maincounter = 0;
        	supercounter = beGO;
        	closingcount = 0;
        	beginMultiThreading();
    	}
    	else {
    		System.exit(0); 
    	}
    	
    	
    }
	public void writeResultSet(ResultSet resultSet) {
		int counter = 0;
		try{
		while (resultSet.next()) {
			String id = resultSet.getString("id");
			String au = resultSet.getString("Authors_with_affiliations");
			
			if (au == null){
				au = "";
			}
	
			dataArray[counter][0] = id;
			dataArray[counter][1] = au.toLowerCase();
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
