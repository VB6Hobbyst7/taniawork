import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Random;

import org.jsoup.Jsoup;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import au.com.bytecode.opencsv.CSVReader;
public class processbook extends NotifyingThread
{
   public String[] line;
   public String souroundingvar = "'";
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public java.util.ArrayList<String>  dataArray2 = new java.util.ArrayList<String>();
   public java.util.ArrayList<String>  dataArray3 = new java.util.ArrayList<String>();
   public processbook(String[] line,java.util.ArrayList<String> dataArray,java.util.ArrayList<String> dataArray2,java.util.ArrayList<String> dataArray3)
   {
      this.line = line;
      this.dataArray = dataArray;
      this.dataArray2 = dataArray2;
      this.dataArray3 = dataArray3;
   }
   @Override
   public void doRun() {   
	   process(this.line);	
   }
	public void process(String[] line){
		String nullline = "NULL";
		String nulllineString = "''";
		if (line[4].compareTo("[No author name available]") != 0){
		String authors = line[17];
		String pmid1 = line[0];
		String pattern = "'";
		authors = authors.replaceAll(pattern, "");
		String pattern2 = "\"";
		authors = authors.replaceAll(pattern2, "");
		authors = authors.replaceAll("-", " ");
		byte ptext[] = authors.getBytes();
		try {
			authors = new String(ptext,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		authors = Normalizer.normalize(authors, Normalizer.Form.NFD);
		authors = authors.replaceAll("[^\\p{ASCII}]", "");
		authors = authors.replace("???", "");
		authors = authors.replace("??", "");
		authors = authors.replace("?", "");
		String[] author = authors.split(";");
		int tempcounter = 0;
		for (int i = 0; i < author.length; i++){
			String pstring = line[0]+Integer.toString(tempcounter);
			//dataArray3.add(pstring);
			String dstring = pstring+",";
			String[] authorvars = author[i].split(",");
			
			
			//////////////////     Table: [Profile.Import].[Person]     ////////////////////
			//internalusername
			String internalusername = getRandomString(5);
			
			
			if (internalusername.contains("ankiewicz")){
				String astop55 = "";
				if (internalusername.contains("?")){
					String astop5555 = "";
				}
			}
			//dstring = souroundingvar+internalusername+souroundingvar+",";
		
			//firstname&middlename
			dstring = dstring+getAuthorSplit(authorvars[1].trim())+",";
			//lastname
			dstring = dstring+souroundingvar+authorvars[0].trim()+souroundingvar+",";
			//displayname
			dstring = dstring+souroundingvar+authorvars[0].trim()+" "+authorvars[1].trim()+souroundingvar+",";
			//suffix
			dstring = dstring+nulllineString+",";
			//addressline1
			dstring = dstring+nulllineString+",";
			//addressline2
			dstring = dstring+nulllineString+",";
			//addressline3
			dstring = dstring+nulllineString+",";
			//addressline4
			dstring = dstring+nulllineString+",";
			//addressstring
			if (authorvars.length > 2){
				dstring = dstring+souroundingvar+isGoodLocation(authorvars[authorvars.length-3].trim()+",")+isGoodLocation(authorvars[authorvars.length-2].trim()+",")+authorvars[authorvars.length-1]+souroundingvar+",";
			}
			else {
				dstring = dstring +nulllineString+",";
			}
			//sate
			dstring = dstring +nulllineString+",";
			//city
			dstring = dstring +nulllineString+",";
			//zip
			dstring = dstring +nulllineString+",";
			//building
			dstring = dstring +nulllineString+",";
			//room
			dstring = dstring +nulllineString+",";
			//floor
			dstring = dstring +nulllineString+",";
			//lat
			dstring = dstring + nullline+",";
			//long
			dstring = dstring + nullline+",";
			//phone
			dstring = dstring +nulllineString+",";
			//fax
			dstring = dstring +nulllineString+",";
			//emailaddr
			dstring = dstring +nulllineString+",";
			//isactive
			dstring = dstring + "1,";
			//isvisible
			dstring = dstring + "1";
			dataArray.add(dstring);
			/////////////////////    Table: [Profile.Import].[PersonAffiliation]      ////////////////////
			String astring = pstring+",";
			//internalusername
			//astring = souroundingvar+internalusername+souroundingvar+",";
			//title
			astring = astring+nulllineString+",";
			//emailaddr
			astring = astring+nullline+",";
			//primaryaffiliation
			astring = astring+"1,";
			//affilliationorder
			astring = astring+"1,";
			//institutionname
			String inst = "";
			String department = "";
			
			Boolean foundexactinst = false;
			Boolean foundexactdepartment = false;
				
			for (int k = authorvars.length-1; k > 1; k--){
				if ((inst.length() == 0)&&(isAfill(authorvars[k]))&&(foundexactinst == false)){
					if (isInst(authorvars[k])){
						inst = authorvars[k];
						foundexactinst = true;
					}
					else {
						inst = authorvars[k];
					}
					
				}
				else if ((isAfill(authorvars[k]))&&(foundexactdepartment == false)){
					if ((isInst(authorvars[k]))||(authorvars[k].toLowerCase().compareTo(inst.toLowerCase()) == 0)){
						foundexactdepartment = true;
					}
					else if (isDepart(authorvars[k])){
						department = authorvars[k];
						foundexactdepartment = true;
					}
					else {
						if ((department.length() > 0)&&(containsbaddeaprtmentwords(authorvars[k]) == false)){
							department = authorvars[k].trim()+" "+department;
						}
						else if (department.length() == 0){
							department = authorvars[k].trim()+" "+department;
						}
						
					}
					
				}
			}
			department = department.trim();
			inst = inst.trim();

		/*	String instsmall = "";
			if (inst.length() > 49){
				instsmall = inst.substring(0,49);
			}
			else {
				instsmall = inst;
			}
			
			if (instsmall.compareTo("and Genetics") == 0){
				String stopasdfsd = "";
			}
			*/
			
			
			
			
			
			
			
			
			astring = astring+souroundingvar+inst+souroundingvar+",";
			//institutionabbreviation
			astring = astring+souroundingvar+inst+souroundingvar+",";
			//departmentname
			astring = astring+souroundingvar+department+souroundingvar+",";
			//departmentvisible
			if (department.length() > 0){
				astring = astring+"1,";
			}
			else {
				astring = astring+"0,";
			}	
			//divisionname
			astring = astring+nullline+",";
			//facultyrank
			astring = astring+nullline+",";
			//facultyrankorder
			astring = astring+nullline;
			dataArray2.add(astring);
			
			
			
			tempcounter++;
		
		}
		}
		
		
    }
	
	public Boolean containsbaddeaprtmentwords(String s){
		if (s.contains("Harvard Medical School")){
			return true;
		}
		else if (s.contains("Institute of High Energy Physics")){
			return true;
		}
		else if (s.contains("Institute of Biology 3 Center for Systems Biology (ZBSA)")){
			return true;
		}
		else if (s.contains("test")){
			return true;
		}
		else if (s.contains("test")){
			return true;
		}
		else if (s.contains("test")){
			return true;
		}
		else if (s.contains("test")){
			return true;
		}
		else if (s.contains("test")){
			return true;
		}
		else if (s.contains("test")){
			return true;
		}
		return false;
	}
	
	public String isGoodLocation(String s){
		s = s.toLowerCase();
		
		if (s.contains("department")){
			return "";
		}
		else if (s.contains("college")){
			return "";
		} 
		else if (s.contains("univ")){
			return "";
		} 
		else if (s.contains("science")){
			return "";
		} 
		else if (s.contains("centre")){
			return "";
		} 
		else if (s.contains("research")){
			return "";
		} 
		else if (s.contains("develop")){
			return "";
		} 
		else if (s.contains("system")){
			return "";
		} 
		else if (s.contains("health")){
			return "";
		} 
		else if (s.contains("pharma")){
			return "";
		} 
		else if (s.contains("hospit")){
			return "";
		} 
		else if (s.contains("biology")){
			return "";
		} 
		else if (s.contains("ology")){
			return "";
		} 
		else if (s.contains("school")){
			return "";
		}
		else if (s.contains("medicine")){
			return "";
		}
		else if (s.contains("medica")){
			return "";
		}
		else if (s.contains("nation")){
			return "";
		}
		else if (s.contains("instit")){
			return "";
		}
		else if (s.contains("genetic")){
			return "";
		}
		else if (s.contains("laborat")){
			return "";
		}
		else if (s.contains("academ")){
			return "";
		}
		else if (s.contains("techniq")){
			return "";
		}
		else if (s.contains("neurodegen")){
			return "";
		}
		else if (s.contains("foundation")){
			return "";
		}
		
		if (s.length() > 20){
			String stop = "";
		}
		return s;
	}
	
	public Boolean isAfill(String s){
		s = s.toLowerCase();
		
		if (s.contains("department")){
			return true;
		}
		else if (s.contains("college")){
			return true;
		} 
		else if (s.contains("univ")){
			return true;
		} 
		else if (s.contains("science")){
			return true;
		} 
		else if (s.contains("centre")){
			return true;
		} 
		else if (s.contains("research")){
			return true;
		} 
		else if (s.contains("develop")){
			return true;
		} 
		else if (s.contains("system")){
			return true;
		} 
		else if (s.contains("health")){
			return true;
		} 
		else if (s.contains("pharma")){
			return true;
		} 
		else if (s.contains("hospit")){
			return true;
		} 
		else if (s.contains("biology")){
			return true;
		} 
		else if (s.contains("ology")){
			return true;
		} 
		else if (s.contains("school")){
			return true;
		}
		else if (s.contains("medicine")){
			return true;
		}
		else if (s.contains("medica")){
			return true;
		}
		else if (s.contains("nation")){
			return true;
		}
		else if (s.contains("instit")){
			return true;
		}
		else if (s.contains("genetic")){
			return true;
		}
		else if (s.contains("laborat")){
			return true;
		}
		else if (s.contains("academ")){
			return true;
		}
		else if (s.contains("techniq")){
			return true;
		}
		else if (s.contains("neurodegen")){
			return true;
		}
		else if (s.contains("foundation")){
			return true;
		}
		
		return false;
	}
	
	public Boolean isInst(String s){
		s = s.toLowerCase();
		
		if (s.contains("college")){
			return true;
		} 
		else if (s.contains("univ")){
			return true;
		}
		else if (s.contains("inst.")){
			return true;
		}
		else if (s.contains("institut")){
			return true;
		}

		return false;
	}
	
	public Boolean isDepart(String s){
		s = s.toLowerCase();
		
		if (s.contains("depart")){
			return true;
		}
		else if (s.contains("dept")){
			return true;
		}
		else if (s.contains(" unit")){
			return true;
		}
		else if (s.contains("division")){
			return true;
		}
		
		
		return false;
	}
	
	public String getAuthorSplit(String s){
		String total = "";
		if (s.contains(".")){
			String first = s.substring(0,s.indexOf("."));
			s = s.substring(s.indexOf(".")+1,s.length());
			if (s.contains(".")){
				String last = s.substring(0,s.indexOf("."));
				
				last = last.replaceAll("\\.", "");
				last = last.replaceAll("-", "");
				last = last.trim();
				
				
				first = first.replaceAll("\\.", "");
				first = first.replaceAll("-", "");
				first = first.trim();
				
				total = souroundingvar+first+souroundingvar+","+souroundingvar+last+souroundingvar;
			}
			else {
				
				first = first.replaceAll("\\.", "");
				first = first.replaceAll("-", "");
				first = first.trim();
				
				total = souroundingvar+first+souroundingvar+","+souroundingvar+souroundingvar;
			}
		}
		else {
			
			s = s.replaceAll("\\.", "");
			s = s.replaceAll("-", "");
			s = s.trim();
			
			total = souroundingvar+s+souroundingvar+","+souroundingvar+souroundingvar;
		}
		return total;
	}
	public static String getRandomString(int length) {
	       final String characters = "1234567890";
	       StringBuilder result = new StringBuilder();
	       while(length > 0) {
	           Random rand = new Random();
	           result.append(characters.charAt(rand.nextInt(characters.length())));
	           length--;
	       }
	       return result.toString();
	    }
}