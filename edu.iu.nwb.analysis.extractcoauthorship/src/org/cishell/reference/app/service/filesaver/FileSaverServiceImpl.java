/*   1:    */ package org.cishell.reference.app.service.filesaver;
/*   2:    */ 
/*   3:    */ import java.io.File;
/*   4:    */ import java.io.FileInputStream;
/*   5:    */ import java.io.FileOutputStream;
/*   6:    */ import java.io.IOException;
/*   7:    */ import java.nio.channels.FileChannel;
/*   8:    */ import org.cishell.app.service.filesaver.AbstractFileSaverService;
/*   9:    */ import org.cishell.app.service.filesaver.FileSaveException;
/*  10:    */ import org.cishell.framework.data.Data;
/*  11:    */ import org.cishell.service.conversion.Converter;
/*  12:    */ import org.cishell.service.conversion.DataConversionService;
/*  13:    */ import org.cishell.service.guibuilder.GUIBuilderService;
/*  14:    */ import org.eclipse.swt.widgets.Display;
/*  15:    */ import org.eclipse.swt.widgets.Shell;
/*  16:    */ import org.eclipse.ui.IWorkbenchWindow;
/*  17:    */ import org.osgi.service.component.ComponentContext;
/*  18:    */ 
/*  19:    */ public class FileSaverServiceImpl
/*  20:    */   extends AbstractFileSaverService
/*  21:    */ {
/*  22:    */   public static final String SAVE_DIALOG_TITLE = "Save";
/*  23:    */   private DataConversionService conversionManager;
/*  24:    */   private GUIBuilderService guiBuilder;
/*  25:    */   
/*  26:    */   protected void activate(ComponentContext componentContext)
/*  27:    */   {
/*  28: 27 */     this.conversionManager = ((DataConversionService)componentContext.locateService("DCS"));
/*  29: 28 */     this.guiBuilder = ((GUIBuilderService)componentContext.locateService("GBS"));
/*  30:    */   }
/*  31:    */   
/*  32:    */   public Converter promptForConverter(Data outDatum, String targetMimeType)
/*  33:    */     throws FileSaveException
/*  34:    */   {
/*  35: 34 */     Converter[] converters = 
/*  36: 35 */       this.conversionManager.findConverters(outDatum, targetMimeType);
/*  37: 37 */     if (converters.length == 0) {
/*  38: 38 */       throw new FileSaveException("No appropriate converters.");
/*  39:    */     }
/*  40: 39 */     if (converters.length == 1)
/*  41:    */     {
/*  42: 41 */       Converter onlyConverter = converters[0];
/*  43:    */       
/*  44: 43 */       return onlyConverter;
/*  45:    */     }
/*  46: 45 */     Shell parentShell = org.eclipse.ui.PlatformUI.getWorkbench().getWorkbenchWindows()[0].getShell();
/*  47: 47 */     if (parentShell.isDisposed()) {
/*  48: 48 */       throw new FileSaveException(
/*  49: 49 */         "Can't create dialog window -- graphical environment not available.");
/*  50:    */     }
/*  51: 52 */     return showDataFormatChooser(outDatum, converters, parentShell);
/*  52:    */   }
/*  53:    */   
/*  54:    */   private Converter showDataFormatChooser(final Data outDatum, final Converter[] converters, final Shell parentShell)
/*  55:    */     throws FileSaveException
/*  56:    */   {
/*  57:    */     try
/*  58:    */     {
/*  59: 61 */       final Converter[] chosenConverter = new Converter[1];
/*  60: 62 */       guiRun(new Runnable()
/*  61:    */       {
/*  62:    */         public void run()
/*  63:    */         {
/*  64: 64 */           DataFormatChooser formatChooser = new DataFormatChooser(
/*  65: 65 */             outDatum, parentShell, converters, "Save");
/*  66: 66 */           formatChooser.createContent(new Shell(parentShell));
/*  67: 67 */           formatChooser.open();
/*  68: 68 */           chosenConverter[0] = formatChooser.getChosenConverter();
/*  69:    */         }
/*  70: 71 */       });
/*  71: 72 */       return chosenConverter[0];
/*  72:    */     }
/*  73:    */     catch (Exception e)
/*  74:    */     {
/*  75: 74 */       throw new FileSaveException(e.getMessage(), e);
/*  76:    */     }
/*  77:    */   }
/*  78:    */   
/*  79:    */   public File promptForTargetFile(final String suggestedFileName, final String defaultFileExtension)
/*  80:    */     throws FileSaveException
/*  81:    */   {
/*  82: 81 */     final File[] resultFile = new File[1];
/*  83:    */     try
/*  84:    */     {
/*  85: 84 */       guiRun(new Runnable()
/*  86:    */       {
/*  87:    */         public void run()
/*  88:    */         {
/*  89: 86 */           SaveAsController saveAs = 
/*  90: 87 */             new SaveAsController(FileSaverServiceImpl.this.guiBuilder);
/*  91:    */           
/*  92: 89 */           resultFile[0] = saveAs.open(suggestedFileName, defaultFileExtension);
/*  93:    */         }
/*  94: 92 */       });
/*  95: 93 */       return resultFile[0];
/*  96:    */     }
/*  97:    */     catch (Throwable e)
/*  98:    */     {
/*  99: 95 */       throw new FileSaveException(e.getMessage(), e);
/* 100:    */     }
/* 101:    */   }
/* 102:    */   
/* 103:    */   public void saveTo(File sourceFile, File targetFile)
/* 104:    */     throws FileSaveException
/* 105:    */   {
/* 106:100 */     if ((sourceFile != null) && (targetFile != null) && (sourceFile.exists())) {
/* 107:101 */       copyFile(sourceFile, targetFile);
/* 108:    */     }
/* 109:    */   }
/* 110:    */   
/* 111:    */   private void guiRun(Runnable run)
/* 112:    */   {
/* 113:106 */     Shell parentShell = org.eclipse.ui.PlatformUI.getWorkbench().getWorkbenchWindows()[0].getShell();
/* 114:108 */     if (Thread.currentThread() == Display.getDefault().getThread()) {
/* 115:109 */       run.run();
/* 116:    */     } else {
/* 117:111 */       parentShell.getDisplay().syncExec(run);
/* 118:    */     }
/* 119:    */   }
/* 120:    */   
/* 121:    */   private static void copyFile(File sourceFile, File targetFile)
/* 122:    */     throws FileSaveException
/* 123:    */   {
/* 124:    */     try
/* 125:    */     {
/* 126:121 */       FileInputStream inputStream = new FileInputStream(sourceFile);
/* 127:122 */       FileOutputStream outputStream = new FileOutputStream(targetFile);
/* 128:    */       
/* 129:124 */       FileChannel readableChannel = inputStream.getChannel();
/* 130:125 */       FileChannel writableChannel = outputStream.getChannel();
/* 131:    */       
/* 132:127 */       writableChannel.truncate(0L);
/* 133:128 */       writableChannel.transferFrom(
/* 134:129 */         readableChannel, 0L, readableChannel.size());
/* 135:130 */       inputStream.close();
/* 136:131 */       outputStream.close();
/* 137:    */     }
/* 138:    */     catch (IOException ioException)
/* 139:    */     {
/* 140:133 */       String exceptionMessage = 
/* 141:134 */         "An error occurred when copying from the file \"" + 
/* 142:135 */         sourceFile.getAbsolutePath() + 
/* 143:136 */         "\" to the file \"" + 
/* 144:137 */         targetFile.getAbsolutePath() + 
/* 145:138 */         "\".";
/* 146:    */       
/* 147:140 */       throw new FileSaveException(exceptionMessage, ioException);
/* 148:    */     }
/* 149:    */   }
/* 150:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.filesaver.FileSaverServiceImpl
 * JD-Core Version:    0.7.0.1
 */