import javax.swing.*;
import javax.swing.event.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.sun.xml.internal.txw2.Document;

import java.awt.*;
import java.awt.event.*;
import java.io.BufferedReader;
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
import java.util.ArrayList;
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
	public static Statement statement = null;
	public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
	public PreparedStatement preparedStatement = null;
	public java.util.ArrayList<String>  fileArray = new java.util.ArrayList<String>();
	public int numberofcores = 1;
	public int counter = 0;
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
    	public void actionPerformed(ActionEvent e){}
    }
    public class ListenCloseWdw extends WindowAdapter{
        public void windowClosing(WindowEvent e){
            System.exit(0);         
        }
    }
    
    public String projectfilepath = "D:/Work/GENE Project/APP/pubmed export from scopus pmids";
    public void launchFrame(){
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack(); //Adjusts panel to components for display
        f.setVisible(true);

        File folder = new File(projectfilepath);
  		File[] listOfFiles = folder.listFiles();
  		for (File file : listOfFiles) {
  		    if (file.isFile()) {
  		       // System.out.println(file.getName());
  		      fileArray.add(file.getName());
  		    }
  		}
  		beginMultiThreading();
    }
    
    public void beginMultiThreading(){	
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
  		
	  		for (int i = 0; i < numberofcores; i++){
	  			if ((tarray[i] == null)||
	  					(tarray[i].isAlive() == false)){
	  				try{
	  					String tempfile =projectfilepath+"/"+fileArray.get(counter);
	  					NotifyingThread newThread = new processfile(tempfile,fileArray.get(counter),dataArray);
	  					tarray[i] = newThread;
	  					tarray[i].start();	
	  	  				counter++;
	  				}
					catch(Exception StringIndexOutOfBoundsException){	
	  				}
	  			}
	  		}
	  		try {
				Thread.sleep(2000);
			} catch (InterruptedException e) {}
	  		
  		} while (counter < fileArray.size());
  		
  		
  		
  		
  		Boolean allthreadsdone = false;
  		do {
  			allthreadsdone = true;
  			for (int i = 0; i < numberofcores; i++){
  				if (tarray[i].isAlive() == true){
  					allthreadsdone = false;
  				}
  			}
  		}while(allthreadsdone == false);
  		
  		
    	
  		
  	  try {
	  		Thread.sleep(10000);
	  	} catch (InterruptedException e) {
	  		e.printStackTrace();
	  	}
  	writetocsvfile();
  }
    public void writetocsvfile() {
      	try {
      		System.out.println("Writing file -- "+projectfilepath+"/resultfile.csv");
  			@SuppressWarnings("resource")
  			FileWriter writer = new FileWriter(projectfilepath+"/resultfile.csv");
  			for (int i = 0; i < dataArray.size()-1; i++){
  				writer.append(dataArray.get(i));
  				writer.append("\n");
  			}
      	} catch (IOException e) {
  			e.printStackTrace();
  		}
      	System.exit(0); 
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
