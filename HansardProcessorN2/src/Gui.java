import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.io.BufferedReader;
import java.awt.event.*;
import java.io.File;
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
import java.util.Scanner;
public class Gui{
    private JFrame f = new JFrame("Basic GUI"); //create Frame
    private JPanel pnlStart = new JPanel(); // North quadrant 
    private JButton startBtn = new JButton("Start");
    private JMenuBar mb = new JMenuBar(); // Menubar
    private JMenu mnuFile = new JMenu("File"); // File Entry on Menu bar
    private JMenuItem mnuItemQuit = new JMenuItem("Quit"); // Quit sub item
    private JMenu mnuHelp = new JMenu("Help"); // Help Menu entry
    public JTextField jl1 = new JTextField("000000000");
    public JLabel jl2 = new JLabel("Updating ");
    public JTextField jl3 = new JTextField("Loading DB");
    public JLabel jl4 = new JLabel("# Simultanious Threads");
	public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
	public java.util.ArrayList<String>  useddates = new java.util.ArrayList<String>();
	   public java.util.ArrayList<String>  fileArray = new java.util.ArrayList<String>();

	public static Statement statement = null;
	public PreparedStatement preparedStatement = null;
	public int maincounter = 0;
	public int counter = 1;
	public int numberofcores = 8;
	//public int filecount = 2513;
	public String datafolder = "yukon";
	
	//public String projectfilepath = "C:/Users/Ninja/workspace/paperdrillupdater2/src/data/";
	public String projectfilepath = "C:/Users/Ninja/Desktop/yukon/33-legislature";
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
    public static void main(String args[]){
        Gui gui = new Gui();
        gui.launchFrame();
    }
    public void launchFrame(){
  		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack(); //Adjusts panel to components for display
        f.setVisible(true);
        getDataSet();
    }
    public void getDataSet(){
      	  beginMultiThreading();
    }
  	public void beginMultiThreading(){	
  		
  		
  		File folder = new File(projectfilepath);
  		File[] listOfFiles = folder.listFiles();

  		for (File file : listOfFiles) {
  		    if (file.isFile()) {
  		       // System.out.println(file.getName());
  		      fileArray.add(file.getName());
  		    }
  		}


  		
  		
  		
  		
  		
  		
  		
  		
  		Thread tarray[] = new Thread[numberofcores];
  		do {
  			Runnable setTextRun = new Runnable() {
  		        public void run() {
  		          jl1.setText(Integer.toString(counter));	
  		          jl1.validate();
  		          jl3.setText(Integer.toString(numberofcores));
  					f.validate();
  		        }
  		      };
  		      try {
  				SwingUtilities.invokeAndWait(setTextRun);
  			} catch (InterruptedException e2) {
  				e2.printStackTrace();
  			} catch (InvocationTargetException e2) {
  				e2.printStackTrace();
  			}
  		
  		for (int i = 0; i < maincounter+numberofcores; i++){
  			if (tarray[i-maincounter] == null){
  				try{
  					String tempfile =projectfilepath+"/"+fileArray.get(counter);
  				
  				
  				counter++;
  				if (datafolder == "hoc"){
  					NotifyingThread newThread = new processfilehouseofcommons(tempfile,fileArray.get(counter),dataArray,useddates);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "nunavut"){
  					NotifyingThread newThread = new processfilenunavut(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "Senate"){
  					NotifyingThread newThread = new processfilesenate(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "nwt"){
  					NotifyingThread newThread = new processfilenwt(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "yukon"){
  					NotifyingThread newThread = new processfileyukon(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				tarray[i].start();	
  				}
  				catch(Exception StringIndexOutOfBoundsException){
  					
  				}
  			}
  			else if (tarray[i-maincounter].isAlive() == false){
  				try{
  				String tempfile =projectfilepath+"/"+fileArray.get(counter);
  				counter++;
  				if (datafolder == "hoc"){
  					NotifyingThread newThread = new processfilehouseofcommons(tempfile,fileArray.get(counter),dataArray,useddates);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "nunavut"){
  					NotifyingThread newThread = new processfilenunavut(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "Senate"){
  					NotifyingThread newThread = new processfilesenate(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "nwt"){
  					NotifyingThread newThread = new processfilenwt(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				else if (datafolder == "yukon"){
  					NotifyingThread newThread = new processfileyukon(tempfile,fileArray.get(counter),dataArray);
  					tarray[i] = newThread;
  				}
  				tarray[i].start();
  				}
  				catch(Exception StringIndexOutOfBoundsException){
  					
  				}
  			}
  			else {
  				
  			}			
  		}
  		
  		
  		try {
  			Thread.sleep(1000);
  		} catch (InterruptedException e) {
  			e.printStackTrace();
  		}
  		
  		} while (counter < fileArray.size());
  		
  		try {
  			Thread.sleep(10000);
  		} catch (InterruptedException e) {
  			e.printStackTrace();
  		}
  		@SuppressWarnings("unused")
  		String stop44 = "";
  		writetocsvfile();
  	}
    public void writetocsvfile() {
      	try {
      		System.out.println("Writing file -- C:/Users/Ninja/Desktop/yukonhansardresult.txt");
  			@SuppressWarnings("resource")
  			FileWriter writer = new FileWriter("C:/Users/Ninja/Desktop/yukonhansardresult.txt");
  		
  			for (int i = 0; i < dataArray.size()-1; i++){
  				writer.append(dataArray.get(i));
  				writer.append("\n");
  			}
      	} catch (IOException e) {
  			e.printStackTrace();
  		}
      	
      	System.exit(0); 
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
}