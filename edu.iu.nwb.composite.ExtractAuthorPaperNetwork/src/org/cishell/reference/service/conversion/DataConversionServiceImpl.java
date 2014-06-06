/*   1:    */ package org.cishell.reference.service.conversion;
/*   2:    */ 
/*   3:    */ import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
/*   4:    */ import com.google.common.collect.Sets;

/*   5:    */ import edu.uci.ics.jung.algorithms.shortestpath.DijkstraShortestPath;
/*   6:    */ import edu.uci.ics.jung.graph.Edge;
/*   7:    */ import edu.uci.ics.jung.graph.Graph;
/*   8:    */ import edu.uci.ics.jung.graph.Vertex;
/*   9:    */ import edu.uci.ics.jung.graph.impl.DirectedSparseEdge;
/*  10:    */ import edu.uci.ics.jung.graph.impl.DirectedSparseGraph;
/*  11:    */ import edu.uci.ics.jung.graph.impl.SparseVertex;
/*  12:    */ import edu.uci.ics.jung.io.GraphMLFile;
import edu.uci.ics.jung.utils.UserDataContainer;
/*  13:    */ import edu.uci.ics.jung.utils.UserDataContainer.CopyAction.Shared;

/*  14:    */ import java.io.File;
/*  15:    */ import java.util.AbstractList;
/*  16:    */ import java.util.ArrayList;
/*  17:    */ import java.util.Arrays;
/*  18:    */ import java.util.Collection;
/*  19:    */ import java.util.Dictionary;
/*  20:    */ import java.util.HashMap;
/*  21:    */ import java.util.HashSet;
/*  22:    */ import java.util.Iterator;
/*  23:    */ import java.util.List;
/*  24:    */ import java.util.Map;
/*  25:    */ import java.util.Set;
/*  26:    */ import java.util.regex.Pattern;

/*  27:    */ import org.cishell.framework.CIShellContext;
/*  28:    */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  29:    */ import org.cishell.framework.algorithm.AlgorithmProperty;
/*  30:    */ import org.cishell.framework.data.Data;
/*  31:    */ import org.cishell.service.conversion.ConversionException;
/*  32:    */ import org.cishell.service.conversion.Converter;
/*  33:    */ import org.cishell.service.conversion.DataConversionService;
/*  34:    */ import org.osgi.framework.BundleContext;
/*  35:    */ import org.osgi.framework.InvalidSyntaxException;
/*  36:    */ import org.osgi.framework.ServiceEvent;
/*  37:    */ import org.osgi.framework.ServiceListener;
/*  38:    */ import org.osgi.framework.ServiceReference;
/*  39:    */ import org.osgi.service.log.LogService;
/*  40:    */ 
/*  41:    */ public class DataConversionServiceImpl
/*  42:    */   implements DataConversionService, AlgorithmProperty, ServiceListener
/*  43:    */ {
/*  44:    */   public static final String SERVICE_LIST = "SERVICE_LIST";
/*  45:    */   private BundleContext bContext;
/*  46:    */   private CIShellContext ciContext;
/*  47:    */   private Map<String, Vertex> dataTypeToVertex;
/*  48:    */   private Graph graph;
/*  49:    */   
/*  50:    */   public DataConversionServiceImpl(BundleContext bContext, CIShellContext ciContext)
/*  51:    */   {
/*  52: 80 */     this.bContext = bContext;
/*  53: 81 */     this.ciContext = ciContext;
/*  54:    */     
/*  55: 83 */     this.graph = new DirectedSparseGraph();
/*  56: 84 */     this.dataTypeToVertex = new HashMap();
/*  57:    */     
/*  58: 86 */     String filter = "(&(type=converter)(in_data=*) (out_data=*)(!(remote=*))(!(in_data=file-ext:*))(!(out_data=file-ext:*)))";
/*  59:    */     try
/*  60:    */     {
/*  61: 94 */       this.bContext.addServiceListener(this, filter);
/*  62:    */     }
/*  63:    */     catch (InvalidSyntaxException e)
/*  64:    */     {
/*  65: 96 */       e.printStackTrace();
/*  66:    */     }
/*  67: 98 */     assembleGraph();
/*  68:    */   }
/*  69:    */   
/*  70:    */   private void assembleGraph()
/*  71:    */   {
/*  72:    */     try
/*  73:    */     {
/*  74:106 */       String filter = "(&(type=converter)(in_data=*) (out_data=*)(!(remote=*))(!(in_data=file-ext:*))(!(out_data=file-ext:*)))";
/*  75:    */       
/*  76:    */ 
/*  77:    */ 
/*  78:    */ 
/*  79:    */ 
/*  80:    */ 
/*  81:113 */       Collection<ServiceReference<AlgorithmFactory>> refs = getAFServiceReferences(filter);
/*  82:115 */       if (refs != null) {
/*  83:116 */         for (ServiceReference<AlgorithmFactory> ref : refs)
/*  84:    */         {
/*  85:117 */           String inData = (String)ref
/*  86:118 */             .getProperty("in_data");
/*  87:119 */           String outData = (String)ref
/*  88:120 */             .getProperty("out_data");
/*  89:    */           
/*  90:122 */           addServiceReference(inData, outData, ref);
/*  91:    */         }
/*  92:    */       }
/*  93:    */     }
/*  94:    */     catch (InvalidSyntaxException e)
/*  95:    */     {
/*  96:126 */       throw new RuntimeException(e);
/*  97:    */     }
/*  98:    */   }
/*  99:    */   
/* 100:    */   public Converter[] findConverters(String inFormat, String outFormat)
/* 101:    */   {
/* 102:138 */     if ((inFormat != null) && (inFormat.length() > 0) && 
/* 103:139 */       (outFormat != null) && (outFormat.length() > 0))
/* 104:    */     {
/* 105:141 */       ConverterImpl[] converters = null;
/* 106:143 */       if (outFormat.startsWith("file-ext:"))
/* 107:    */       {
/* 108:144 */         converters = getConvertersByWildcard(inFormat, "file:*");
/* 109:145 */         converters = connectValidator(converters, outFormat);
/* 110:    */       }
/* 111:    */       else
/* 112:    */       {
/* 113:147 */         converters = getConvertersByWildcard(inFormat, outFormat);
/* 114:    */       }
/* 115:150 */       return converters;
/* 116:    */     }
/* 117:152 */     return new Converter[0];
/* 118:    */   }
/* 119:    */   
/* 120:    */   private ConverterImpl[] connectValidator(ConverterImpl[] converters, String outFormat)
/* 121:    */   {
/* 122:165 */     Collection<ConverterImpl> newConverters = Sets.newHashSet();
/* 123:    */     
/* 124:167 */     Set<String> formats = Sets.newHashSet();
/* 125:168 */     for (int i = 0; i < converters.length; i++)
/* 126:    */     {
/* 127:169 */       String format = (String)converters[i].getProperties().get("out_data");
/* 128:171 */       if (!formats.contains(format))
/* 129:    */       {
/* 130:172 */         String filter = "(&(type=validator)(!(remote=*))(in_data=" + 
/* 131:    */         
/* 132:174 */           format + ")" + 
/* 133:175 */           "(" + "out_data" + "=" + outFormat + "))";
/* 134:    */         try
/* 135:    */         {
/* 136:178 */           Collection<ServiceReference<AlgorithmFactory>> refs = 
/* 137:179 */             getAFServiceReferences(filter);
/* 138:181 */           if ((refs != null) && (refs.size() > 0))
/* 139:    */           {
/* 140:182 */             for (ServiceReference<AlgorithmFactory> ref : refs)
/* 141:    */             {
/* 142:183 */               ArrayList<Object> chain = 
/* 143:184 */                 Lists.newArrayList(converters[i].getConverterList());
/* 144:185 */               chain.add(ref);
/* 145:    */               
/* 146:187 */               newConverters.add(ConverterImpl.createConverter(this.bContext, this.ciContext,  chain));
/* 148:    */             }
/* 149:191 */             formats.add(format);
/* 150:    */           }
/* 151:    */         }
/* 152:    */         catch (InvalidSyntaxException e)
/* 153:    */         {
/* 154:194 */           e.printStackTrace();
/* 155:    */         }
/* 156:    */       }
/* 157:    */     }
/* 158:199 */     return (ConverterImpl[])newConverters.toArray(new ConverterImpl[0]);
/* 159:    */   }
/* 160:    */   
/* 161:    */   private Collection<ServiceReference<AlgorithmFactory>> getAFServiceReferences(String filter)
/* 162:    */     throws InvalidSyntaxException
/* 163:    */   {
/* 164:203 */     List<ServiceReference<AlgorithmFactory>> refList = Lists.newArrayList();
/* 165:    */     
/* 166:    */ 
/* 167:    */ 
/* 168:    */ 
/* 169:    */ 
/* 170:    */ 
/* 171:210 */     ServiceReference[] refArray = 
/* 172:211 */       this.bContext.getServiceReferences(
/* 173:212 */       AlgorithmFactory.class.getName(), 
/* 174:213 */       filter);
/* 175:215 */     if ((refArray != null) && (refArray.length > 0)) {
/* 176:216 */       refList.addAll((Collection<? extends ServiceReference<AlgorithmFactory>>) Arrays.asList(refArray));
/* 177:    */     }
/* 178:219 */     return refList;
/* 179:    */   }
/* 180:    */   
/* 181:    */   private Set<String> resolveDataWildcard(String formatString, String algorithmProperty)
/* 182:    */   {
/* 183:230 */     Set<String> expansions = new HashSet();
/* 184:231 */     if (!formatString.contains("*"))
/* 185:    */     {
/* 186:232 */       expansions.add(formatString);
/* 187:233 */       return expansions;
/* 188:    */     }
/* 189:    */     String algorithmFilter;
/* 190:237 */     if (algorithmProperty.equals("in_data"))
/* 191:    */     {
/* 192:238 */       algorithmFilter = createConverterFilterForInFormat(formatString);
/* 193:    */     }
/* 194:    */     else
/* 195:    */     {
/* 196:    */       String algorithmFilter1;
/* 197:239 */       if (algorithmProperty.equals("out_data")) {
/* 198:240 */         algorithmFilter1 = createConverterFilterForOutFormat(formatString);
/* 199:    */       } else {
/* 200:242 */         throw new IllegalArgumentException(String.format(
/* 201:243 */           "Got algorithm property %s, expected one of AlgorithmProperty.{IN,OUT}_DATA", new Object[] {
/* 202:244 */           algorithmProperty }));
/* 203:    */       }
/* 204:    */     }
/* 205:    */     try
/* 206:    */     {
/* 207:    */       String algorithmFilter1 = null;
/* 208:249 */       Collection<ServiceReference<AlgorithmFactory>> matches = 
/* 209:250 */         getAFServiceReferences(algorithmFilter1);
/* 210:251 */       for (ServiceReference<AlgorithmFactory> match : matches) {
/* 211:252 */         expansions.add((String)match.getProperty(algorithmProperty));
/* 212:    */       }
/* 213:    */     }
/* 214:    */     catch (InvalidSyntaxException e)
/* 215:    */     {
/* 216:255 */       getLogger().log(2, String.format("Error while looking for %s: %s", new Object[] { formatString, e.getMessage() }));
/* 217:    */     }
/* 218:259 */     return expansions;
/* 219:    */   }
/* 220:    */   
/* 221:    */   private LogService getLogger()
/* 222:    */   {
/* 223:263 */     return (LogService)this.ciContext.getService(LogService.class.getName());
/* 224:    */   }
/* 225:    */   
/* 226:    */   private ConverterImpl[] getConvertersByWildcard(String inFormat, String outFormat)
/* 227:    */   {
/* 228:274 */     Set<String> matchingInFileTypes = resolveDataWildcard(inFormat, "in_data");
/* 229:275 */     Set<String> matchingOutFileTypes = resolveDataWildcard(outFormat, "out_data");
/* 230:276 */     Set<ConverterImpl> possibleConverters = new HashSet();
/* 231:281 */     if (outFormat.contains("*"))
/* 232:    */     {
/* 233:282 */       String outFormatRegex = outFormat.replaceAll("[*]", ".*");
/* 234:283 */       if (Pattern.matches(outFormatRegex, inFormat)) {
/* 235:284 */         possibleConverters.add(ConverterImpl.createNoOpConverter(this.bContext, this.ciContext, inFormat));
/* 236:    */       }
/* 237:    */     }
/* 238:    */     Iterator localIterator2;
/* 239:288 */     for (Iterator localIterator1 = matchingInFileTypes.iterator(); localIterator1.hasNext(); localIterator2.hasNext())
/* 240:    */     {
/* 241:288 */       String srcDataType = (String)localIterator1.next();
/* 242:289 */       localIterator2 = matchingOutFileTypes.iterator(); continue;     }
/* 249:297 */     return (ConverterImpl[])possibleConverters.toArray(new ConverterImpl[0]);
/* 250:    */   }
/* 251:    */   
/* 252:    */   private String createConverterFilterForOutFormat(String outFormat)
/* 253:    */   {
/* 254:301 */     String outFilter = "(&(type=converter)(in_data=*) (out_data=" + 
/* 255:302 */       outFormat + ")" + 
/* 256:303 */       "(!(" + "remote" + "=*)))";
/* 257:304 */     return outFilter;
/* 258:    */   }
/* 259:    */   
/* 260:    */   private String createConverterFilterForInFormat(String inFormat)
/* 261:    */   {
/* 262:308 */     String inFilter = "(&(type=converter)(in_data=" + 
/* 263:309 */       inFormat + ") " + "(" + "out_data" + "=*)" + 
/* 264:310 */       "(!(" + "in_data" + "=file-ext:*))" + "(!(" + "remote" + "=*)))";
/* 265:311 */     return inFilter;
/* 266:    */   }
/* 267:    */   
/* 268:    */   private ConverterImpl getConverter(String inType, String outType)
/* 269:    */   {
/* 270:321 */     Vertex sourceVertex = (Vertex)this.dataTypeToVertex.get(inType);
/* 271:322 */     Vertex targetVertex = (Vertex)this.dataTypeToVertex.get(outType);
/* 272:324 */     if ((sourceVertex != null) && (targetVertex != null))
/* 273:    */     {
/* 274:325 */       DijkstraShortestPath shortestPathAlg = 
/* 275:326 */         new DijkstraShortestPath(this.graph);
/* 276:    */       
/* 277:    */ 
/* 278:    */ 
/* 279:330 */       List<Edge> edgeList = shortestPathAlg.getPath(sourceVertex, targetVertex);
/* 280:332 */       if (edgeList.size() > 0)
/* 281:    */       {
/* 282:333 */         ArrayList<Object> serviceReferences = Lists.newArrayList();
/* 283:334 */         for (Edge edge : edgeList)
/* 284:    */         {
/* 285:335 */           AbstractList converterList = 
/* 286:336 */             (AbstractList)edge.getUserDatum("SERVICE_LIST");
/* 287:337 */           serviceReferences.add((ServiceReference)converterList.get(0));
/* 288:    */         }
/* 289:340 */         return ConverterImpl.createConverter(this.bContext, this.ciContext, serviceReferences);
/* 290:    */       }
/* 291:    */     }
/* 292:344 */     return null;
/* 293:    */   }
/* 294:    */   
/* 295:    */   public Converter[] findConverters(Data data, String outFormat)
/* 296:    */   {
/* 297:355 */     if (data == null)
/* 298:    */     {
/* 299:356 */       if ("null".equalsIgnoreCase(outFormat)) {
/* 300:357 */         return new Converter[] { ConverterImpl.createNoOpConverter(this.bContext, this.ciContext, outFormat) };
/* 301:    */       }
/* 302:359 */       return new Converter[0];
/* 303:    */     }
/* 304:363 */     String format = data.getFormat();
/* 305:    */     
/* 306:365 */     Set set = new HashSet();
/* 307:366 */     Converter[] converters = new Converter[0];
/* 308:367 */     if (format != null)
/* 309:    */     {
/* 310:368 */       converters = findConverters(format, outFormat);
/* 311:369 */       set.addAll(new HashSet(Arrays.asList(converters)));
/* 312:    */     }
/* 313:371 */     if ((!(data.getData() instanceof File)) && (data.getData() != null))
/* 314:    */     {
/* 315:372 */       Class dataClass = data.getData().getClass();
/* 316:373 */       for (Iterator it = getClassesFor(dataClass).iterator(); 
/* 317:374 */             it.hasNext();)
/* 318:    */       {
/* 319:375 */         Class c = (Class)it.next();
/* 320:376 */         converters = findConverters(c.getName(), outFormat);
/* 321:377 */         set.addAll(new HashSet(Arrays.asList(converters)));
/* 322:    */       }
/* 323:    */     }
/* 324:381 */     return (Converter[])set.toArray(new Converter[0]);
/* 325:    */   }
/* 326:    */   
/* 327:    */   protected Collection getClassesFor(Class clazz)
/* 328:    */   {
/* 329:390 */     Set classes = new HashSet();
/* 330:    */     
/* 331:392 */     Class[] c = clazz.getInterfaces();
/* 332:393 */     for (int i = 0; i < c.length; i++) {
/* 333:394 */       classes.addAll(getClassesFor(c[i]));
/* 334:    */     }
/* 335:397 */     Class superC = clazz.getSuperclass();
/* 336:399 */     if (superC != Object.class)
/* 337:    */     {
/* 338:400 */       if (superC != null) {
/* 339:401 */         classes.addAll(getClassesFor(superC));
/* 340:    */       }
/* 341:    */     }
/* 342:    */     else {
/* 343:403 */       classes.add(superC);
/* 344:    */     }
/* 345:406 */     classes.add(clazz);
/* 346:    */     
/* 347:408 */     return classes;
/* 348:    */   }
/* 349:    */   
/* 350:    */   public Data convert(Data inDM, String outFormat)
/* 351:    */     throws ConversionException
/* 352:    */   {
/* 353:419 */     String inFormat = inDM.getFormat();
/* 354:421 */     if ((inFormat != null) && (inFormat.equals(outFormat))) {
/* 355:422 */       return inDM;
/* 356:    */     }
/* 357:425 */     Converter[] converters = findConverters(inDM, outFormat);
/* 358:426 */     if (converters.length > 0) {
/* 359:427 */       inDM = converters[0].convert(inDM);
/* 360:    */     }
/* 361:430 */     return inDM;
/* 362:    */   }
/* 363:    */   
/* 364:    */   public void serviceChanged(ServiceEvent event)
/* 365:    */   {
/* 366:438 */     ServiceReference<?> inServiceRef = event.getServiceReference();
/* 367:    */     
/* 368:440 */     String inDataType = 
/* 369:441 */       (String)inServiceRef.getProperty("in_data");
/* 370:442 */     String outDataType = 
/* 371:443 */       (String)inServiceRef.getProperty("out_data");
/* 372:445 */     if (event.getType() == 2)
/* 373:    */     {
/* 374:446 */       removeServiceReference(inDataType, outDataType, inServiceRef);
/* 375:447 */       addServiceReference(inDataType, outDataType, inServiceRef);
/* 376:    */     }
/* 377:449 */     else if (event.getType() == 1)
/* 378:    */     {
/* 379:450 */       addServiceReference(inDataType, outDataType, inServiceRef);
/* 380:    */     }
/* 381:452 */     else if (event.getType() == 4)
/* 382:    */     {
/* 383:453 */       removeServiceReference(inDataType, outDataType, inServiceRef);
/* 384:    */     }
/* 385:    */   }
/* 386:    */   
/* 387:    */   private void removeServiceReference(String sourceDataType, String targetDataType, ServiceReference<?> serviceReference)
/* 388:    */   {
/* 389:466 */     if ((sourceDataType != null) && (targetDataType != null))
/* 390:    */     {
/* 391:467 */       Vertex sourceVertex = (Vertex)this.dataTypeToVertex.get(sourceDataType);
/* 392:468 */       Vertex targetVertex = (Vertex)this.dataTypeToVertex.get(targetDataType);
/* 393:469 */       String pid = 
/* 394:470 */         (String)serviceReference.getProperty("service.pid");
/* 395:472 */       if ((sourceVertex != null) && (targetVertex != null))
/* 396:    */       {
/* 397:473 */         Edge edge = sourceVertex.findEdge(targetVertex);
/* 398:474 */         if (edge != null)
/* 399:    */         {
/* 400:475 */           AbstractList serviceList = 
/* 401:476 */             (AbstractList)edge.getUserDatum("SERVICE_LIST");
/* 402:477 */           for (Iterator refs = serviceList.iterator(); refs.hasNext();)
/* 403:    */           {
/* 404:478 */             ServiceReference currentServiceReference = 
/* 405:479 */               (ServiceReference)refs.next();
/* 406:480 */             String currentPid = 
/* 407:481 */               (String)currentServiceReference
/* 408:482 */               .getProperty("service.pid");
/* 409:484 */             if (pid.equals(currentPid)) {
/* 410:485 */               refs.remove();
/* 411:    */             }
/* 412:    */           }
/* 413:488 */           if (serviceList.isEmpty()) {
/* 414:489 */             this.graph.removeEdge(edge);
/* 415:    */           }
/* 416:    */         }
/* 417:    */       }
/* 418:    */     }
/* 419:    */   }
/* 420:    */   
/* 421:    */   private void addServiceReference(String sourceDataType, String targetDataType, ServiceReference<?> serviceReference)
/* 422:    */   {
/* 423:505 */     if ((sourceDataType != null) && (sourceDataType.length() > 0) && 
/* 424:506 */       (targetDataType != null) && (targetDataType.length() > 0))
/* 425:    */     {
/* 426:507 */       Vertex sourceVertex = getVertex(sourceDataType);
/* 427:508 */       Vertex targetVertex = getVertex(targetDataType);
/* 428:    */       
/* 429:510 */       removeServiceReference(
/* 430:511 */         sourceDataType, targetDataType, serviceReference);
/* 431:    */       
/* 432:513 */       Edge directedEdge = sourceVertex.findEdge(targetVertex);
/* 433:514 */       if (directedEdge == null)
/* 434:    */       {
/* 435:515 */         directedEdge = 
/* 436:516 */           new DirectedSparseEdge(sourceVertex, targetVertex);
/* 437:517 */         this.graph.addEdge(directedEdge);
/* 438:    */       }
/* 439:520 */       AbstractList serviceList = 
/* 440:521 */         (AbstractList)directedEdge.getUserDatum("SERVICE_LIST");
/* 441:522 */       if (serviceList == null)
/* 442:    */       {
/* 443:523 */         serviceList = new ArrayList();
/* 444:524 */         serviceList.add(serviceReference);
/* 445:    */       }
/* 446:526 */       directedEdge.setUserDatum("SERVICE_LIST", serviceList, 
/* 447:527 */         new UserDataContainer.CopyAction.Shared());
/* 448:    */     }
/* 449:    */   }
/* 450:    */   
/* 451:    */   private Vertex getVertex(String dataType)
/* 452:    */   {
/* 453:538 */     Vertex vertex = (SparseVertex)this.dataTypeToVertex.get(dataType);
/* 454:539 */     if (vertex == null)
/* 455:    */     {
/* 456:540 */       vertex = new SparseVertex();
/* 457:541 */       vertex.addUserDatum("label", 
/* 458:542 */         dataType, 
/* 459:543 */         new UserDataContainer.CopyAction.Shared());
/* 460:544 */       this.graph.addVertex(vertex);
/* 461:545 */       this.dataTypeToVertex.put(dataType, vertex);
/* 462:    */     }
/* 463:547 */     return vertex;
/* 464:    */   }
/* 465:    */   
/* 466:    */   private void saveGraph()
/* 467:    */   {
/* 468:555 */     GraphMLFile writer = new GraphMLFile();
/* 469:556 */     Graph g = (Graph)this.graph.copy();
/* 470:557 */     for (Iterator edges = g.getEdges().iterator(); edges.hasNext();)
/* 471:    */     {
/* 472:558 */       Edge e = (Edge)edges.next();
/* 473:559 */       e.removeUserDatum("SERVICE_LIST");
/* 474:    */     }
/* 475:562 */     writer.save(g, System.getProperty("user.home") + 
/* 476:563 */       File.separator + 
/* 477:564 */       "convertGraph.xml");
/* 478:    */   }
/* 479:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.service.conversion.DataConversionServiceImpl
 * JD-Core Version:    0.7.0.1
 */