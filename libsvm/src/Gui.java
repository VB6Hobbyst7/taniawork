import javax.swing.*;
import javax.swing.event.*;

import edu.berkeley.compbio.jlibsvm.SVM;
import edu.berkeley.compbio.jlibsvm.SvmProblem;

import stemmer.PorterAlgo;
import stemmer.Stopwords;


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
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;
import java.util.StringTokenizer;

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
	public String dataArray[][][] = new String[10000][100][3];
	public String termArray[] = new String[100];
	public ArrayList<String> good = new ArrayList<String>();
	public ArrayList<String> bad = new ArrayList<String>();
	public ArrayList<String> testSet = new ArrayList<String>();
	public ArrayList<String> goodsvm = new ArrayList<String>();
	public ArrayList<String> badsvm = new ArrayList<String>();
	public ArrayList<String> testSetsvm = new ArrayList<String>();


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
        
        String current = null;
		try {
			current = new java.io.File( "." ).getCanonicalPath();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    
        
        
        getTerms(getFristColumnTextOnly(current + "\\src\\data\\test.csv")+" "+getFristColumnTextOnly(current + "\\src\\data\\train.csv"));
        //term array now filled with 100 most used terms with no stopwords and they are stemed to boot.
        congragateGoodBadData(current + "\\src\\data\\train.csv");
        creategoodfiles();
        createbadfiles();
        
        congragateTestData(current + "\\src\\data\\test.csv");
        createtestfiles();
        
        
        
        //try to do libsvn here 
       // SVM d;
       //// SvmProblem pd;
       // pd.     http://stackoverflow.com/questions/6172159/how-to-use-libsvm-for-text-classification
       
        
        
        try {
			printfiles();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        
        
        
    }
    public void printfiles() throws IOException{
    	int i = 0;
    	System.out.println("Writing file -- C:/Users/Ninja2/Desktop/goodset.csv");
		FileWriter writer = new FileWriter("C:/Users/Ninja2/Desktop/goodset.csv");
		for (i = 0; i < goodsvm.size(); i++){
			writer.append(goodsvm.get(i));
			writer.append("\n");
		}
		writer.close();
		
		System.out.println("Writing file -- C:/Users/Ninja2/Desktop/badset.csv");
		writer = new FileWriter("C:/Users/Ninja2/Desktop/badset.csv");
		for (i = 0; i < badsvm.size(); i++){
			writer.append(badsvm.get(i));
			writer.append("\n");
		}
		writer.close();
		
		System.out.println("Writing file -- C:/Users/Ninja2/Desktop/testset.csv");
		writer = new FileWriter("C:/Users/Ninja2/Desktop/testset.csv");
		for (i = 0; i < testSetsvm.size(); i++){
			writer.append(testSetsvm.get(i));
			writer.append("\n");
		}
		writer.close();
		System.exit(0);
    }
    public void creategoodfiles(){
    	
    	for (int i = 0; i < good.size(); i++){
    		if (good.get(i).length() > 0){
    			String doctext = good.get(i);
    			String svmline = "1";//String.valueOf(i+1);
    			for (int j = 0; j < termArray.length; j++){
    			
    				int lastIndex = 0;
    				int termcount =0;

    				while(lastIndex != -1){

    				       lastIndex = doctext.indexOf(termArray[j],lastIndex);

    				       if( lastIndex != -1){
    				    	   termcount ++;
    				             lastIndex+=termArray[j].length();
    				      }
    				}
    				if (termcount != 0){
        				svmline = svmline + " " + String.valueOf(j+1) + ":" + String.valueOf(termcount);
    				}    				 
    			}
    			goodsvm.add(svmline);
    			
    		}
    	}
    	
    	
    }
    
    public void createbadfiles(){ 	
    	for (int i = 0; i < bad.size(); i++){
    		if (bad.get(i).length() > 0){
    			String doctext = bad.get(i);
    			String svmline = "-1";//String.valueOf(i+1);
    			for (int j = 0; j < termArray.length; j++){
    			
    				int lastIndex = 0;
    				int termcount =0;

    				while(lastIndex != -1){

    				       lastIndex = doctext.indexOf(termArray[j],lastIndex);

    				       if( lastIndex != -1){
    				    	   termcount ++;
    				             lastIndex+=termArray[j].length();
    				      }
    				}
    				if (termcount != 0){
        				svmline = svmline + " " + String.valueOf(j+1) + ":" + String.valueOf(termcount);
    				}    				 
    			}
    			badsvm.add(svmline);
    			
    		}
    	}
    	
    	
    }
    public void createtestfiles(){ 	
    	for (int i = 0; i < testSet.size(); i++){
    		if (testSet.get(i).length() > 0){
    			String doctext = testSet.get(i);
    			String svmline = "0";//String.valueOf(i+1);
    			for (int j = 0; j < termArray.length; j++){
    			
    				int lastIndex = 0;
    				int termcount =0;

    				while(lastIndex != -1){

    				       lastIndex = doctext.indexOf(termArray[j],lastIndex);

    				       if( lastIndex != -1){
    				    	   termcount ++;
    				             lastIndex+=termArray[j].length();
    				      }
    				}
    				if (termcount != 0){
        				svmline = svmline + " " + String.valueOf(j+1) + ":" + String.valueOf(termcount);
    				}
    				 
    			}
    			testSetsvm.add(svmline);
    			
    		}
    	}
    	
    	
    }
    public void getTerms(String filetext){
    	
    	filetext = fixText(filetext.toLowerCase());
    
    	 StringTokenizer strtoken = new StringTokenizer(filetext);
         ArrayList<String> filetoken = new ArrayList<String>();
         while(strtoken.hasMoreElements()){
             filetoken.add(strtoken.nextToken());
         }
         
         
         ArrayList<String> split = completeStem(filetoken);
    	
    	
    	
    	Map<String, Integer> counts = new HashMap<String,Integer>();
        for(int i=0; i<split.size()-1; i++){
            String phrase = split.get(i);
            Integer count = counts.get(phrase);
            if(count==null){
                counts.put(phrase, 1);
            } else {
                counts.put(phrase, count+1);
            }
        }

        Map.Entry<String,Integer>[] entries = counts.entrySet().toArray(new Map.Entry[0]);
        Arrays.sort(entries, new Comparator<Map.Entry<String, Integer>>() {
            public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
                return o2.getValue().compareTo(o1.getValue());
            }
        });
        int rank=1;
        int termcount = 0;
        System.out.println("Rank Freq Phrase");
        for(Map.Entry<String,Integer> entry:entries){
            int count = entry.getValue();
            if(count>1){
               // System.out.printf("%4d %4d %s\n", rank++, count,entry.getKey());
                
                if (termcount < 100){
                	 termArray[termcount]=entry.getKey();
                     termcount++;
                }
               
                
            }
        }
    
      
    
    	
    }
    public static ArrayList<String> completeStem(List<String> tokens1){
        PorterAlgo pa = new PorterAlgo();
        ArrayList<String> arrstr = new ArrayList<String>();
        for (String i : tokens1){
        	if (i.length() > 1){
	            String s1 = pa.step1(i);
	            String s2 = pa.step2(s1);
	            String s3= pa.step3(s2);
	            String s4= pa.step4(s3);
	            String s5= pa.step5(s4);
	            
	            if ((s5.length() > 3)&&(isStopWord(s5) == false)){
	            	arrstr.add(s5);
	            }
        	}
          
        }
        return arrstr;
    }
    public static Boolean isStopWord(String s){
    	 String[] stopwords = {"a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost",
    	            "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "amoungst", "amount", "an", "and",
    	            "another", "any", "anyhow", "anyone", "anything", "anyway", "anywhere", "are", "around", "as", "at", "back", "be", "became",
    	            "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides",
    	            "between", "beyond", "bill", "both", "bottom", "but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt",
    	            "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven", "else",
    	            "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few",
    	            "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from",
    	            "front", "full", "further", "get", "give", "go", "had", "has", "hasnt",
    	            "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself",
    	            "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into",
    	            "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many",
    	            "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must",
    	            "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none",
    	            "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto",
    	            "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own", "part", "per", "perhaps",
    	            "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she",
    	            "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something",
    	            "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their",
    	            "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon",
    	            "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru",
    	            "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until",
    	            "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever",
    	            "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while",
    	            "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet",
    	            "you", "your", "yours", "yourself", "yourselves", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "1.", "2.", "3.", "4.", "5.", "6.", "11",
    	            "7.", "8.", "9.", "12", "13", "14", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    	            "terms", "CONDITIONS", "conditions", "values", "interested.", "care", "sure", ".", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "{", "}", "[", "]", ":", ";", ",", "<", ".", ">", "/", "?", "_", "-", "+", "=",
    	            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    	            "contact", "grounds", "buyers", "tried", "said,", "plan", "value", "principle.", "forces", "sent:", "is,", "was", "like",
    	            "discussion", "tmus", "diffrent.", "layout", "area.", "thanks", "thankyou", "hello", "bye", "rise", "fell", "fall", "psqft.", "http://", "km", "miles"};
		
    	 for (int i = 0; i < stopwords.length; i++){
    		 if (s.compareTo(stopwords[i].toLowerCase()) == 0){
    			 return true;
    		 }
    	 }
    	 
    	 
    	 return false;
    }
    
    @SuppressWarnings("resource")
    public void congragateGoodBadData(String tempfile){
    	StringBuilder rs2 = new StringBuilder();
    	 BufferedReader reader;
		try {
			reader = new BufferedReader( new FileReader (tempfile));
			 String         line = null;
	    	 String ls = System.getProperty("line.separator");

	    	    try {
					while( ( line = reader.readLine() ) != null ) {
						String text = line.substring(0, line.indexOf(","));
						text = fixText(text.toLowerCase());
						 StringTokenizer strtoken = new StringTokenizer(text);
						 ArrayList<String> filetoken = new ArrayList<String>();
						 while(strtoken.hasMoreElements()){
						     filetoken.add(strtoken.nextToken());
						 }
						 
						 ArrayList<String> split = completeStem(filetoken);
						 String text2 = fixText(split.toString());
						 String cat = line.substring(line.indexOf(',')+1, line.length());
						
						if (cat.compareTo("1") == 0){
							good.add(text2);
						}
						else if (text.length() > 5){
							bad.add(text2);
						}	
					}
					
				} catch (IOException e) {
					e.printStackTrace();
				}
		} 
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
    }
    
    @SuppressWarnings("resource")
    public void congragateTestData(String tempfile){
    	StringBuilder rs2 = new StringBuilder();
    	 BufferedReader reader;
		try {
			reader = new BufferedReader( new FileReader (tempfile));
			 String         line = null;
	    	 String ls = System.getProperty("line.separator");

	    	    try {
					while( ( line = reader.readLine() ) != null ) {
						String text = line.substring(0, line.indexOf(","));
						text = fixText(text.toLowerCase());
						 StringTokenizer strtoken = new StringTokenizer(text);
						 ArrayList<String> filetoken = new ArrayList<String>();
						 while(strtoken.hasMoreElements()){
						     filetoken.add(strtoken.nextToken());
						 }
						 
						 ArrayList<String> split = completeStem(filetoken);
						 String text2 = fixText(split.toString());
						 String cat = line.substring(line.indexOf(',')+1, line.length());
						 testSet.add(text2);
					}
					
				} catch (IOException e) {
					e.printStackTrace();
				}
		} 
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
    }
    
    @SuppressWarnings("resource")
	public static String getFristColumnTextOnly(String tempfile){
    	StringBuilder rs2 = new StringBuilder();
    	 BufferedReader reader;
		try {
			reader = new BufferedReader( new FileReader (tempfile));
			 String         line = null;
	    	    String ls = System.getProperty("line.separator");

	    	    try {
					while( ( line = reader.readLine() ) != null ) {
						line = line.substring(0, line.indexOf(","));
						
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
    public static String fixText(String s){
    	
    	String pattern = "\r";
		s = s.replaceAll(pattern, " ");
		pattern = "\n";
		s = s.replaceAll(pattern, " ");
		pattern = ";";
		s = s.replaceAll(pattern, " ");
		pattern = ",";
		s = s.replaceAll(pattern, " ");
		pattern = "\\]";
		s = s.replaceAll(pattern, " ");
		pattern = "\\[";
		s = s.replaceAll(pattern, " ");
		pattern = ">";
		s = s.replaceAll(pattern, " ");
		pattern = "<";
		s = s.replaceAll(pattern, " ");
		pattern = "/";
		s = s.replaceAll(pattern, " ");
		pattern = "'s";
		s = s.replaceAll(pattern, " ");
		pattern = "'";
		s = s.replaceAll(pattern, " ");
		pattern = ":";
		s = s.replaceAll(pattern, " ");
		pattern = "&nbsp;";
		s = s.replaceAll(pattern, " ");
		pattern = "-";
		s = s.replaceAll(pattern, " ");
		pattern = "/n";
		s = s.replaceAll(pattern, " ");
		pattern = "\r";
		s = s.replaceAll(pattern, " ");
		pattern = "\\.";
		s = s.replaceAll(pattern, " ");
		pattern = "\\?";
		s = s.replaceAll(pattern, " ");
		pattern = "\\)";
		s = s.replaceAll(pattern, " ");
		pattern = "\\(";
		s = s.replaceAll(pattern, " ");
		pattern = "Monday";
		s = s.replaceAll(pattern, " ");
		s = s.replaceAll("[-+.^:,]"," ");
		s = s.replaceAll("[\\-\\+\\.\\^:,]"," ");
		
		s = s.replaceAll("[^\\x20-\\x7e]", " ");
		
		
		s = s.replaceAll("^ +| +$|( )+", "$1");

		return s;
    }
    public static void main(String args[]){
        Gui gui = new Gui();
        gui.launchFrame();
    }
	@Override
	public void notifyOfThreadComplete(Thread thread, int threadindex) {
		// TODO Auto-generated method stub
		
	}
}
