/*  1:   */ package org.cishell.service.autostart;
/*  2:   */ 
/*  3:   */ import java.util.Dictionary;
/*  4:   */ import java.util.Enumeration;
/*  5:   */ import org.eclipse.update.configurator.ConfiguratorUtils;
/*  6:   */ import org.osgi.framework.Bundle;
/*  7:   */ import org.osgi.framework.BundleActivator;
/*  8:   */ import org.osgi.framework.BundleContext;
/*  9:   */ import org.osgi.framework.BundleEvent;
/* 10:   */ import org.osgi.framework.BundleException;
/* 11:   */ import org.osgi.framework.BundleListener;
/* 12:   */ 
/* 13:   */ public class Activator
/* 14:   */   implements BundleActivator, BundleListener
/* 15:   */ {
/* 16:   */   public void start(BundleContext context)
/* 17:   */     throws Exception
/* 18:   */   {
/* 19:22 */     ConfiguratorUtils.getCurrentPlatformConfiguration();
/* 20:23 */     context.addBundleListener(this);
/* 21:24 */     Bundle[] bundles = context.getBundles();
/* 22:26 */     for (int i = 0; i < bundles.length; i++) {
/* 23:27 */       if (bundles[i].getState() == 4) {
/* 24:28 */         startBundle(bundles[i]);
/* 25:   */       }
/* 26:   */     }
/* 27:   */   }
/* 28:   */   
/* 29:   */   public void stop(BundleContext context)
/* 30:   */     throws Exception
/* 31:   */   {
/* 32:36 */     context.removeBundleListener(this);
/* 33:   */   }
/* 34:   */   
/* 35:   */   public void bundleChanged(BundleEvent e)
/* 36:   */   {
/* 37:44 */     if (e.getType() == 32) {
/* 38:45 */       startBundle(e.getBundle());
/* 39:   */     }
/* 40:   */   }
/* 41:   */   
/* 42:   */   private void startBundle(Bundle bundle)
/* 43:   */   {
/* 44:50 */     Dictionary header = bundle.getHeaders();
/* 45:52 */     for (Enumeration iter = header.keys(); iter.hasMoreElements();)
/* 46:   */     {
/* 47:53 */       String key = iter.nextElement().toString();
/* 48:55 */       if (("x-autostart".equalsIgnoreCase(key)) && 
/* 49:56 */         ("true".equals(header.get(key)))) {
/* 50:   */         try
/* 51:   */         {
/* 52:58 */           bundle.start();
/* 53:   */         }
/* 54:   */         catch (BundleException e1)
/* 55:   */         {
/* 56:60 */           e1.printStackTrace();
/* 57:   */         }
/* 58:   */       }
/* 59:   */     }
/* 60:   */   }
/* 61:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.service.autostart_1.0.0.jar
 * Qualified Name:     org.cishell.service.autostart.Activator
 * JD-Core Version:    0.7.0.1
 */