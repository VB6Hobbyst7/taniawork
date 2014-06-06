/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*  2:   */ 
/*  3:   */ public class CountFunctionFactory
/*  4:   */   implements AggregateFunctionFactory
/*  5:   */ {
/*  6: 4 */   private static final AggregateFunctionName TYPE = AggregateFunctionName.COUNT;
/*  7:   */   
/*  8:   */   public AbstractAggregateFunction getFunction(Class c)
/*  9:   */   {
/* 10: 8 */     return new Count();
/* 11:   */   }
/* 12:   */   
/* 13:   */   public AggregateFunctionName getType()
/* 14:   */   {
/* 15:13 */     return TYPE;
/* 16:   */   }
/* 17:   */   
/* 18:   */   class Count
/* 19:   */     extends AbstractAggregateFunction
/* 20:   */   {
/* 21:   */     private int total;
/* 22:   */     
/* 23:   */     public Count()
/* 24:   */     {
/* 25:20 */       this.total = 0;
/* 26:   */     }
/* 27:   */     
/* 28:   */     public Object getResult()
/* 29:   */     {
/* 30:25 */       return Integer.valueOf(this.total);
/* 31:   */     }
/* 32:   */     
/* 33:   */     public Class getType()
/* 34:   */     {
/* 35:35 */       return Integer.TYPE;
/* 36:   */     }
/* 37:   */     
/* 38:   */     protected void innerOperate(Object object)
/* 39:   */     {
/* 40:43 */       this.total += 1;
/* 41:   */     }
/* 42:   */     
/* 43:   */     protected Object cleanPrefuseIssue(Object object)
/* 44:   */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 45:   */     {
/* 46:53 */       return object;
/* 47:   */     }
/* 48:   */   }
/* 49:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.CountFunctionFactory
 * JD-Core Version:    0.7.0.1
 */