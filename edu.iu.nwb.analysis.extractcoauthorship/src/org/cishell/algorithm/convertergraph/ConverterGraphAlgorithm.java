/*   1:    */ package org.cishell.algorithm.convertergraph;
/*   2:    */ 
/*   3:    */ import edu.uci.ics.jung.graph.Graph;
/*   4:    */ import java.util.Dictionary;
/*   5:    */ import org.cishell.framework.CIShellContext;
/*   6:    */ import org.cishell.framework.algorithm.Algorithm;
/*   7:    */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*   8:    */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*   9:    */ import org.cishell.framework.data.BasicData;
/*  10:    */ import org.cishell.framework.data.Data;
/*  11:    */ import org.osgi.framework.BundleContext;
/*  12:    */ import org.osgi.framework.InvalidSyntaxException;
/*  13:    */ import org.osgi.framework.ServiceReference;
/*  14:    */ import org.osgi.service.log.LogService;
/*  15:    */ 
/*  16:    */ public class ConverterGraphAlgorithm
/*  17:    */   implements Algorithm
/*  18:    */ {
/*  19: 35 */   private int edgeCount = 0;
/*  20: 35 */   private int nodeCount = 0;
/*  21:    */   private Graph outputGraph;
/*  22:    */   private BundleContext bundleContext;
/*  23:    */   private LogService logger;
/*  24:    */   
/*  25:    */   public ConverterGraphAlgorithm(Data[] data, Dictionary parameters, CIShellContext ciShellContext, BundleContext bundleContext)
/*  26:    */   {
/*  27: 45 */     this.bundleContext = bundleContext;
/*  28: 46 */     this.logger = ((LogService)ciShellContext.getService(LogService.class.getName()));
/*  29:    */   }
/*  30:    */   
/*  31:    */   public Data[] execute()
/*  32:    */     throws AlgorithmExecutionException
/*  33:    */   {
/*  34: 54 */     ServiceReference[] allConverterServices = getAllConverters();
/*  35:    */     
/*  36:    */ 
/*  37:    */ 
/*  38:    */ 
/*  39: 59 */     ConverterGraphComputation converterGraphComputation = 
/*  40: 60 */       new ConverterGraphComputation(allConverterServices, this.logger);
/*  41:    */     
/*  42:    */ 
/*  43:    */ 
/*  44:    */ 
/*  45: 65 */     return prepareOutputMetadata(new BasicData(converterGraphComputation.getOutputGraph(), 
/*  46: 66 */       Graph.class.getName()));
/*  47:    */   }
/*  48:    */   
/*  49:    */   private ServiceReference[] getAllConverters()
/*  50:    */   {
/*  51:    */     try
/*  52:    */     {
/*  53: 75 */       ServiceReference[] allConverters = 
/*  54: 76 */         this.bundleContext.getAllServiceReferences(
/*  55: 77 */         AlgorithmFactory.class.getName(), 
/*  56: 78 */         "(&(type=converter))");
/*  57: 80 */       if (allConverters == null) {}
/*  58: 85 */       return new ServiceReference[0];
/*  59:    */     }
/*  60:    */     catch (InvalidSyntaxException e)
/*  61:    */     {
/*  62: 91 */       e.printStackTrace();
/*  63:    */     }
/*  64: 92 */     return new ServiceReference[0];
/*  65:    */   }
/*  66:    */   
/*  67:    */   private Data[] prepareOutputMetadata(Data outNWBData)
/*  68:    */   {
/*  69:102 */     outNWBData.getMetadata().put("Label", "Converter Graph having " + 
/*  70:103 */       ((Graph)outNWBData.getData()).numVertices() + " nodes & " + 
/*  71:104 */       ((Graph)outNWBData.getData()).numEdges() + " edges.");
/*  72:105 */     outNWBData.getMetadata().put("Type", "Network");
/*  73:106 */     return new Data[] { outNWBData };
/*  74:    */   }
/*  75:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.algorithm.convertergraph_1.0.0.jar
 * Qualified Name:     org.cishell.algorithm.convertergraph.ConverterGraphAlgorithm
 * JD-Core Version:    0.7.0.1
 */