/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*   2:    */ 
/*   3:    */ import java.util.HashMap;
/*   4:    */ import java.util.HashSet;
/*   5:    */ import java.util.Iterator;
/*   6:    */ import java.util.Properties;
/*   7:    */ import java.util.Set;
/*   8:    */ import java.util.regex.Pattern;

import javax.swing.JOptionPane;

/*   9:    */ import org.cishell.framework.algorithm.ProgressMonitor;
/*  10:    */ import org.cishell.utilities.StringUtilities;
/*  11:    */ import org.osgi.service.log.LogService;

/*  12:    */ import prefuse.data.Graph;
/*  13:    */ import prefuse.data.Node;
/*  14:    */ import prefuse.data.Schema;
/*  15:    */ import prefuse.data.Table;
/*  16:    */ import prefuse.data.column.Column;
/*  17:    */ 
/*  18:    */ public class GraphContainer
/*  19:    */ {
/*  20:    */   public static final String TARGET_COLUMN_NAME = "target";
/*  21:    */   public static final String SOURCE_COLUMN_NAME = "source";
/*  22:    */   public static final String LABEL_COLUMN_NAME = "label";
/*  23:    */   private Graph graph;
/*  24:    */   private Table table;
/*  25:    */   private AggregateFunctionMappings nodeFunctionMap;
/*  26:    */   private AggregateFunctionMappings edgeFunctionMap;
/*  27: 31 */   private ProgressMonitor progressMonitor = null;
/*  28:    */   
/*  29:    */   public GraphContainer(Graph graph, Table table, AggregateFunctionMappings nodeFunctionMap, AggregateFunctionMappings edgeFunctionMap, ProgressMonitor progressMonitor)
/*  30:    */   {
/*  31: 35 */     this.graph = graph;
/*  32: 36 */     this.table = table;
/*  33: 37 */     this.nodeFunctionMap = nodeFunctionMap;
/*  34: 38 */     this.edgeFunctionMap = edgeFunctionMap;
/*  35: 39 */     this.progressMonitor = progressMonitor;
/*  36:    */   }
/*  37:    */   
/*  38:    */   public Graph buildGraph(String sourceColumnName, String targetColumnName, String delimiter, boolean requestBipartite, LogService log)
/*  39:    */   {
/*  40: 48 */     String[] targetColumnNames = targetColumnName.split("\\,");
/*  41: 50 */     if (this.graph.isDirected()) {
/*  42: 51 */       return buildDirectedGraph(
/*  43: 52 */         sourceColumnName, targetColumnNames, delimiter, requestBipartite, log);
/*  44:    */     }
/*  45: 54 */     return buildUndirectedGraph(targetColumnNames, delimiter, log);
/*  46:    */   }
/*  47:    */   
/*  48:    */   private Graph buildUndirectedGraph(String[] targetColumnNames, String delimiter, LogService log)
/*  49:    */   {
/*  50: 59 */     boolean duplicateValues = false;
/*  51: 60 */     HashMap dupValuesErrorMessages = new HashMap();
/*  52: 61 */     int numTotalRows = this.table.getRowCount();
/*  53: 62 */     int numRowsProcessedSoFar = 0;
/*  54:    */     
/*  55: 64 */     NodeMaintainer nodeMaintainer = new NodeMaintainer();
/*  56: 66 */     if (this.progressMonitor != null) {
/*  57: 67 */       this.progressMonitor.start(2, numTotalRows);
/*  58:    */     }
/*  59: 70 */     int recordsWithSkippedColumns = 0;
/*  60: 71 */     for (Iterator rowIt = this.table.rows(); rowIt.hasNext();)
/*  61:    */     {
/*  62: 72 */       boolean rowHasSkippedColumns = false;
/*  63: 73 */       int row = ((Integer)rowIt.next()).intValue();
/*  64:    */       
/*  65: 75 */       Node node1 = null;
/*  66: 76 */       Node node2 = null;
/*  67:    */       
/*  68: 78 */       String targetString = 
/*  69: 79 */         buildRowTargetStringFromColumnNames(row, targetColumnNames, this.table, delimiter);
//JOptionPane.showMessageDialog(null, "My Goodness, this is so concise2");
/*  70:    */      // log.log(1, "Howdie 2");
/*  71: 81 */       Set seenObject = new HashSet();
/*  72: 83 */       if (targetString != null)
/*  73:    */       {
/*  74: 84 */         Pattern splitPattern = Pattern.compile("\\Q" + delimiter + "\\E");
/*  75: 85 */         String[] splitTargetStringArray = 
/*  76: 86 */           splitIfDelimiterIsValid(targetString, delimiter, splitPattern);
/*  77: 89 */         for (int ii = 0; ii < splitTargetStringArray.length; ii++) {
/*  78: 90 */           splitTargetStringArray[ii] = normalizeLabel(splitTargetStringArray[ii]);
/*  79:    */         }
/*  80: 93 */         for (int ii = splitTargetStringArray.length - 1; ii >= 0; ii--) {
/*  81: 94 */           if (!"".equals(splitTargetStringArray[ii]))
/*  82:    */           {
/*  83: 98 */             if (seenObject.add(splitTargetStringArray[ii]))
/*  84:    */             {
/*  85:101 */               node1 = nodeMaintainer.mutateNode(
/*  86:102 */                 splitTargetStringArray[ii], 
/*  87:103 */                 null, 
/*  88:104 */                 this.graph, 
/*  89:105 */                 this.table, 
/*  90:106 */                 row, 
/*  91:107 */                 this.nodeFunctionMap, 
/*  92:108 */                 0);
/*  93:109 */               if (nodeMaintainer.hasSkippedColumns)
/*  94:    */               {
/*  95:110 */                 rowHasSkippedColumns = true;
/*  96:111 */                 nodeMaintainer.hasSkippedColumns = false;
/*  97:    */               }
/*  98:    */             }
/*  99:115 */             node1 = this.graph.getNode(this.nodeFunctionMap.getFunctionRow(
/* 100:116 */               new NodeID(splitTargetStringArray[ii], null)).getRowNumber());
/* 101:118 */             for (int jj = 0; jj < ii; jj++) {
/* 102:119 */               if (!"".equals(splitTargetStringArray[jj])) {
/* 103:123 */                 if (!splitTargetStringArray[jj].equals(splitTargetStringArray[ii]))
/* 104:    */                 {
/* 105:124 */                   if (seenObject.add(splitTargetStringArray[jj])) {
/* 106:127 */                     node2 = nodeMaintainer.mutateNode(
/* 107:128 */                       splitTargetStringArray[jj], 
/* 108:129 */                       null, 
/* 109:130 */                       this.graph, 
/* 110:131 */                       this.table, 
/* 111:132 */                       row, 
/* 112:133 */                       this.nodeFunctionMap, 
/* 113:134 */                       0);
/* 114:    */                   }
/* 115:138 */                   node2 = this.graph.getNode(this.nodeFunctionMap.getFunctionRow(
/* 116:139 */                     new NodeID(splitTargetStringArray[jj], null)).getRowNumber());
/* 117:140 */                   EdgeContainer edgeContainer = new EdgeContainer();
/* 118:141 */                   edgeContainer.mutateEdge(
/* 119:142 */                     node1, node2, this.graph, this.table, row, this.edgeFunctionMap);
/* 120:143 */                   if (edgeContainer.hasSkippedColumns)
/* 121:    */                   {
/* 122:144 */                     rowHasSkippedColumns = true;
/* 123:145 */                     edgeContainer.hasSkippedColumns = false;
/* 124:    */                   }
/* 125:    */                 }
/* 126:    */                 else
/* 127:    */                 {
/* 128:148 */                   duplicateValues = true;
/* 129:    */                 }
/* 130:    */               }
/* 131:    */             }
/* 132:    */           }
/* 133:    */         }
/* 134:    */       }
/* 135:168 */       numRowsProcessedSoFar++;
/* 136:170 */       if (this.progressMonitor != null) {
/* 137:171 */         this.progressMonitor.worked(numRowsProcessedSoFar);
/* 138:    */       }
/* 139:173 */       if (rowHasSkippedColumns) {
/* 140:174 */         recordsWithSkippedColumns++;
/* 141:    */       }
/* 142:    */     }
/* 143:178 */     for (Iterator dupIter = dupValuesErrorMessages.keySet().iterator(); dupIter.hasNext();) {
/* 144:179 */       log.log(2, (String)dupValuesErrorMessages.get(dupIter.next()));
/* 145:    */     }
/* 146:182 */     if (recordsWithSkippedColumns > 0) {
/* 147:183 */       log.log(2, recordsWithSkippedColumns + " records had empty values or parsing issues and were skipped.");
/* 148:    */     }
/* 149:186 */     return this.graph;
/* 150:    */   }
/* 151:    */   
/* 152:    */   private static String normalizeLabel(String label)
/* 153:    */   {
/* 154:190 */     String[] parts = label.trim().split("\\s+");
/* 155:191 */     for (int ii = 0; ii < parts.length; ii++) {
/* 156:192 */       parts[ii] = capitalize(parts[ii]);
/* 157:    */     }
/* 158:194 */     return StringUtilities.implodeStringArray(parts, " ");
/* 159:    */   }
/* 160:    */   
/* 161:    */   private static String capitalize(String s)
/* 162:    */   {
/* 163:198 */     if (s.length() <= 1) {
/* 164:199 */       return s.toUpperCase();
/* 165:    */     }
/* 166:201 */     return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
/* 167:    */   }
/* 168:    */   
/* 169:    */   private Graph buildDirectedGraph(String sourceColumnName, String[] targetColumnNames, String delimiter, boolean requestBipartite, LogService log)
/* 170:    */   {
/* 171:210 */     Pattern splitPattern = Pattern.compile("\\Q" + delimiter + "\\E");
/* 172:211 */     HashMap dupValuesErrorMessages = new HashMap();
/* 173:212 */     Column sourceColumn = this.table.getColumn(sourceColumnName);
/* 174:    */     
/* 175:214 */     NodeMaintainer nodeMaintainer = new NodeMaintainer();
/* 176:    */     
/* 177:216 */     String sourceBipartiteType = null;
/* 178:217 */     String targetBipartiteType = null;
/* 179:219 */     if (requestBipartite)
/* 180:    */     {
/* 181:220 */       sourceBipartiteType = sourceColumnName;
/* 182:221 */       targetBipartiteType = separate(targetColumnNames, " OR ");
/* 183:    */     }
/* 184:224 */     int numTotalRows = this.table.getRowCount();
/* 185:225 */     int numRowsProcessedSoFar = 0;
/* 186:227 */     if (this.progressMonitor != null) {
/* 187:228 */       this.progressMonitor.start(2, numTotalRows);
/* 188:    */     }
/* 189:231 */     int recordsWithSkippedColumns = 0;
/* 190:232 */     for (Iterator rows = this.table.rows(); rows.hasNext();)
/* 191:    */     {
/* 192:233 */       boolean rowHasSkippedColumns = false;
/* 193:234 */       int row = ((Integer)rows.next()).intValue();
/* 194:    */       
/* 195:236 */       String sourceString = sourceColumn.getString(row);
/* 196:237 */       String targetString = 
/* 197:238 */         buildRowTargetStringFromColumnNames(row, targetColumnNames, this.table, delimiter);
//JOptionPane.showMessageDialog(null, "My Goodness, this is so concise1");
//log.log(1, "Howdie 1");
/* 198:240 */       if ((sourceString != null) && (targetString != null))
/* 199:    */       {
/* 200:242 */         String[] sources = 
/* 201:243 */           splitIfDelimiterIsValid(sourceString, delimiter, splitPattern);
/* 202:244 */         Set cleanSourceNames = clean(sources);
/* 203:245 */         String[] targets = 
/* 204:246 */           splitIfDelimiterIsValid(targetString, delimiter, splitPattern);
/* 205:247 */         Set cleanTargetNames = clean(targets);
/* 206:    */         
/* 207:    */ 
/* 208:250 */         Set updatedSources = updateNodes(nodeMaintainer, row, 
/* 209:251 */           cleanSourceNames, sourceBipartiteType, 
/* 210:252 */           1);
/* 211:253 */         if (nodeMaintainer.hasSkippedColumns)
/* 212:    */         {
/* 213:254 */           rowHasSkippedColumns = true;
/* 214:255 */           nodeMaintainer.hasSkippedColumns = false;
/* 215:    */         }
/* 216:258 */         Set updatedTargets = updateNodes(nodeMaintainer, row, 
/* 217:259 */           cleanTargetNames, targetBipartiteType, 
/* 218:260 */           2);
/* 219:261 */         if (nodeMaintainer.hasSkippedColumns)
/* 220:    */         {
/* 221:262 */           rowHasSkippedColumns = true;
/* 222:263 */           nodeMaintainer.hasSkippedColumns = false;
/* 223:    */         }
/* 224:    */         Iterator updatedTargetsIt;
/* 225:267 */         for (Iterator updatedSourcesIt = updatedSources.iterator(); 
/* 226:268 */               updatedSourcesIt.hasNext(); 
/* 227:272 */               updatedTargetsIt.hasNext())
/* 228:    */         {
/* 229:269 */           Node updatedSource = (Node)updatedSourcesIt.next();
/* 230:    */           
/* 231:271 */           updatedTargetsIt = updatedTargets.iterator();
/* 232:272 */           continue;
/* 233:273 */          //Node updatedTarget = (Node)updatedTargetsIt.next();
/* 234:    */           
/* 235:275 */          // EdgeContainer edgeContainer = new EdgeContainer();
/* 236:276 */          // edgeContainer.mutateEdge(updatedSource, updatedTarget, this.graph, this.table, row, 
/* 237:277 */           //  this.edgeFunctionMap);
/* 238:278 */          // if (edgeContainer.hasSkippedColumns)
/* 239:    */          // {
/* 240:279 */           //  rowHasSkippedColumns = true;
/* 241:280 */           //  edgeContainer.hasSkippedColumns = false;
/* 242:    */          // }
/* 243:    */         }
/* 244:    */       }
/* 245:286 */       numRowsProcessedSoFar++;
/* 246:288 */       if (this.progressMonitor != null) {
/* 247:289 */         this.progressMonitor.worked(numRowsProcessedSoFar);
/* 248:    */       }
/* 249:291 */       if (rowHasSkippedColumns) {
/* 250:292 */         recordsWithSkippedColumns++;
/* 251:    */       }
/* 252:    */     }
/* 253:296 */     for (Iterator dupIter = dupValuesErrorMessages.keySet().iterator(); dupIter.hasNext();) {
/* 254:297 */       log.log(2, (String)dupValuesErrorMessages.get(dupIter.next()));
/* 255:    */     }
/* 256:300 */     if (recordsWithSkippedColumns > 0) {
/* 257:301 */       log.log(2, recordsWithSkippedColumns + " records had empty values and were skipped.");
/* 258:    */     }
/* 259:304 */     return this.graph;
/* 260:    */   }
/* 261:    */   
/* 262:    */   private static String separate(Object[] array, String delimiter)
/* 263:    */   {
/* 264:308 */     StringBuffer buffer = new StringBuffer();
/* 265:310 */     if (array.length > 0)
/* 266:    */     {
/* 267:311 */       buffer.append(array[0]);
/* 268:313 */       for (int ii = 1; ii < array.length; ii++)
/* 269:    */       {
/* 270:314 */         buffer.append(delimiter);
/* 271:315 */         buffer.append(array[ii]);
/* 272:    */       }
/* 273:    */     }
/* 274:319 */     return buffer.toString();
/* 275:    */   }
/* 276:    */   
/* 277:    */   private Set updateNodes(NodeMaintainer nodeMaintainer, int rowIndex, Set cleanNames, String bipartiteType, int aggregateFunctionMappingType)
/* 278:    */   {
/* 279:324 */     Set updatedNodes = new HashSet();
/* 280:326 */     for (Iterator cleanNamesIt = cleanNames.iterator(); cleanNamesIt.hasNext();)
/* 281:    */     {
/* 282:327 */       String cleanName = (String)cleanNamesIt.next();
/* 283:    */       
/* 284:329 */       Node updatedNode = nodeMaintainer.mutateNode(cleanName, bipartiteType, 
/* 285:330 */         this.graph, this.table, rowIndex, this.nodeFunctionMap, aggregateFunctionMappingType);
/* 286:    */       
/* 287:332 */       updatedNodes.add(updatedNode);
/* 288:    */     }
/* 289:335 */     return updatedNodes;
/* 290:    */   }
/* 291:    */   
/* 292:    */   private static Set clean(String[] strings)
/* 293:    */   {
/* 294:340 */     Set cleanedStrings = new HashSet();
/* 295:342 */     for (int ii = 0; ii < strings.length; ii++)
/* 296:    */     {
/* 297:343 */       String rawString = strings[ii];
/* 298:344 */       String trimmedString = normalizeLabel(rawString);
/* 299:346 */       if (!"".equals(trimmedString)) {
/* 300:347 */         cleanedStrings.add(trimmedString);
/* 301:    */       }
/* 302:    */     }
/* 303:351 */     return cleanedStrings;
/* 304:    */   }
/* 305:    */   
/* 306:    */   public static GraphContainer initializeGraph(Table inputTable, String sourceColumnName, String targetColumnName, boolean isDirected, Properties properties, LogService log)
/* 307:    */     throws InvalidColumnNameException, GraphContainer.PropertyParsingException
/* 308:    */   {
				log.log(1,"newtest2");
/* 309:357 */     return initializeGraph(inputTable, sourceColumnName, targetColumnName, isDirected, properties, log, 
/* 310:358 */       null);
/* 311:    */   }
/* 312:    */   
/* 313:    */   public static GraphContainer initializeGraph(Table inputTable, String sourceColumnName, String targetColumnName, boolean isDirected, Properties properties, LogService log, ProgressMonitor progressMonitor)  throws InvalidColumnNameException, GraphContainer.PropertyParsingException
/* 315:    */   {
					log.log(1,"newtest1");
					//JOptionPane.showMessageDialog(null, "test 11");
/* 316:364 */     Schema inputSchema = inputTable.getSchema();
/* 317:366 */     if (inputSchema.getColumnIndex(sourceColumnName) < 0) {
	JOptionPane.showMessageDialog(null, "ERROR 3");
/* 318:367 */       throw new InvalidColumnNameException(sourceColumnName + 
/* 319:368 */         " was not a column in this table.\n");
/* 320:    */     }
/* 321:372 */     String[] targetColumnNameArray = targetColumnName.split("\\,");
/* 322:376 */     if ((targetColumnNameArray == null) || (targetColumnNameArray.length == 0)) {
	JOptionPane.showMessageDialog(null, "ERROR 4");
/* 323:377 */       throw new InvalidColumnNameException(targetColumnName + 
/* 324:378 */         " was not a column in this table.\n");
/* 325:    */     }
/* 326:381 */     for (String columnName : targetColumnNameArray) {
/* 327:382 */       if (inputSchema.getColumnIndex(columnName) < 0) {
	JOptionPane.showMessageDialog(null, "ERROR 5");
/* 328:383 */         throw new InvalidColumnNameException(columnName + 
/* 329:384 */           " was not a column in this table.\n");
/* 330:    */       }
/* 331:    */     }
/* 332:389 */     Schema nodeSchema = createNodeSchema();
/* 333:390 */     Schema edgeSchema = createEdgeSchema();
/* 334:    */     
/* 335:392 */     AggregateFunctionMappings nodeAggregateFunctionMap = new AggregateFunctionMappings();
/* 336:393 */     AggregateFunctionMappings edgeAggregateFunctionMap = new AggregateFunctionMappings();
/* 337:    */     try
/* 338:    */     {
/* 339:396 */       AggregateFunctionMappings.parseProperties(inputSchema, nodeSchema, 
/* 340:397 */         edgeSchema, properties, nodeAggregateFunctionMap, 
/* 341:398 */         edgeAggregateFunctionMap, log);
/* 342:    */     }
/* 343:    */     catch (AggregateFunctionMappings.CompatibleAggregationNotFoundException e)
/* 344:    */     {
	JOptionPane.showMessageDialog(null, "ERROR 6");
/* 345:400 */       throw new PropertyParsingException(e);
/* 346:    */     }
/* 347:403 */     if (isPerformingCooccurrenceExtraction(sourceColumnName, targetColumnName)) {
/* 348:411 */       if (edgeSchema.getColumnIndex("weight") == -1) {
/* 349:    */         try
/* 350:    */         {
/* 351:413 */           AggregateFunctionMappings.addDefaultEdgeWeightColumn(inputSchema, edgeSchema, 
/* 352:414 */             edgeAggregateFunctionMap, sourceColumnName);
/* 353:    */         }
/* 354:    */         catch (AggregateFunctionMappings.CompatibleAggregationNotFoundException e)
/* 355:    */         {
	JOptionPane.showMessageDialog(null, "ERROR 7");
/* 356:416 */           throw new PropertyParsingException(e);
/* 357:    */         }
/* 358:    */       }
/* 359:    */     }
/* 360:421 */     Graph outputGraph = new Graph(nodeSchema.instantiate(), edgeSchema.instantiate(), 
/* 361:422 */       isDirected);
/* 362:    */     
/* 363:424 */     return new GraphContainer(outputGraph, inputTable, nodeAggregateFunctionMap, 
/* 364:425 */       edgeAggregateFunctionMap, progressMonitor);
/* 365:    */   }
/* 366:    */   
/* 367:    */   private static boolean isPerformingCooccurrenceExtraction(String sourceColumnName, String targetColumnName)
/* 368:    */   {
/* 369:431 */     return sourceColumnName.equals(targetColumnName);
/* 370:    */   }
/* 371:    */   
/* 372:    */   private static Schema createNodeSchema()
/* 373:    */   {
/* 374:435 */     Schema nodeSchema = new Schema();
/* 375:436 */     nodeSchema.addColumn("label", String.class);
/* 376:    */     
/* 377:438 */     return nodeSchema;
/* 378:    */   }
/* 379:    */   
/* 380:    */   private static Schema createEdgeSchema()
/* 381:    */   {
/* 382:442 */     Schema edgeSchema = new Schema();
/* 383:443 */     edgeSchema.addColumn("source", Integer.TYPE);
/* 384:444 */     edgeSchema.addColumn("target", Integer.TYPE);
/* 385:445 */     return edgeSchema;
/* 386:    */   }
/* 387:    */   
/* 388:    */   private static String buildRowTargetStringFromColumnNames(int row, String[] targetColumnNames, Table table, String delimiter)
/* 389:    */   {
/* 390:450 */     String targetString = "";
/* 391:    */     
/* 392:    */ 
/* 393:    */ 
/* 394:454 */     Column targetColumn = table.getColumn(targetColumnNames[0]);
/* 395:455 */     targetString = targetString + targetColumn.getString(row);
/* 396:457 */     for (int iColumn = 1; iColumn < targetColumnNames.length; iColumn++)
/* 397:    */     {
/* 398:458 */       targetColumn = table.getColumn(targetColumnNames[iColumn]);
/* 399:459 */       targetString = targetString + delimiter;
/* 400:460 */       targetString = targetString + targetColumn.getString(row);
/* 401:    */     }
/* 399:459 */     //  targetString = targetString + delimiter;
/* 400:460 */      // targetString = targetString + "TESTO";
/* 402:463 */     return targetString;
/* 403:    */   }
/* 404:    */   
/* 405:    */   private static String[] splitIfDelimiterIsValid(String toSplit, String delimiter, Pattern splitPattern)
/* 406:    */   {
/* 407:468 */     if (!StringUtilities.isNull_Empty_OrWhitespace(delimiter)) {
/* 408:469 */       return splitPattern.split(toSplit);
/* 409:    */     }
/* 410:471 */     return new String[] { toSplit };
/* 411:    */   }
/* 412:    */   
/* 413:    */   public static class PropertyParsingException
/* 414:    */     extends Exception
/* 415:    */   {
/* 416:    */     private static final long serialVersionUID = 814116449021611862L;
/* 417:    */     
/* 418:    */     public PropertyParsingException() {}
/* 419:    */     
/* 420:    */     public PropertyParsingException(String message)
/* 421:    */     {
/* 422:491 */       super();
/* 423:    */     }
/* 424:    */     
/* 425:    */     public PropertyParsingException(Throwable cause)
/* 426:    */     {
/* 427:498 */       super();
/* 428:    */     }
/* 429:    */     
/* 430:    */     public PropertyParsingException(String message, Throwable cause)
/* 431:    */     {
/* 432:505 */       super(cause);
/* 433:    */     }
/* 434:    */   }
/* 435:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.GraphContainer
 * JD-Core Version:    0.7.0.1
 */