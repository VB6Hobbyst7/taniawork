/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*  2:   */ 
/*  3:   */ import edu.iu.nwb.analysis.extractnetfromtable.aggregate.AbstractAggregateFunction;
/*  4:   */ import java.util.HashMap;
/*  5:   */ import java.util.Map;
/*  6:   */ 
/*  7:   */ public class ValueAttributes
/*  8:   */ {
/*  9:   */   private int rowNumber;
/* 10:   */   private Map<Integer, AbstractAggregateFunction> columnNumberToFunction;
/* 11:   */   
/* 12:   */   public ValueAttributes(int rowNumber)
/* 13:   */   {
/* 14:25 */     this.rowNumber = rowNumber;
/* 15:26 */     this.columnNumberToFunction = new HashMap();
/* 16:   */   }
/* 17:   */   
/* 18:   */   public void putFunction(int columnNumber, AbstractAggregateFunction aggregateFunction)
/* 19:   */   {
/* 20:41 */     this.columnNumberToFunction.put(Integer.valueOf(columnNumber), aggregateFunction);
/* 21:   */   }
/* 22:   */   
/* 23:   */   public AbstractAggregateFunction getFunction(int columnNumber)
/* 24:   */   {
/* 25:52 */     return (AbstractAggregateFunction)this.columnNumberToFunction.get(Integer.valueOf(columnNumber));
/* 26:   */   }
/* 27:   */   
/* 28:   */   public int getRowNumber()
/* 29:   */   {
/* 30:61 */     return this.rowNumber;
/* 31:   */   }
/* 32:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.ValueAttributes
 * JD-Core Version:    0.7.0.1
 */