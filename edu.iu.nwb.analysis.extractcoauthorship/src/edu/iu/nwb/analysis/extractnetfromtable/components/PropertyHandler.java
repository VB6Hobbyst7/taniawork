/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*  2:   */ 
/*  3:   */ import java.io.BufferedReader;
/*  4:   */ import java.io.File;
/*  5:   */ import java.io.FileInputStream;
/*  6:   */ import java.io.FileNotFoundException;
/*  7:   */ import java.io.IOException;
/*  8:   */ import java.io.InputStreamReader;
/*  9:   */ import java.util.Properties;
/* 10:   */ import java.util.regex.Matcher;
/* 11:   */ import java.util.regex.Pattern;
/* 12:   */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/* 13:   */ import org.osgi.service.log.LogService;
/* 14:   */ 
/* 15:   */ public class PropertyHandler
/* 16:   */ {
/* 17:   */   public static boolean validateProperties(FileInputStream fis)
/* 18:   */     throws IOException
/* 19:   */   {
/* 20:20 */     BufferedReader br = new BufferedReader(new InputStreamReader(fis));
/* 21:   */     
/* 22:22 */     boolean wellFormed = true;
/* 23:   */     
/* 24:24 */     Pattern p = Pattern.compile("^.*\\..*=.*\\..*");
/* 25:   */     String line;
/* 26:27 */     while ((line = br.readLine()) != null)
/* 27:   */     {
/* 28:   */       String line1 = null;
/* 29:28 */       if ((line1.startsWith("node.")) || (line1.startsWith("edge.")))
/* 30:   */       {
/* 31:29 */         Matcher m = p.matcher(line1.subSequence(0, line1.length())).reset();
/* 32:30 */         if (!m.find()) {
/* 33:31 */           wellFormed = false;
/* 34:   */         }
/* 35:   */       }
/* 36:   */     }
/* 37:35 */     br.close();
/* 38:36 */     return wellFormed;
/* 39:   */   }
/* 40:   */   
/* 41:   */   public static Properties getProperties(String fileName, LogService log)
/* 42:   */     throws AlgorithmExecutionException
/* 43:   */   {
/* 44:40 */     Properties aggregateDefs = new Properties();
/* 45:41 */     boolean wellFormed = true;
/* 46:   */     try
/* 47:   */     {
/* 48:44 */       File f = new File(fileName);
/* 49:45 */       FileInputStream in = new FileInputStream(f);
/* 50:   */       
/* 51:47 */       wellFormed = validateProperties(in);
/* 52:49 */       if (wellFormed)
/* 53:   */       {
/* 54:50 */         in = new FileInputStream(f);
/* 55:51 */         aggregateDefs.load(in);
/* 56:   */       }
/* 57:   */       else
/* 58:   */       {
/* 59:54 */         log.log(2, "Your Aggregate Function File did not follow the specified format.\nContinuing the extraction without additional analysis.");
/* 60:   */       }
/* 61:   */     }
/* 62:   */     catch (FileNotFoundException fnfe)
/* 63:   */     {
/* 64:60 */       throw new AlgorithmExecutionException(fnfe.getMessage(), fnfe);
/* 65:   */     }
/* 66:   */     catch (IOException ie)
/* 67:   */     {
/* 68:62 */       throw new AlgorithmExecutionException(ie.getMessage(), ie);
/* 69:   */     }
/* 70:64 */     return aggregateDefs;
/* 71:   */   }
/* 72:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.PropertyHandler
 * JD-Core Version:    0.7.0.1
 */