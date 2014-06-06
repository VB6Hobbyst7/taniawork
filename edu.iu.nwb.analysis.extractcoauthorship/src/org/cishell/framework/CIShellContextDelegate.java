/*  1:   */ package org.cishell.framework;
/*  2:   */ 
/*  3:   */ import org.osgi.framework.ServiceReference;
/*  4:   */ import org.osgi.service.log.LogService;
/*  5:   */ 
/*  6:   */ public class CIShellContextDelegate
/*  7:   */   implements CIShellContext
/*  8:   */ {
/*  9:   */   private ServiceReference uniqueServiceReference;
/* 10:   */   private CIShellContext actualCIShellContext;
/* 11:   */   
/* 12:   */   public CIShellContextDelegate(ServiceReference uniqueServiceReference, CIShellContext actualCIShellContext)
/* 13:   */   {
/* 14:12 */     this.uniqueServiceReference = uniqueServiceReference;
/* 15:13 */     this.actualCIShellContext = actualCIShellContext;
/* 16:   */   }
/* 17:   */   
/* 18:   */   public Object getService(String service)
/* 19:   */   {
/* 20:17 */     if (LogService.class.getName().equals(service)) {
/* 21:18 */       return new LogServiceDelegate(
/* 22:19 */         this.uniqueServiceReference, 
/* 23:20 */         (LogService)this.actualCIShellContext.getService(service));
/* 24:   */     }
/* 25:22 */     return this.actualCIShellContext.getService(service);
/* 26:   */   }
/* 27:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.CIShellContextDelegate
 * JD-Core Version:    0.7.0.1
 */