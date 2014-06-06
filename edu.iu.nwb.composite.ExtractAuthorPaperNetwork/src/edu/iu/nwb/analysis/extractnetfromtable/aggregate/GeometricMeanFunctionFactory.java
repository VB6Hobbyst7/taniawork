/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*   2:    */ 
/*   3:    */ public class GeometricMeanFunctionFactory
/*   4:    */   implements AggregateFunctionFactory
/*   5:    */ {
/*   6:  4 */   private static final AggregateFunctionName TYPE = AggregateFunctionName.GEOMETRICMEAN;
/*   7:    */   
/*   8:    */   public AbstractAggregateFunction getFunction(Class c)
/*   9:    */   {
/*  10:  8 */  
/*  22: 20 */     return null;
/*  23:    */   }
/*  24:    */   
/*  25:    */   public AggregateFunctionName getType()
/*  26:    */   {
/*  27: 27 */     return TYPE;
/*  28:    */   }
/*  29:    */   
/*  30:    */   class DoubleGeometricMean
/*  31:    */     extends AbstractAggregateFunction
/*  32:    */   {
/*  33:    */     private double value;
/*  34:    */     private long items;
/*  35:    */     
/*  36:    */     public DoubleGeometricMean()
/*  37:    */     {
/*  38: 35 */       this.items = 0L;
/*  39: 36 */       this.value = 1.0D;
/*  40:    */     }
/*  41:    */     
/*  42:    */     public Object getResult()
/*  43:    */     {
/*  44: 41 */       double result = Math.pow(this.value, 1.0D / this.items);
/*  45: 42 */       return Double.valueOf(result);
/*  46:    */     }
/*  47:    */     
/*  48:    */     public Class getType()
/*  49:    */     {
/*  50: 47 */       return Double.class;
/*  51:    */     }
/*  52:    */     
/*  53:    */     protected void innerOperate(Object object)
/*  54:    */     {
/*  55: 52 */       if ((object instanceof Number))
/*  56:    */       {
/*  57: 53 */         this.items += 1L;
/*  58: 54 */         this.value *= ((Number)object).doubleValue();
/*  59:    */       }
/*  60:    */       else
/*  61:    */       {
/*  62: 56 */         throw new IllegalArgumentException(
/*  63: 57 */           "DoubleGeometricMean can only operate on Numbers.");
/*  64:    */       }
/*  65:    */     }
/*  66:    */     
/*  67:    */     protected Double cleanPrefuseIssue(Object object)
/*  68:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  69:    */     {
/*  70: 64 */       return cleanDoublePrefuseBug(object);
/*  71:    */     }
/*  72:    */   }
/*  73:    */   
/*  74:    */   class FloatGeometricMean
/*  75:    */     extends AbstractAggregateFunction
/*  76:    */   {
/*  77:    */     private float value;
/*  78:    */     private long items;
/*  79:    */     
/*  80:    */     public FloatGeometricMean()
/*  81:    */     {
/*  82: 73 */       this.value = 1.0F;
/*  83: 74 */       this.items = 0L;
/*  84:    */     }
/*  85:    */     
/*  86:    */     public Object getResult()
/*  87:    */     {
/*  88: 79 */       float result = (float)Math.pow(this.value, 
/*  89: 80 */         1.0F / (float)this.items);
/*  90: 81 */       return Float.valueOf(result);
/*  91:    */     }
/*  92:    */     
/*  93:    */     public Class getType()
/*  94:    */     {
/*  95: 86 */       return Float.class;
/*  96:    */     }
/*  97:    */     
/*  98:    */     protected void innerOperate(Object object)
/*  99:    */     {
/* 100: 91 */       if ((object instanceof Number))
/* 101:    */       {
/* 102: 92 */         this.items += 1L;
/* 103: 93 */         this.value *= ((Number)object).floatValue();
/* 104:    */       }
/* 105:    */       else
/* 106:    */       {
/* 107: 95 */         throw new IllegalArgumentException(
/* 108: 96 */           "FloatArithmeticMean can only operate on Numbers.");
/* 109:    */       }
/* 110:    */     }
/* 111:    */     
/* 112:    */     protected Float cleanPrefuseIssue(Object object)
/* 113:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 114:    */     {
/* 115:103 */       return cleanFloatPrefuseBug(object);
/* 116:    */     }
/* 117:    */   }
/* 118:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.GeometricMeanFunctionFactory
 * JD-Core Version:    0.7.0.1
 */