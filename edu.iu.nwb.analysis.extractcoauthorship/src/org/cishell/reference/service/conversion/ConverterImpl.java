/*   1:    */ package org.cishell.reference.service.conversion;
/*   2:    */ 
/*   3:    */ import com.google.common.base.Objects;
/*   4:    */ import com.google.common.base.Objects.ToStringHelper;

import java.util.ArrayList;
/*   6:    */ import java.util.Dictionary;
/*   7:    */ import java.util.Enumeration;
/*   8:    */ import java.util.Hashtable;
/*   9:    */ import java.util.List;

/*  10:    */ import org.cishell.framework.CIShellContext;
/*  11:    */ import org.cishell.framework.algorithm.Algorithm;
/*  12:    */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  13:    */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*  14:    */ import org.cishell.framework.algorithm.AlgorithmProperty;
/*  15:    */ import org.cishell.framework.data.BasicData;
/*  16:    */ import org.cishell.framework.data.Data;
/*  17:    */ import org.cishell.service.conversion.ConversionException;
/*  18:    */ import org.cishell.service.conversion.Converter;
/*  19:    */ import org.cishell.utility.dict.ImmutableDictionary;
/*  20:    */ import org.osgi.framework.BundleContext;
/*  21:    */ import org.osgi.framework.ServiceReference;
/*  22:    */ import org.osgi.service.log.LogService;
/*  23:    */ import org.osgi.service.metatype.MetaTypeProvider;
/*  24:    */ 
/*  25:    */ public class ConverterImpl
/*  26:    */   implements Converter, AlgorithmFactory, AlgorithmProperty
/*  27:    */ {
/*  28:    */   private final ArrayList<Object> serviceReferences;
/*  29:    */   private final BundleContext bContext;
/*  30:    */   private final ImmutableDictionary<String, Object> properties;
/*  31:    */   private final CIShellContext ciContext;
/*  32:    */   
/*  33:    */   private ConverterImpl(BundleContext bContext, CIShellContext ciContext, ArrayList<Object> ArrayList, Dictionary<String, Object> properties)
/*  34:    */   {
/*  35: 49 */     this.bContext = bContext;
/*  36: 50 */     this.ciContext = ciContext;
/*  37: 51 */     this.serviceReferences = ArrayList;
/*  38: 52 */     this.properties = ImmutableDictionary.fromDictionary(properties);
/*  39:    */   }
/*  40:    */   
/*  41:    */   static ConverterImpl createNoOpConverter(BundleContext bContext, CIShellContext ciContext, String dataFormat)
/*  42:    */   {
/*  43: 70 */     Dictionary<String, Object> properties = new Hashtable();
/*  44: 71 */     properties.put("in_data", dataFormat);
/*  45: 72 */     properties.put("out_data", dataFormat);
/*  46: 73 */     properties.put("label", properties.get("in_data") + " --(no-op)-> " + properties.get("out_data"));
/*  47:    */     
/*  48: 75 */     properties.put("conversion", "lossless");
ArrayList<Object> ArrayList = null;
/*  49:    */     
/*  50: 77 */     ConverterImpl toReturn = new ConverterImpl(bContext, ciContext,  ArrayList, properties);
/*  52:    */     
/*  53: 80 */     return toReturn;
/*  54:    */   }
/*  55:    */   
/*  56:    */   static ConverterImpl createConverter(BundleContext bContext, CIShellContext ciContext, ArrayList<Object> serviceReferences2)
/*  57:    */   {
/*  58:102 */     if (serviceReferences2.size() == 0) {
/*  59:103 */       throw new IllegalArgumentException("This static factory requires 1 or more algorithms in the chain; try .createNoOpConverter");
/*  60:    */     }
/*  61:105 */     Dictionary<String, Object> properties = new Hashtable();
/*  62:    */     
/*  63:107 */     properties.put("in_data", ((ServiceReference)serviceReferences2.get(0)).getProperty("in_data"));
/*  64:108 */     properties.put("out_data", ((ServiceReference)serviceReferences2.get(serviceReferences2.size() - 1)).getProperty("out_data"));
/*  65:109 */     properties.put("label", properties.get("in_data") + " -> " + properties.get("out_data"));
/*  66:    */     
/*  67:    */ 
/*  68:112 */     String lossiness = "lossy";//calculateLossiness(refs);
/*  69:113 */     properties.put("conversion", lossiness);
/*  70:114 */     return new ConverterImpl(bContext, ciContext, serviceReferences2, properties);
/*  71:    */   }
/*  72:    */   
/*  73:    */   public Data convert(Data inData)
/*  74:    */     throws ConversionException
/*  75:    */   {
/*  76:121 */     AlgorithmFactory factory = getAlgorithmFactory();
/*  77:122 */     Algorithm algorithm = factory.createAlgorithm(new Data[] { inData }, new Hashtable(), this.ciContext);
/*  78:    */     try
/*  79:    */     {
/*  80:126 */       Data[] resultDataArray = algorithm.execute();
/*  81:    */     }
/*  82:    */     catch (AlgorithmExecutionException e)
/*  83:    */     {
/*  84:    */       Data[] resultDataArray;
/*  85:128 */       e.printStackTrace();
/*  86:129 */       throw new ConversionException(e.getMessage(), e);
/*  87:    */     }
/*  88:    */     catch (Exception e)
/*  89:    */     {
/*  90:131 */       e.printStackTrace();
/*  91:132 */       throw new ConversionException(
/*  92:133 */         "Unexpected error: " + e.getMessage(), e);
/*  93:    */     }
/*  94:    */     Data[] resultDataArray = null;
/*  95:136 */     Object result = null;
/*  96:137 */     if ((resultDataArray != null) && (resultDataArray.length > 0)) {
/*  97:138 */       result = resultDataArray[0].getData();
/*  98:    */     }
/*  99:141 */     if (result != null)
/* 100:    */     {
/* 101:142 */       Dictionary<String, Object> properties = inData.getMetadata();
/* 102:143 */       Dictionary<String, Object> newProperties = new Hashtable();
/* 103:145 */       for (Enumeration<String> propertyKeys = properties.keys(); propertyKeys.hasMoreElements();)
/* 104:    */       {
/* 105:146 */         String key = (String)propertyKeys.nextElement();
/* 106:147 */         newProperties.put(key, properties.get(key));
/* 107:    */       }
/* 108:150 */       String outFormat = 
/* 109:151 */         (String)getProperties().get("out_data");
/* 110:    */       
/* 111:153 */       return new BasicData(newProperties, result, outFormat);
/* 112:    */     }
/* 113:155 */     return null;
/* 114:    */   }
/* 115:    */   
/* 116:    */   public AlgorithmFactory getAlgorithmFactory()
/* 117:    */   {
/* 118:164 */     return this;
/* 119:    */   }
/* 120:    */   
/* 121:    */   public ServiceReference[] getConverterChain()
/* 122:    */   {
/* 123:173 */     return (ServiceReference[])this.serviceReferences.toArray(new ServiceReference[0]);
/* 124:    */   }
/* 125:    */   
/* 126:    */   public ArrayList<Object> getConverterList()
/* 127:    */   {
/* 128:177 */     return this.serviceReferences;
/* 129:    */   }
/* 130:    */   
/* 131:    */   public Dictionary<String, Object> getProperties()
/* 132:    */   {
/* 133:184 */     return this.properties;
/* 134:    */   }
/* 135:    */   
/* 136:    */   public Algorithm createAlgorithm(Data[] dm, Dictionary parameters, CIShellContext context)
/* 137:    */   {
/* 138:191 */     return new ConverterAlgorithm(dm, parameters, context, this.serviceReferences);
/* 139:    */   }
/* 140:    */   
/* 141:    */   public MetaTypeProvider createParameters(Data[] dm)
/* 142:    */   {
/* 143:195 */     return null;
/* 144:    */   }
/* 145:    */   
/* 146:    */   public int hashCode()
/* 147:    */   {
/* 148:199 */     return Objects.hashCode(new Object[] { this.properties, this.serviceReferences });
/* 149:    */   }
/* 150:    */   
/* 151:    */   public String toString()
/* 152:    */   {
/* 153:204 */     return 
/* 154:    */     
/* 155:    */ 
/* 156:207 */       Objects.toStringHelper(Converter.class).add("properties", this.properties).add("chain", this.serviceReferences).toString();
/* 157:    */   }
/* 158:    */   
/* 159:    */   public boolean equals(Object compareTo)
/* 160:    */   {
/* 161:213 */     if (!(compareTo instanceof ConverterImpl)) {
/* 162:214 */       return false;
/* 163:    */     }
/* 164:216 */     ConverterImpl that = (ConverterImpl)compareTo;
/* 165:    */     
/* 166:    */ 
/* 167:219 */     return (this.properties.equals(that.properties)) && (this.serviceReferences.equals(that.serviceReferences));
/* 168:    */   }
/* 169:    */   
/* 170:    */   public String calculateLossiness()
/* 171:    */   {
/* 172:223 */     return "lossy";
/* 173:    */   }
/* 174:    */   
/* 175:    */   private static String calculateLossiness(List<ServiceReference<AlgorithmFactory>> serviceReferences)
/* 176:    */   {
/* 177:227 */     for (ServiceReference<AlgorithmFactory> serviceReference : serviceReferences) {
/* 178:228 */       if ("lossy".equals(serviceReference.getProperty("conversion"))) {
/* 179:229 */         return "lossy";
/* 180:    */       }
/* 181:    */     }
/* 182:233 */     return "lossless";
/* 183:    */   }
/* 184:    */   
/* 185:    */   private class ConverterAlgorithm
/* 186:    */     implements Algorithm
/* 187:    */   {
/* 188:    */     public static final String FILE_EXTENSION_PREFIX = "file-ext:";
/* 189:    */     public static final String MIME_TYPE_PREFIX = "file:";
/* 190:    */     private Data[] inData;
/* 191:    */     private Dictionary<String, Object> parameters;
/* 192:    */     private CIShellContext ciShellContext;
/* 193:    */     private LogService logger;
/* 194:    */     private ArrayList<ServiceReference<AlgorithmFactory>> serviceReferences;
/* 195:    */     
/* 196:    */     public ConverterAlgorithm(Data[] inData, Dictionary<String, Object> parameters, CIShellContext ciShellContext)
/* 197:    */     {
/* 198:250 */       this.inData = inData;
/* 199:251 */       this.parameters = parameters;
/* 200:252 */       this.ciShellContext = ciShellContext;
/* 201:253 */       this.serviceReferences = serviceReferences;
/* 202:254 */       this.logger = 
/* 203:255 */         ((LogService)ciShellContext.getService(LogService.class.getName()));
/* 204:    */     }
public ConverterAlgorithm(Data[] dm, Dictionary parameters2,
		CIShellContext context, ArrayList<Object> serviceReferences2) {
	// TODO Auto-generated constructor stub
}
/* 205:    */     
/* 206:    */     public Data[] execute()
/* 207:    */       throws AlgorithmExecutionException
/* 208:    */     {
/* 209:260 */       Data[] convertedData = this.inData;
/* 210:263 */       for (int ii = 0; ii < this.serviceReferences.size(); ii++)
/* 211:    */       {
/* 212:264 */         AlgorithmFactory factory = 
/* 213:265 */           (AlgorithmFactory)ConverterImpl.this.bContext.getService((ServiceReference)this.serviceReferences.get(ii));
/* 214:267 */         if (factory != null)
/* 215:    */         {
/* 216:268 */           Algorithm algorithm = factory.createAlgorithm(
/* 217:269 */             convertedData, this.parameters, this.ciShellContext);
/* 218:    */           try
/* 219:    */           {
/* 220:272 */             convertedData = algorithm.execute();
/* 221:    */           }
/* 222:    */           catch (AlgorithmExecutionException e)
/* 223:    */           {
/* 224:274 */             boolean isLastStep = ii == this.serviceReferences.size() - 1;
/* 225:275 */             if ((isLastStep) && (isHandler((ServiceReference)this.serviceReferences.get(ii))))
/* 226:    */             {
/* 227:281 */               String warningMessage = 
/* 228:282 */                 "Warning: Attempting to convert data without validating the output since the validator failed with this problem:\n    " + 
/* 229:    */                 
/* 230:    */ 
/* 231:285 */                 createErrorMessage((ServiceReference)this.serviceReferences.get(ii), e);
/* 232:    */               
/* 233:287 */               this.logger.log(2, warningMessage, e);
/* 234:    */               
/* 235:289 */               return convertedData;
/* 236:    */             }
/* 237:291 */             throw new AlgorithmExecutionException(
/* 238:292 */               createErrorMessage((ServiceReference)this.serviceReferences.get(ii), e), e);
/* 239:    */           }
/* 240:    */         }
/* 241:    */         else
/* 242:    */         {
/* 243:296 */           throw new AlgorithmExecutionException(
/* 244:297 */             "Missing subconverter: " + 
/* 245:298 */             ((ServiceReference)this.serviceReferences.get(ii)).getProperty("service.pid"));
/* 246:    */         }
/* 247:    */       }
/* 248:302 */       return convertedData;
/* 249:    */     }
/* 250:    */     
/* 251:    */     private boolean isHandler(ServiceReference<AlgorithmFactory> ref)
/* 252:    */     {
/* 253:310 */       String algorithmType = 
/* 254:311 */         (String)ref.getProperty("type");
/* 255:312 */       boolean algorithmTypeIsValidator = 
/* 256:313 */         "validator".equals(algorithmType);
/* 257:    */       
/* 258:315 */       String inDataType = 
/* 259:316 */         (String)ref.getProperty("in_data");
/* 260:317 */       boolean inDataTypeIsFile = inDataType.startsWith("file:");
/* 261:    */       
/* 262:319 */       String outDataType = 
/* 263:320 */         (String)ref.getProperty("out_data");
/* 264:321 */       boolean outDataTypeIsFileExt = 
/* 265:322 */         outDataType.startsWith("file-ext:");
/* 266:    */       
/* 267:    */ 
/* 268:    */ 
/* 269:326 */       return (algorithmTypeIsValidator) && (inDataTypeIsFile) && (outDataTypeIsFileExt);
/* 270:    */     }
/* 271:    */     
/* 272:    */     private String createErrorMessage(ServiceReference<AlgorithmFactory> ref, Throwable e)
/* 273:    */     {
/* 274:330 */       String inType = (String)ConverterImpl.this.properties.get("in_data");
/* 275:331 */       String preProblemType = (String)ref.getProperty("in_data");
/* 276:332 */       String postProblemType = (String)ref.getProperty("out_data");
/* 277:333 */       String outType = (String)ConverterImpl.this.properties.get("out_data");
/* 278:338 */       if ((inType.equals(preProblemType)) && 
/* 279:339 */         (outType.equals(postProblemType))) {
/* 280:340 */         return 
/* 281:    */         
/* 282:    */ 
/* 283:    */ 
/* 284:344 */           "Problem converting data from " + prettifyDataType(inType) + " to " + prettifyDataType(outType) + " (See the log file for more details).:\n        " + e.getMessage();
/* 285:    */       }
/* 286:347 */       return 
/* 287:    */       
/* 288:    */ 
/* 289:    */ 
/* 290:    */ 
/* 291:    */ 
/* 292:    */ 
/* 293:354 */         "Problem converting data from " + prettifyDataType(inType) + " to " + prettifyDataType(outType) + " during the necessary intermediate conversion from " + prettifyDataType(preProblemType) + " to " + prettifyDataType(postProblemType) + " (See the log file for more details):\n        " + e.getMessage();
/* 294:    */     }
/* 295:    */     
/* 296:    */     private String prettifyDataType(String dataType)
/* 297:    */     {
/* 298:359 */       if (dataType.startsWith("file:")) {
/* 299:360 */         return withoutFirstCharacters(
/* 300:361 */           dataType, "file:".length());
/* 301:    */       }
/* 302:363 */       if (dataType.startsWith("file-ext:")) {
/* 303:364 */         return "." + withoutFirstCharacters(
/* 304:365 */           dataType, "file-ext:".length());
/* 305:    */       }
/* 306:368 */       return dataType;
/* 307:    */     }
/* 308:    */     
/* 309:    */     public String withoutFirstCharacters(String s, int n)
/* 310:    */     {
/* 311:373 */       return s.substring(n);
/* 312:    */     }
/* 313:    */   }
/* 314:    */ }



/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar

 * Qualified Name:     org.cishell.reference.service.conversion.ConverterImpl

 * JD-Core Version:    0.7.0.1

 */