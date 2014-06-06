/*   1:    */ package org.cishell.algorithm.convertergraph;
/*   2:    */ 
/*   3:    */ import edu.uci.ics.jung.graph.Edge;
/*   4:    */ import edu.uci.ics.jung.graph.Graph;
/*   5:    */ import edu.uci.ics.jung.graph.Vertex;
/*   6:    */ import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;
/*   7:    */ import edu.uci.ics.jung.graph.impl.DirectedSparseGraph;
/*   8:    */ import edu.uci.ics.jung.graph.impl.DirectedSparseVertex;
import edu.uci.ics.jung.utils.UserDataContainer;
/*   9:    */ import edu.uci.ics.jung.utils.UserDataContainer.CopyAction.Shared;

/*  10:    */ import java.util.HashSet;
/*  11:    */ import java.util.Iterator;
/*  12:    */ import java.util.Set;

/*  13:    */ import org.osgi.framework.ServiceReference;
/*  14:    */ import org.osgi.service.log.LogService;
/*  15:    */ 
/*  16:    */ public class ConverterGraphComputation
/*  17:    */ {
/*  18:    */   private LogService logger;
/*  19:    */   private ServiceReference[] allConverterServices;
/*  20: 53 */   private Set nodeLabels = new HashSet();
/*  21:    */   private Graph outputGraph;
/*  22:    */   private int nodeCount;
/*  23:    */   
/*  24:    */   public Graph getOutputGraph()
/*  25:    */   {
/*  26: 61 */     return this.outputGraph;
/*  27:    */   }
/*  28:    */   
/*  29:    */   public ConverterGraphComputation(ServiceReference[] allConverterServices, LogService logger)
/*  30:    */   {
/*  31: 69 */     this.nodeCount = 0;
/*  32: 70 */     this.logger = logger;
/*  33: 71 */     this.allConverterServices = allConverterServices;
/*  34: 72 */     this.outputGraph = new DirectedSparseGraph();
/*  35:    */     
/*  36:    */ 
/*  37:    */ 
/*  38:    */ 
/*  39: 77 */     processServiceReferences();
/*  40:    */   }
/*  41:    */   
/*  42:    */   private void processServiceReferences()
/*  43:    */   {
/*  44: 86 */     for (int converterCount = 0; converterCount < this.allConverterServices.length; converterCount++)
/*  45:    */     {
/*  46: 92 */       ServiceReference currentConverterServiceReference = 
/*  47: 93 */         this.allConverterServices[converterCount];
/*  48:    */       
/*  49: 95 */       String sourceNodeKey = 
/*  50: 96 */         (String)currentConverterServiceReference.getProperty("in_data");
/*  51: 97 */       String targetNodeKey = 
/*  52: 98 */         (String)currentConverterServiceReference.getProperty("out_data");
/*  53:    */       Vertex sourceNode;
/*  54:    */       Vertex sourceNode1;
/*  55:100 */       if (this.nodeLabels.contains(sourceNodeKey)) {
/*  56:101 */         sourceNode1 = updateNode(sourceNodeKey);
/*  57:    */       } else {
/*  58:103 */         sourceNode1 = createNode(sourceNodeKey);
/*  59:    */       }
/*  60:    */       Vertex targetNode;
/*  61:    */       Vertex targetNode1;
/*  62:106 */       if (this.nodeLabels.contains(targetNodeKey)) {
/*  63:107 */         targetNode1 = updateNode(targetNodeKey);
/*  64:    */       } else {
/*  65:109 */         targetNode1 = createNode(targetNodeKey);
/*  66:    */       }
/*  67:112 */       createEdge(sourceNode1, targetNode1, currentConverterServiceReference);
/*  68:    */     }
/*  69:    */   }
/*  70:    */   
/*  71:    */   private Vertex updateNode(String currentNodeKey)
/*  72:    */   {
/*  73:118 */     for (Iterator nodeIterator = this.outputGraph.getVertices().iterator(); 
/*  74:119 */           nodeIterator.hasNext();)
/*  75:    */     {
/*  76:120 */       Vertex currentVertex = (Vertex)nodeIterator.next();
/*  77:122 */       if (currentVertex.getUserDatum("label").toString().equalsIgnoreCase(currentNodeKey))
/*  78:    */       {
/*  79:123 */         int currentVertexStrength = 
/*  80:124 */           ((Integer)currentVertex.getUserDatum("strength")).intValue();
/*  81:125 */         currentVertex.setUserDatum("strength", new Integer(++currentVertexStrength), 
/*  82:126 */           new UserDataContainer.CopyAction.Shared());
/*  83:127 */         return currentVertex;
/*  84:    */       }
/*  85:    */     }
/*  86:130 */     return new DirectedSparseVertex();
/*  87:    */   }
/*  88:    */   
/*  89:    */   private Vertex createNode(String nodeKey)
/*  90:    */   {
/*  91:134 */     this.nodeCount += 1;
/*  92:    */     
/*  93:136 */     Vertex node = new DirectedSparseVertex();
/*  94:137 */     node.addUserDatum("strength", new Integer(1), new UserDataContainer.CopyAction.Shared());
/*  95:138 */     node.addUserDatum("label", nodeKey, new UserDataContainer.CopyAction.Shared());
/*  96:    */     
/*  97:140 */     this.outputGraph.addVertex(node);
/*  98:141 */     this.nodeLabels.add(nodeKey);
/*  99:    */     
/* 100:143 */     return node;
/* 101:    */   }
/* 102:    */   
/* 103:    */   private void createEdge(Vertex sourceNode, Vertex targetNode, ServiceReference currentConverterServiceReference)
/* 104:    */   {
/* 105:154 */     String serviceCompletePID = 
/* 106:155 */       (String)currentConverterServiceReference.getProperty("service.pid");
/* 107:    */     
/* 108:    */ 
/* 109:    */ 
/* 110:    */ 
/* 111:    */ 
/* 112:161 */     int startIndexForConverterName = serviceCompletePID.lastIndexOf(".") + 1;
/* 113:162 */     String serviceShortPID = serviceCompletePID.substring(startIndexForConverterName);
/* 114:    */     
/* 115:    */ 
/* 116:    */ 
/* 117:    */ 
/* 118:167 */     Edge edge = new DirectedSparseEdge(sourceNode, targetNode);
/* 119:    */     
/* 120:169 */     edge.addUserDatum("converter_name", serviceShortPID, 
/* 121:170 */       new UserDataContainer.CopyAction.Shared());
/* 122:171 */     edge.addUserDatum("service_pid", serviceCompletePID, 
/* 123:172 */       new UserDataContainer.CopyAction.Shared());
/* 124:    */     
/* 125:174 */     this.outputGraph.addEdge(edge);
/* 126:    */   }
/* 127:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.algorithm.convertergraph_1.0.0.jar
 * Qualified Name:     org.cishell.algorithm.convertergraph.ConverterGraphComputation
 * JD-Core Version:    0.7.0.1
 */