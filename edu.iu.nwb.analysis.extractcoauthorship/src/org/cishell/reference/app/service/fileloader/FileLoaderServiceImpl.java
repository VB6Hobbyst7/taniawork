/*   1:    */ package org.cishell.reference.app.service.fileloader;
/*   2:    */ 
/*   3:    */ import java.io.File;
/*   4:    */ import java.io.PrintStream;
/*   5:    */ import java.io.UnsupportedEncodingException;
/*   6:    */ import java.util.ArrayList;
/*   7:    */ import java.util.Collection;
/*   8:    */ import java.util.Dictionary;
/*   9:    */ import java.util.HashSet;
/*  10:    */ import java.util.Hashtable;
/*  11:    */ import org.cishell.app.service.fileloader.FileLoadException;
/*  12:    */ import org.cishell.app.service.fileloader.FileLoadListener;
/*  13:    */ import org.cishell.app.service.fileloader.FileLoaderService;
/*  14:    */ import org.cishell.framework.CIShellContext;
/*  15:    */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  16:    */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  17:    */ import org.cishell.framework.algorithm.ProgressMonitor;
/*  18:    */ import org.cishell.framework.data.Data;
/*  19:    */ import org.eclipse.swt.widgets.Display;
/*  20:    */ import org.eclipse.ui.IWorkbench;
/*  21:    */ import org.eclipse.ui.IWorkbenchWindow;
/*  22:    */ import org.eclipse.ui.PlatformUI;
/*  23:    */ import org.osgi.framework.BundleContext;
/*  24:    */ import org.osgi.framework.InvalidSyntaxException;
/*  25:    */ import org.osgi.framework.ServiceReference;
/*  26:    */ import org.osgi.service.cm.ConfigurationException;
/*  27:    */ import org.osgi.service.cm.ManagedService;
/*  28:    */ import org.osgi.service.log.LogService;
/*  29:    */ 
/*  30:    */ public class FileLoaderServiceImpl
/*  31:    */   implements FileLoaderService, ManagedService
/*  32:    */ {
/*  33:    */   public static final String LOAD_DIRECTORY_PREFERENCE_KEY = "loadDir";
/*  34: 31 */   public static String defaultLoadDirectory = "";
/*  35: 33 */   private Dictionary preferences = new Hashtable();
/*  36: 34 */   private Collection<FileLoadListener> listeners = new HashSet();
/*  37:    */   
/*  38:    */   public void registerListener(FileLoadListener listener)
/*  39:    */   {
/*  40: 37 */     this.listeners.add(listener);
/*  41:    */   }
/*  42:    */   
/*  43:    */   public void unregisterListener(FileLoadListener listener)
/*  44:    */   {
/*  45: 41 */     if (this.listeners.contains(listener)) {
/*  46: 42 */       this.listeners.remove(listener);
/*  47:    */     }
/*  48:    */   }
/*  49:    */   
/*  50:    */   public File[] getFilesToLoadFromUser(boolean selectSingleFile, String[] filterExtensions)
/*  51:    */     throws FileLoadException
/*  52:    */   {
/*  53: 48 */     IWorkbenchWindow window = getFirstWorkbenchWindow();
/*  54: 49 */     Display display = PlatformUI.getWorkbench().getDisplay();
/*  55:    */     
/*  56: 51 */     return getFilesToLoadFromUserInternal(window, display, selectSingleFile, filterExtensions);
/*  57:    */   }
/*  58:    */   
/*  59:    */   public Data[] loadFilesFromUserSelection(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, boolean selectSingleFile)
/*  60:    */     throws FileLoadException
/*  61:    */   {
/*  62: 60 */     if ("".equals(defaultLoadDirectory)) {
/*  63: 61 */       defaultLoadDirectory = determineDefaultLoadDirectory();
/*  64:    */     }
/*  65: 64 */     File[] files = getFilesToLoadFromUser(selectSingleFile, null);
/*  66: 66 */     if (files != null) {
/*  67: 67 */       return loadFiles(bundleContext, ciShellContext, logger, progressMonitor, files);
/*  68:    */     }
/*  69: 69 */     return null;
/*  70:    */   }
/*  71:    */   
/*  72:    */   public Data[] loadFiles(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, File[] files)
/*  73:    */     throws FileLoadException
/*  74:    */   {
/*  75: 79 */     Data[] loadedFileData = 
/*  76: 80 */       loadFilesInternal(bundleContext, ciShellContext, logger, progressMonitor, files);
/*  77: 82 */     for (File file : files) {
/*  78: 83 */       for (FileLoadListener listener : this.listeners) {
/*  79: 84 */         listener.fileLoaded(file);
/*  80:    */       }
/*  81:    */     }
/*  82: 88 */     return loadedFileData;
/*  83:    */   }
/*  84:    */   
/*  85:    */   public Data[] loadFile(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, File file)
/*  86:    */     throws FileLoadException
/*  87:    */   {
/*  88: 97 */     return loadFiles(
/*  89: 98 */       bundleContext, ciShellContext, logger, progressMonitor, new File[] { file });
/*  90:    */   }
/*  91:    */   
/*  92:    */   public Data[] loadFileOfType(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, File file, String fileExtension, String mimeType)
/*  93:    */     throws FileLoadException
/*  94:    */   {
/*  95:    */     try
/*  96:    */     {
/*  97:110 */       String format = 
/*  98:111 */         "(& (type=validator)(| (in_data=file-ext:%1$s) (also_validates=%1$s))(out_data=%2$s))";
/*  99:    */       
/* 100:    */ 
/* 101:    */ 
/* 102:115 */       String validatorsQuery = String.format(format, new Object[] { fileExtension, mimeType });
/* 103:116 */       ServiceReference[] supportingValidators = bundleContext.getAllServiceReferences(
/* 104:117 */         AlgorithmFactory.class.getName(), validatorsQuery);
/* 105:119 */       if (supportingValidators == null) {
/* 106:120 */         throw new FileLoadException(String.format(
/* 107:121 */           "The file %s cannot be loaded as type %s.", new Object[] { file.getName(), mimeType }));
/* 108:    */       }
/* 109:123 */       AlgorithmFactory validator = 
/* 110:124 */         (AlgorithmFactory)bundleContext.getService(supportingValidators[0]);
/* 111:    */       
/* 112:126 */       return loadFileOfType(
/* 113:127 */         bundleContext, ciShellContext, logger, progressMonitor, file, validator);
/* 114:    */     }
/* 115:    */     catch (InvalidSyntaxException e)
/* 116:    */     {
/* 117:130 */       e.printStackTrace();
/* 118:    */       
/* 119:132 */       throw new FileLoadException(e.getMessage(), e);
/* 120:    */     }
/* 121:    */   }
/* 122:    */   
/* 123:    */   public Data[] loadFileOfType(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, File file, AlgorithmFactory validator)
/* 124:    */     throws FileLoadException
/* 125:    */   {
/* 126:    */     try
/* 127:    */     {
/* 128:144 */       Data[] loadedFileData = loadFileInternal(
/* 129:145 */         bundleContext, ciShellContext, logger, progressMonitor, file, validator);
/* 130:147 */       for (FileLoadListener listener : this.listeners) {
/* 131:148 */         listener.fileLoaded(file);
/* 132:    */       }
/* 133:151 */       return loadedFileData;
/* 134:    */     }
/* 135:    */     catch (AlgorithmExecutionException e)
/* 136:    */     {
/* 137:153 */       throw new FileLoadException(e.getMessage(), e);
/* 138:    */     }
/* 139:    */   }
/* 140:    */   
/* 141:    */   public void updated(Dictionary preferences)
/* 142:    */     throws ConfigurationException
/* 143:    */   {
/* 144:158 */     if (preferences != null) {
/* 145:159 */       this.preferences = preferences;
/* 146:    */     }
/* 147:    */   }
/* 148:    */   
/* 149:    */   private String determineDefaultLoadDirectory()
/* 150:    */   {
/* 151:164 */     if (this.preferences != null)
/* 152:    */     {
/* 153:165 */       Object directoryPreference = this.preferences.get("loadDir");
/* 154:167 */       if (directoryPreference != null) {
/* 155:168 */         return directoryPreference.toString();
/* 156:    */       }
/* 157:170 */       return "";
/* 158:    */     }
/* 159:173 */     return "";
/* 160:    */   }
/* 161:    */   
/* 162:    */   private Data[] loadFilesInternal(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, File[] files)
/* 163:    */     throws FileLoadException
/* 164:    */   {
/* 165:183 */     IWorkbenchWindow window = getFirstWorkbenchWindow();
/* 166:184 */     Display display = PlatformUI.getWorkbench().getDisplay();
/* 167:186 */     if ((files != null) && (files.length != 0))
/* 168:    */     {
/* 169:187 */       Collection<Data> finalLabeledFileData = new ArrayList();
/* 170:189 */       for (File file : files) {
/* 171:    */         try
/* 172:    */         {
/* 173:191 */           AlgorithmFactory validator = 
/* 174:192 */             getValidatorFromUser(bundleContext, window, display, file);
/* 175:    */           
/* 176:    */ 
/* 177:    */ 
/* 178:    */ 
/* 179:    */ 
/* 180:    */ 
/* 181:    */ 
/* 182:    */ 
/* 183:    */ 
/* 184:    */ 
/* 185:    */ 
/* 186:204 */           Data[] labeledFileData = loadFileInternal(
/* 187:205 */             bundleContext, 
/* 188:206 */             ciShellContext, 
/* 189:207 */             logger, 
/* 190:208 */             progressMonitor, 
/* 191:209 */             file, 
/* 192:210 */             validator);
/* 193:212 */           for (Data data : labeledFileData) {
/* 194:213 */             finalLabeledFileData.add(data);
/* 195:    */           }
/* 196:    */         }
/* 197:    */         catch (Throwable e)
/* 198:    */         {
/* 199:216 */           String format = 
/* 200:217 */             "The chosen file is not compatible with this format.  Check that your file is correctly formatted or try another validator.  The reason is: %s";
/* 201:    */           
/* 202:    */ 
/* 203:220 */           String logMessage = String.format(format, new Object[] { e.getMessage() });
/* 204:221 */           logger.log(1, logMessage, e);
/* 205:    */         }
/* 206:    */       }
/* 207:225 */       return (Data[])finalLabeledFileData.toArray(new Data[0]);
/* 208:    */     }
/* 209:227 */     return null;
/* 210:    */   }
/* 211:    */   
/* 212:    */   private Data[] loadFileInternal(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, File file, AlgorithmFactory validator)
/* 213:    */     throws AlgorithmExecutionException, FileLoadException
/* 214:    */   {
/* 215:238 */     IWorkbenchWindow window = getFirstWorkbenchWindow();
/* 216:239 */     Display display = PlatformUI.getWorkbench().getDisplay();
/* 217:240 */     Data[] validatedFileData = validateFile(
/* 218:241 */       bundleContext, 
/* 219:242 */       ciShellContext, 
/* 220:243 */       logger, 
/* 221:244 */       progressMonitor, 
/* 222:245 */       window, 
/* 223:246 */       display, 
/* 224:247 */       file, 
/* 225:248 */       validator);
/* 226:249 */     Data[] labeledFileData = labelFileData(file, validatedFileData);
/* 227:    */     
/* 228:251 */     return labeledFileData;
/* 229:    */   }
/* 230:    */   
/* 231:    */   private IWorkbenchWindow getFirstWorkbenchWindow()
/* 232:    */     throws FileLoadException
/* 233:    */   {
/* 234:255 */     IWorkbenchWindow[] windows = PlatformUI.getWorkbench().getWorkbenchWindows();
/* 235:257 */     if (windows.length == 0) {
/* 236:258 */       throw new FileLoadException(
/* 237:259 */         "Cannot obtain workbench window needed to open dialog.");
/* 238:    */     }
/* 239:261 */     return windows[0];
/* 240:    */   }
/* 241:    */   
/* 242:    */   private File[] getFilesToLoadFromUserInternal(IWorkbenchWindow window, Display display, boolean selectSingleFile, String[] filterExtensions)
/* 243:    */   {
/* 244:270 */     FileSelectorRunnable fileSelector = 
/* 245:271 */       new FileSelectorRunnable(window, selectSingleFile, filterExtensions);
/* 246:273 */     if (Thread.currentThread() != display.getThread()) {
/* 247:274 */       display.syncExec(fileSelector);
/* 248:    */     } else {
/* 249:276 */       fileSelector.run();
/* 250:    */     }
/* 251:279 */     return fileSelector.getFiles();
/* 252:    */   }
/* 253:    */   
/* 254:    */   private Data[] validateFile(BundleContext bundleContext, CIShellContext ciShellContext, LogService logger, ProgressMonitor progressMonitor, IWorkbenchWindow window, Display display, File file, AlgorithmFactory validator)
/* 255:    */     throws AlgorithmExecutionException
/* 256:    */   {
/* 257:291 */     if ((file == null) || (validator == null))
/* 258:    */     {
/* 259:292 */       String logMessage = "File loading canceled";
/* 260:293 */       logger.log(2, logMessage);
/* 261:    */     }
/* 262:    */     else
/* 263:    */     {
/* 264:    */       try
/* 265:    */       {
/* 266:296 */         System.err.println("file: " + file);
/* 267:297 */         System.err.println("validator: " + validator);
/* 268:298 */         System.err.println("progressMonitor: " + progressMonitor);
/* 269:299 */         System.err.println("ciShellContext: " + ciShellContext);
/* 270:300 */         System.err.println("logger: " + logger);
/* 271:301 */         return FileValidator.validateFile(
/* 272:302 */           file, validator, progressMonitor, ciShellContext, logger);
/* 273:    */       }
/* 274:    */       catch (AlgorithmExecutionException e)
/* 275:    */       {
/* 276:304 */         if ((e.getCause() != null) && 
/* 277:305 */           ((e.getCause() instanceof UnsupportedEncodingException)))
/* 278:    */         {
/* 279:306 */           String format = 
/* 280:307 */             "This file cannot be loaded; it uses the unsupported character encoding %s.";
/* 281:    */           
/* 282:309 */           String logMessage = String.format(format, new Object[] { e.getCause().getMessage() });
/* 283:310 */           logger.log(1, logMessage);
/* 284:    */         }
/* 285:    */         else
/* 286:    */         {
/* 287:312 */           throw e;
/* 288:    */         }
/* 289:    */       }
/* 290:    */     }
/* 291:317 */     return new Data[0];
/* 292:    */   }
/* 293:    */   
/* 294:    */   private Data[] labelFileData(File file, Data[] validatedFileData)
/* 295:    */   {
/* 296:321 */     Data[] labeledFileData = 
/* 297:322 */       PrettyLabeler.relabelWithFileNameHierarchy(validatedFileData, file);
/* 298:    */     
/* 299:324 */     return labeledFileData;
/* 300:    */   }
/* 301:    */   
/* 302:    */   private AlgorithmFactory getValidatorFromUser(BundleContext bundleContext, IWorkbenchWindow window, Display display, File file)
/* 303:    */   {
/* 304:329 */     ValidatorSelectorRunnable validatorSelector = 
/* 305:330 */       new ValidatorSelectorRunnable(window, bundleContext, file);
/* 306:332 */     if (Thread.currentThread() != display.getThread()) {
/* 307:333 */       display.syncExec(validatorSelector);
/* 308:    */     } else {
/* 309:335 */       validatorSelector.run();
/* 310:    */     }
/* 311:338 */     return validatorSelector.getValidator();
/* 312:    */   }
/* 313:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.fileloader.FileLoaderServiceImpl
 * JD-Core Version:    0.7.0.1
 */