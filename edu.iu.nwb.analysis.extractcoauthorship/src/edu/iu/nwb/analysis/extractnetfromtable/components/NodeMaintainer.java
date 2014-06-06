/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*  2:   */ 
/*  3:   */ import org.cishell.utilities.TableUtilities;
/*  4:   */ import prefuse.data.Graph;
/*  5:   */ import prefuse.data.Node;
/*  6:   */ import prefuse.data.Table;
/*  7:   */ 
/*  8:   */ public class NodeMaintainer
/*  9:   */ {
/* 10:   */   public static final String BIPARTITE_TYPE_SUGGESTED_COLUMN_NAME = "bipartiteType";
/* 11:17 */   private String bipartiteTypeColumnName = null;
/* 12:   */   boolean hasSkippedColumns;
/* 13:   */   
/* 14:   */   public NodeMaintainer()
/* 15:   */   {
/* 16:22 */     this.hasSkippedColumns = false;
/* 17:   */   }
/* 18:   */   
/* 19:   */   protected Node createNode(String label, String bipartiteType, Graph graph, Table table, int rowNumber, AggregateFunctionMappings nodeFunctionMappings, int nodeType)
/* 20:   */   {
/* 21:27 */     int nodeNumber = graph.addNodeRow();
/* 22:28 */     Node n = graph.getNode(nodeNumber);
/* 23:29 */     n.set("label", label);
/* 24:32 */     if (bipartiteType != null)
/* 25:   */     {
/* 26:34 */       if (this.bipartiteTypeColumnName == null)
/* 27:   */       {
/* 28:35 */         this.bipartiteTypeColumnName = 
/* 29:36 */           TableUtilities.formNonConflictingNewColumnName(
/* 30:37 */           graph.getNodeTable().getSchema(), "bipartiteType");
/* 31:38 */         graph.getNodeTable().addColumn(this.bipartiteTypeColumnName, String.class);
/* 32:   */       }
/* 33:41 */       n.set(this.bipartiteTypeColumnName, bipartiteType);
/* 34:   */     }
/* 35:43 */     ValueAttributes va = new ValueAttributes(nodeNumber);
/* 36:44 */     FunctionContainer functionContainer = new FunctionContainer();
/* 37:45 */     va = functionContainer.mutateFunctions(n, table, rowNumber, va, nodeFunctionMappings, 
/* 38:46 */       nodeType);
/* 39:47 */     if (functionContainer.hasSkippedColumns) {
/* 40:48 */       this.hasSkippedColumns = true;
/* 41:   */     }
/* 42:50 */     nodeFunctionMappings.addFunctionRow(new NodeID(label, bipartiteType), va);
/* 43:51 */     return n;
/* 44:   */   }
/* 45:   */   
/* 46:   */   protected Node mutateNode(String tableValue, String bipartiteType, Graph graph, Table table, int rowNumber, AggregateFunctionMappings afm, int nodeType)
/* 47:   */   {
/* 48:56 */     ValueAttributes va = afm.getFunctionRow(new NodeID(tableValue, bipartiteType));
/* 49:   */     Node n;
/* 50:   */     Node n1;
/* 51:62 */     if (va == null)
/* 52:   */     {
/* 53:63 */       n1 = createNode(tableValue, bipartiteType, graph, table, rowNumber, afm, nodeType);
/* 54:   */     }
/* 55:   */     else
/* 56:   */     {
/* 57:65 */       int nodeNumber = va.getRowNumber();
/* 58:66 */       n1 = graph.getNode(nodeNumber);
/* 59:67 */       FunctionContainer functionContainer = new FunctionContainer();
/* 60:68 */       functionContainer.mutateFunctions(n1, table, rowNumber, va, afm, nodeType);
/* 61:69 */       if (functionContainer.hasSkippedColumns) {
/* 62:70 */         this.hasSkippedColumns = true;
/* 63:   */       }
/* 64:   */     }
/* 65:74 */     return n1;
/* 66:   */   }
/* 67:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.NodeMaintainer
 * JD-Core Version:    0.7.0.1
 */