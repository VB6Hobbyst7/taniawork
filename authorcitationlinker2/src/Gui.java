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
	public String dataArray[][] = new String[118389][7];
	//public int toGO = 118389;
	public int toGO = 110100;
    public int beGO = 110000;
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
		       resultSet = statement.executeQuery("select id, Authors, Title, Referencess as cr, Year from scopus3");
		       writeResultSet(resultSet);	
		       connection.close();
		   } 
		   catch (ClassNotFoundException e) {} 
		   catch (SQLException e) {}
		  beginMultiThreading();    
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
						dataArray[supercounter][2], 
						dataArray[supercounter][3], 
						dataArray[supercounter][4],
						dataArray,supercounter);
				tarray[i] = newThread;
				tarray[i].start();
				supercounter++;
				
			}
			else if (tarray[i-maincounter].isAlive() == false){
				NotifyingThread newThread = new findLinkage(
						dataArray[supercounter][0], 
						dataArray[supercounter][1], 
						dataArray[supercounter][2], 
						dataArray[supercounter][3], 
						dataArray[supercounter][4],
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
    		System.out.println("Writing file -- C:/Users/Ninja2/Desktop/linkageresult" + Integer.toString(beGO)+"-"+Integer.toString(toGO)+".txt");
			FileWriter writer = new FileWriter("C:/Users/Ninja2/Desktop/linkageresult" + Integer.toString(beGO)+"-"+Integer.toString(toGO)+".txt");
		
			for (int i = beGO; i < toGO; i++){
				writer.append("\"");
				writer.append(dataArray[i][0]);
				//Thread.sleep(10);
				writer.append("\"");
				writer.append(",");
				writer.append("\"");
				writer.append(dataArray[i][5]);
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
			
    	} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	beGO = beGO + 20000;
    	toGO = toGO + 20000;
    	maincounter = 0;

    	supercounter = beGO;
    	
    	//beginMultiThreading();
    	//System.exit(0); 
    }
	public void writeResultSet(ResultSet resultSet) {
		int counter = 0;
		try{
		while (resultSet.next()) {
			String id = resultSet.getString("id");
			String au = resultSet.getString("Authors");
			String ti = resultSet.getString("Title");
			String py = resultSet.getString("Year");
			String cr = "";
			cr = resultSet.getString("cr");
			if (cr == null){
				cr = "";
			}
		
			if (au == null){
				au = "";
			}
			
			if (ti == null){
				ti = "";
			}
			
			if (py == null){
				py = "";
			}
			
		
			//if (cr != ""){
			dataArray[counter][0] = id;
			dataArray[counter][1] = au.toLowerCase();
			dataArray[counter][2] = ti;
			dataArray[counter][3] = cr.toLowerCase();
			dataArray[counter][4] = py;
			counter++;
			//}
		}
		}
		catch(SQLException e){}		
	}
    public static void main(String args[]){
        Gui gui = new Gui();
        gui.launchFrame();
    }
}
