/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*   2:    */ 
/*   3:    */ import java.util.Iterator;
/*   4:    */ import prefuse.data.Graph;
/*   5:    */ import prefuse.data.Node;
/*   6:    */ import prefuse.data.Schema;
/*   7:    */ import prefuse.data.Table;
/*   8:    */ 
/*   9:    */ public class ExtractNetworkFromTable
/*  10:    */ {
/*  11:    */   public static Table constructTable(Graph graph)
/*  12:    */   {
/*  13: 72 */     Table outputTable = new Table();
/*  14: 73 */     outputTable = createTableSchema(graph.getNodeTable().getSchema(), 
/*  15: 74 */       outputTable);
/*  16: 75 */     outputTable = populateTable(outputTable, graph);
/*  17: 76 */     return outputTable;
/*  18:    */   }
/*  19:    */   
/*  20:    */   private static Table createTableSchema(Schema graphSchema, Table t)
/*  21:    */   {
/*  22: 81 */     for (int i = 0; i < graphSchema.getColumnCount(); i++) {
/*  23: 82 */       t.addColumn(graphSchema.getColumnName(i), graphSchema.getColumnType(i));
/*  24:    */     }
/*  25: 85 */     t.addColumn("uniqueIndex", Integer.class);
/*  26: 86 */     t.addColumn("combineValues", String.class, "*");
/*  27:    */     
/*  28: 88 */     return t;
/*  29:    */   }
/*  30:    */   
/*  31:    */   private static Table populateTable(Table t, Graph g)
/*  32:    */   {
/*  33: 92 */     for (Iterator it = g.nodes(); it.hasNext();)
/*  34:    */     {
/*  35: 93 */       Node n = (Node)it.next();
/*  36: 94 */       t.addRow();
/*  37: 95 */       for (int i = 0; i < n.getColumnCount(); i++) {
/*  38: 96 */         t.set(t.getRowCount() - 1, i, n.get(i));
/*  39:    */       }
/*  40: 98 */       t.set(t.getRowCount() - 1, "uniqueIndex", new Integer(t
/*  41: 99 */         .getRowCount()));
/*  42:    */     }
/*  43:101 */     return t;
/*  44:    */   }
/*  45:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.ExtractNetworkFromTable
 * JD-Core Version:    0.7.0.1
 */