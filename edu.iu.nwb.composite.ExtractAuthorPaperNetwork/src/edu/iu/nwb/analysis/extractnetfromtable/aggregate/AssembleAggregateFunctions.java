/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*  2:   */ 
/*  3:   */ import java.util.HashMap;
/*  4:   */ import java.util.Set;
/*  5:   */ 
/*  6:   */ public class AssembleAggregateFunctions
/*  7:   */ {
/*  8:   */   private HashMap<AggregateFunctionName, AggregateFunctionFactory> nameToFunctionFactory;
/*  9:   */   
/* 10:   */   public AssembleAggregateFunctions()
/* 11:   */   {
/* 12:10 */     this.nameToFunctionFactory = new HashMap();
/* 13:   */   }
/* 14:   */   
/* 15:   */   public static AssembleAggregateFunctions defaultAssembly()
/* 16:   */   {
/* 17:14 */     AssembleAggregateFunctions aaf = new AssembleAggregateFunctions();
/* 18:   */     
/* 19:16 */     aaf.putAggregateFunctionFactory(AggregateFunctionName.ARITHMETICMEAN, 
/* 20:17 */       new ArithmeticMeanFunctionFactory());
/* 21:18 */     aaf.putAggregateFunctionFactory(AggregateFunctionName.COUNT, 
/* 22:19 */       new CountFunctionFactory());
/* 23:20 */     aaf.putAggregateFunctionFactory(AggregateFunctionName.GEOMETRICMEAN, 
/* 24:21 */       new GeometricMeanFunctionFactory());
/* 25:22 */     aaf.putAggregateFunctionFactory(AggregateFunctionName.MAX, 
/* 26:23 */       new MaxFunctionFactory());
/* 27:24 */     aaf.putAggregateFunctionFactory(AggregateFunctionName.MIN, 
/* 28:25 */       new MinFunctionFactory());
/* 29:26 */     aaf.putAggregateFunctionFactory(AggregateFunctionName.SUM, 
/* 30:27 */       new SumFunctionFactory());
/* 31:28 */     aaf.putAggregateFunctionFactory(AggregateFunctionName.MODE, 
/* 32:29 */       new ModeFunctionFactory());
/* 33:   */     
/* 34:31 */     return aaf;
/* 35:   */   }
/* 36:   */   
/* 37:   */   public AbstractAggregateFunction getAggregateFunction(AggregateFunctionName function, Class type)
/* 38:   */   {
/* 39:36 */     AbstractAggregateFunction af = null;
/* 40:   */     try
/* 41:   */     {
/* 42:39 */       af = 
/* 43:40 */         ((AggregateFunctionFactory)this.nameToFunctionFactory.get(function)).getFunction(type);
/* 44:   */     }
/* 45:   */     catch (NullPointerException localNullPointerException)
/* 46:   */     {
/* 47:42 */       af = null;
/* 48:   */     }
/* 49:45 */     return af;
/* 50:   */   }
/* 51:   */   
/* 52:   */   public AggregateFunctionFactory putAggregateFunctionFactory(AggregateFunctionName name, AggregateFunctionFactory aggregationFunctionFactory)
/* 53:   */   {
/* 54:51 */     if (this.nameToFunctionFactory.get(name) != null) {
/* 55:56 */       return null;
/* 56:   */     }
/* 57:58 */     this.nameToFunctionFactory.put(name, aggregationFunctionFactory);
/* 58:59 */     return aggregationFunctionFactory;
/* 59:   */   }
/* 60:   */   
/* 61:   */   public AggregateFunctionFactory removeAggregateFunctionFactory(String functionName)
/* 62:   */   {
/* 63:65 */     return (AggregateFunctionFactory)this.nameToFunctionFactory.get(functionName);
/* 64:   */   }
/* 65:   */   
/* 66:   */   public Set<AggregateFunctionName> getFunctionNames()
/* 67:   */   {
/* 68:69 */     return this.nameToFunctionFactory.keySet();
/* 69:   */   }
/* 70:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.AssembleAggregateFunctions
 * JD-Core Version:    0.7.0.1
 */