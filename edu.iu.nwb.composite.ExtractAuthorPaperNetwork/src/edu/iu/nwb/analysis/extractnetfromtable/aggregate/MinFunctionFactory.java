/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*   2:    */ 
/*   3:    */ public class MinFunctionFactory
/*   4:    */   implements AggregateFunctionFactory
/*   5:    */ {
/*   6:  4 */   private static final AggregateFunctionName TYPE = AggregateFunctionName.MIN;
/*   7:    */   
/*   8:    */   public AggregateFunctionName getType()
/*   9:    */   {
/*  10:  8 */     return TYPE;
/*  11:    */   }
/*  12:    */   
/*  13:    */   public AbstractAggregateFunction getFunction(Class c)
/*  14:    */   {
/*  15: 13 */    
/*  27: 25 */     return null;
/*  28:    */   }
/*  29:    */   
/*  30:    */   class DoubleMin
/*  31:    */     extends AbstractAggregateFunction
/*  32:    */   {
/*  33:    */     private double value;
/*  34:    */     
/*  35:    */     public DoubleMin()
/*  36:    */     {
/*  37: 32 */       this.value = 1.7976931348623157E+308D;
/*  38:    */     }
/*  39:    */     
/*  40:    */     public Object getResult()
/*  41:    */     {
/*  42: 37 */       return new Double(this.value);
/*  43:    */     }
/*  44:    */     
/*  45:    */     public Class getType()
/*  46:    */     {
/*  47: 42 */       return Double.class;
/*  48:    */     }
/*  49:    */     
/*  50:    */     protected void innerOperate(Object object)
/*  51:    */     {
/*  52: 47 */       if ((object instanceof Number))
/*  53:    */       {
/*  54: 48 */         if (((Number)object).doubleValue() < this.value) {
/*  55: 49 */           this.value = ((Number)object).doubleValue();
/*  56:    */         }
/*  57:    */       }
/*  58:    */       else {
/*  59: 52 */         throw new IllegalArgumentException(
/*  60: 53 */           "DoubleMin can only operate on Numbers.");
/*  61:    */       }
/*  62:    */     }
/*  63:    */     
/*  64:    */     protected Double cleanPrefuseIssue(Object object)
/*  65:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  66:    */     {
/*  67: 60 */       return cleanDoublePrefuseBug(object);
/*  68:    */     }
/*  69:    */   }
/*  70:    */   
/*  71:    */   class FloatMin
/*  72:    */     extends AbstractAggregateFunction
/*  73:    */   {
/*  74:    */     private float value;
/*  75:    */     
/*  76:    */     public FloatMin()
/*  77:    */     {
/*  78: 68 */       this.value = 3.4028235E+38F;
/*  79:    */     }
/*  80:    */     
/*  81:    */     public Object getResult()
/*  82:    */     {
/*  83: 73 */       return new Float(this.value);
/*  84:    */     }
/*  85:    */     
/*  86:    */     public Class getType()
/*  87:    */     {
/*  88: 78 */       return Float.class;
/*  89:    */     }
/*  90:    */     
/*  91:    */     protected void innerOperate(Object object)
/*  92:    */     {
/*  93: 83 */       if ((object instanceof Number))
/*  94:    */       {
/*  95: 84 */         if (((Number)object).floatValue() < this.value) {
/*  96: 85 */           this.value = ((Number)object).floatValue();
/*  97:    */         }
/*  98:    */       }
/*  99:    */       else {
/* 100: 88 */         throw new IllegalArgumentException(
/* 101: 89 */           "FloatMin can only operate on Numbers.");
/* 102:    */       }
/* 103:    */     }
/* 104:    */     
/* 105:    */     protected Float cleanPrefuseIssue(Object object)
/* 106:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 107:    */     {
/* 108: 96 */       return cleanFloatPrefuseBug(object);
/* 109:    */     }
/* 110:    */   }
/* 111:    */   
/* 112:    */   class IntegerMin
/* 113:    */     extends AbstractAggregateFunction
/* 114:    */   {
/* 115:    */     private int value;
/* 116:    */     
/* 117:    */     public IntegerMin()
/* 118:    */     {
/* 119:104 */       this.value = 2147483647;
/* 120:    */     }
/* 121:    */     
/* 122:    */     public Object getResult()
/* 123:    */     {
/* 124:109 */       return Integer.valueOf(this.value);
/* 125:    */     }
/* 126:    */     
/* 127:    */     public Class getType()
/* 128:    */     {
/* 129:114 */       return Integer.class;
/* 130:    */     }
/* 131:    */     
/* 132:    */     protected void innerOperate(Object object)
/* 133:    */     {
/* 134:119 */       if ((object instanceof Number))
/* 135:    */       {
/* 136:120 */         if (((Number)object).intValue() < this.value) {
/* 137:121 */           this.value = ((Number)object).intValue();
/* 138:    */         }
/* 139:    */       }
/* 140:    */       else {
/* 141:124 */         throw new IllegalArgumentException(
/* 142:125 */           "IntegerMin can only operate on Numbers.");
/* 143:    */       }
/* 144:    */     }
/* 145:    */     
/* 146:    */     protected Integer cleanPrefuseIssue(Object object)
/* 147:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 148:    */     {
/* 149:133 */       return cleanIntegerPrefuseBug(object);
/* 150:    */     }
/* 151:    */   }
/* 152:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.MinFunctionFactory
 * JD-Core Version:    0.7.0.1
 */