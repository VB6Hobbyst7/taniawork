/*  1:   */ package org.cishell.framework;
/*  2:   */ 
/*  3:   */ import org.cishell.service.conversion.DataConversionService;
/*  4:   */ import org.cishell.service.guibuilder.GUIBuilderService;
/*  5:   */ import org.osgi.service.log.LogService;
/*  6:   */ import org.osgi.service.prefs.PreferencesService;
/*  7:   */ 
/*  8:   */ public abstract interface CIShellContext
/*  9:   */ {
/* 10:38 */   public static final String[] DEFAULT_SERVICES = { LogService.class.getName(), 
/* 11:39 */     PreferencesService.class.getName(), 
/* 12:40 */     DataConversionService.class.getName(), 
/* 13:41 */     GUIBuilderService.class.getName() };
/* 14:   */   
/* 15:   */   public abstract Object getService(String paramString);
/* 16:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.CIShellContext
 * JD-Core Version:    0.7.0.1
 */