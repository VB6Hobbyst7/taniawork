/*   1:    */ package edu.iu.nwb.composite.extractpapercitationnetwork.algorithm;
/*   2:    */ 
/*   3:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.ExtractNetworkFromTable;
/*   4:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer;
/*   5:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer.PropertyParsingException;
/*   6:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.InvalidColumnNameException;

/*   7:    */ import java.io.FileNotFoundException;
/*   8:    */ import java.io.IOException;
/*   9:    */ import java.io.InputStream;
/*  10:    */ import java.util.Dictionary;
/*  11:    */ import java.util.Properties;

/*  12:    */ import org.cishell.framework.CIShellContext;
/*  13:    */ import org.cishell.framework.algorithm.Algorithm;
/*  14:    */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  15:    */ import org.cishell.framework.algorithm.ProgressMonitor;
/*  16:    */ import org.cishell.framework.algorithm.ProgressTrackable;
/*  17:    */ import org.cishell.framework.data.BasicData;
/*  18:    */ import org.cishell.framework.data.Data;
/*  19:    */ import org.osgi.service.log.LogService;

/*  20:    */ import prefuse.data.Graph;
/*  21:    */ import prefuse.data.Table;
/*  22:    */ 
/*  23:    */ public class ExtractPaperCitationNetwork
/*  24:    */   implements Algorithm, ProgressTrackable
/*  25:    */ {
/*  26:    */   public static final String ISI_FILE_TYPE = "isi";
/*  27:    */   public static final String PAPER_COLUMN_NAME = "Cite Me As";
/*  28:    */   public static final String CITATION_COLUMN_NAME = "Cited References";
/*  29:    */   private Data[] data;
/*  30:    */   private LogService logger;
/*  31:    */   private ProgressMonitor progressMonitor;
/*  32:    */   
/*  33:    */   public ExtractPaperCitationNetwork(Data[] data, CIShellContext context)
/*  34:    */   {
/*  35: 36 */     this.data = data;
/*  36:    */     
/*  37: 38 */     this.logger = ((LogService)context.getService(LogService.class.getName()));
/*  38:    */   }
/*  39:    */   
/*  40:    */   public Data[] execute()
/*  41:    */     throws AlgorithmExecutionException
/*  42:    */   {
/*  43: 42 */     Table inTable = (Table)this.data[0].getData();
/*  44:    */     
/*  45: 44 */     String fileFormatPropertiesFile = getFileTypeProperties("isi");
/*  46:    */     
/*  47: 46 */     ClassLoader loader = getClass().getClassLoader();
/*  48: 47 */     InputStream fileTypePropertiesFile = 
/*  49: 48 */       loader.getResourceAsStream(fileFormatPropertiesFile);
/*  50:    */     
/*  51: 50 */     Properties metaData = new Properties();
/*  52:    */     try
/*  53:    */     {
/*  54: 52 */       metaData.load(fileTypePropertiesFile);
/*  55:    */     }
/*  56:    */     catch (FileNotFoundException e)
/*  57:    */     {
/*  58: 54 */       this.logger.log(1, e.getMessage(), e);
/*  59:    */     }
/*  60:    */     catch (IOException e)
/*  61:    */     {
/*  62: 56 */       this.logger.log(1, e.getMessage(), e);
/*  63:    */     }
/*  64:    */     try
/*  65:    */     {
/*  66: 60 */       GraphContainer gc = 
/*  67: 61 */         GraphContainer.initializeGraph(
/*  68: 62 */         inTable, 
/*  69: 63 */         "Cited References", 
/*  70: 64 */         "Cite Me As", 
/*  71: 65 */         true, 
/*  72: 66 */         metaData, 
/*  73: 67 */         this.logger, 
/*  74: 68 */         this.progressMonitor);
/*  75:    */       
/*  76: 70 */       Graph outputGraph = 
/*  77: 71 */         gc.buildGraph("Cited References", "Cite Me As", "|", false, this.logger);
/*  78: 72 */       Data outputGraphData = createOutputGraphData(outputGraph);
					Boolean donewcode = true;  


		

if (donewcode){
Table dataTable = inTable;					
int i = 0;

String authorColumnNeeded = "Authors";
int authorColumnIndex = 0;

String dataTableColumnNeded2 = "Title";
int dataTableColumnIndex2 = 0;

String dataTableColumnNeded3 = "Allo";
int dataTableColumnIndex3 = 0;

String dataTableColumnNeded4 = "Auto";
int dataTableColumnIndex4 = 0;

String term1 = "CLINICAL TRIAL";
String term2 = "CASE REPORTS";

for (int p = 0; p < dataTable.getColumnCount(); p++){
	if (dataTableColumnNeded2.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
		dataTableColumnIndex2 = p;
		this.logger.log(1, "Analyzing Column2 : "+dataTable.getColumnName(p));
	}
	
	if (authorColumnNeeded.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
		authorColumnIndex = p;
		this.logger.log(1, "Author Column found : "+dataTable.getColumnName(p));
	}
	
	if (dataTableColumnNeded3.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
		dataTableColumnIndex3 = p;
		this.logger.log(1, "Allo Column found : "+dataTable.getColumnName(p));
	}
	
	if (dataTableColumnNeded4.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
		dataTableColumnIndex4 = p;
		this.logger.log(1, "Auto Column found : "+dataTable.getColumnName(p));
	}
}

int erorcount = 0;
outputGraph.addColumn("oldid", String.class);
outputGraph.addColumn("special", int.class);
outputGraph.addColumn("termso", String.class);
outputGraph.addColumn("linkweight", int.class);

int initialsizeedge = outputGraph.getEdgeCount();
int endcount = outputGraph.getNodeCount();
String lasttarget = "";

this.logger.log(1, "Here 1");
try{
	for (i = 0; i < outputGraph.getNodeCount(); i++){
		outputGraph.getNode(i).setInt("regular", 0);
		outputGraph.getNode(i).setString("amount", "0");
		outputGraph.getNode(i).setInt("linkweight", 0);
		outputGraph.getNode(i).setString("termso", "none");
	}
}
catch (ArrayIndexOutOfBoundsException e) {}

this.logger.log(1, "Here 2");
int counter = 0;
for (i = 0; i < initialsizeedge; i++){
	String source1 = outputGraph.getEdge(i).get("source").toString();
	String target1 = outputGraph.getEdge(i).get("target").toString();
	if (lasttarget.compareTo(target1) != 0){
		lasttarget = target1;
		String termso = "";
		String titlecheck =  outputGraph.getNode(Integer.parseInt(target1)).get("label").toString();
		
		
		/*
		String nc = dataTable.getString(counter, dataTableColumnNeded3).toLowerCase() + " " + dataTable.getString(counter, dataTableColumnIndex2).toLowerCase();
		if ((nc.contains(term1))&&(nc.contains(term2))){
			termso = "Both";
		}
		else if (nc.contains(term1)){
			termso = term1;
		}
		else if (nc.contains(term2)){
			termso = term2;
		}
		else {
			termso = "neither";
		}*/
		
		int count1 = Integer.parseInt(dataTable.getString(counter, dataTableColumnNeded3));
		int count2 = Integer.parseInt(dataTable.getString(counter, dataTableColumnNeded4));
		
		if ((count1 == 0)&&(count2 == 0)){
			termso = "neither";
		}
		else if (count1 == count2){
			termso = "both";
		}
		else if (count1 > count2){
			termso = "Allo";
		}
		else if (count1 < count2){
			termso = "Auto";
		}
		else {
			termso = "neither";
		}

		outputGraph.addNode();
		outputGraph.getNode(outputGraph.getNodeCount()-1).setString("label", outputGraph.getNode(Integer.parseInt(target1)).get("label").toString());
	//	outputGraph.getNode(outputGraph.getNodeCount()-1).setInt("linkweight", Integer.parseInt(outputGraph.getNode(Integer.parseInt(target1)).get("linkweight").toString()));
		outputGraph.getNode(outputGraph.getNodeCount()-1).setInt("linkweight",0);

		outputGraph.getNode(outputGraph.getNodeCount()-1).setString("oldid", target1);
		outputGraph.getNode(outputGraph.getNodeCount()-1).setInt("special", 10);
		if (termso.length() > 0){
			outputGraph.getNode(outputGraph.getNodeCount()-1).setString("termso", termso); 
		}
		else {
			outputGraph.getNode(outputGraph.getNodeCount()-1).setString("termso", "none"); 
		}
		counter++;
	}		
}
this.logger.log(1, "Here 4");
for (i = 0; i < initialsizeedge; i++){
	String source1 = outputGraph.getEdge(i).get("source").toString();
	String target1 = outputGraph.getEdge(i).get("target").toString();
	this.logger.log(1, "done "+Integer.toString(i)+"/"+Integer.toString(initialsizeedge));
	if (i != initialsizeedge-1){
		for (int k = i+1; k < initialsizeedge; k++){
			//this.logger.log(1, "Here 8");
			String source2 = outputGraph.getEdge(k).get("source").toString();
			String target2 = outputGraph.getEdge(k).get("target").toString();
			if ((target2.compareTo(target1) != 0)&&(source2.compareTo(source1) == 0)){
				String target3 = "";
				String source3 = "";
			
				for (int j = endcount; j < outputGraph.getNodeCount(); j++){
					if (target2.compareTo(outputGraph.getNode(j).get("oldid").toString()) == 0){
						target3 = Integer.toString(j);
					}
					
					if (target1.compareTo(outputGraph.getNode(j).get("oldid").toString()) == 0){
						source3 = Integer.toString(j);
					}
					
				}
			//	this.logger.log(1, "Here 9");
				Boolean goodtogo = true;
				for (int kk = initialsizeedge; kk < outputGraph.getEdgeCount(); kk++){
					if ((outputGraph.getEdge(kk).getString("source").compareTo(source3) == 0)&&
							(outputGraph.getEdge(kk).getString("target").compareTo(target3) == 0)){
						outputGraph.getEdge(kk).setInt("linkweight", outputGraph.getEdge(kk).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(source3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(source3)).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(target3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(target3)).getInt("linkweight")+1);
						goodtogo = false;
					}
					else if ((outputGraph.getEdge(kk).getString("source").compareTo(target3) == 0)&&
							(outputGraph.getEdge(kk).getString("target").compareTo(source3) == 0)){
						outputGraph.getEdge(kk).setInt("linkweight", outputGraph.getEdge(kk).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(source3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(source3)).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(target3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(target3)).getInt("linkweight")+1);
						goodtogo = false;
					}
				}
			//	this.logger.log(1, "Here 10");
				if (goodtogo){
					outputGraph.addEdge(outputGraph.getNode(Integer.parseInt(target3)), outputGraph.getNode(Integer.parseInt(source3)));
					outputGraph.getEdge(outputGraph.getEdgeCount()-1).setInt("linkweight", 1);
					outputGraph.getEdge(outputGraph.getEdgeCount()-1).setString("oldid", "1");
				//	outputGraph.getEdge(outputGraph.getEdgeCount()-1).setString("termo", "none");
					outputGraph.getEdge(outputGraph.getEdgeCount()-1).setInt("special", 10);
				}
				
			}
		}
	}
	
}
this.logger.log(1, "Here 5");
outputGraph.removeEdge(outputGraph.getEdgeCount()-1);
this.logger.log(1, "errorfound: "+Integer.toString(erorcount));
}			
					
					
					
					
					/*
if (donewcode){
Table dataTable = inTable;					
int i = 0;

String authorColumnNeeded = "Authors";
int authorColumnIndex = 0;

String dataTableColumnNeded2 = "Title";
int dataTableColumnIndex2 = 0;

String dataTableColumnNeded3 = "Abstract";
int dataTableColumnIndex3 = 0;

String term1 = "protein";
String term2 = "contain";

for (int p = 0; p < dataTable.getColumnCount(); p++){
	if (dataTableColumnNeded2.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
		dataTableColumnIndex2 = p;
		this.logger.log(1, "Analyzing Column2 : "+dataTable.getColumnName(p));
	}
	
	if (authorColumnNeeded.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
		authorColumnIndex = p;
		this.logger.log(1, "Author Column found : "+dataTable.getColumnName(p));
	}
	
	if (dataTableColumnNeded3.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
		dataTableColumnIndex3 = p;
		this.logger.log(1, "Abstract Column found : "+dataTable.getColumnName(p));
	}
}

int erorcount = 0;
outputGraph.addColumn("oldid", String.class);
outputGraph.addColumn("special", int.class);
outputGraph.addColumn("termso", String.class);
outputGraph.addColumn("linkweight", int.class);

int initialsizeedge = outputGraph.getEdgeCount();
int endcount = outputGraph.getNodeCount();
String lasttarget = "";

this.logger.log(1, "Here 1");
try{
	for (i = 0; i < outputGraph.getNodeCount(); i++){
		outputGraph.getNode(i).setInt("regular", 0);
		outputGraph.getNode(i).setString("amount", "0");
		outputGraph.getNode(i).setInt("linkweight", 0);
		outputGraph.getNode(i).setString("termso", "none");
	}
}
catch (ArrayIndexOutOfBoundsException e) {}

this.logger.log(1, "Here 2");
int counter = 0;
for (i = 0; i < initialsizeedge; i++){
	String source1 = outputGraph.getEdge(i).get("source").toString();
	String target1 = outputGraph.getEdge(i).get("target").toString();
	if (lasttarget.compareTo(target1) != 0){
		lasttarget = target1;
		String termso = "";
		String titlecheck =  outputGraph.getNode(Integer.parseInt(target1)).get("label").toString();
		String nc = dataTable.getString(counter, dataTableColumnNeded3).toLowerCase() + " " + dataTable.getString(counter, dataTableColumnIndex2).toLowerCase();
		if ((nc.contains(term1))&&(nc.contains(term2))){
			termso = "Both";
		}
		else if (nc.contains(term1)){
			termso = term1;
		}
		else if (nc.contains(term2)){
			termso = term2;
		}
		else {
			termso = "neither";
		}

		outputGraph.addNode();
		outputGraph.getNode(outputGraph.getNodeCount()-1).setString("label", outputGraph.getNode(Integer.parseInt(target1)).get("label").toString());
	//	outputGraph.getNode(outputGraph.getNodeCount()-1).setInt("linkweight", Integer.parseInt(outputGraph.getNode(Integer.parseInt(target1)).get("linkweight").toString()));
		outputGraph.getNode(outputGraph.getNodeCount()-1).setInt("linkweight",0);

		outputGraph.getNode(outputGraph.getNodeCount()-1).setString("oldid", target1);
		outputGraph.getNode(outputGraph.getNodeCount()-1).setInt("special", 10);
		if (termso.length() > 0){
			outputGraph.getNode(outputGraph.getNodeCount()-1).setString("termso", termso); 
		}
		else {
			outputGraph.getNode(outputGraph.getNodeCount()-1).setString("termso", "none"); 
		}
		counter++;
	}		
}
this.logger.log(1, "Here 4");
for (i = 0; i < initialsizeedge; i++){
	String source1 = outputGraph.getEdge(i).get("source").toString();
	String target1 = outputGraph.getEdge(i).get("target").toString();
	//this.logger.log(1, "Here 7");
	if (i != initialsizeedge-1){
		for (int k = i+1; k < initialsizeedge; k++){
			//this.logger.log(1, "Here 8");
			String source2 = outputGraph.getEdge(k).get("source").toString();
			String target2 = outputGraph.getEdge(k).get("target").toString();
			if ((target2.compareTo(target1) != 0)&&(source2.compareTo(source1) == 0)){
				String target3 = "";
				String source3 = "";
			
				for (int j = endcount; j < outputGraph.getNodeCount(); j++){
					if (target2.compareTo(outputGraph.getNode(j).get("oldid").toString()) == 0){
						target3 = Integer.toString(j);
					}
					
					if (target1.compareTo(outputGraph.getNode(j).get("oldid").toString()) == 0){
						source3 = Integer.toString(j);
					}
					
				}
			//	this.logger.log(1, "Here 9");
				Boolean goodtogo = true;
				for (int kk = initialsizeedge; kk < outputGraph.getEdgeCount(); kk++){
					if ((outputGraph.getEdge(kk).getString("source").compareTo(source3) == 0)&&
							(outputGraph.getEdge(kk).getString("target").compareTo(target3) == 0)){
						outputGraph.getEdge(kk).setInt("linkweight", outputGraph.getEdge(kk).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(source3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(source3)).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(target3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(target3)).getInt("linkweight")+1);
						goodtogo = false;
					}
					else if ((outputGraph.getEdge(kk).getString("source").compareTo(target3) == 0)&&
							(outputGraph.getEdge(kk).getString("target").compareTo(source3) == 0)){
						outputGraph.getEdge(kk).setInt("linkweight", outputGraph.getEdge(kk).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(source3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(source3)).getInt("linkweight")+1);
						outputGraph.getNode(Integer.parseInt(target3)).setInt("linkweight", outputGraph.getNode(Integer.parseInt(target3)).getInt("linkweight")+1);
						goodtogo = false;
					}
				}
			//	this.logger.log(1, "Here 10");
				if (goodtogo){
					outputGraph.addEdge(outputGraph.getNode(Integer.parseInt(target3)), outputGraph.getNode(Integer.parseInt(source3)));
					outputGraph.getEdge(outputGraph.getEdgeCount()-1).setInt("linkweight", 1);
					outputGraph.getEdge(outputGraph.getEdgeCount()-1).setString("oldid", "1");
				//	outputGraph.getEdge(outputGraph.getEdgeCount()-1).setString("termo", "none");
					outputGraph.getEdge(outputGraph.getEdgeCount()-1).setInt("special", 10);
				}
				
			}
		}
	}
	
}
this.logger.log(1, "Here 5");
outputGraph.removeEdge(outputGraph.getEdgeCount()-1);
this.logger.log(1, "errorfound: "+Integer.toString(erorcount));
}
*/


   Table outputTable = ExtractNetworkFromTable.constructTable(outputGraph);
		Data outputTableData = createOutputTableData(outputTable);
/*  83:    */       
/*  84: 78 */       return new Data[] { outputGraphData, outputTableData };
/*  85:    */     }
/*  86:    */     catch (InvalidColumnNameException e)
/*  87:    */     {
/*  88: 80 */       throw new AlgorithmExecutionException(e.getMessage(), e);
/*  89:    */     }
/*  90:    */     catch (GraphContainer.PropertyParsingException e)
/*  91:    */     {
/*  92: 82 */       throw new AlgorithmExecutionException(e);
/*  93:    */     }
/*  94:    */   }
/*  95:    */   
/*  96:    */   private Data createOutputTableData(Table outputTable)
/*  97:    */   {
/*  98: 88 */     Data outputTableData = 
/*  99: 89 */       new BasicData(outputTable, Table.class.getName());
/* 100: 90 */     Dictionary tableAttributes = outputTableData.getMetadata();
/* 101: 91 */     tableAttributes.put("Modified", new Boolean(true));
/* 102: 92 */     tableAttributes.put("Parent", this.data[0]);
/* 103: 93 */     tableAttributes.put("Type", "Matrix");
/* 104: 94 */     tableAttributes.put("Label", "Paper information");
/* 105: 95 */     return outputTableData;
/* 106:    */   }
/* 107:    */   
/* 108:    */   private Data createOutputGraphData(Graph outputGraph)
/* 109:    */   {
/* 110: 99 */     Data outputGraphData = new BasicData(outputGraph, Graph.class.getName());
/* 111:100 */     Dictionary graphAttributes = outputGraphData.getMetadata();
/* 112:101 */     graphAttributes.put("Modified", new Boolean(true));
/* 113:102 */     graphAttributes.put("Parent", this.data[0]);
/* 114:103 */     graphAttributes.put("Type", "Network");
/* 115:104 */     graphAttributes.put("Label", "Extracted paper-citation network");
/* 116:105 */     return outputGraphData;
/* 117:    */   }
/* 118:    */   
/* 119:    */   private String getFileTypeProperties(String fileType)
/* 120:    */   {
/* 121:109 */     String propertiesFileName = "/edu/iu/nwb/composite/extractpapercitationnetwork/metadata/";
/* 122:110 */     return propertiesFileName + fileType + ".properties";
/* 123:    */   }
/* 124:    */   
/* 125:    */   public ProgressMonitor getProgressMonitor()
/* 126:    */   {
/* 127:114 */     return this.progressMonitor;
/* 128:    */   }
/* 129:    */   
/* 130:    */   public void setProgressMonitor(ProgressMonitor monitor)
/* 131:    */   {
/* 132:118 */     this.progressMonitor = monitor;
/* 133:    */   }
/* 134:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\javasrc\important ones\edu.iu.nwb.composite.extractpapercitationnetwork_0.0.2.jar
 * Qualified Name:     edu.iu.nwb.composite.extractpapercitationnetwork.algorithm.ExtractPaperCitationNetwork
 * JD-Core Version:    0.7.0.1
 */