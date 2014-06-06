/*  1:   */ package org.cishell.reference.app.service.fileloader;
/*  2:   */ 
/*  3:   */ import java.io.File;
/*  4:   */ import org.eclipse.swt.widgets.FileDialog;
/*  5:   */ import org.eclipse.ui.IWorkbenchWindow;
/*  6:   */ 
/*  7:   */ public final class FileSelectorRunnable
/*  8:   */   implements Runnable
/*  9:   */ {
/* 10:   */   private IWorkbenchWindow window;
/* 11:   */   private boolean selectSingleFile;
/* 12:   */   private String[] filterExtensions;
/* 13:   */   private File[] files;
/* 14:   */   
/* 15:   */   public FileSelectorRunnable(IWorkbenchWindow window, boolean selectSingleFile, String[] filterExtensions)
/* 16:   */   {
/* 17:17 */     this.window = window;
/* 18:18 */     this.selectSingleFile = selectSingleFile;
/* 19:19 */     this.filterExtensions = filterExtensions;
/* 20:   */   }
/* 21:   */   
/* 22:   */   public File[] getFiles()
/* 23:   */   {
/* 24:23 */     return this.files;
/* 25:   */   }
/* 26:   */   
/* 27:   */   public void run()
/* 28:   */   {
/* 29:27 */     this.files = getFilesFromUser();
/* 30:29 */     if (this.files.length == 0) {
/* 31:30 */       return;
/* 32:   */     }
/* 33:32 */     FileLoaderServiceImpl.defaultLoadDirectory = 
/* 34:33 */       this.files[0].getParentFile().getAbsolutePath();
/* 35:   */   }
/* 36:   */   
/* 37:   */   private File[] getFilesFromUser()
/* 38:   */   {
/* 39:38 */     FileDialog fileDialog = createFileDialog();
/* 40:39 */     fileDialog.open();
/* 41:40 */     String path = fileDialog.getFilterPath();
/* 42:41 */     String[] fileNames = fileDialog.getFileNames();
/* 43:43 */     if ((fileNames == null) || (fileNames.length == 0)) {
/* 44:44 */       return new File[0];
/* 45:   */     }
/* 46:46 */     File[] files = new File[fileNames.length];
/* 47:48 */     for (int ii = 0; ii < fileNames.length; ii++)
/* 48:   */     {
/* 49:49 */       String fullFileName = path + File.separator + fileNames[ii];
/* 50:50 */       files[ii] = new File(fullFileName);
/* 51:   */     }
/* 52:53 */     return files;
/* 53:   */   }
/* 54:   */   
/* 55:   */   private FileDialog createFileDialog()
/* 56:   */   {
/* 57:58 */     File currentDirectory = new File(FileLoaderServiceImpl.defaultLoadDirectory);
/* 58:59 */     String absolutePath = currentDirectory.getAbsolutePath();
/* 59:60 */     FileDialog fileDialog = 
/* 60:61 */       new FileDialog(this.window.getShell(), 0x1000 | determineSWTFileSelectFlag());
/* 61:62 */     fileDialog.setFilterPath(absolutePath);
/* 62:64 */     if ((this.filterExtensions != null) && (this.filterExtensions.length > 0)) {
/* 63:65 */       fileDialog.setFilterExtensions(this.filterExtensions);
/* 64:   */     }
/* 65:68 */     fileDialog.setText("Select Files");
/* 66:   */     
/* 67:70 */     return fileDialog;
/* 68:   */   }
/* 69:   */   
/* 70:   */   private int determineSWTFileSelectFlag()
/* 71:   */   {
/* 72:74 */     if (this.selectSingleFile) {
/* 73:75 */       return 4;
/* 74:   */     }
/* 75:77 */     return 2;
/* 76:   */   }
/* 77:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.fileloader.FileSelectorRunnable
 * JD-Core Version:    0.7.0.1
 */