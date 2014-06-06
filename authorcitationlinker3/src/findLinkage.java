import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class findLinkage extends NotifyingThread
{
   private int number;
   public String id;
   private String au;
   private String ti;
   private String cr;
   private String py;
   private int superid;
   private String dataArray[][];
   public Statement statement = null;
   private PreparedStatement preparedStatement = null;
   
   public findLinkage(String id, String au, String ti, 
		   String cr, String py, String dataArray[][], int superid)
   {
      this.id = id;
      this.au = au;
      this.ti = ti;
      this.cr = cr;
      this.py = py;
      this.superid = superid;
      this.dataArray = dataArray;
      
   }
   @Override
   public void doRun() {
	   String authorWithComma = "";
	   String authorWithOutComma = "";
	   if (au.contains(",")){
		   authorWithComma = au;
		   authorWithOutComma = au;
		   authorWithOutComma = authorWithOutComma.replace(",", "");
	   }
	   else {
		   authorWithOutComma = au;
		   authorWithComma = au;
		   authorWithComma = authorWithComma.replace(" ", ", ");
	   }
	   System.out.println("Doing Id : "+id);
	   bothCiting(authorWithComma,py,cr,id);
	  // workCiting(authorWithOutComma,py,id,workCited(cr,id));
   	
   }
   @SuppressWarnings({ "unused", "unchecked" })
  public void bothCiting(String authorWithOutComma, String date,String tcr, String tid){
	  
	   
	   
	   
	   //CITING SECTION
	   String authorString = authorWithOutComma;
	   String authorString2 = "";
	   int ccount = 0;
	   ArrayList posAuth = new ArrayList();
	 	do {
	   		if (authorString.contains(",")){
	   			authorString2 = authorString.substring(0, authorString.indexOf(","));
	   			if (authorString.length() > authorString.indexOf(",")+2){
	   				authorString = authorString.substring( authorString.indexOf(",")+2, authorString.length());
	   			}
	   			else {
	   				authorString = "done";
	   			}
	   			
	   		}
	   		else {
	   			authorString2 = authorString;
	   			authorString = "done";
	   		}
	   		
	   		posAuth.add(authorString2.toLowerCase());
	   	   ccount = ccount + 1;
	   	 }while(authorString != "done");
	   
	 	
	 	
	 	//CITED SECTION
	 	 String CITEDauthorString = tcr;
		   String CITEDauthorString2 = "";
		   int CITEDccount = 0;
		   ArrayList CITEDposAuth = new ArrayList();
		   ArrayList CITEDposDate = new ArrayList();
		   ArrayList CITEDposTitle = new ArrayList();
		 	do {
		 		
		 		String authName = "EMPTYVAR";
		 		String authYear = "none";
		 		String authTitle = "none";
		 		
		 		if (CITEDauthorString.contains(";")){
		   			CITEDauthorString2 = CITEDauthorString.substring(0, CITEDauthorString.indexOf(";"));
		   			if (CITEDauthorString.length() > CITEDauthorString.indexOf(";")+2){
		   				CITEDauthorString = CITEDauthorString.substring( CITEDauthorString.indexOf(";")+2, CITEDauthorString.length());
		   			}
		   			else {
		   				CITEDauthorString = "done";
		   			}
		   		}
		   		else {
		   			CITEDauthorString2 = CITEDauthorString;
		   			CITEDauthorString = "done";
		   		}
		   		
		   		
		   		
		   		if ((CITEDauthorString2.contains(",") == false)||(CITEDauthorString2.indexOf("(") < CITEDauthorString2.indexOf(".,"))){
		   			authName = "none";
		   			authYear = "none";
		   		}
		   		else {		   			   			
		   			if (CITEDauthorString2.contains(".,")){
		   				String savedCitedauthstring2 = CITEDauthorString2;
		   				//System.out.println(CITEDauthorString2);
		   				authName =  CITEDauthorString2.substring(0, CITEDauthorString2.lastIndexOf(".,")+1);
		   				int savedlastauthindex = CITEDauthorString2.lastIndexOf(".,")+1;
		   				
		   				if (authName.indexOf("(") != -1){
		   					do {
		   						savedlastauthindex = authName.lastIndexOf(".,")+1;
		   						authName =  authName.substring(0, authName.lastIndexOf(".,")+1);	
		   					} while (authName.indexOf("(") != -1);
		   					
		   				}
		   				
		   				CITEDauthorString2 = CITEDauthorString2.substring(savedlastauthindex+2, CITEDauthorString2.length());
		   				authTitle = CITEDauthorString2.substring(0, CITEDauthorString2.indexOf("("));
		   			}
		   			else {		
		   				String ERRORADDRESSTHISISSUE = "";
		   			}
		   			
		   			authName.replace("*", "");	   		
		   			CITEDposAuth.add(authName);
		   			//CITEDposDate.add(authYear);
		   			CITEDposTitle.add(authTitle);
			   		CITEDccount = CITEDccount + 1;
		   		}
		   	 }while(CITEDauthorString != "done");
		 	
	   String citeb = "";
	   String citef = "";
	   int tempcount = 0;
	   int tempcount2 = 0;
	   //for each item in the entire database
	   for (int i = 0; i < dataArray.length; i++){
		   
		   //for each of my current authors
		   String titleseq = ti.toLowerCase();
		   int hit1 = 0;
		   Boolean titleyes = false;
		  for (int j = 0; j < posAuth.size(); j++){
			   String charseq = posAuth.get(j).toString().toLowerCase();
			   String charseq2 = charseq;
			   charseq2 = charseq2.replace(" ", ", ");
			   if (dataArray[i][3].toLowerCase().contains(charseq)){  
				   hit1++;
			   }
			   else if (dataArray[i][3].toLowerCase().contains(charseq2)){  
				   hit1++;
			   }
		   }
		   
		   if (dataArray[i][3].toLowerCase().contains(titleseq)){  
			   hit1++;
			   titleyes = true;
		   }
		   
		   //if at least 50% of hits then its a good one
		   if ((hit1 >= posAuth.size())||(titleyes)){
			   if (tempcount == 0){
				   citeb = dataArray[i][0].toString();
			   }
			   else {
				   citeb = citeb.concat(",");
				   citeb = citeb.concat(dataArray[i][0].toString());
			   }
			   tempcount++;
		   }
		   
		   
		   
		   int hit2 = 0;
		   Boolean titleyes2 = false;
		   //for each of my cited authors
		   for (int j = 0; j < CITEDposAuth.size(); j++){
			   String charseq = CITEDposAuth.get(j).toString().toLowerCase();
			  // String chardate = CITEDposDate.get(j).toString().toLowerCase();
			   String chartitle = CITEDposTitle.get(j).toString().toLowerCase();
			   String[] authparts = charseq.split("\\., ");
			   
			   for (int k = 0; k < authparts.length; k++){
				   String citedcharseq = authparts[k].toString().toLowerCase();
				   String citedcharseq2 = citedcharseq;
				   citedcharseq2 = citedcharseq2.replace(",", " ");
				   if (dataArray[i][1].toLowerCase().contains(citedcharseq)){ 
					   hit2++;
				   }
				   else if (dataArray[i][1].toLowerCase().contains(citedcharseq2)){  
					   hit2++;
				   }
			   }
			   
			   
			   if (dataArray[i][2].toLowerCase().contains(chartitle)){  
				   hit2++;
				   titleyes2 = true;
			   }
			   
			   
			   if ((((hit2 >= authparts.length)||(titleyes2))&&(chartitle.length() > 20))||
					   (((hit2 >= authparts.length)&&(titleyes2))&&(chartitle.length() <= 20))){
				   if (tempcount2 == 0){
					   citef = dataArray[i][0].toString();
				   }
				   else {
					   citef = citef.concat(",");
					   citef = citef.concat(dataArray[i][0].toString());
				   }
				   tempcount2++;
			   }
 
		   }
		 
		   
		 
		   
		 
	   }
	   

	  dataArray[superid][6] = dataArray[superid][6] + citeb;
	   dataArray[superid][5] = dataArray[superid][5] + citef;
	   
   }
   public static boolean isNumeric(String str)
   {
     return str.matches("-?\\d+(\\.\\d+)?");  //match a number with optional '-' and decimal.
   }
}