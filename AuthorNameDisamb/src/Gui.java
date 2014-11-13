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

import au.com.bytecode.opencsv.CSVReader;

import com.sun.xml.internal.txw2.Document;
import com.sun.xml.internal.ws.wsdl.writer.document.http.Address;

import java.awt.*;
import java.awt.event.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Writer;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
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
	public java.util.ArrayList<String>  dataArray2 = new java.util.ArrayList<String>();
	public java.util.ArrayList<String>  dataArray3 = new java.util.ArrayList<String>();
	public authorentry[] authordataarray;
	public PreparedStatement preparedStatement = null;
	public java.util.ArrayList<String>  fileArray = new java.util.ArrayList<String>();
   // public String filepath = "C:/Users/Ninja/Desktop/Bone Marrow/1970s/ovid-pubmed-scopus-15_half.csv";
    public String filepath = "C:/Users/Ninja/Desktop/app-pubmed-scopus-3.csv";
    public int numberofcores = 8;
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
    public void launchFrame(){
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack(); //Adjusts panel to components for display
        f.setVisible(true);
  		beginMultiThreading();
    }  
   
    static final Comparator<authorentry> ORDER_BY_FIRSTNAME = new Comparator<authorentry>() {
    	public int compare(authorentry a1, authorentry a2) {
    		if ((a1 != null)&&(a2 != null)){
    			return a1.firstname.compareTo(a2.firstname);
    		}
    		return 0;	
    	}
    };
    static final Comparator<authorentry> ORDER_BY_LASTNAME = new Comparator<authorentry>() {
    	public int compare(authorentry a1, authorentry a2) {
    		if ((a1 != null)&&(a2 != null)){
    			return a1.lastname.compareTo(a2.lastname);
    		}
    		return 0;	
    	}
    };
    static final Comparator<authorentry> ORDER_BY_MIDDLENAME = new Comparator<authorentry>() {
    	public int compare(authorentry a1, authorentry a2) {
    		if ((a1 != null)&&(a2 != null)){
    			return a1.middlename.compareTo(a2.middlename);
    		}
    		return 0;	
    	}
    };
    static final Comparator<authorentry> ORDER_BY_RULES = new Comparator<authorentry>() {
    	public int compare(authorentry a1, authorentry a2) {
    		int i = ORDER_BY_LASTNAME.compare(a1,a2);
    		if(i == 0){
    			i = ORDER_BY_FIRSTNAME.compare(a1,a2);
    			if(i == 0){
    				i = ORDER_BY_MIDDLENAME.compare(a1,a2);
    			}
    		}
    		return i;
    	}
    };
    public void beginMultiThreading(){	
    	Thread tarray[] = new Thread[numberofcores];
    	  CSVReader reader = null;
		try {
			reader = new CSVReader(new FileReader(filepath));
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();}
    	  String [] nextLine;
    	    try {
				while ((nextLine = reader.readNext()) != null) {
					 CharSequence cs1 = "mullan";
					 String tempstring = nextLine[4].toString().toLowerCase();
					if ((counter != 0)&&(tempstring.contains(cs1))){
					Boolean foundthreadtouse = false;
					do {
				  		for (int i = 0; i < numberofcores; i++){
				  			if (((tarray[i] == null)||(tarray[i].isAlive() == false))&&(foundthreadtouse == false)){
				  				try{
				  					foundthreadtouse = true;
				  					NotifyingThread newThread = new processbook(nextLine,dataArray);
				  					tarray[i] = newThread;
				  					tarray[i].start();	
				  				}
								catch(Exception StringIndexOutOfBoundsException){}
				  			}
				  		}
				  		if (foundthreadtouse == false){
				  			try {
								Thread.sleep(2000);
							} catch (InterruptedException e) {}
				  		}
					} while (foundthreadtouse == false);
					}
					counter++;
					updateVisuals();
				}
			} catch (IOException e) {e.printStackTrace();}
    	    
    	    try {
				Thread.sleep(2000);
			} catch (InterruptedException e) {}
    	    
    	    //Start of wait for threads to be finished
    	    Boolean threadstillinuse = false;
    		do {
    			threadstillinuse = false;
    			for (int u = 0; u < numberofcores; u++){
		  			if (((tarray[u] == null)||(tarray[u].isAlive() == false))){
		  				
		  			}
		  			else {
		  				threadstillinuse = true;
		  			}
		  			
		  		  try {
		  				Thread.sleep(250);
		  			} catch (InterruptedException e) {}
    			}
    		}while(threadstillinuse);
    		//end of wait for threads to be finished. 
    		
    		int i = 0;
    		authordataarray = new authorentry[dataArray.size()];
    		for (i = 0; i < dataArray.size()-1; i++){
    			String datastring = dataArray.get(i);
    			List<String> items = Arrays.asList(datastring.split("\\s*;\\s*"));
    			authordataarray[i] = new authorentry();
    			authordataarray[i].pmid = items.get(0).replace("\"", "");
    			authordataarray[i].firstname = items.get(1).replace("\"", "");
    			authordataarray[i].middlename = items.get(2).replace("\"", "");
    			authordataarray[i].lastname = items.get(3).replace("\"", "");
    			authordataarray[i].displayname = items.get(4).replace("\"", "");
    			authordataarray[i].country = items.get(5).replace("\"", "");
    			authordataarray[i].address = items.get(6).replace("\"", "");
    			authordataarray[i].inst = items.get(7).replace("\"", "");
    			authordataarray[i].department = items.get(8).replace("\"", "");
    			authordataarray[i].pmidlist = items.get(9).replace("\"", "");
    			authordataarray[i].year = items.get(10).replace("\"", "");
    			authordataarray[i].coauthors = items.get(11).replace("\"", "");
    		}
    		int counter = 0;
    		Arrays.sort(authordataarray, ORDER_BY_RULES);
    		tarray = new Thread[numberofcores];
    		for (i = 0; i < authordataarray.length-1; i++){
    			java.util.ArrayList<authorentry>  tempauthorarray = new java.util.ArrayList<authorentry>();
    			tempauthorarray.add(authordataarray[i]);
    			authordataarray[i].tempid = i;
    			for (int j = i+1; j < authordataarray.length-1; j++){
        			if ((authordataarray[i].lastname.compareTo(authordataarray[j].lastname) == 0)&&
        					(authordataarray[i].firstname.compareTo(authordataarray[j].firstname) == 0)){
        				authordataarray[j].tempid = j;
        				tempauthorarray.add(authordataarray[j]);
        			}
        			else {
        				if (tempauthorarray.size() > 1){
        					Boolean foundthreadtouse = false;
        					do {
        				  		for (int p = 0; p < numberofcores; p++){
        				  			if (((tarray[p] == null)||(tarray[p].isAlive() == false))&&(foundthreadtouse == false)){
        				  				try{
        				  					foundthreadtouse = true;
        				  					NotifyingThread newThread = new processauthor(authordataarray,tempauthorarray);
        				  					tarray[p] = newThread;
        				  					tarray[p].start();	
        				  				}
        								catch(Exception StringIndexOutOfBoundsException){}
        				  			}
        				  		}
        				  		if (foundthreadtouse == false){
        				  			try {
        								Thread.sleep(2000);
        							} catch (InterruptedException e) {}
        				  		}
        					} while (foundthreadtouse == false);	
        				}
        				i = j-1;
        				j = authordataarray.length;
        			}
        		}
    			//do for the final last block 
    			if (tempauthorarray.size() > 1){
					Boolean foundthreadtouse = false;
					do {
				  		for (int p = 0; p < numberofcores; p++){
				  			if (((tarray[p] == null)||(tarray[p].isAlive() == false))&&(foundthreadtouse == false)){
				  				try{
				  					foundthreadtouse = true;
				  					NotifyingThread newThread = new processauthor(authordataarray,tempauthorarray);
				  					tarray[p] = newThread;
				  					tarray[p].start();	
				  				}
								catch(Exception StringIndexOutOfBoundsException){}
				  			}
				  		}
				  		if (foundthreadtouse == false){
				  			try {
								Thread.sleep(2000);
							} catch (InterruptedException e) {}
				  		}
					} while (foundthreadtouse == false);	
				}
    			if (i % 10 == 0) {
    				System.out.println("Doing item : "+Integer.toString(i)+"/"+Integer.toString(authordataarray.length-1));
    				try {
    					Thread.sleep(1);
    				} catch (InterruptedException e) {}
    			}	
    		}
    		
    		 //Start of wait for threads to be finished
    	    threadstillinuse = false;
    	   int limitcounter = 0;
    		do {
    			threadstillinuse = false;
    			for (int u = 0; u < numberofcores; u++){
		  			if (((tarray[u] == null)||(tarray[u].isAlive() == false))){
		  				
		  			}
		  			else {
		  				threadstillinuse = true;
		  			}
		  			
		  		  try {
		  				Thread.sleep(500);
		  			} catch (InterruptedException e) {}
    			}
    			//limitcounter++;
    		}while((threadstillinuse)&&(limitcounter < 1000));
    		//end of wait for threads to be finished. 

    		Arrays.sort(authordataarray, ORDER_BY_RULES);
    		writetocsvfile();
	  }
   
    public void writetocsvfile() {
		try {
		String souroundingvar = "\"";
		System.out.println("Writing file -- C:/Users/Ninja/Desktop/AuthorReferenceTable.csv");
		@SuppressWarnings("resource")
		FileWriter writer = new FileWriter("C:/Users/Ninja/Desktop/AuthorReferenceTable.csv");
		writer.append("pmid,year,firstname,middlename,lastname,displayname,country,address,inst,department,coauthors,pmidlist,edited");		
		writer.append("\n");
		for (int i = 0; i < authordataarray.length-1; i++){
			if (i != 0){
				writer.append("\n");
		}		
		writer.append(souroundingvar+authordataarray[i].pmid+souroundingvar+","+
				souroundingvar+authordataarray[i].year+souroundingvar+","+
				souroundingvar+authordataarray[i].firstname+souroundingvar+","+
				souroundingvar+authordataarray[i].middlename+souroundingvar+","+
				souroundingvar+authordataarray[i].lastname+souroundingvar+","+
				souroundingvar+authordataarray[i].displayname+souroundingvar+","+
				souroundingvar+authordataarray[i].country+souroundingvar+","+
				souroundingvar+authordataarray[i].address+souroundingvar+","+
				souroundingvar+authordataarray[i].inst+souroundingvar+","+
				souroundingvar+authordataarray[i].department+souroundingvar+","+
				souroundingvar+authordataarray[i].coauthors+souroundingvar+","+
				souroundingvar+authordataarray[i].pmidlist+souroundingvar+","+
						souroundingvar+authordataarray[i].edited+souroundingvar);
			}
			writer.close();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
		try {
			Thread.sleep(4000);
		} 
		catch (InterruptedException e) {}
		System.exit(0); 
    }
    public void updateVisuals(){
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