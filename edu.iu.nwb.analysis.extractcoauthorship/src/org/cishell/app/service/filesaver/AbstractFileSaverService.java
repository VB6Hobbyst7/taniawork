/*   1:    */ package org.cishell.app.service.filesaver;
/*   2:    */ 
/*   3:    */ import java.io.File;
/*   4:    */ import java.io.PrintStream;
/*   5:    */ import java.util.Arrays;
/*   6:    */ import java.util.Collection;
/*   7:    */ import java.util.Collections;
/*   8:    */ import java.util.Dictionary;
/*   9:    */ import java.util.HashSet;
/*  10:    */ import org.cishell.framework.data.Data;
/*  11:    */ import org.cishell.service.conversion.ConversionException;
/*  12:    */ import org.cishell.service.conversion.Converter;
/*  13:    */ 
/*  14:    */ public abstract class AbstractFileSaverService
/*  15:    */   implements FileSaverService
/*  16:    */ {
/*  17: 18 */   public static final Collection<Character> INVALID_FILENAME_CHARACTERS = Collections.unmodifiableSet(new HashSet(Arrays.asList(new Character[] {
/*  18: 19 */     new Character('\\'), 
/*  19: 20 */     new Character('/'), 
/*  20: 21 */     new Character(':'), 
/*  21: 22 */     new Character('*'), 
/*  22: 23 */     new Character('?'), 
/*  23: 24 */     new Character('"'), 
/*  24: 25 */     new Character('<'), 
/*  25: 26 */     new Character('>'), 
/*  26: 27 */     new Character('|'), 
/*  27: 28 */     new Character('%') })));
/*  28:    */   public static final char FILENAME_CHARACTER_REPLACEMENT = '#';
/*  29:    */   public static final String FILE_EXTENSION_PREFIX = "file-ext:";
/*  30:    */   public static final String FILE_PREFIX = "file:";
/*  31:    */   private Collection<FileSaveListener> listeners;
/*  32:    */   
/*  33:    */   public void registerListener(FileSaveListener listener)
/*  34:    */   {
/*  35: 36 */     this.listeners.add(listener);
/*  36:    */   }
/*  37:    */   
/*  38:    */   public void unregisterListener(FileSaveListener listener)
/*  39:    */   {
/*  40: 40 */     this.listeners.remove(listener);
/*  41:    */   }
/*  42:    */   
/*  43:    */   public File promptForTargetFile()
/*  44:    */     throws FileSaveException
/*  45:    */   {
/*  46: 44 */     return promptForTargetFile("");
/*  47:    */   }
/*  48:    */   
/*  49:    */   public File promptForTargetFile(String defaultFileExtension)
/*  50:    */     throws FileSaveException
/*  51:    */   {
/*  52: 48 */     return promptForTargetFile("", defaultFileExtension);
/*  53:    */   }
/*  54:    */   
/*  55:    */   public File promptForTargetFile(Data datum, String defaultFileExtension)
/*  56:    */     throws FileSaveException
/*  57:    */   {
/*  58: 53 */     Object dataObject = datum.getData();
/*  59: 55 */     if ((dataObject instanceof File))
/*  60:    */     {
/*  61: 56 */       String fileName = ((File)datum.getData()).getName();
/*  62: 57 */       return promptForTargetFile(fileName, defaultFileExtension);
/*  63:    */     }
/*  64: 59 */     return promptForTargetFile(suggestFileName(datum), defaultFileExtension);
/*  65:    */   }
/*  66:    */   
/*  67:    */   public File promptForTargetFile(File outputFile)
/*  68:    */     throws FileSaveException
/*  69:    */   {
/*  70: 64 */     return promptForTargetFile(outputFile.getName(), "");
/*  71:    */   }
/*  72:    */   
/*  73:    */   public File saveData(Data sourceDatum)
/*  74:    */     throws FileSaveException
/*  75:    */   {
/*  76: 68 */     return saveData(sourceDatum, "file-ext:*");
/*  77:    */   }
/*  78:    */   
/*  79:    */   public File saveData(Data sourceDatum, String targetMimeType)
/*  80:    */     throws FileSaveException
/*  81:    */   {
/*  82: 73 */     Converter converter = promptForConverter(sourceDatum, targetMimeType);
/*  83: 75 */     if (converter != null) {
/*  84: 76 */       return saveData(sourceDatum, converter);
/*  85:    */     }
/*  86: 79 */     return null;
/*  87:    */   }
/*  88:    */   
/*  89:    */   public File saveData(Data sourceDatum, Converter converter)
/*  90:    */     throws FileSaveException
/*  91:    */   {
/*  92: 84 */     String outputMimeType = 
/*  93: 85 */       converter.getProperties().get("out_data").toString();
/*  94: 86 */     System.err.println("outputMimeType: " + outputMimeType);
/*  95: 87 */     String suggestedFileExtension = suggestFileExtension(outputMimeType);
/*  96: 88 */     System.err.println("suggestedFileExtension: " + suggestedFileExtension);
/*  97: 89 */     File targetFile = promptForTargetFile(sourceDatum, suggestedFileExtension);
/*  98: 91 */     if (targetFile != null) {
/*  99: 92 */       return saveData(sourceDatum, converter, targetFile);
/* 100:    */     }
/* 101: 95 */     return null;
/* 102:    */   }
/* 103:    */   
/* 104:    */   public File saveData(Data sourceDatum, Converter converter, File targetFile)
/* 105:    */     throws FileSaveException
/* 106:    */   {
/* 107:    */     try
/* 108:    */     {
/* 109:102 */       Data convertedDatum = converter.convert(sourceDatum);
/* 110:103 */       saveTo((File)convertedDatum.getData(), targetFile);
/* 111:    */       
/* 112:105 */       return targetFile;
/* 113:    */     }
/* 114:    */     catch (ConversionException e)
/* 115:    */     {
/* 116:107 */       throw new FileSaveException(e.getMessage(), e);
/* 117:    */     }
/* 118:    */   }
/* 119:    */   
/* 120:    */   public File save(File sourceFile)
/* 121:    */     throws FileSaveException
/* 122:    */   {
/* 123:112 */     File targetFile = promptForTargetFile(sourceFile);
/* 124:113 */     saveTo(sourceFile, targetFile);
/* 125:    */     
/* 126:115 */     return targetFile;
/* 127:    */   }
/* 128:    */   
/* 129:    */   public String suggestFileName(Data datum)
/* 130:    */   {
/* 131:119 */     return replaceInvalidFilenameCharacters(getLabel(datum));
/* 132:    */   }
/* 133:    */   
/* 134:    */   private static String getLabel(Data datum)
/* 135:    */   {
/* 136:123 */     Dictionary<String, Object> metadata = datum.getMetadata();
/* 137:124 */     Object labelObject = metadata.get("Label");
/* 138:126 */     if (labelObject != null) {
/* 139:127 */       return labelObject.toString();
/* 140:    */     }
/* 141:129 */     Object shortLabelObject = metadata.get("Short_Label");
/* 142:131 */     if (shortLabelObject != null) {
/* 143:132 */       return shortLabelObject.toString();
/* 144:    */     }
/* 145:134 */     return datum.toString();
/* 146:    */   }
/* 147:    */   
/* 148:    */   private static String replaceInvalidFilenameCharacters(String fileName)
/* 149:    */   {
/* 150:140 */     String cleanedFilename = fileName;
/* 151:142 */     for (Character invalidCharacter : INVALID_FILENAME_CHARACTERS) {
/* 152:143 */       cleanedFilename = 
/* 153:144 */         cleanedFilename.replace(invalidCharacter.charValue(), '#');
/* 154:    */     }
/* 155:147 */     return cleanedFilename;
/* 156:    */   }
/* 157:    */   
/* 158:    */   private static String suggestFileExtension(String targetMimeType)
/* 159:    */   {
/* 160:151 */     if (targetMimeType.startsWith("file-ext:")) {
/* 161:152 */       return targetMimeType.substring("file-ext:".length());
/* 162:    */     }
/* 163:153 */     if (targetMimeType.startsWith("file:"))
/* 164:    */     {
/* 165:154 */       int forwardSlashCharacterIndex = targetMimeType.indexOf('/');
/* 166:156 */       if (forwardSlashCharacterIndex != -1)
/* 167:    */       {
/* 168:157 */         int parsedOutFileExtensionStart = forwardSlashCharacterIndex + 1;
/* 169:159 */         if (parsedOutFileExtensionStart < targetMimeType.length()) {
/* 170:160 */           return targetMimeType.substring(parsedOutFileExtensionStart);
/* 171:    */         }
/* 172:162 */         return "";
/* 173:    */       }
/* 174:165 */       return "";
/* 175:    */     }
/* 176:168 */     return targetMimeType;
/* 177:    */   }
/* 178:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.filesaver.AbstractFileSaverService
 * JD-Core Version:    0.7.0.1
 */