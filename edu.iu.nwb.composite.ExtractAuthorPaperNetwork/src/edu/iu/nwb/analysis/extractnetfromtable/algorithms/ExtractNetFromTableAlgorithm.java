/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.algorithms;
/*   2:    */ 
/*   3:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.ExtractNetworkFromTable;
/*   4:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer;
/*   5:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer.PropertyParsingException;
/*   6:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.InvalidColumnNameException;
/*   7:    */ import edu.iu.nwb.analysis.extractnetfromtable.components.PropertyHandler;
/*   8:    */ import java.util.Dictionary;
/*   9:    */ import java.util.Properties;
/*  10:    */ import org.cishell.framework.CIShellContext;
/*  11:    */ import org.cishell.framework.algorithm.Algorithm;
/*  12:    */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  13:    */ import org.cishell.framework.data.Data;
/*  14:    */ import org.cishell.utilities.DataFactory;
/*  15:    */ import org.osgi.service.log.LogService;
/*  16:    */ import prefuse.data.Graph;
/*  17:    */ import prefuse.data.Table;
/*  18:    */ 
/*  19:    */ public class ExtractNetFromTableAlgorithm
/*  20:    */   implements Algorithm
/*  21:    */ {
/*  22:    */   private Data[] data;
/*  23:    */   private Dictionary<String, Object> parameters;
/*  24:    */   private LogService logger;
/*  25:    */   
/*  26:    */   public ExtractNetFromTableAlgorithm(Data[] data, Dictionary<String, Object> parameters, CIShellContext context)
/*  27:    */   {
/*  28: 31 */     this.data = data;
/*  29: 32 */     this.parameters = parameters;
/*  30: 33 */     this.logger = 
/*  31: 34 */       ((LogService)context.getService(LogService.class.getName()));
/*  32:    */   }
/*  33:    */   
/*  34:    */   public Data[] execute()
/*  35:    */     throws AlgorithmExecutionException
/*  36:    */   {
/*  37: 39 */     Table dataTable = (Table)this.data[0].getData();
					//Table testExtraTable = (Table)this.data[0].getData();
/*  38:    */     
/*  39: 41 */     String delimiter = 
/*  40: 42 */       (String)this.parameters.get(
/*  41: 43 */       "delimiter");
/*  42: 44 */     String extractColumn = 
/*  43: 45 */       (String)this.parameters.get(
/*  44: 46 */       "columnName");
				
/*  45: 47 */     Properties properties = null;
/*  46:    */     
/*  47: 49 */     Object aggregationFunctionFilePath = 
/*  48: 50 */       this.parameters.get(
/*  49: 51 */       "aggregationFunctionFile");
/*  50: 52 */     if (aggregationFunctionFilePath != null) {
/*  51: 53 */       properties = 
/*  52: 54 */         PropertyHandler.getProperties(
/*  53: 55 */         (String)aggregationFunctionFilePath, 
/*  54: 56 */         this.logger);
/*  55:    */     }
/*  56: 59 */     Graph graph = getGraph(dataTable, delimiter, extractColumn , properties);
/*  57:    */     
/*  58: 61 */     Table mergeTable = ExtractNetworkFromTable.constructTable(graph);
/*  59:    */     
/*  60: 63 */     Data outGraphData = createOutGraphData(extractColumn, graph);
/*  61: 64 */     Data outTableData = createOutTableData(extractColumn, mergeTable);
/*  62:    */     
/*  63: 66 */     return new Data[] { outGraphData, outTableData };
/*  64:    */   }
/*  65:    */   
/*  66:    */   private Graph getGraph(Table dataTable, String delimiter, String extractColumn, Properties properties)
/*  67:    */     throws AlgorithmExecutionException
/*  68:    */   {
/*  69:    */     try
/*  70:    */     {
/*  71: 73 */       GraphContainer graphContainer = 
/*  72: 74 */         GraphContainer.initializeGraph(
/*  73: 75 */         dataTable, 
/*  74: 76 */         extractColumn, 
/*  75: 77 */         extractColumn, 
/*  76: 78 */         false, 
/*  77: 79 */         properties, 
/*  78: 80 */         this.logger);
/*  79: 81 */       return 
/*  80: 82 */         graphContainer.buildGraph(extractColumn, extractColumn, delimiter, false, this.logger);
/*  81:    */     }
/*  82:    */     catch (InvalidColumnNameException e)
/*  83:    */     {
/*  84: 85 */       String message = "Invalid column name: " + e.getMessage();
/*  85: 86 */       throw new AlgorithmExecutionException(message, e);
/*  86:    */     }
/*  87:    */     catch (GraphContainer.PropertyParsingException e)
/*  88:    */     {
/*  89: 88 */       throw new AlgorithmExecutionException(e);
/*  90:    */     }
/*  91:    */   }
/*  92:    */   
/*  93:    */   private Data createOutGraphData(String extractColumn, Graph outputGraph)
/*  94:    */   {
/*  95: 94 */     Data outData = DataFactory.withClassNameAsFormat(outputGraph, 
/*  96: 95 */       "Network", this.data[0], 
/*  97: 96 */       "Extracted Network on Column " + extractColumn);
/*  98: 97 */     outData.getMetadata().put("Modified", Boolean.valueOf(true));
/*  99:    */     
/* 100: 99 */     return outData;
/* 101:    */   }
/* 102:    */   
/* 103:    */   private Data createOutTableData(String extractColumn, Table table)
/* 104:    */   {
/* 105:103 */     Data outData = DataFactory.withClassNameAsFormat(table, 
/* 106:104 */       "Matrix", this.data[0], 
/* 107:105 */       "Merge Table: based on " + extractColumn);
/* 108:106 */     outData.getMetadata().put("Modified", Boolean.valueOf(true));
/* 109:    */     
/* 110:    */ 
/* 111:109 */     return outData;
/* 112:    */   }
/* 113:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.algorithms.ExtractNetFromTableAlgorithm
 * JD-Core Version:    0.7.0.1
 */