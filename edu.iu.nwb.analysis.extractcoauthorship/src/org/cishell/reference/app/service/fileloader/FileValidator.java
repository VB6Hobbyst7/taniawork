/*  1:   */ package org.cishell.reference.app.service.fileloader;
/*  2:   */ 
/*  3:   */ import java.io.File;
/*  4:   */ import java.util.Hashtable;
/*  5:   */ import org.cishell.framework.CIShellContext;
/*  6:   */ import org.cishell.framework.algorithm.Algorithm;
/*  7:   */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  8:   */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  9:   */ import org.cishell.framework.algorithm.ProgressMonitor;
/* 10:   */ import org.cishell.framework.algorithm.ProgressTrackable;
/* 11:   */ import org.cishell.framework.data.BasicData;
/* 12:   */ import org.cishell.framework.data.Data;
/* 13:   */ import org.osgi.service.log.LogService;
/* 14:   */ 
/* 15:   */ public final class FileValidator
/* 16:   */ {
/* 17:   */   public static Data[] validateFile(File file, AlgorithmFactory validator, ProgressMonitor progressMonitor, CIShellContext ciShellContext, LogService logger)
/* 18:   */     throws AlgorithmExecutionException
/* 19:   */   {
/* 20:23 */     Data[] validationData = 
/* 21:24 */       { new BasicData(file.getPath(), String.class.getName()) };
/* 22:25 */     Algorithm algorithm = validator.createAlgorithm(
/* 23:26 */       validationData, new Hashtable(), ciShellContext);
/* 24:28 */     if ((progressMonitor != null) && ((algorithm instanceof ProgressTrackable)))
/* 25:   */     {
/* 26:29 */       ProgressTrackable progressTrackable = (ProgressTrackable)algorithm;
/* 27:30 */       progressTrackable.setProgressMonitor(progressMonitor);
/* 28:   */     }
/* 29:33 */     Data[] validatedData = algorithm.execute();
/* 30:35 */     if (validatedData != null) {
/* 31:36 */       logger.log(3, "Loaded: " + file.getPath());
/* 32:   */     }
/* 33:39 */     return validatedData;
/* 34:   */   }
/* 35:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.fileloader.FileValidator
 * JD-Core Version:    0.7.0.1
 */