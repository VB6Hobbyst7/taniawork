/*  1:   */ package org.cishell.framework.algorithm;
/*  2:   */ 
/*  3:   */ public class AlgorithmExecutionException
/*  4:   */   extends Exception
/*  5:   */ {
/*  6:   */   private static final long serialVersionUID = 9017277008277139930L;
/*  7:   */   
/*  8:   */   public AlgorithmExecutionException(String message, Throwable exception)
/*  9:   */   {
/* 10:25 */     super(message, exception);
/* 11:   */   }
/* 12:   */   
/* 13:   */   public AlgorithmExecutionException(Throwable exception)
/* 14:   */   {
/* 15:29 */     super(exception);
/* 16:   */   }
/* 17:   */   
/* 18:   */   public AlgorithmExecutionException(String message)
/* 19:   */   {
/* 20:33 */     super(message);
/* 21:   */   }
/* 22:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.algorithm.AlgorithmExecutionException
 * JD-Core Version:    0.7.0.1
 */