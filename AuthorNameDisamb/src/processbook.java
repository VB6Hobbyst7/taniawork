import java.io.UnsupportedEncodingException;
import java.text.Normalizer;
import java.util.Random;
public class processbook extends NotifyingThread
{
   public String[] line;
   public String souroundingvar = "\"";
   public String seperator = ";";
   public java.util.ArrayList<String>  dataArray = new java.util.ArrayList<String>();
   public java.util.ArrayList<String>  dataArray2 = new java.util.ArrayList<String>();
   public java.util.ArrayList<String>  dataArray3 = new java.util.ArrayList<String>();
   public processbook(String[] line,java.util.ArrayList<String> dataArray)
   {
      this.line = line;
      this.dataArray = dataArray;
   }
   @Override
   public void doRun() {   
	   process(this.line);	
   }
	public void process(String[] line){
		if (line[4].compareTo("[No author name available]") != 0){
		String authors = line[17];
		String pmid1 = line[0];
		String YEAR = line[6];
		String COAUTHORS = line[4];
		String pattern = "'";
		authors = authors.replaceAll(pattern, "");
		String pattern2 = "\"";
		authors = authors.replaceAll(pattern2, "");
		authors = authors.replaceAll("-", " ");
		byte ptext[] = authors.getBytes();
		try {
			authors = new String(ptext,"UTF-8");
		} catch (UnsupportedEncodingException e) {
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
			String authoridstring = line[0]+Integer.toString(tempcounter);
			String art = "";
			String[] authorvars = author[i].split(",");
			if (authorvars.length > 1){
				String firstmiddletemp = getAuthorSplit(authorvars[1].trim());
				String FIRSTNAME = firstmiddletemp.substring(0,firstmiddletemp.indexOf(","));
				String MIDDLENAME = firstmiddletemp.substring(firstmiddletemp.indexOf(",")+1,firstmiddletemp.length());
				FIRSTNAME = FIRSTNAME.replaceAll(pattern2, "");
				MIDDLENAME = MIDDLENAME.replaceAll(pattern2, "");
				String LASTNAME = authorvars[0].trim();
				String DISPLAYNAME = authorvars[0].trim()+" "+authorvars[1].trim();
				String COUNTRY = "";
				String ADDRESS = "";
				if (authorvars.length > 2){
					ADDRESS = isGoodLocation(authorvars[authorvars.length-3].trim()+",")+isGoodLocation(authorvars[authorvars.length-2].trim()+",")+authorvars[authorvars.length-1].trim();
					ADDRESS = ADDRESS.trim();
					COUNTRY = authorvars[authorvars.length-1].trim();
				}
				
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
	        	String PMIDLIST = "";
				dataArray.add(souroundingvar+pmid1+souroundingvar+seperator+
						souroundingvar+FIRSTNAME+souroundingvar+seperator+
						souroundingvar+MIDDLENAME+souroundingvar+seperator+
						souroundingvar+LASTNAME+souroundingvar+seperator+
						souroundingvar+DISPLAYNAME+souroundingvar+seperator+
						souroundingvar+COUNTRY+souroundingvar+seperator+
						souroundingvar+ADDRESS+souroundingvar+seperator+
						souroundingvar+inst+souroundingvar+seperator+
						souroundingvar+department+souroundingvar+seperator+
						souroundingvar+PMIDLIST+souroundingvar+seperator+
						souroundingvar+YEAR+souroundingvar+seperator+
						souroundingvar+COAUTHORS+souroundingvar);
				tempcounter++;
			}
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
		else if (s.contains("osp.")){
			return "";
		} 
		else if (s.contains("hop.")){
			return "";
		} 
		else if (s.contains("publ.")){
			return "";
		} 
		else if (s.contains("fond.")){
			return "";
		} 
		else if (s.contains("min.")){
			return "";
		} 
		else if (s.contains("civ.")){
			return "";
		} 
		else if (s.contains("ist.")){
			return "";
		} 
		else if (s.contains("lab.")){
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
		else if (s.contains("dept.")){
			return "";
		}
		else if (s.contains("sci.")){
			return "";
		}
		else if (s.contains("clin.")){
			return "";
		}
		else if (s.contains("med.")){
			return "";
		}
		else if (s.contains("acad.")){
			return "";
		}
		else if (s.contains("hosp.")){
			return "";
		}
		else if (s.contains("nat.")){
			return "";
		}
		else if (s.contains("inst.")){
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
		else if (s.contains("dept.")){
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
		else if (s.contains("lab.")){
			return true;
		}
		else if (s.contains("med.")){
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
		if (s.contains("dept.")){
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
		else if (s.contains("lab.")){
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