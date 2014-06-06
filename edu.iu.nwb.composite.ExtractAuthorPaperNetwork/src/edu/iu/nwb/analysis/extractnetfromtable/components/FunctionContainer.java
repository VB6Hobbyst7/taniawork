/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*  2:   */ 
/*  3:   */ import edu.iu.nwb.analysis.extractnetfromtable.aggregate.AbstractAggregateFunction;
/*  4:   */ import edu.iu.nwb.analysis.extractnetfromtable.aggregate.AssembleAggregateFunctions;
/*  5:   */ import prefuse.data.Table;
/*  6:   */ import prefuse.data.Tuple;
/*  7:   */ 
/*  8:   */ public class FunctionContainer
/*  9:   */ {
/* 10:   */   boolean hasSkippedColumns;
/* 11:   */   
/* 12:   */   public FunctionContainer()
/* 13:   */   {
/* 14:12 */     this.hasSkippedColumns = false;
/* 15:   */   }
/* 16:   */   
/* 17:   */   protected ValueAttributes mutateFunctions(Tuple tuple, Table t, int rowNumber, ValueAttributes va, AggregateFunctionMappings aggregateFunctionMappings, int nodeType)
/* 18:   */   {
/* 19:19 */     AssembleAggregateFunctions assembleAggregateFunction = 
/* 20:20 */       AssembleAggregateFunctions.defaultAssembly();
/* 21:   */     
/* 22:   */ 
/* 23:23 */     String operateColumn = null;
/* 24:25 */     for (int cc = 0; cc < tuple.getColumnCount(); cc++)
/* 25:   */     {
/* 26:26 */       String columnName = tuple.getColumnName(cc);
/* 27:   */       
/* 28:28 */       AbstractAggregateFunction aggregateFunction = va.getFunction(cc);
/* 29:31 */       if (aggregateFunction == null) {
/* 30:32 */         aggregateFunction = 
/* 31:33 */           assembleAggregateFunction.getAggregateFunction(
/* 32:34 */           aggregateFunctionMappings.getFunctionFromColumnName(columnName), 
/* 33:35 */           tuple.getColumnType(cc));
/* 34:   */       }
/* 35:38 */       if (aggregateFunction != null)
/* 36:   */       {
/* 37:39 */         operateColumn = 
/* 38:40 */           aggregateFunctionMappings.getOriginalColumnFromFunctionColumn(columnName);
/* 39:42 */         if (aggregateFunction.skippedColumns() > 0) {
/* 40:43 */           this.hasSkippedColumns = true;
/* 41:   */         }
/* 42:46 */         int appliedNodeType = aggregateFunctionMappings.getAppliedNodeType(columnName);
/* 43:48 */         if (aggregateFunction.skippedColumns() > 0) {
/* 44:49 */           this.hasSkippedColumns = true;
/* 45:   */         }
/* 46:52 */         if ((appliedNodeType == nodeType) || 
/* 47:53 */           (appliedNodeType == 0))
/* 48:   */         {
/* 49:54 */           aggregateFunction.operate(t.get(rowNumber, operateColumn));
/* 50:55 */           tuple.set(cc, aggregateFunction.getResult());
/* 51:   */         }
/* 52:58 */         if (va.getFunction(cc) == null) {
/* 53:59 */           va.putFunction(cc, aggregateFunction);
/* 54:   */         }
/* 55:61 */         if (aggregateFunction.skippedColumns() > 0) {
/* 56:62 */           this.hasSkippedColumns = true;
/* 57:   */         }
/* 58:   */       }
/* 59:   */     }
/* 60:67 */     return va;
/* 61:   */   }
/* 62:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.FunctionContainer
 * JD-Core Version:    0.7.0.1
 */