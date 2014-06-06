/*   1:    */ package org.cishell.reference.app.service.filesaver;
/*   2:    */ 
/*   3:    */ import java.io.File;
/*   4:    */ import java.util.Arrays;
/*   5:    */ import java.util.Collection;
/*   6:    */ import java.util.Collections;
/*   7:    */ import java.util.Iterator;
/*   8:    */ import org.cishell.service.guibuilder.GUIBuilderService;
/*   9:    */ import org.eclipse.swt.widgets.FileDialog;
/*  10:    */ import org.eclipse.swt.widgets.Shell;
/*  11:    */ import org.eclipse.ui.IWorkbenchWindow;
/*  12:    */ 
/*  13:    */ public class SaveAsController
/*  14:    */ {
/*  15: 16 */   public static final Collection<Character> INVALID_FILENAME_CHARACTERS = Collections.unmodifiableCollection(Arrays.asList(new Character[] {
/*  16: 17 */     Character.valueOf('\\'), Character.valueOf('/'), Character.valueOf(':'), Character.valueOf('*'), Character.valueOf('?'), Character.valueOf('"'), Character.valueOf('<'), Character.valueOf('>'), Character.valueOf('|'), Character.valueOf('%') }));
/*  17:    */   public static final char FILENAME_CHARACTER_REPLACEMENT = '#';
/*  18:    */   public static final String FILE_EXTENSION_PREFIX = "file-ext:";
/*  19:    */   private static File currentDirectory;
/*  20:    */   private GUIBuilderService guiBuilder;
/*  21:    */   
/*  22:    */   public SaveAsController(GUIBuilderService guiBuilder)
/*  23:    */   {
/*  24: 27 */     this.guiBuilder = guiBuilder;
/*  25:    */   }
/*  26:    */   
/*  27:    */   public File open(String suggestedFileName, String suggestedFileExtension)
/*  28:    */   {
/*  29: 31 */     String fileExtension = determineFileExtension(suggestedFileName, suggestedFileExtension);
/*  30: 32 */     Shell parentShell = org.eclipse.ui.PlatformUI.getWorkbench().getWorkbenchWindows()[0].getShell();
/*  31: 33 */     FileDialog dialog = new FileDialog(parentShell, 8192);
/*  32: 35 */     if (currentDirectory == null) {
/*  33: 36 */       currentDirectory = 
/*  34: 37 */         new File(System.getProperty("user.home") + File.separator + "anything");
/*  35:    */     }
/*  36: 40 */     dialog.setFilterPath(currentDirectory.getPath());
/*  37: 42 */     if ((fileExtension != null) && (!"*".equals(fileExtension)) && (!"".equals(fileExtension)) && 
/*  38: 43 */       (!suggestedFileName.endsWith(fileExtension)))
/*  39:    */     {
/*  40: 45 */       stripFileExtension(suggestedFileName);
/*  41: 46 */       suggestedFileName = String.format("%s.%s", new Object[] { suggestedFileName, suggestedFileExtension });
/*  42: 47 */       dialog.setFilterExtensions(new String[] { String.format("*.%s", new Object[] { fileExtension }) });
/*  43:    */     }
/*  44: 50 */     dialog.setText("Choose File");
/*  45: 51 */     String cleanedSuggestedFileName = replaceInvalidFilenameCharacters(suggestedFileName);
/*  46:    */     
/*  47: 53 */     dialog.setFileName(cleanedSuggestedFileName);
/*  48:    */     File selectedFile = null;
/*  49:    */     do
/*  50:    */     {
/*  51: 56 */       String fileName = dialog.open();
/*  52: 58 */       if (fileName == null) {
/*  53:    */         break;
/*  54:    */       }
/*  55: 59 */       selectedFile = new File(fileName);
/*  56: 61 */     } while (!isSaveFileValid(selectedFile));
/*  57: 64 */     return selectedFile;
}
/*  62:    */   
/*  63:    */   private String determineFileExtension(String suggestedFileName, String suggestedFileExtension)
/*  64:    */   {
/*  65: 74 */     if ((suggestedFileExtension != null) && (!"".equals(suggestedFileExtension))) {
/*  66: 75 */       return suggestedFileExtension;
/*  67:    */     }
/*  68: 77 */     String fileExtension = getFileExtension(suggestedFileName);
/*  69: 79 */     if (!"".equals(fileExtension)) {
/*  70: 80 */       return fileExtension;
/*  71:    */     }
/*  72: 82 */     return "";
/*  73:    */   }
/*  74:    */   
/*  75:    */   private boolean confirmFileOverwrite(File file)
/*  76:    */   {
/*  77: 97 */     String message = "The file:\n" + file.getPath() + 
/*  78: 98 */       "\nalready exists. Are you sure you want to overwrite it?";
/*  79:    */     
/*  80:100 */     return this.guiBuilder.showConfirm("File Overwrite", message, "");
/*  81:    */   }
/*  82:    */   
/*  83:    */   private boolean isSaveFileValid(File file)
/*  84:    */   {
/*  85:104 */     if (file.isDirectory())
/*  86:    */     {
/*  87:105 */       String message = "Destination cannot be a directory. Please choose a file";
/*  88:106 */       this.guiBuilder.showError("Invalid Destination", message, "");
/*  89:    */       
/*  90:108 */       return false;
/*  91:    */     }
/*  92:109 */     if (file.exists()) {
/*  93:110 */       return confirmFileOverwrite(file);
/*  94:    */     }
/*  95:112 */     return true;
/*  96:    */   }
/*  97:    */   
/*  98:    */   public static String getFileExtension(String filePath)
/*  99:    */   {
/* 100:118 */     int periodPosition = filePath.lastIndexOf(".");
/* 101:120 */     if ((periodPosition != -1) && (periodPosition + 1 < filePath.length())) {
/* 102:121 */       return filePath.substring(periodPosition + 1);
/* 103:    */     }
/* 104:123 */     return "";
/* 105:    */   }
/* 106:    */   
/* 107:    */   private static String replaceInvalidFilenameCharacters(String filename)
/* 108:    */   {
/* 109:129 */     String cleanedFilename = filename;
/* 110:131 */     for (Iterator localIterator = INVALID_FILENAME_CHARACTERS.iterator(); localIterator.hasNext();)
/* 111:    */     {
/* 112:131 */       char invalidCharacter = ((Character)localIterator.next()).charValue();
/* 113:132 */       cleanedFilename = 
/* 114:133 */         cleanedFilename.replace(invalidCharacter, '#');
/* 115:    */     }
/* 116:136 */     return cleanedFilename;
/* 117:    */   }
/* 118:    */   
/* 119:    */   private static String stripFileExtension(String filePath)
/* 120:    */   {
/* 121:141 */     int periodPosition = filePath.lastIndexOf(".");
/* 122:143 */     if ((periodPosition != -1) && (periodPosition + 1 < filePath.length())) {
/* 123:144 */       return filePath.substring(0, periodPosition);
/* 124:    */     }
/* 125:146 */     return filePath;
/* 126:    */   }
/* 127:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.filesaver.SaveAsController
 * JD-Core Version:    0.7.0.1
 */