/*   1:    */ package org.cishell.reference.app.service.fileloader;
/*   2:    */ 
/*   3:    */ import java.io.File;
/*   4:    */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*   5:    */ import org.eclipse.ui.IWorkbenchWindow;
/*   6:    */ import org.osgi.framework.BundleContext;
/*   7:    */ import org.osgi.framework.InvalidSyntaxException;
/*   8:    */ import org.osgi.framework.ServiceReference;
/*   9:    */ 
/*  10:    */ public final class ValidatorSelectorRunnable
/*  11:    */   implements Runnable
/*  12:    */ {
/*  13:    */   private IWorkbenchWindow window;
/*  14:    */   private BundleContext bundleContext;
/*  15:    */   private File file;
/*  16:    */   private AlgorithmFactory chosenValidator;
/*  17:    */   
/*  18:    */   public ValidatorSelectorRunnable(IWorkbenchWindow window, BundleContext bundleContext, File file)
/*  19:    */   {
/*  20: 20 */     this.window = window;
/*  21: 21 */     this.bundleContext = bundleContext;
/*  22: 22 */     this.file = file;
/*  23:    */   }
/*  24:    */   
/*  25:    */   public AlgorithmFactory getValidator()
/*  26:    */   {
/*  27: 27 */     return this.chosenValidator;
/*  28:    */   }
/*  29:    */   
/*  30:    */   public void run()
/*  31:    */   {
/*  32: 31 */     String fileExtension = 
/*  33: 32 */       getFileExtension(this.file.getAbsolutePath()).toLowerCase().substring(1);
/*  34:    */     
/*  35: 34 */     ServiceReference[] supportingValidators = 
/*  36: 35 */       getSupportingValidators(this.bundleContext, fileExtension);
/*  37: 38 */     if (supportingValidators.length == 0)
/*  38:    */     {
/*  39: 41 */       ServiceReference[] allValidators = getAllValidators(this.bundleContext);
/*  40:    */       
/*  41: 43 */       FileFormatSelector validatorSelector = new FileFormatSelector(
/*  42: 44 */         "Load", this.window.getShell(), this.bundleContext, allValidators, this.file);
/*  43: 45 */       validatorSelector.open();
/*  44: 46 */       this.chosenValidator = validatorSelector.getValidator();
/*  45:    */     }
/*  46: 47 */     else if (supportingValidators.length == 1)
/*  47:    */     {
/*  48: 48 */       ServiceReference onlyPossibleValidator = supportingValidators[0];
/*  49: 49 */       this.chosenValidator = 
/*  50: 50 */         ((AlgorithmFactory)this.bundleContext.getService(onlyPossibleValidator));
/*  51:    */     }
/*  52: 53 */     if (supportingValidators.length > 1)
/*  53:    */     {
/*  54: 54 */       FileFormatSelector validatorSelector = new FileFormatSelector(
/*  55: 55 */         "Load", this.window.getShell(), this.bundleContext, supportingValidators, this.file);
/*  56: 56 */       validatorSelector.open();
/*  57: 57 */       this.chosenValidator = validatorSelector.getValidator();
/*  58:    */     }
/*  59:    */   }
/*  60:    */   
/*  61:    */   public static ServiceReference[] getAllValidators(BundleContext bundleContext)
/*  62:    */   {
/*  63:    */     try
/*  64:    */     {
/*  65: 63 */       String validatorsQuery = "(&(type=validator)(in_data=file-ext:*))";
/*  66: 64 */       ServiceReference[] allValidators = bundleContext.getAllServiceReferences(
/*  67: 65 */         AlgorithmFactory.class.getName(), validatorsQuery);
/*  68: 67 */       if (allValidators == null) {
/*  69: 68 */         return new ServiceReference[0];
/*  70:    */       }
/*  71: 70 */       return allValidators;
/*  72:    */     }
/*  73:    */     catch (InvalidSyntaxException e)
/*  74:    */     {
/*  75: 73 */       e.printStackTrace();
/*  76:    */     }
/*  77: 75 */     return new ServiceReference[0];
/*  78:    */   }
/*  79:    */   
/*  80:    */   public static ServiceReference[] getSupportingValidators(BundleContext bundleContext, String fileExtension)
/*  81:    */   {
/*  82:    */     try
/*  83:    */     {
/*  84: 82 */       String validatorsQuery = 
/*  85: 83 */         "(& (type=validator)(|(in_data=file-ext:" + 
/*  86:    */         
/*  87: 85 */         fileExtension + ")" + 
/*  88: 86 */         "(also_validates=" + fileExtension + ")" + 
/*  89: 87 */         "))";
/*  90:    */       
/*  91: 89 */       ServiceReference[] supportingValidators = bundleContext.getAllServiceReferences(
/*  92: 90 */         AlgorithmFactory.class.getName(), validatorsQuery);
/*  93: 92 */       if (supportingValidators == null) {
/*  94: 93 */         return new ServiceReference[0];
/*  95:    */       }
/*  96: 95 */       return supportingValidators;
/*  97:    */     }
/*  98:    */     catch (InvalidSyntaxException e)
/*  99:    */     {
/* 100: 98 */       e.printStackTrace();
/* 101:    */     }
/* 102:100 */     return new ServiceReference[0];
/* 103:    */   }
/* 104:    */   
/* 105:    */   private static String getFileExtension(String filePath)
/* 106:    */   {
/* 107:106 */     int periodPosition = filePath.lastIndexOf(".");
/* 108:108 */     if ((periodPosition != -1) && (periodPosition + 1 < filePath.length())) {
/* 109:109 */       return filePath.substring(periodPosition);
/* 110:    */     }
/* 111:111 */     return "";
/* 112:    */   }
/* 113:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.fileloader.ValidatorSelectorRunnable
 * JD-Core Version:    0.7.0.1
 */