/*  1:   */ package org.cishell.framework.algorithm;
/*  2:   */ 
/*  3:   */ public class AlgorithmCreationFailedException
/*  4:   */   extends RuntimeException
/*  5:   */ {
/*  6:   */   private static final long serialVersionUID = 9017277008277139930L;
/*  7:   */   
/*  8:   */   public AlgorithmCreationFailedException(String message, Throwable exception)
/*  9:   */   {
/* 10: 7 */     super(message, exception);
/* 11:   */   }
/* 12:   */   
/* 13:   */   public AlgorithmCreationFailedException(Throwable exception)
/* 14:   */   {
/* 15:11 */     super(exception);
/* 16:   */   }
/* 17:   */   
/* 18:   */   public AlgorithmCreationFailedException(String message)
/* 19:   */   {
/* 20:15 */     super(message);
/* 21:   */   }
/* 22:   */   
/* 23:   */   public AlgorithmCreationFailedException()
/* 24:   */   {
/* 25:19 */     this("Algorithm canceled by user.");
/* 26:   */   }
/* 27:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.algorithm.AlgorithmCreationFailedException
 * JD-Core Version:    0.7.0.1
 */