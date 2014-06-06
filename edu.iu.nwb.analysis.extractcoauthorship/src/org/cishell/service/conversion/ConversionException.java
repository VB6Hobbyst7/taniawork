/*  1:   */ package org.cishell.service.conversion;
/*  2:   */ 
/*  3:   */ public class ConversionException
/*  4:   */   extends Exception
/*  5:   */ {
/*  6:   */   private static final long serialVersionUID = 1749134893481511313L;
/*  7:   */   
/*  8:   */   public ConversionException(String message, Throwable exception)
/*  9:   */   {
/* 10:27 */     super(message, exception);
/* 11:   */   }
/* 12:   */   
/* 13:   */   public ConversionException(Throwable exception)
/* 14:   */   {
/* 15:31 */     super(exception);
/* 16:   */   }
/* 17:   */   
/* 18:   */   public ConversionException(String message)
/* 19:   */   {
/* 20:35 */     super(message);
/* 21:   */   }
/* 22:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.conversion.ConversionException
 * JD-Core Version:    0.7.0.1
 */