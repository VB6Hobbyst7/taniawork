/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*   2:    */ 
/*   3:    */ import java.util.HashMap;
/*   4:    */ import java.util.Map;
/*   5:    */ import java.util.Map.Entry;
/*   6:    */ 
/*   7:    */ public class ModeFunctionFactory
/*   8:    */   implements AggregateFunctionFactory
/*   9:    */ {
/*  10:  8 */   private static final AggregateFunctionName TYPE = AggregateFunctionName.MODE;
/*  11:    */   
/*  12:    */   public AbstractAggregateFunction getFunction(Class c)
/*  13:    */   {
/*  14: 12 */    
/*  22: 19 */     return new StringMode();
/*  23:    */   }
/*  24:    */   
/*  25:    */   public AggregateFunctionName getType()
/*  26:    */   {
/*  27: 25 */     return TYPE;
/*  28:    */   }
/*  29:    */   
/*  30:    */   private static abstract class AbstractModeFunction
/*  31:    */     extends AbstractAggregateFunction
/*  32:    */   {
/*  33:    */     private Map<Object, Integer> objectToOccurrences;
/*  34:    */     
/*  35:    */     public AbstractModeFunction()
/*  36:    */     {
/*  37: 32 */       this.objectToOccurrences = new HashMap();
/*  38:    */     }
/*  39:    */     
/*  40:    */     public Object getResult()
/*  41:    */     {
/*  42: 37 */       return findKeyWithMaxValue(this.objectToOccurrences);
/*  43:    */     }
/*  44:    */     
/*  45:    */     public void innerOperate(Object object)
/*  46:    */     {
/*  47: 42 */       if (!this.objectToOccurrences.containsKey(object)) {
/*  48: 43 */         this.objectToOccurrences.put(object, Integer.valueOf(0));
/*  49:    */       }
/*  50: 46 */       Integer oldNumberOfOccurrences = 
/*  51: 47 */         (Integer)this.objectToOccurrences.get(object);
/*  52:    */       
/*  53: 49 */       this.objectToOccurrences.put(object, Integer.valueOf(oldNumberOfOccurrences.intValue() + 1));
/*  54:    */     }
/*  55:    */     
/*  56:    */     private static Object findKeyWithMaxValue(Map<Object, Integer> map)
/*  57:    */     {
/*  58: 61 */       Object maxKey = null;
/*  59: 62 */       Integer maxValue = Integer.valueOf(-2147483648);
/*  60: 64 */       for (Map.Entry<Object, Integer> numericEntry : map.entrySet())
/*  61:    */       {
/*  62: 65 */         Integer value = (Integer)numericEntry.getValue();
/*  63: 67 */         if (value.intValue() >= maxValue.intValue())
/*  64:    */         {
/*  65: 68 */           maxKey = numericEntry.getKey();
/*  66: 69 */           maxValue = value;
/*  67:    */         }
/*  68:    */       }
/*  69: 73 */       return maxKey;
/*  70:    */     }
/*  71:    */   }
/*  72:    */   
/*  73:    */   class IntegerMode
/*  74:    */     extends ModeFunctionFactory.AbstractModeFunction
/*  75:    */   {
/*  76:    */     IntegerMode() {}
/*  77:    */     
/*  78:    */     public Class getType()
/*  79:    */     {
/*  80: 79 */       return Integer.class;
/*  81:    */     }
/*  82:    */     
/*  83:    */     protected Integer cleanPrefuseIssue(Object object)
/*  84:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  85:    */     {
/*  86: 85 */       return cleanIntegerPrefuseBug(object);
/*  87:    */     }
/*  88:    */   }
/*  89:    */   
/*  90:    */   class StringMode
/*  91:    */     extends ModeFunctionFactory.AbstractModeFunction
/*  92:    */   {
/*  93:    */     StringMode() {}
/*  94:    */     
/*  95:    */     public Class getType()
/*  96:    */     {
/*  97: 91 */       return String.class;
/*  98:    */     }
/*  99:    */     
/* 100:    */     protected String cleanPrefuseIssue(Object object)
/* 101:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 102:    */     {
/* 103: 97 */       return cleanStringPrefuseBug(object);
/* 104:    */     }
/* 105:    */   }
/* 106:    */   
/* 107:    */   class BooleanMode
/* 108:    */     extends ModeFunctionFactory.AbstractModeFunction
/* 109:    */   {
/* 110:    */     BooleanMode() {}
/* 111:    */     
/* 112:    */     public Class getType()
/* 113:    */     {
/* 114:103 */       return Boolean.class;
/* 115:    */     }
/* 116:    */     
/* 117:    */     protected Boolean cleanPrefuseIssue(Object object)
/* 118:    */       throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 119:    */     {
/* 120:109 */       return cleanBooleanPrefuseBug(object);
/* 121:    */     }
/* 122:    */   }
/* 123:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.ModeFunctionFactory
 * JD-Core Version:    0.7.0.1
 */