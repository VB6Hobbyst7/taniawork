/*  1:   */ package org.cishell.reference.app.service.fileloader;
/*  2:   */ 
/*  3:   */ import java.io.File;
/*  4:   */ import java.util.ArrayList;
/*  5:   */ import java.util.Collection;
/*  6:   */ import java.util.Dictionary;
/*  7:   */ import java.util.Enumeration;
/*  8:   */ import java.util.Hashtable;
/*  9:   */ import org.cishell.framework.data.BasicData;
/* 10:   */ import org.cishell.framework.data.Data;
/* 11:   */ 
/* 12:   */ public class PrettyLabeler
/* 13:   */ {
/* 14:   */   public static Data[] relabelWithFileName(Data[] data, File file)
/* 15:   */   {
/* 16:16 */     File absoluteFile = file.getAbsoluteFile();
/* 17:17 */     File parent = absoluteFile.getParentFile();
/* 18:   */     
/* 19:   */ 
/* 20:   */ 
/* 21:   */ 
/* 22:22 */     String parentName = parent.getName();
/* 23:   */     String prefix;
/* 24:   */     String prefix1;
/* 25:23 */     if (parentName.trim().length() == 0) {
/* 26:24 */       prefix1 = File.separator;
/* 27:   */     } else {
/* 28:26 */       prefix1 = "..." + File.separator + parentName + File.separator;
/* 29:   */     }
/* 30:29 */     Collection<Data> newData = new ArrayList(data.length);
/* 31:   */     
/* 32:   */ 
/* 33:   */ 
/* 34:   */ 
/* 35:34 */     Data[] arrayOfData = data;int j = data.length;
/* 36:34 */     for (int i = 0; i < j; i++)
/* 37:   */     {
/* 38:34 */       Data datum = arrayOfData[i];
/* 39:35 */       Dictionary<String, Object> originalDatumMetadata = datum.getMetadata();
/* 40:36 */       Dictionary<String, Object> labeledDatumMetadata = new Hashtable();
/* 41:38 */       for (Enumeration<String> keys = originalDatumMetadata.keys(); 
/* 42:39 */             keys.hasMoreElements();)
/* 43:   */       {
/* 44:40 */         String key = (String)keys.nextElement();
/* 45:41 */         labeledDatumMetadata.put(key, originalDatumMetadata.get(key));
/* 46:   */       }
/* 47:44 */       Data labeledDatum = 
/* 48:45 */         new BasicData(labeledDatumMetadata, datum.getData(), datum.getFormat());
/* 49:46 */       labeledDatumMetadata.put("Label", prefix1 + absoluteFile.getName());
/* 50:47 */       newData.add(labeledDatum);
/* 51:   */     }
/* 52:50 */     return (Data[])newData.toArray(new Data[0]);
/* 53:   */   }
/* 54:   */   
/* 55:   */   public static Data[] relabelWithFileNameHierarchy(Data[] data, File file)
/* 56:   */   {
/* 57:61 */     File absoluteFile = file.getAbsoluteFile();
/* 58:62 */     File parent = absoluteFile.getParentFile();
/* 59:   */     
/* 60:   */ 
/* 61:65 */     String parentName = parent.getName();
/* 62:   */     String prefix;
/* 63:   */     String prefix1;
/* 64:66 */     if (parentName.trim().length() == 0) {
/* 65:67 */       prefix1 = File.separator;
/* 66:   */     } else {
/* 67:69 */       prefix1 = "..." + File.separator + parentName + File.separator;
/* 68:   */     }
/* 69:72 */     Collection<Data> possibleParents = new ArrayList(data.length);
/* 70:   */     
/* 71:74 */     Data[] arrayOfData = data;int j = data.length;
/* 72:74 */     for (int i = 0; i < j; i++)
/* 73:   */     {
/* 74:74 */       Data datum = arrayOfData[i];
/* 75:75 */       Dictionary<String, Object> labeledDatumMetadata = datum.getMetadata();
/* 76:76 */       Object labelObject = labeledDatumMetadata.get("Label");
/* 77:78 */       if ((labelObject == null) || ("".equals(labelObject.toString())))
/* 78:   */       {
/* 79:79 */         Data dataParent = getParent(labeledDatumMetadata);
/* 80:81 */         if (!possibleParents.contains(dataParent)) {
/* 81:82 */           labeledDatumMetadata.put("Label", prefix1 + absoluteFile.getName());
/* 82:   */         }
/* 83:85 */         possibleParents.add(datum);
/* 84:   */       }
/* 85:   */     }
/* 86:89 */     return data;
/* 87:   */   }
/* 88:   */   
/* 89:   */   private static Data getParent(Dictionary<String, Object> labeledDatumMetadata)
/* 90:   */   {
/* 91:96 */     return (Data)labeledDatumMetadata.get("Parent");
/* 92:   */   }
/* 93:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.fileloader.PrettyLabeler
 * JD-Core Version:    0.7.0.1
 */