 package edu.iu.nwb.composite.extractauthorpapernetwork.algorithm;
import edu.iu.nwb.analysis.extractnetfromtable.components.ExtractNetworkFromTable;
/*   4:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer;
/*   5:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer.PropertyParsingException;
/*   6:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.InvalidColumnNameException;
/*   7:    */ import edu.iu.nwb.composite.extractauthorpapernetwork.metadata.AuthorPaperFormat;

/*   8:    */ import java.io.FileNotFoundException;
/*   9:    */ import java.io.IOException;
/*  10:    */ import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
/*  11:    */ import java.util.Dictionary;
/*  12:    */ import java.util.Map;
/*  13:    */ import java.util.Properties;
import javax.swing.SwingUtilities;
/*  14:    */ import org.cishell.framework.algorithm.Algorithm;
/*  15:    */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  16:    */ import org.cishell.framework.algorithm.ProgressMonitor;
/*  17:    */ import org.cishell.framework.algorithm.ProgressTrackable;
/*  18:    */ import org.cishell.framework.data.BasicData;
/*  19:    */ import org.cishell.framework.data.Data;
/*  20:    */ import org.osgi.service.log.LogService;

/*  21:    */ import prefuse.data.Graph;
/*  22:    */ import prefuse.data.Table;
/*  23:    */ 
/*  24:    */ public class ExtractAuthorPaperNetwork
/*  25:    */   implements Algorithm, ProgressTrackable
/*  26:    */ {
/*  27:    */   private Data inData;
/*  28:    */   private LogService logger;
/*  29:    */   private Table table;
/*  30:    */   private String fileFormat;
				public int numberofcores = 4;
/*  31:    */   private String fileFormatPropertiesFileName;
/*  32:    */   private ProgressMonitor progressMonitor;
/*  33:    */   
/*  34:    */   public ExtractAuthorPaperNetwork(Table table, String fileFormat, Data inData, LogService logger)
/*  35:    */   {
/*  36: 36 */     this.table = table;
/*  37: 37 */     this.fileFormat = fileFormat;
/*  38: 38 */     this.inData = inData;
/*  39: 39 */     this.logger = logger;
/*  40:    */     
/*  41: 41 */     this.fileFormatPropertiesFileName = getFileTypePropertiesFileName(this.fileFormat);
/*  42:    */   }
/*  43:    */   
/*  44:    */   public Data[] execute()
/*  45:    */     throws AlgorithmExecutionException
/*  46:    */   {
/*  47:    */     try
/*  48:    */     {
/*  49: 46 */       Graph outputNetwork = constructNetwork();
					Table dataTable = this.table;					
					int i = 0;
					
					String dataTableColumnNeded = "id";
					int dataTableColumnIndex = 0;
					
					String authorColumnNeeded = "Authors";
					int authorColumnIndex = 0;
					
					
					String dataTableColumnNeded2 = "Title";
					int dataTableColumnIndex2 = 0;
					
					String dataTableColumnNeded3 = "Abstract";
					int dataTableColumnIndex3 = 0;
					
					String term1 = "auto";
					String term2 = "allo";
					
					
					
					for (int p = 0; p < dataTable.getColumnCount(); p++){
						if (dataTableColumnNeded.toLowerCase().compareTo(dataTable.getColumnName(p).toLowerCase()) == 0){
							dataTableColumnIndex = p;
							this.logger.log(1, "Analyzing Column : "+dataTable.getColumnName(p));
						}

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
					outputNetwork.addColumn("oldid", String.class);
					outputNetwork.addColumn("special", int.class);
					outputNetwork.addColumn("termso", String.class);

					int initialsizeedge = outputNetwork.getEdgeCount();
					int endcount = outputNetwork.getNodeCount();
					String lasttarget = "";
					
					this.logger.log(1, "Here 1");
					try{
						for (i = 0; i < outputNetwork.getNodeCount(); i++){
							outputNetwork.getNode(i).setInt("regular", 0);
							outputNetwork.getNode(i).setString("amount", "0");
							outputNetwork.getNode(i).setString("termso", "none");
						}
					}
					catch (ArrayIndexOutOfBoundsException e) {}
					this.logger.log(1, "Here 2");
					int counter = 0;
					for (i = 0; i < initialsizeedge; i++){
						String source1 = outputNetwork.getEdge(i).get("source").toString();
						String target1 = outputNetwork.getEdge(i).get("target").toString();
						if (lasttarget.compareTo(target1) != 0){
							lasttarget = target1;
							String termso = "";
							String titlecheck =  outputNetwork.getNode(Integer.parseInt(target1)).get("label").toString();
									String nc = dataTable.getString(counter, dataTableColumnNeded3).toLowerCase() + " " + dataTable.getString(counter, dataTableColumnIndex2).toLowerCase();
									if ((nc.contains(term1))&&(nc.contains(term2))){
										termso = "Both";
									}
									else	 if (nc.contains(term1)){
										termso = term1;
									}
									else if (nc.contains(term2)){
										termso = term2;
									}
									else {
										termso = "neither";
									}
							outputNetwork.addNode();
							outputNetwork.getNode(outputNetwork.getNodeCount()-1).setString("label", outputNetwork.getNode(Integer.parseInt(target1)).get("label").toString());
							outputNetwork.getNode(outputNetwork.getNodeCount()-1).setInt("numberOfWorks", Integer.parseInt(outputNetwork.getNode(Integer.parseInt(target1)).get("numberOfWorks").toString()));
							outputNetwork.getNode(outputNetwork.getNodeCount()-1).setString("oldid", target1);
							outputNetwork.getNode(outputNetwork.getNodeCount()-1).setInt("special", 10);
							if (termso.length() > 0){
								outputNetwork.getNode(outputNetwork.getNodeCount()-1).setString("termso", termso); 
							}
							else {
								outputNetwork.getNode(outputNetwork.getNodeCount()-1).setString("termso", "none"); 
							}
							counter++;
						}		
					}
					this.logger.log(1, "Here 4");
					Thread tarray[] = new Thread[numberofcores];
					for (i = 0; i < initialsizeedge; i++){
						String source1 = outputNetwork.getEdge(i).get("source").toString();
						String target1 = outputNetwork.getEdge(i).get("target").toString();
						this.logger.log(1, "Doing : "+Integer.toString(i)+"/"+Integer.toString(initialsizeedge));
						Boolean didit = false;
						Boolean foundacore = false;
						if (i != initialsizeedge-1){
							do {
						  		for (int ll = 0; ll < numberofcores; ll++){
						  			if ((tarray[ll] == null)||(tarray[ll].isAlive() == false)){
						  				try{
						  					NotifyingThread newThread = 
						  							new processfile(initialsizeedge,outputNetwork,source1,target1,endcount, i);
						  					tarray[ll] = newThread;
						  					tarray[ll].start();	
						  					foundacore = true;
						  				}
										catch(Exception StringIndexOutOfBoundsException){	
						  				}
						  			}
						  		}
					  		} while (foundacore == false);
						}
					}
					outputNetwork.removeEdge(outputNetwork.getEdgeCount()-1);
					this.logger.log(1, "errorfound: "+Integer.toString(erorcount));
					Data graphData = wrapOutputNetworkAsData(outputNetwork);
/*  52: 49 */       Table outputTable = ExtractNetworkFromTable.constructTable(outputNetwork);
/*  53: 50 */       Data tableData = wrapOutputTableAsData(outputTable);
/*  54:    */       
/*  55: 52 */       return new Data[] { graphData, tableData };
/*  56:    */     }
/*  57:    */     catch (InvalidColumnNameException e)
/*  58:    */     {
	this.logger.log(1, "BIG ERROR");
/*  59: 54 */       throw new AlgorithmExecutionException(e.getMessage(), e);
/*  60:    */     }
/*  61:    */   }
/*  62:    */   
/*  63:    */   public ProgressMonitor getProgressMonitor()
/*  64:    */   {
/*  65: 59 */     return this.progressMonitor;
/*  66:    */   }
/*  67:    */   
/*  68:    */   public void setProgressMonitor(ProgressMonitor progressMonitor)
/*  69:    */   {
/*  70: 63 */     this.progressMonitor = progressMonitor;
/*  71:    */   }
/*  72:    */   
/*  73:    */   private Data wrapOutputNetworkAsData(Graph outputNetwork)
/*  74:    */     throws InvalidColumnNameException
/*  75:    */   {
/*  76: 68 */     Data networkData = new BasicData(outputNetwork, Graph.class.getName());
/*  77: 69 */     Dictionary<String, Object> graphAttributes = networkData.getMetadata();
/*  78: 70 */     graphAttributes.put("Modified", new Boolean(true));
/*  79: 71 */     graphAttributes.put("Parent", this.inData);
/*  80: 72 */     graphAttributes.put("Type", "Network");
/*  81: 73 */     graphAttributes.put("Label", "Extracted author-paper network");
/*  82:    */     
/*  83: 75 */     return networkData;
/*  84:    */   }
/*  85:    */   
/*  86:    */   private Data wrapOutputTableAsData(Table outputTable)
/*  87:    */   {
/*  88: 79 */     Data tableData = new BasicData(outputTable, Table.class.getName());
/*  89: 80 */     Dictionary<String, Object> tableAttributes = tableData.getMetadata();
/*  90: 81 */     tableAttributes.put("Modified", new Boolean(true));
/*  91: 82 */     tableAttributes.put("Parent", this.inData);
/*  92: 83 */     tableAttributes.put("Type", "Matrix");
/*  93: 84 */     tableAttributes.put("Label", "author-paper information");
/*  94:    */     
/*  95: 86 */     return tableData;
/*  96:    */   }
/*  97:    */   
/*  98:    */   private Graph constructNetwork()
/*  99:    */     throws InvalidColumnNameException, AlgorithmExecutionException
/* 100:    */   {
/* 101: 90 */     Properties aggregateProperties = 
/* 102: 91 */       loadAggregatePropertiesFile(this.fileFormatPropertiesFileName);
/* 103:    */      GraphContainer graphContainer = null;
/* 104: 93 */     String authorColumn = 
/* 105: 94 */       (String)AuthorPaperFormat.AUTHOR_NAME_COLUMNS_BY_FORMATS.get(this.fileFormat);
/* 106: 95 */     String paperColumn = (String)AuthorPaperFormat.PAPER_NAME_COLUMNS_BY_FORMATS.get(this.fileFormat);
/* 107:    */     try
/* 108:    */     {
/* 109: 98 */        graphContainer = GraphContainer.initializeGraph(
/* 110: 99 */         this.table, 
/* 111:100 */         authorColumn, 
/* 112:101 */         paperColumn, 
/* 113:102 */         true, 
/* 114:103 */         aggregateProperties, 
/* 115:104 */         this.logger, 
/* 116:105 */         this.progressMonitor);
/* 117:    */     }
/* 118:    */     catch (GraphContainer.PropertyParsingException e)
/* 119:    */     {
/* 121:107 */       throw new AlgorithmExecutionException(e);
/* 122:    */     }
/* 123:    */    
/* 124:110 */     Graph outputNetwork = graphContainer.buildGraph(
/* 125:111 */       authorColumn, paperColumn, "|", false, this.logger);
/* 126:    */     
/* 127:113 */     return outputNetwork;
/* 128:    */   }
/* 129:    */   
/* 130:    */   private Properties loadAggregatePropertiesFile(String fileFormatPropertiesFileName)
/* 131:    */   {
/* 132:117 */     InputStream fileTypePropertiesFile = 
/* 133:118 */       getFileTypePropertiesFile(this.fileFormatPropertiesFileName);
/* 134:    */     
/* 135:120 */     Properties aggregateProperties = new Properties();
/* 136:    */     try
/* 137:    */     {
/* 138:123 */       aggregateProperties.load(fileTypePropertiesFile);
/* 139:    */     }
/* 140:    */     catch (FileNotFoundException e)
/* 141:    */     {
/* 142:125 */       this.logger.log(1, e.getMessage(), e);
/* 143:    */     }
/* 144:    */     catch (IOException e)
/* 145:    */     {
/* 146:127 */       this.logger.log(1, e.getMessage(), e);
/* 147:    */     }
/* 148:130 */     return aggregateProperties;
/* 149:    */   }
/* 150:    */   
/* 151:    */   private InputStream getFileTypePropertiesFile(String fileFormatPropertiesFile)
/* 152:    */   {
/* 153:134 */     ClassLoader loader = getClass().getClassLoader();
/* 154:    */     
/* 155:136 */     return loader.getResourceAsStream(fileFormatPropertiesFile);
/* 156:    */   }
/* 157:    */   
/* 158:    */   private static String getFileTypePropertiesFileName(String fileType)
/* 159:    */   {
/* 160:140 */     String propertiesFileName = "/edu/iu/nwb/composite/extractauthorpapernetwork/metadata/";
/* 161:    */     
/* 162:142 */     return propertiesFileName + fileType + ".properties";
/* 163:    */   }
/* 164:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\javasrc\important ones\edu.iu.nwb.composite.extractauthorpapernetwork_0.0.2.jar
 * Qualified Name:     edu.iu.nwb.composite.extractauthorpapernetwork.algorithm.ExtractAuthorPaperNetwork
 * JD-Core Version:    0.7.0.1
 */