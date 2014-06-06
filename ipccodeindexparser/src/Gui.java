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
	public String dataArray[][] = new String[30000][7];
	//public int toGO = 118389;
	public int toGO = 30000;
    public int beGO = 0;
	 public int supercounter = beGO;
	public int maincounter = 0;
	public int numberofcores = 4;
	public 	int addcount = 0;
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
    	String rs = "";
    	addcount = 0;
    	StringBuilder rs2 = new StringBuilder();
    	 BufferedReader reader;
		try {
		
			reader = new BufferedReader( new FileReader ("C:/Users/Ninja2/Desktop/IPC Code Decompiler/cpi_manualcodes.txt"));
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
		rs = rs2.toString();
		
		String pattern = "\r\n.  \r\n";
		rs = rs.replaceAll(pattern, "\r\n");
		
		
		
		
		
		do {
			try{
			String entity = rs.substring(rs.indexOf("-")-5, rs.indexOf("-")+6);
			String start = entity.substring(0, 2);
			String end = entity.substring(entity.length()-2, entity.length());
			
			String entity2 = rs.substring(rs.indexOf("-")-5, rs.indexOf("-")+7);
			String start2 = entity2.substring(0, 2);
			String end2 = entity2.substring(entity2.length()-2, entity2.length());
			
			String entity3 = rs.substring(rs.indexOf("-")-5, rs.indexOf("-")+8);
			String start3 = entity3.substring(0, 2);
			String end3 = entity3.substring(entity3.length()-2, entity3.length());
			
			String entity4 = rs.substring(rs.indexOf("-")-5, rs.indexOf("-")+5);
			String start4 = entity4.substring(0, 2);
			String end4 = entity4.substring(entity4.length()-2, entity4.length());
			
			
			String code = "";
			String text = "";
			if (addcount > 2450){
				String stopsdf = "";
			}
			
			
			
		
			if (((start.compareTo("\r\n") == 0)&&(end.compareTo("  ") == 0))||
					((start.compareTo("\r\n") == 0)&&(end.compareTo("\r\n") == 0))){			
				code = entity.substring(2, entity.length()-2);
				String patter2 = "\r";
				code = code.replaceAll(patter2, "");
				String patter3 = "\n";
				code = code.replaceAll(patter3, "");
				code = code.trim();
				rs = rs.substring(rs.indexOf("-")+1, rs.length());
				rs = rs.substring(rs.indexOf("\r\n")+2, rs.length());
				if (rs.indexOf("-") > rs.indexOf("\r\n")){
					text = rs.substring(0, rs.indexOf("-")-3);
				}
				else {
					text = rs.substring(0, rs.indexOf("\r\n"));
				}
				text = fixText(text);
				code = fixText2(code);
				String stop = "";
				addit(code,text);
				
			}
			else if (((start4.compareTo("\r\n") == 0)&&(end4.compareTo("  ") == 0))||
					((start4.compareTo("\r\n") == 0)&&(end4.compareTo(" \r") == 0))){			
				code = entity4.substring(2, entity4.length()-2);
				String patter2 = "\r";
				code = code.replaceAll(patter2, "");
				String patter3 = "\n";
				code = code.replaceAll(patter3, "");
				code = code.trim();
				code = fixText2(code);
				rs = rs.substring(rs.indexOf("-")+1, rs.length());
				rs = rs.substring(rs.indexOf("\r\n")+2, rs.length());
				if (rs.indexOf("-") > rs.indexOf("\r\n")){
					text = rs.substring(0, rs.indexOf("-")-3);
				}
				else {
					text = rs.substring(0, rs.indexOf("\r\n"));
				}
			
				text = fixText(text);
				String stop = "";
				addit(code,text);
			}
			else if (((start2.compareTo("\r\n") == 0)&&(end2.compareTo("  ") == 0))||
					((start2.compareTo("\r\n") == 0)&&(end2.compareTo(" \r") == 0))){			
				code = entity2.substring(2, entity2.length()-2);
				String patter2 = "\r";
				code = code.replaceAll(patter2, "");
				String patter3 = "\n";
				code = code.replaceAll(patter3, "");
				code = code.trim();
				code = fixText2(code);
				
				rs = rs.substring(rs.indexOf("-")+1, rs.length());
				rs = rs.substring(rs.indexOf("\r\n")+2, rs.length());
				if (rs.indexOf("-") > rs.indexOf("\r\n")){
					text = rs.substring(0, rs.indexOf("-")-3);
				}
				else {
					text = rs.substring(0, rs.indexOf("\r\n"));
				}
				text = fixText(text);
				String stop = "";
				addit(code,text);
			}
			else if (((start3.compareTo("\r\n") == 0)&&(end3.compareTo("  ") == 0))||
					((start3.compareTo("\r\n") == 0)&&(end3.compareTo(" \r") == 0))){			
				code = entity3.substring(2, entity3.length()-2);
				String patter2 = "\r";
				code = code.replaceAll(patter2, "");
				String patter3 = "\n";
				code = code.replaceAll(patter3, "");
				code = code.trim();
				code = fixText2(code);
				rs = rs.substring(rs.indexOf("-")+1, rs.length());
				rs = rs.substring(rs.indexOf("\r\n")+2, rs.length());
				if (rs.indexOf("-") > rs.indexOf("\r\n")){
					text = rs.substring(0, rs.indexOf("-")-3);
				}
				else {
					text = rs.substring(0, rs.indexOf("\r\n"));
				}
				text = fixText(text);
				String stop = "";
				addit(code,text);
			}
			else {
				
				/*if (entity.contains(":")){
					String patter4 = ":";
					entity = entity.replaceAll(patter4, "");
				}
				
				if (entity.contains(",")){
					String patter4 = ",";
					entity = entity.replaceAll(patter4, "");
				}*/
				entity = entity.trim();
				
				if (isgood(entity)){
					
					if (entity.contains("\r")){
						entity = entity.substring(0, entity.indexOf("\r"));
					}
					
					if (entity.contains(" ")){
						entity = entity.substring(0, entity.indexOf(" "));
					}
					
					if (entity.contains(")")){
						entity = entity.substring(0, entity.indexOf(")"));
					}
					
					if (entity.contains(";")){
						entity = entity.substring(0, entity.indexOf(";"));
					}
					
					code = entity;
					String patter2 = "\r";
					code = code.replaceAll(patter2, "");
					String patter3 = "\n";
					code = code.replaceAll(patter3, "");
					code = code.trim();
					code = fixText2(code);
					rs = rs.substring(rs.indexOf("-")+1, rs.length());
					rs = rs.substring(rs.indexOf("\r\n")+2, rs.length());
					if (rs.indexOf("-") > rs.indexOf("\r\n")){
						text = rs.substring(0, rs.indexOf("-")-3);
					}
					else {
						text = rs.substring(0, rs.indexOf("\r\n"));
					}
					text = fixText(text);
					String stop = "";
					addit(code,text);
					
					
				
				}
				else {
					rs = rs.substring(rs.indexOf("-")+1,rs.length());
				}
				
			
				if ((text.length() == 0)&&(code.length() > 0)){
					String lkjsd = "";
				}
				
				
				
				
				
			}

			}
			catch(Exception e){
				rs = rs.substring(rs.indexOf("-")+1,rs.length());
			}
			
		}while (rs.indexOf("-") != -1);
		
		
		
		writetocsvfile();
		
		
		
		
		
		
		
		
		
		
		
    }
    public void addit(String s, String t){
    	Boolean found1 = false;
    	for (int i = 0; i < addcount; i++){
    		if (found1 == false){
    			if (dataArray[i][0].compareTo(s) == 0){
    				
    				if (dataArray[i][1].length() < t.length()){
    					dataArray[i][1] = t;
    				}
        			found1 = true;
        		}
    		}
    		
    	}
    	
    	if (found1 == false){
    		dataArray[addcount][0] = s;
    		dataArray[addcount][1] = t;
    		addcount++;
    	}
    	
    	
    }
    public static Boolean isgood(String s){
    	
    	if ((s.charAt(3) == '-')&&(s.contains("pre") == false)){
    		return true;
    	}
    	
    	
    	
    	return false;
    	
    }
 public static String fixText(String s){
    	
    	
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
		s = s.replaceAll(pattern, "");
		pattern = "<";
		s = s.replaceAll(pattern, "");
		pattern = "/";
		s = s.replaceAll(pattern, "");
		pattern = "'s";
		s = s.replaceAll(pattern, "s");
		pattern = "'";
		s = s.replaceAll(pattern, "");
		pattern = ":";
		s = s.replaceAll(pattern, "");
		pattern = "&nbsp;";
		s = s.replaceAll(pattern, " ");
		pattern = "-";
		s = s.replaceAll(pattern, " ");
		pattern = "\\.";
		s = s.replaceAll(pattern, " ");
		pattern = "\\?";
		s = s.replaceAll(pattern, "");
		pattern = "\\)";
		s = s.replaceAll(pattern, "");
		pattern = "\\(";
		s = s.replaceAll(pattern, "");
		s = s.replaceAll("[-+.^:,]","");
		s = s.replace("\"","");
		s = s.replaceAll("[\\-\\+\\.\\^:,]","");
		
		s = s.replaceAll("[^\\x20-\\x7e]", "");
		
		
		s = s.replaceAll("^ +| +$|( )+", "$1");
	

		return s;
    }
 
 public static String fixText2(String s){
 	
 	
 	String pattern = "\r";
		s = s.replaceAll(pattern, " ");
		pattern = "\n";
		s = s.replaceAll(pattern, " ");
		pattern = "\\+";
		s = s.replaceAll(pattern, "");
		pattern = "#";
		s = s.replaceAll(pattern, "");
		pattern = ";";
		s = s.replaceAll(pattern, " ");
		pattern = ",";
		s = s.replaceAll(pattern, " ");
		pattern = ">";
		s = s.replaceAll(pattern, "");
		pattern = "<";
		s = s.replaceAll(pattern, "");
		pattern = "/";
		s = s.replaceAll(pattern, "");
		pattern = "'s";
		s = s.replaceAll(pattern, "s");
		pattern = "'";
		s = s.replaceAll(pattern, "");
		pattern = ":";
		s = s.replaceAll(pattern, " ");
		pattern = "&nbsp;";
		
		s = s.replaceAll(pattern, "");
		pattern = "\\.";
		s = s.replaceAll(pattern, " ");
		pattern = "\\?";
		s = s.replaceAll(pattern, "");
		pattern = "\\)";
		s = s.replaceAll(pattern, "");
		pattern = "\\(";
		s = s.replaceAll(pattern, "");
	s = s.trim();
	

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
