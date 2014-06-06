/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*   2:    */ 
/*   3:    */ public class SumFunctionFactory
/*   4:    */   implements AggregateFunctionFactory
/*   5:    */ {
/*   6:  4 */   private static final AggregateFunctionName TYPE = AggregateFunctionName.SUM;
/*   7:    */   
/*   8:    */   public AbstractAggregateFunction getFunction(Class c)
/*   9:    */   {
/*  10:  8 */    
/*  22: 20 */     return null;
/*  23:    */   }
/*  24:    */   
/*  25:    */   public AggregateFunctionName getType()
/*  26:    */   {
/*  27: 25 */     return TYPE;
/*  28:    */   }
/*  29:    */   
/*  30:    */   class DoubleSum
/*  31:    */     extends AbstractAggregateFunction
/*  32:    */   {
/*  33:    */     private double total;
/*  34:    */     
/*  35:    */     public DoubleSum()
/*  36:    */     {
/*  37: 32 */       this.total = 0.0D;
/*  38:    */     }
/*  39:    */     
/*  40:    */     public Double getResult()
/*  41:    */     {
/*  42: 37 */       return Double.valueOf(this.total);
/*  43:    */     }
/*  44:    */     
/*  45:    */     public Class getType()
/*  46:    */     {
/*  47: 42 */       return Double.class;
/*  48:    */     }
/*  49:    */     
/*  50:    */     protected void innerOperate(Object object)
/*  51:    */     {
/*  52: 47 */       if ((object instanceof Number)) {
/*  53: 48 */         this.total += ((Number)object).doubleValue();
/*  54:    */       } else {
/*  55: 50 */         throw new IllegalArgumentException(
/*  56: 51 */           "DoubleSum can only operate on Numbers.");
/*  57:    */       }
/*  58:    */     }
/*  59:    */     
/*  60:    */     protected Double cleanPrefuseIssue(Object object)
/*  61:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  62:    */     {
/*  63: 58 */       return cleanDoublePrefuseBug(object);
/*  64:    */     }
/*  65:    */   }
/*  66:    */   
/*  67:    */   class FloatSum
/*  68:    */     extends AbstractAggregateFunction
/*  69:    */   {
/*  70:    */     private float total;
/*  71:    */     
/*  72:    */     public FloatSum()
/*  73:    */     {
/*  74: 66 */       this.total = 0.0F;
/*  75:    */     }
/*  76:    */     
/*  77:    */     public Float getResult()
/*  78:    */     {
/*  79: 71 */       return Float.valueOf(this.total);
/*  80:    */     }
/*  81:    */     
/*  82:    */     public Class getType()
/*  83:    */     {
/*  84: 76 */       return Float.class;
/*  85:    */     }
/*  86:    */     
/*  87:    */     protected void innerOperate(Object object)
/*  88:    */     {
/*  89: 81 */       if ((object instanceof Number)) {
/*  90: 82 */         this.total += ((Number)object).floatValue();
/*  91:    */       } else {
/*  92: 84 */         throw new IllegalArgumentException(
/*  93: 85 */           "FloatSum can only operate on Numbers.");
/*  94:    */       }
/*  95:    */     }
/*  96:    */     
/*  97:    */     protected Float cleanPrefuseIssue(Object object)
/*  98:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  99:    */     {
/* 100: 92 */       return cleanFloatPrefuseBug(object);
/* 101:    */     }
/* 102:    */   }
/* 103:    */   
/* 104:    */   class IntegerSum
/* 105:    */     extends AbstractAggregateFunction
/* 106:    */   {
/* 107:    */     private int total;
/* 108:    */     
/* 109:    */     public IntegerSum()
/* 110:    */     {
/* 111:100 */       this.total = 0;
/* 112:    */     }
/* 113:    */     
/* 114:    */     public Integer getResult()
/* 115:    */     {
/* 116:105 */       return Integer.valueOf(this.total);
/* 117:    */     }
/* 118:    */     
/* 119:    */     public Class getType()
/* 120:    */     {
/* 121:110 */       return Integer.class;
/* 122:    */     }
/* 123:    */     
/* 124:    */     protected void innerOperate(Object object)
/* 125:    */     {
/* 126:115 */       if ((object instanceof Number)) {
/* 127:116 */         this.total += ((Number)object).intValue();
/* 128:    */       } else {
/* 129:118 */         throw new IllegalArgumentException(
/* 130:119 */           "IntegerSum can only operate on Numbers.");
/* 131:    */       }
/* 132:    */     }
/* 133:    */     
/* 134:    */     protected Integer cleanPrefuseIssue(Object object)
/* 135:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 136:    */     {
/* 137:126 */       return cleanIntegerPrefuseBug(object);
/* 138:    */     }
/* 139:    */   }
/* 140:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.SumFunctionFactory
 * JD-Core Version:    0.7.0.1
 */