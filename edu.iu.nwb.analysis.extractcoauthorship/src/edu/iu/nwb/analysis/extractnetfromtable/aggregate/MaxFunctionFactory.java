/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*   2:    */ 
/*   3:    */ public class MaxFunctionFactory
/*   4:    */   implements AggregateFunctionFactory
/*   5:    */ {
/*   6:  4 */   private static final AggregateFunctionName TYPE = AggregateFunctionName.MAX;
/*   7:    */   
/*   8:    */   public AbstractAggregateFunction getFunction(Class c)
/*   9:    */   {
/*  10:  9 */    
/*  22: 22 */     return null;
/*  23:    */   }
/*  24:    */   
/*  25:    */   public AggregateFunctionName getType()
/*  26:    */   {
/*  27: 27 */     return TYPE;
/*  28:    */   }
/*  29:    */   
/*  30:    */   class IntegerMax
/*  31:    */     extends AbstractAggregateFunction
/*  32:    */   {
/*  33:    */     private int value;
/*  34:    */     
/*  35:    */     public IntegerMax()
/*  36:    */     {
/*  37: 34 */       this.value = -2147483648;
/*  38:    */     }
/*  39:    */     
/*  40:    */     public Object getResult()
/*  41:    */     {
/*  42: 39 */       return Integer.valueOf(this.value);
/*  43:    */     }
/*  44:    */     
/*  45:    */     public Class getType()
/*  46:    */     {
/*  47: 44 */       return Integer.class;
/*  48:    */     }
/*  49:    */     
/*  50:    */     protected void innerOperate(Object object)
/*  51:    */     {
/*  52: 49 */       if ((object instanceof Number))
/*  53:    */       {
/*  54: 50 */         if (((Number)object).intValue() > this.value) {
/*  55: 51 */           this.value = ((Number)object).intValue();
/*  56:    */         }
/*  57:    */       }
/*  58:    */       else {
/*  59: 54 */         throw new IllegalArgumentException(
/*  60: 55 */           "IntegerMax can only operate on Numbers.");
/*  61:    */       }
/*  62:    */     }
/*  63:    */     
/*  64:    */     protected Integer cleanPrefuseIssue(Object object)
/*  65:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  66:    */     {
/*  67: 62 */       return cleanIntegerPrefuseBug(object);
/*  68:    */     }
/*  69:    */   }
/*  70:    */   
/*  71:    */   class FloatMax
/*  72:    */     extends AbstractAggregateFunction
/*  73:    */   {
/*  74:    */     private float value;
/*  75:    */     
/*  76:    */     public FloatMax()
/*  77:    */     {
/*  78: 70 */       this.value = 1.4E-45F;
/*  79:    */     }
/*  80:    */     
/*  81:    */     public Object getResult()
/*  82:    */     {
/*  83: 75 */       return new Float(this.value);
/*  84:    */     }
/*  85:    */     
/*  86:    */     public Class getType()
/*  87:    */     {
/*  88: 80 */       return Float.class;
/*  89:    */     }
/*  90:    */     
/*  91:    */     protected void innerOperate(Object object)
/*  92:    */     {
/*  93: 85 */       if ((object instanceof Number))
/*  94:    */       {
/*  95: 86 */         if (((Number)object).floatValue() > this.value) {
/*  96: 87 */           this.value = ((Number)object).floatValue();
/*  97:    */         }
/*  98:    */       }
/*  99:    */       else {
/* 100: 90 */         throw new IllegalArgumentException(
/* 101: 91 */           "FloatMax can only operate on Numbers.");
/* 102:    */       }
/* 103:    */     }
/* 104:    */     
/* 105:    */     protected Float cleanPrefuseIssue(Object object)
/* 106:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 107:    */     {
/* 108: 98 */       return cleanFloatPrefuseBug(object);
/* 109:    */     }
/* 110:    */   }
/* 111:    */   
/* 112:    */   class DoubleMax
/* 113:    */     extends AbstractAggregateFunction
/* 114:    */   {
/* 115:    */     private double value;
/* 116:    */     
/* 117:    */     public DoubleMax()
/* 118:    */     {
/* 119:106 */       this.value = 4.9E-324D;
/* 120:    */     }
/* 121:    */     
/* 122:    */     public Object getResult()
/* 123:    */     {
/* 124:111 */       return new Double(this.value);
/* 125:    */     }
/* 126:    */     
/* 127:    */     public Class getType()
/* 128:    */     {
/* 129:116 */       return Double.class;
/* 130:    */     }
/* 131:    */     
/* 132:    */     protected void innerOperate(Object object)
/* 133:    */     {
/* 134:121 */       if ((object instanceof Number))
/* 135:    */       {
/* 136:122 */         if (((Number)object).doubleValue() > this.value) {
/* 137:123 */           this.value = ((Number)object).doubleValue();
/* 138:    */         }
/* 139:    */       }
/* 140:    */       else {
/* 141:126 */         throw new IllegalArgumentException(
/* 142:127 */           "DoubleMax can only operate on Numbers.");
/* 143:    */       }
/* 144:    */     }
/* 145:    */     
/* 146:    */     protected Double cleanPrefuseIssue(Object object)
/* 147:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 148:    */     {
/* 149:134 */       return cleanDoublePrefuseBug(object);
/* 150:    */     }
/* 151:    */   }
/* 152:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.MaxFunctionFactory
 * JD-Core Version:    0.7.0.1
 */