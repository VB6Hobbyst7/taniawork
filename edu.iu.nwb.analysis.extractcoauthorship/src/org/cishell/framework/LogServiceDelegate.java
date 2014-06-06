/*  1:   */ package org.cishell.framework;
/*  2:   */ 
/*  3:   */ import org.osgi.framework.ServiceReference;
/*  4:   */ import org.osgi.service.log.LogService;
/*  5:   */ 
/*  6:   */ public class LogServiceDelegate
/*  7:   */   implements LogService
/*  8:   */ {
/*  9:   */   private ServiceReference uniqueServiceReference;
/* 10:   */   private LogService actualLogService;
/* 11:   */   
/* 12:   */   public LogServiceDelegate(ServiceReference uniqueServiceReference, LogService actualLogService)
/* 13:   */   {
/* 14:12 */     this.uniqueServiceReference = uniqueServiceReference;
/* 15:13 */     this.actualLogService = actualLogService;
/* 16:   */   }
/* 17:   */   
/* 18:   */   public void log(int level, String message)
/* 19:   */   {
/* 20:17 */     this.actualLogService.log(this.uniqueServiceReference, level, message);
/* 21:   */   }
/* 22:   */   
/* 23:   */   public void log(int level, String message, Throwable exception)
/* 24:   */   {
/* 25:21 */     this.actualLogService.log(this.uniqueServiceReference, level, message, exception);
/* 26:   */   }
/* 27:   */   
/* 28:   */   public void log(ServiceReference serviceReference, int level, String message)
/* 29:   */   {
/* 30:25 */     this.actualLogService.log(serviceReference, level, message);
/* 31:   */   }
/* 32:   */   
/* 33:   */   public void log(ServiceReference serviceReference, int level, String message, Throwable exception)
/* 34:   */   {
/* 35:30 */     this.actualLogService.log(serviceReference, level, message, exception);
/* 36:   */   }
/* 37:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.LogServiceDelegate
 * JD-Core Version:    0.7.0.1
 */