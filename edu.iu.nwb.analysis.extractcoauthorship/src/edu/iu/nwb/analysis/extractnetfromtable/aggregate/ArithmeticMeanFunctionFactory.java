/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*  2:   */ 
/*  3:   */ public class ArithmeticMeanFunctionFactory
/*  4:   */   implements AggregateFunctionFactory
/*  5:   */ {
/*  6: 4 */   private static final AggregateFunctionName TYPE = AggregateFunctionName.ARITHMETICMEAN;
/*  7:   */   
/*  8:   */   public AbstractAggregateFunction getFunction(Class c)
/*  9:   */   {
/* 10: 8 */  //  if ((c.equals(Integer.TYPE)) || (c.equals(Integer.class)) || 
/* 11: 9 */     //  (c.equals([Ljava.lang.Integer.class)) || (c.equals([I.class))) {
/* 12:10 */  //     return new DoubleArithmeticMean();
/* 13:   */    // }
/* 14:12 */    // if ((c.equals(Double.TYPE)) || (c.equals(Double.class)) || 
/* 15:13 */    //  (c.equals([Ljava.lang.Double.class)) || (c.equals([D.class))) {
/* 16:14 */     //  return new DoubleArithmeticMean();
/* 17:   */    // }
/* 18:16 */     //if ((c.equals(Float.TYPE)) || (c.equals(Float.class)) || 
/* 19:17 */    //   (c.equals([Ljava.lang.Float.class)) || (c.equals([F.class))) {
/* 20:18 */    //   return new FloatArithmeticMean();
/* 21:   */    // }
/* 22:20 */     return null;
/* 23:   */   }
/* 24:   */   
/* 25:   */   public AggregateFunctionName getType()
/* 26:   */   {
/* 27:25 */     return TYPE;
/* 28:   */   }
/* 29:   */   
/* 30:   */   class DoubleArithmeticMean
/* 31:   */     extends AbstractAggregateFunction
/* 32:   */   {
/* 33:   */     private double total;
/* 34:   */     private long items;
/* 35:   */     
/* 36:   */     public DoubleArithmeticMean()
/* 37:   */     {
/* 38:33 */       this.total = 0.0D;
/* 39:34 */       this.items = 0L;
/* 40:   */     }
/* 41:   */     
/* 42:   */     public Double getResult()
/* 43:   */     {
/* 44:39 */       return new Double(this.total / this.items);
/* 45:   */     }
/* 46:   */     
/* 47:   */     public Class<Double> getType()
/* 48:   */     {
/* 49:44 */       return Double.class;
/* 50:   */     }
/* 51:   */     
/* 52:   */     protected void innerOperate(Object object)
/* 53:   */     {
/* 54:49 */       if ((object instanceof Number))
/* 55:   */       {
/* 56:50 */         this.items += 1L;
/* 57:51 */         this.total += ((Number)object).doubleValue();
/* 58:   */       }
/* 59:   */       else
/* 60:   */       {
/* 61:53 */         throw new IllegalArgumentException(
/* 62:54 */           "DoubleArithmeticMean can only operate on Numbers.");
/* 63:   */       }
/* 64:   */     }
/* 65:   */     
/* 66:   */     protected Double cleanPrefuseIssue(Object object)
/* 67:   */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 68:   */     {
/* 69:61 */       return cleanDoublePrefuseBug(object);
/* 70:   */     }
/* 71:   */   }
/* 72:   */   
/* 73:   */   class FloatArithmeticMean
/* 74:   */     extends AbstractAggregateFunction
/* 75:   */   {
/* 76:   */     private float total;
/* 77:   */     private long items;
/* 78:   */     
/* 79:   */     public FloatArithmeticMean()
/* 80:   */     {
/* 81:70 */       this.total = 0.0F;
/* 82:71 */       this.items = 0L;
/* 83:   */     }
/* 84:   */     
/* 85:   */     public Float getResult()
/* 86:   */     {
/* 87:76 */       return new Float(this.total / (float)this.items);
/* 88:   */     }
/* 89:   */     
/* 90:   */     public Class<Float> getType()
/* 91:   */     {
/* 92:81 */       return Float.class;
/* 93:   */     }
/* 94:   */     
/* 95:   */     protected void innerOperate(Object object)
/* 96:   */     {
/* 97:86 */       if ((object instanceof Number))
/* 98:   */       {
/* 99:87 */         this.items += 1L;
/* :0:88 */         this.total += ((Number)object).floatValue();
/* :1:   */       }
/* :2:   */       else
/* :3:   */       {
/* :4:90 */         throw new IllegalArgumentException(
/* :5:91 */           "FloatArithmeticMean can only operate on Numbers.");
/* :6:   */       }
/* :7:   */     }
/* :8:   */     
/* :9:   */     protected Float cleanPrefuseIssue(Object object)
/* ;0:   */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* ;1:   */     {
/* ;2:98 */       return cleanFloatPrefuseBug(object);
/* ;3:   */     }
/* ;4:   */   }
/* ;5:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.ArithmeticMeanFunctionFactory
 * JD-Core Version:    0.7.0.1
 */