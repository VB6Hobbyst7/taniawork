/*  1:   */ package org.cishell.framework;
/*  2:   */ 
/*  3:   */ import org.osgi.framework.BundleContext;
/*  4:   */ import org.osgi.framework.ServiceReference;
/*  5:   */ 
/*  6:   */ public class LocalCIShellContext
/*  7:   */   implements CIShellContext
/*  8:   */ {
/*  9:   */   private BundleContext bContext;
/* 10:   */   private String[] standardServices;
/* 11:   */   
/* 12:   */   public LocalCIShellContext(BundleContext bContext)
/* 13:   */   {
/* 14:42 */     this(bContext, DEFAULT_SERVICES);
/* 15:   */   }
/* 16:   */   
/* 17:   */   public LocalCIShellContext(BundleContext bContext, String[] standardServices)
/* 18:   */   {
/* 19:56 */     this.bContext = bContext;
/* 20:57 */     this.standardServices = standardServices;
/* 21:   */   }
/* 22:   */   
/* 23:   */   public Object getService(String service)
/* 24:   */   {
/* 25:65 */     for (int i = 0; i < this.standardServices.length; i++) {
/* 26:66 */       if (this.standardServices[i].equals(service))
/* 27:   */       {
/* 28:67 */         ServiceReference ref = this.bContext.getServiceReference(service);
/* 29:68 */         if (ref != null) {
/* 30:69 */           return this.bContext.getService(ref);
/* 31:   */         }
/* 32:71 */         throw new RuntimeException("Standard CIShell Service: " + 
/* 33:72 */           service + " not installed!");
/* 34:   */       }
/* 35:   */     }
/* 36:82 */     ServiceReference ref = this.bContext.getServiceReference(service);
/* 37:83 */     return this.bContext.getService(ref);
/* 38:   */   }
/* 39:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.LocalCIShellContext
 * JD-Core Version:    0.7.0.1
 */