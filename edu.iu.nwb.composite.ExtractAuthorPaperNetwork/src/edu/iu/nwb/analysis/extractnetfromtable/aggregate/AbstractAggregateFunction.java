/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.aggregate;
/*   2:    */ 
/*   3:    */ import org.cishell.utilities.PrefuseUtilities;
/*   4:    */ import org.cishell.utilities.PrefuseUtilities.EmptyInterpretedObjectException;
/*   5:    */ import org.cishell.utilities.PrefuseUtilities.UninterpretableObjectException;
/*   6:    */ 
/*   7:    */ public abstract class AbstractAggregateFunction
/*   8:    */ {
/*   9:    */   private int skippedCount;
/*  10:    */   
/*  11:    */   public abstract Object getResult();
/*  12:    */   
/*  13:    */   public abstract Class getType();
/*  14:    */   
/*  15:    */   public int skippedColumns()
/*  16:    */   {
/*  17: 20 */     return this.skippedCount;
/*  18:    */   }
/*  19:    */   
/*  20:    */   public final void operate(Object object)
/*  21:    */   {
/*  22:    */     try
/*  23:    */     {
/*  24: 32 */       Object cleanObject = cleanPrefuseIssue(object);
/*  25: 33 */       innerOperate(cleanObject);
/*  26:    */     }
/*  27:    */     catch (ObjectCouldNotBeCleanedException localObjectCouldNotBeCleanedException)
/*  28:    */     {
/*  29: 35 */       incrementSkippedColumns();
/*  30:    */     }
/*  31:    */   }
/*  32:    */   
/*  33:    */   protected abstract void innerOperate(Object paramObject);
/*  34:    */   
/*  35:    */   protected abstract Object cleanPrefuseIssue(Object paramObject)
/*  36:    */     throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException;
/*  37:    */   
/*  38:    */   protected static Number cleanNumberPrefuseBug(Object object)
/*  39:    */     throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  40:    */   {
/*  41:    */     try
/*  42:    */     {
/*  43: 78 */       return PrefuseUtilities.interpretObjectAsNumber(object);
/*  44:    */     }
/*  45:    */     catch (PrefuseUtilities.EmptyInterpretedObjectException e)
/*  46:    */     {
/*  47: 80 */       throw new ObjectCouldNotBeCleanedException(e);
/*  48:    */     }
/*  49:    */     catch (PrefuseUtilities.UninterpretableObjectException e)
/*  50:    */     {
/*  51: 82 */       throw new ObjectCouldNotBeCleanedException(e);
/*  52:    */     }
/*  53:    */   }
/*  54:    */   
/*  55:    */   protected static Integer cleanIntegerPrefuseBug(Object object)
/*  56:    */     throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  57:    */   {
/*  58:    */     try
/*  59:    */     {
/*  60:100 */       return PrefuseUtilities.interpretObjectAsInteger(object);
/*  61:    */     }
/*  62:    */     catch (PrefuseUtilities.EmptyInterpretedObjectException e)
/*  63:    */     {
/*  64:102 */       throw new ObjectCouldNotBeCleanedException(e);
/*  65:    */     }
/*  66:    */     catch (PrefuseUtilities.UninterpretableObjectException e)
/*  67:    */     {
/*  68:104 */       throw new ObjectCouldNotBeCleanedException(e);
/*  69:    */     }
/*  70:    */   }
/*  71:    */   
/*  72:    */   protected static Float cleanFloatPrefuseBug(Object object)
/*  73:    */     throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  74:    */   {
/*  75:    */     try
/*  76:    */     {
/*  77:122 */       return PrefuseUtilities.interpretObjectAsFloat(object);
/*  78:    */     }
/*  79:    */     catch (PrefuseUtilities.EmptyInterpretedObjectException e)
/*  80:    */     {
/*  81:124 */       throw new ObjectCouldNotBeCleanedException(e);
/*  82:    */     }
/*  83:    */     catch (PrefuseUtilities.UninterpretableObjectException e)
/*  84:    */     {
/*  85:126 */       throw new ObjectCouldNotBeCleanedException(e);
/*  86:    */     }
/*  87:    */   }
/*  88:    */   
/*  89:    */   protected static Double cleanDoublePrefuseBug(Object object)
/*  90:    */     throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/*  91:    */   {
/*  92:    */     try
/*  93:    */     {
/*  94:144 */       return PrefuseUtilities.interpretObjectAsDouble(object);
/*  95:    */     }
/*  96:    */     catch (PrefuseUtilities.EmptyInterpretedObjectException e)
/*  97:    */     {
/*  98:146 */       throw new ObjectCouldNotBeCleanedException(e);
/*  99:    */     }
/* 100:    */     catch (PrefuseUtilities.UninterpretableObjectException e)
/* 101:    */     {
/* 102:148 */       throw new ObjectCouldNotBeCleanedException(e);
/* 103:    */     }
/* 104:    */   }
/* 105:    */   
/* 106:    */   protected static Boolean cleanBooleanPrefuseBug(Object object)
/* 107:    */     throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 108:    */   {
/* 109:    */     try
/* 110:    */     {
/* 111:165 */       return PrefuseUtilities.interpretObjectAsBoolean(object);
/* 112:    */     }
/* 113:    */     catch (PrefuseUtilities.EmptyInterpretedObjectException e)
/* 114:    */     {
/* 115:167 */       throw new ObjectCouldNotBeCleanedException(e);
/* 116:    */     }
/* 117:    */   }
/* 118:    */   
/* 119:    */   protected static String cleanStringPrefuseBug(Object object)
/* 120:    */     throws AbstractAggregateFunction.ObjectCouldNotBeCleanedException
/* 121:    */   {
/* 122:    */     try
/* 123:    */     {
/* 124:184 */       return PrefuseUtilities.interpretObjectAsString(object);
/* 125:    */     }
/* 126:    */     catch (PrefuseUtilities.EmptyInterpretedObjectException e)
/* 127:    */     {
/* 128:186 */       throw new ObjectCouldNotBeCleanedException(e);
/* 129:    */     }
/* 130:    */   }
/* 131:    */   
/* 132:    */   private void incrementSkippedColumns()
/* 133:    */   {
/* 134:193 */     this.skippedCount += 1;
/* 135:    */   }
/* 136:    */   
/* 137:    */   protected static class ObjectCouldNotBeCleanedException
/* 138:    */     extends Exception
/* 139:    */   {
/* 140:    */     private static final long serialVersionUID = -776940374030425321L;
/* 141:    */     
/* 142:    */     public ObjectCouldNotBeCleanedException() {}
/* 143:    */     
/* 144:    */     public ObjectCouldNotBeCleanedException(String message)
/* 145:    */     {
/* 146:214 */       super();
/* 147:    */     }
/* 148:    */     
/* 149:    */     public ObjectCouldNotBeCleanedException(Throwable cause)
/* 150:    */     {
/* 151:221 */       super();
/* 152:    */     }
/* 153:    */     
/* 154:    */     public ObjectCouldNotBeCleanedException(String message, Throwable cause)
/* 155:    */     {
/* 156:228 */       super(cause);
/* 157:    */     }
/* 158:    */   }
/* 159:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.AbstractAggregateFunction
 * JD-Core Version:    0.7.0.1
 */