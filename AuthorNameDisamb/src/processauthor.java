import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.text.Normalizer;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Random;
public class processauthor extends NotifyingThread
{
	public authorentry[] authordataarray;
	java.util.ArrayList<authorentry>  tempauthorarray = new java.util.ArrayList<authorentry>();
	 static final Comparator<String> NumberSort = new Comparator<String>() {
	    	public int compare(String a1, String a2) {
	    		if ((a1 != null)&&(a2 != null)){
	    		       int num1 = Integer.parseInt(a1);
	    		       int num2 = Integer.parseInt(a2);
	    		       return num1 - num2;
	    		}
	    		return 0;	
	    	}
	    };
	public processauthor(authorentry[] authordataarray,java.util.ArrayList<authorentry> tempauthorarray){
      this.authordataarray = authordataarray;
      this.tempauthorarray = tempauthorarray;
   }
   @Override
   public void doRun() {   
	   process(this.tempauthorarray);	
   }
   public void process(java.util.ArrayList<authorentry>  tempauthorarray){
	 
	    	Boolean pmidfetched = false;
	    	Boolean atleastonehadmiddleinital = false;
	    	int i = 0;
	    	for (i = 0; i < tempauthorarray.size(); i++){
	    		java.util.ArrayList<authorentry>  tempauthorarray2 = new java.util.ArrayList<authorentry>();
	    		if (tempauthorarray.get(i).middlename.length() == 0){
	    			for (int j = 0; j < tempauthorarray.size(); j++){
	            		if ((j != i)&&(tempauthorarray.get(j).middlename.length() != 0)){
	            			//compare similar authors and determine possible matches
	            			tempauthorarray2.add(tempauthorarray.get(j));
	            		}
	            	}
	    			//look at the list and determine which one this person is closer too. 
	    			if (tempauthorarray2.size() > 0){
	    				atleastonehadmiddleinital = true;
	    				Boolean allsamemiddle = true;
	    				int k = 0;
	    				for (k = 0; k < tempauthorarray2.size(); k++){
	    					for (int l = 0; l < tempauthorarray2.size(); l++){
	        					if (tempauthorarray2.get(k).middlename.compareTo(tempauthorarray2.get(l).middlename) != 0){
	        						allsamemiddle = false;
	        					}
	        				}
	    				}
	    				
	    				if (allsamemiddle){
	    					//all the middle names are the same so its prob gonna be the same too. 
	    					authordataarray[tempauthorarray.get(i).tempid].middlename = tempauthorarray2.get(0).middlename;
	    					authordataarray[tempauthorarray.get(i).tempid].displayname = tempauthorarray2.get(0).displayname;
	    					authordataarray[tempauthorarray.get(i).tempid].edited = "true";
	    				}
	    				else {
	    					//some entries are different so a more complex method is needed. 
	    					//Step 1, grab all pmids using ProfileRNS author disambiguation service (if not done allready)
	    					if (pmidfetched == false){
	    						for (k = 0; k < tempauthorarray.size(); k++){
	    							tempauthorarray.get(k).pmidlist = getPmidsOfAuthor(tempauthorarray.get(k).firstname, 
	    									tempauthorarray.get(k).middlename,
	    									tempauthorarray.get(k).lastname,
	    									tempauthorarray.get(k).inst, 
	    									tempauthorarray.get(k).pmid,
	    									tempauthorarray.get(k).country);
	        					}
	    						pmidfetched = true;
	    					}
	    					tempauthorarray2 = new java.util.ArrayList<authorentry>();
	    					Boolean foundpmidlistmatch = false;
	    					String mainpmidlist = tempauthorarray.get(i).pmidlist;
	    					String mainfirstname = tempauthorarray.get(i).firstname;
	    					String mainlastname = tempauthorarray.get(i).lastname;
	    					
	    					for (int j = 0; j < tempauthorarray.size(); j++){
	    	            		if ((j != i)&&(tempauthorarray.get(j).middlename.length() != 0)){
	    	            			//compare similar authors and determine possible matches
	    	            			if ((foundpmidlistmatch == false)&&(comparePmidLists(mainpmidlist,tempauthorarray.get(j).pmidlist))){
	    	            				authordataarray[tempauthorarray.get(i).tempid].middlename = tempauthorarray.get(j).middlename;
	    	            				authordataarray[tempauthorarray.get(i).tempid].displayname = tempauthorarray.get(j).displayname;
	    	        					authordataarray[tempauthorarray.get(i).tempid].edited = "true";
	    	            				foundpmidlistmatch = true;
	    	            			} 
	    	            			tempauthorarray2.add(tempauthorarray.get(j));
	    	            		}
	    	            	}

	    					if (foundpmidlistmatch == false){
	    						//We need to proceed with further analysis
	    						String stop2 = "";
	    					}
	    					else {
	    						//found match was sucessfull
	    						String stop3 = "";
	    					}
	    				}
	    			}
	    		}
	    		else {
	    			atleastonehadmiddleinital = true;
	    		}
	    	}
	    	
	    	if (atleastonehadmiddleinital == false){
	    		//all names in this list have no middle initial (ex Ahmed A.) need to determine and add fake middle initials     	
	    		for (int k = 0; k < tempauthorarray.size(); k++){
					tempauthorarray.get(k).pmidlist = getPmidsOfAuthor(tempauthorarray.get(k).firstname, 
							tempauthorarray.get(k).middlename,
							tempauthorarray.get(k).lastname,
							tempauthorarray.get(k).inst, 
							tempauthorarray.get(k).pmid,
							tempauthorarray.get(k).country);
				}
	    		int middlenameinc = 1;
	    		for (int k = 0; k < tempauthorarray.size(); k++){	    			
	    			for (int l = 0; l < tempauthorarray.size(); l++){
	    				if (l != k){
	    					if (comparePmidLists(tempauthorarray.get(k).pmidlist,tempauthorarray.get(l).pmidlist)){
	    						String tempmiddleinital = "";
	    						if ((tempauthorarray.get(k).middlename.length() == 0)&&(tempauthorarray.get(l).middlename.length() != 0)){
	    							tempauthorarray.get(k).middlename = tempauthorarray.get(l).middlename;
	    							tempauthorarray.get(k).edited = "phase2fix";
	    						}
	    						else if ((tempauthorarray.get(k).middlename.length() != 0)&&(tempauthorarray.get(l).middlename.length() == 0)){
	    							tempauthorarray.get(l).middlename = tempauthorarray.get(k).middlename;
	    							tempauthorarray.get(l).edited = "phase2fix";
	    						}
	    						else if ((tempauthorarray.get(k).middlename.length() == 0)&&(tempauthorarray.get(l).middlename.length() == 0)){
	    							//neither have one so set it to middlenameinc
	    							tempauthorarray.get(k).middlename = Integer.toString(middlenameinc);
	    							tempauthorarray.get(l).middlename = Integer.toString(middlenameinc);
	    							tempauthorarray.get(l).edited = "phase2fix";
	    							tempauthorarray.get(k).edited = "phase2fix";
	    							middlenameinc++;
	    						}
	    					}
	    				}	
	    			}
	    		}
	    		
	    		if (tempauthorarray.get(0).lastname.trim().toLowerCase().compareTo("Beutler") == 0){
	    			String stop1 = "";
	    		}
	    		String stop88 = "";
	    	}
	    	
	    	//Finish by merging all address info of similar authors
	    	for (i = 0; i < tempauthorarray.size(); i++){
	    		
	    	}
	    }
	    public Boolean comparePmidLists(String pmidlist1, String pmidlist2){
	    	String[] pmidlistone = pmidlist1.split(",");
	    	String[] pmidlisttwo = pmidlist2.split(",");
	    	Arrays.sort(pmidlistone, NumberSort);
	    	Arrays.sort(pmidlisttwo, NumberSort);
	    	int wins = 0;
			int losses = 0;
	    	for (int i = 0; i < pmidlistone.length; i++){
	    		Boolean foundmatch = false;
	    		for (int j = 0; j < pmidlisttwo.length; j++){
	    			if (pmidlistone[i].compareTo(pmidlisttwo[j]) == 0){
	    				foundmatch = true;
	    			}
	    		}
	    		
	    		if (foundmatch){
	    			wins++;
	    		}
	    		else {
	    			losses++;
	    		}
	    	}
	    	//interperate wins vs losses and see if its significant to declar a match
	    	if (wins > losses){
	    		return true;
	    	}
	    	//BACKWARDS THIS TIME JUST IN CASE
	    	wins = 0;
			losses = 0;
	    	for (int i = 0; i < pmidlisttwo.length; i++){
	    		Boolean foundmatch = false;
	    		for (int j = 0; j < pmidlistone.length; j++){
	    			if (pmidlistone[i].compareTo(pmidlisttwo[j]) == 0){
	    				foundmatch = true;
	    			}
	    		}
	    		
	    		if (foundmatch){
	    			wins++;
	    		}
	    		else {
	    			losses++;
	    		}
	    	}
	    	//interperate wins vs losses and see if its significant to declare a match
	    	if (wins > losses){
	    		return true;
	    	}
	    	
	    	return false;
	    }
	    public String getPmidsOfAuthor(String FIRSTNAME,String MIDDLENAME, String LASTNAME, String inst, String pmid1,String country){
	    	String inputLine;
	    	String resultpmids = "";
			URL getpmidurl = null;
			try {
				getpmidurl = new URL("http://enactforum.org/authordis/getpmids.php?first="+FIRSTNAME+"&middle="+MIDDLENAME+"&last="+LASTNAME+"&inst="+inst+"&pmid="+pmid1+"&country="+country);
			} catch (MalformedURLException e1) {
				e1.printStackTrace();
			}
	        URLConnection yc = null;
	        BufferedReader in = null;
			try {
				yc = getpmidurl.openConnection();
				in = new BufferedReader(
				                        new InputStreamReader(
				                        yc.getInputStream()));
			} catch (IOException e) {
				e.printStackTrace();
			}
	        
	        try {
				while ((inputLine = in.readLine()) != null) 
				resultpmids = resultpmids + inputLine;
			} catch (IOException e) {
				e.printStackTrace();
			}
	        try {
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}     
	     
	        String temppmidlist = resultpmids.substring(0, resultpmids.indexOf("</PMIDList>"));
	        temppmidlist = temppmidlist.substring(10);
	        if (temppmidlist.length() > 2){
	        	String pattern11 = "</PMID><PMID>";
	        	temppmidlist = temppmidlist.replaceAll(pattern11, ",");
	        	String pattern12 = "<PMID>";
	        	temppmidlist = temppmidlist.replaceAll(pattern12, "");
	        	String pattern13 = "</PMID>";
	        	temppmidlist = temppmidlist.replaceAll(pattern13, "");
	        }
			String PMIDLIST = temppmidlist;
			return PMIDLIST;
	    }
}