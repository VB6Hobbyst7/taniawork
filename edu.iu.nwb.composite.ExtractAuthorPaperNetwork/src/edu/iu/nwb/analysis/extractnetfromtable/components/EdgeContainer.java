/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*  2:   */ 
/*  3:   */ import java.util.TreeSet;
/*  4:   */ import java.util.Vector;
/*  5:   */ import prefuse.data.Edge;
/*  6:   */ import prefuse.data.Graph;
/*  7:   */ import prefuse.data.Node;
/*  8:   */ import prefuse.data.Table;
/*  9:   */ 
/* 10:   */ public class EdgeContainer
/* 11:   */ {
/* 12:   */   boolean hasSkippedColumns;
/* 13:   */   
/* 14:   */   public EdgeContainer()
/* 15:   */   {
/* 16:15 */     this.hasSkippedColumns = false;
/* 17:   */   }
/* 18:   */   
/* 19:   */   private void createEdge(Vector edgeVector, Graph graph, Table table, int rowNumber, AggregateFunctionMappings afm)
/* 20:   */   {
/* 21:19 */     if (!graph.isDirected())
/* 22:   */     {
/* 23:20 */       Integer src = new Integer(((Node)edgeVector.get(0)).getRow());
/* 24:21 */       Integer tgt = new Integer(((Node)edgeVector.get(1)).getRow());
/* 25:22 */       TreeSet edgeSet = new TreeSet();
/* 26:23 */       edgeSet.add(src);
/* 27:24 */       edgeSet.add(tgt);
/* 28:25 */       edgeVector.set(0, graph.getNode(((Integer)edgeSet.first()).intValue()));
/* 29:26 */       edgeVector.set(1, graph.getNode(((Integer)edgeSet.last()).intValue()));
/* 30:   */     }
/* 31:29 */     Node source = (Node)edgeVector.get(0);
/* 32:30 */     Node target = (Node)edgeVector.get(1);
/* 33:   */     
/* 34:32 */     Edge edge = graph.addEdge(source, target);
/* 35:   */     
/* 36:34 */     ValueAttributes va = new ValueAttributes(edge.getRow());
/* 37:35 */     FunctionContainer functionContainer = new FunctionContainer();
/* 38:36 */     va = functionContainer.mutateFunctions(edge, table, rowNumber, va, afm, 
/* 39:37 */       0);
/* 40:38 */     if (functionContainer.hasSkippedColumns)
/* 41:   */     {
/* 42:39 */       this.hasSkippedColumns = true;
/* 43:40 */       functionContainer.hasSkippedColumns = false;
/* 44:   */     }
/* 45:42 */     afm.addFunctionRow(edgeVector, va);
/* 46:   */   }
/* 47:   */   
/* 48:   */   void mutateEdge(Node source, Node target, Graph graph, Table table, int rowNumber, AggregateFunctionMappings afm)
/* 49:   */   {
/* 50:48 */     if ((source == null) || (target == null)) {
/* 51:49 */       return;
/* 52:   */     }
/* 53:52 */     Vector edgeVector = new Vector(2);
/* 54:54 */     if (!graph.isDirected())
/* 55:   */     {
/* 56:55 */       Integer src = new Integer(source.getRow());
/* 57:56 */       Integer tgt = new Integer(target.getRow());
/* 58:57 */       TreeSet edgeSet = new TreeSet();
/* 59:58 */       edgeSet.add(src);
/* 60:59 */       edgeSet.add(tgt);
/* 61:60 */       edgeVector.add(graph.getNode(((Integer)edgeSet.first()).intValue()));
/* 62:61 */       edgeVector.add(graph.getNode(((Integer)edgeSet.last()).intValue()));
/* 63:   */     }
/* 64:   */     else
/* 65:   */     {
/* 66:63 */       edgeVector.add(source);
/* 67:64 */       edgeVector.add(target);
/* 68:   */     }
/* 69:67 */     ValueAttributes va = afm.getFunctionRow(edgeVector);
/* 70:71 */     if (va == null)
/* 71:   */     {
/* 72:72 */       createEdge(edgeVector, graph, table, rowNumber, afm);
/* 73:   */     }
/* 74:   */     else
/* 75:   */     {
/* 76:74 */       int edgeNumber = va.getRowNumber();
/* 77:75 */       FunctionContainer functionContainer = new FunctionContainer();
/* 78:76 */       functionContainer.mutateFunctions(graph.getEdge(edgeNumber), table, rowNumber, va, afm, 
/* 79:77 */         0);
/* 80:78 */       if (functionContainer.hasSkippedColumns)
/* 81:   */       {
/* 82:79 */         this.hasSkippedColumns = true;
/* 83:80 */         functionContainer.hasSkippedColumns = false;
/* 84:   */       }
/* 85:   */     }
/* 86:   */   }
/* 87:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.EdgeContainer
 * JD-Core Version:    0.7.0.1
 */