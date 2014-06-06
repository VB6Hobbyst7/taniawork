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
		       resultSet = statement.executeQuery("select * from `justsynth-assigneeconetwork`");
		       writeResultSet2(resultSet);	
		       connection.close();
		       
		       
		   
		      
		       connection.close();
		       
		   } 
		   catch (ClassNotFoundException e) {} 
		   catch (SQLException e) {}	
		  
		   analize();
   }
    public void analize(){
    	String usedArray[][] = new String[10000][6];
    	String edgeArray[][] = new String[10000][6];
    	String xmlString = "<graphml>";
    	int u = 100;
    	String nodexml = "";
    	String edgexml = "";
    	int usedarraycounter = 0; 
    	int edgearraycounter = 0;
    	for (int i = 0; i < dataArray2.length; i++){
    		if (dataArray2[i][0]   != null){
    			
    			
    			currentid = dataArray2[i][0];
        		String assignee1 = dataArray2[i][1]; 
        		String assignee2 = dataArray2[i][2];
        		String claims = dataArray2[i][3];
        	
        		String nodelabel1 = assignee1.toLowerCase();
        		String nodelabel2 = assignee2.toLowerCase();
        		String title1 = assignee1.toLowerCase();
        		String title2 = assignee2.toLowerCase();
        		String claims1 = claims.toLowerCase();
        		String claims2 = claims.toLowerCase();
        		String pubyear1 = "";
        		String pubyear2 = "";
        		
        		
        		
        	
    		
    			
    			
    				//if ((nodelabel1.toLowerCase().indexOf("w") != -1)&&(nodelabel1.toLowerCase().indexOf("w") != -1)){
    				Boolean found1 = false;
        			Boolean found2 = false;
    				String foundid1 = "NO";
        			String foundid2 = "NO";
    				for (int j = 0; j < usedArray.length; j++){
    					if (usedArray[j][1] != null){
    						
    						
    						if (usedArray[j][1].compareTo(nodelabel1) == 0){
    							found1 = true;
    							foundid1 = usedArray[j][0];
    							usedArray[j][2] = usedArray[j][2]+1;
    						}
    						else {
    							int spaceCount = 0;
    							for (char c : usedArray[j][1].toCharArray()) {
    							    if (c == ' ') {
    							         spaceCount++;
    							    }
    							}
    							
    							String tempss1 = usedArray[j][1];
    							
    							if (spaceCount >= 2){
    								
    								
    								
    								String part1 = "";
    								String part2 = "";
    								part1 = tempss1.substring(0, tempss1.indexOf(" "));
    								tempss1 = tempss1.substring(tempss1.indexOf(" ")+1, tempss1.length());
    								part2 = tempss1.substring(0, tempss1.indexOf(" "));
    								tempss1 = part1 + " " + part2;
    								
    							}
    							
    							int spaceCount2 = 0;
    							for (char c : nodelabel1.toCharArray()) {
    							    if (c == ' ') {
    							         spaceCount2++;
    							    }
    							}
    							
    							String tempss2 = nodelabel1;
    							
    							if (spaceCount2 >= 2){
    								String part1 = "";
    								String part2 = "";
    								part1 = tempss2.substring(0, tempss2.indexOf(" "));
    								tempss2 = tempss2.substring(tempss2.indexOf(" ")+1, tempss2.length());
    								part2 = tempss2.substring(0, tempss2.indexOf(" "));
    								tempss2 = part1 + " " + part2;
    								
    								
    							}
    							
    							if ((tempss1.contains("ginkgo"))&&(tempss2.contains("ginkgo"))){
    								String adsfdsfadsf = "";
    							}
    							
    							if (tempss1.compareTo(tempss2) == 0){
        							found1 = true;
        							foundid1 = usedArray[j][0];
        							usedArray[j][2] = usedArray[j][2]+1;
        						}
    							
    							
    						}
    						
    						
    						
    						if (usedArray[j][1].compareTo(nodelabel2) == 0){
    							found2 = true;
    							foundid2 = usedArray[j][0];
    							usedArray[j][2] = usedArray[j][2]+1;
    						}
    						else {
    							int spaceCount = 0;
    							for (char c : usedArray[j][1].toCharArray()) {
    							    if (c == ' ') {
    							         spaceCount++;
    							    }
    							}
    							
    							String tempss1 = usedArray[j][1];
    							
    							if (spaceCount >= 2){
    								
    								
    								String part1 = "";
    								String part2 = "";
    								part1 = tempss1.substring(0, tempss1.indexOf(" "));
    								tempss1 = tempss1.substring(tempss1.indexOf(" ")+1, tempss1.length());
    								part2 = tempss1.substring(0, tempss1.indexOf(" "));
    								tempss1 = part1 + " " + part2;
    								String adsfdsfadsf = "";
    							
    								
    								
    							}
    							
    							int spaceCount2 = 0;
    							for (char c : nodelabel2.toCharArray()) {
    							    if (c == ' ') {
    							         spaceCount2++;
    							    }
    							}
    							
    							String tempss2 = nodelabel2;
    							
    							if (spaceCount2 >= 2){
    								String part1 = "";
    								String part2 = "";
    								part1 = tempss2.substring(0, tempss2.indexOf(" "));
    								tempss2 = tempss2.substring(tempss2.indexOf(" ")+1, tempss2.length());
    								part2 = tempss2.substring(0, tempss2.indexOf(" "));
    								tempss2 = part1 + " " + part2;
    								
    								
    							}
    							
    							if ((tempss1.contains("ginkgo"))&&(tempss2.contains("ginkgo"))){
    								String adsfdsfadsf = "";
    							}
    							
    							if (tempss1.compareTo(tempss2) == 0){
    								found2 = true;
        							foundid2 = usedArray[j][0];
        							usedArray[j][2] = usedArray[j][2]+1;
        						}
    							
    							
    						}
    						
    						
    						
    						
    					}
    					else {
    						j = usedArray.length;
    					}
    					
    				}
    				
    				String id1 = "";
    				String id2 = "";
    				if ((found1 == false)&&(found2 == false)){
    					id1 = Integer.toString(usedarraycounter);
    					id2 = Integer.toString(usedarraycounter+1);
    					
    					
    					
    					usedArray[usedarraycounter][0] = id1;
    					usedArray[usedarraycounter][1] = nodelabel1;
    					usedArray[usedarraycounter][2] = "1";
    					usedArray[usedarraycounter][3] = claims1;
    					usedArray[usedarraycounter][4] = title1;
    					usedArray[usedarraycounter][5] = pubyear1;
    					
    					usedarraycounter++;
    					
    					usedArray[usedarraycounter][0] = id2;
    					usedArray[usedarraycounter][1] = nodelabel2;
    					usedArray[usedarraycounter][2] = "1";
    					usedArray[usedarraycounter][3] = claims2;
    					usedArray[usedarraycounter][4] = title2;
    					usedArray[usedarraycounter][5] = pubyear2;
    					
    					usedarraycounter++;
    					
    					
    					//nodexml = nodexml + "<node id='"+id1+"' label='"+nodelabel1+"'/>";
    					//nodexml = nodexml + "<node id='"+id2+"' label='"+nodelabel2+"'/>";	
    				}
    				else if (found1 == false){
    					id1 = Integer.toString(usedarraycounter);
    					
    					usedArray[usedarraycounter][0] = id1;
    					usedArray[usedarraycounter][1] = nodelabel1;
    					usedArray[usedarraycounter][2] = "1";
    					usedArray[usedarraycounter][3] = claims1;
    					usedArray[usedarraycounter][4] = title1;
    					usedArray[usedarraycounter][5] = pubyear1;
    					
    					usedarraycounter++;
    					
    					id2 = foundid2;
    					//nodexml = nodexml + "<node id='"+id1+"' label='"+nodelabel1+"'/>";
    				}
    				else if (found2 == false){
    					id2 = Integer.toString(usedarraycounter);
    					
    					usedArray[usedarraycounter][0] = id2;
    					usedArray[usedarraycounter][1] = nodelabel2;
    					usedArray[usedarraycounter][2] = "1";
    					usedArray[usedarraycounter][3] = claims2;
    					usedArray[usedarraycounter][4] = title2;
    					usedArray[usedarraycounter][5] = pubyear2;
    					
    					usedarraycounter++;
    					
    					id1 = foundid1;
    					//nodexml = nodexml + "<node id='"+id2+"' label='"+nodelabel2+"'/>";
    				}
    				else {
    					id1 = foundid1;
    					id2 = foundid2;
    				}
    				//edgeArray.addItem({id1:id1,id2:id2});
    				edgexml = edgexml + "\n<edge source='"+id1+"' target='"+id2+"'/>";
    				String stop22 = "";
    				//trace(i.toString()+"/"+resultArray.length.toString());
    				//}
    				//step
    				
    				
    			
    		}
    		else {
    			i = dataArray2.length;
    		}
    		
				
			}
    	
		
			String groupArray[][] = new String[10000][2];
			int grouparraycounter = 0;
			groupArray[grouparraycounter][0] = "plant";
			groupArray[grouparraycounter][1] = "\n<node id=\"n1\" label=\"Plant\" layout=\"singleCircular\">\n<graph id=\"n1:\" edgedefault=\"undirected\">";
			grouparraycounter++;
			
			groupArray[grouparraycounter][0] = "other";
			groupArray[grouparraycounter][1] = "\n<node id=\"n2\" label=\"Not Plant\" layout=\"singleCircular\">\n<graph id=\"n2:\" edgedefault=\"undirected\">";
			grouparraycounter++;
			
			
		
			
			
			for (int p = 0; p < usedArray.length; p++){
				if (usedArray[p][1] != null){
				//	if (Integer.parseInt(usedArray[p][2]) >= u){
						
						if ((usedArray[p][3].indexOf("plant") != -1)||
							(usedArray[p][3].indexOf("Plant") != -1)){
							groupArray[0][1] = groupArray[0][1] + "\n<node id='"+usedArray[p][0]+"' label='"+usedArray[p][1]+"'" +
								" claims='"+""+"' title='"+usedArray[p][4]+"' pubyear='"+usedArray[p][5]+"'/>";
						}
						else {
							groupArray[1][1] = groupArray[1][1] + "\n<node id='"+usedArray[p][0]+"' label='"+usedArray[p][1]+"'" +
								" claims='"+""+"' title='"+usedArray[p][4]+"' pubyear='"+usedArray[p][5]+"'/>";
						}
						
						
						
					//}
					//else {
					//	p = usedArray.length;
					//}
				}
				else {
					p = usedArray.length;
				}
				
			}
			
			groupArray[0][1] = groupArray[0][1] + "\n</graph>\n</node>";
			
			groupArray[1][1] = groupArray[1][1] + "\n</graph>\n</node>";
			
			
			
			xmlString = xmlString + groupArray[0][1];
			xmlString = xmlString + groupArray[1][1];

			xmlString = xmlString + edgexml + "\n</graphml>";
			
			
			String stop234342 = "";
			writetocsvfile(xmlString);
		/*	var fi:File = new File("C:\\patentcitationxml.txt");
			var st:FileStream = new FileStream();
			st.open(fi,FileMode.WRITE);
			st.writeUTFBytes(xmlString);
			st.close();
			var stop333:String = "";
			
			*/
  		  
    		
    		
  		   
    	
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
 

    public void writetocsvfile(String s) {
    	
    	try {
    		System.out.println("Writing file -- C:/Users/Ninja2/Desktop/defaultXML.xml");
			FileWriter writer = new FileWriter("C:/Users/Ninja2/Desktop/defaultXML.xml");
			writer.append(s);
			
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
				String st1 = resultSet.getString("patentid");
				String st2 = resultSet.getString("assignee1");
				String st3 = resultSet.getString("assignee2");
				String st4 = resultSet.getString("claims");
				dataArray2[counter][0] = st1;
				dataArray2[counter][1] = st2;
				dataArray2[counter][2] = st3;
				dataArray2[counter][3] = st4;
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
