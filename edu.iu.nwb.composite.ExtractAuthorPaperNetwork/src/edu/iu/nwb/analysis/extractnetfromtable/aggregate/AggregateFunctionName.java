/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*  2:   */ 
/*  3:   */ public enum AggregateFunctionName
/*  4:   */ {
/*  5: 8 */   ARITHMETICMEAN("arithmeticmean"),  SUM("sum"),  COUNT("count"),  GEOMETRICMEAN("geometricmean"),  MAX("max"),  MIN("min"),  MODE("mode");
/*  6:   */   
/*  7:   */   private final String name;
/*  8:   */   
/*  9:   */   private AggregateFunctionName(String name)
/* 10:   */   {
/* 11:19 */     this.name = name;
/* 12:   */   }
/* 13:   */   
/* 14:   */   public static AggregateFunctionName fromString(String name)
/* 15:   */   {
/* 16:35 */     if (name == null) {
/* 17:36 */       throw new NullPointerException();
/* 18:   */     }
/* 19:   */     AggregateFunctionName[] arrayOfAggregateFunctionName;
/* 20:40 */     int j = (arrayOfAggregateFunctionName = values()).length;
/* 21:40 */     for (int i = 0; i < j; i++)
/* 22:   */     {
/* 23:40 */       AggregateFunctionName aggregateFunctionName = arrayOfAggregateFunctionName[i];
/* 24:41 */       if (aggregateFunctionName.name.equalsIgnoreCase(name)) {
/* 25:42 */         return aggregateFunctionName;
/* 26:   */       }
/* 27:   */     }
/* 28:46 */     throw new IllegalArgumentException(
/* 29:47 */       "No AggregateFunctionNames could be found for '" + name + "'.");
/* 30:   */   }
/* 31:   */   
/* 32:   */   public final String toString()
/* 33:   */   {
/* 34:52 */     return this.name;
/* 35:   */   }
/* 36:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.AggregateFunctionName
 * JD-Core Version:    0.7.0.1
 */