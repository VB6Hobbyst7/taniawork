/*  1:   */ package org.cishell.app.service.fileloader;
/*  2:   */ 
/*  3:   */ public class FileLoadException
/*  4:   */   extends Exception
/*  5:   */ {
/*  6:   */   private static final long serialVersionUID = 1L;
/*  7:   */   
/*  8:   */   public FileLoadException(String message, Throwable exception)
/*  9:   */   {
/* 10: 7 */     super(message, exception);
/* 11:   */   }
/* 12:   */   
/* 13:   */   public FileLoadException(Throwable exception)
/* 14:   */   {
/* 15:11 */     super(exception);
/* 16:   */   }
/* 17:   */   
/* 18:   */   public FileLoadException(String message)
/* 19:   */   {
/* 20:15 */     super(message);
/* 21:   */   }
/* 22:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.fileloader.FileLoadException
 * JD-Core Version:    0.7.0.1
 */