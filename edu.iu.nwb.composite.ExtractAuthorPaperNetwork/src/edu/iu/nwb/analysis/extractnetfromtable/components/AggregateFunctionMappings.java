/*   1:    */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*   2:    */ 
/*   3:    */ import edu.iu.nwb.analysis.extractnetfromtable.aggregate.AbstractAggregateFunction;
/*   4:    */ import edu.iu.nwb.analysis.extractnetfromtable.aggregate.AggregateFunctionName;
/*   5:    */ import edu.iu.nwb.analysis.extractnetfromtable.aggregate.AssembleAggregateFunctions;
/*   6:    */ import java.util.HashMap;
/*   7:    */ import java.util.HashSet;
/*   8:    */ import java.util.Iterator;
/*   9:    */ import java.util.Properties;
/*  10:    */ import java.util.Set;
/*  11:    */ import org.osgi.service.log.LogService;
/*  12:    */ import prefuse.data.Schema;
/*  13:    */ 
/*  14:    */ public class AggregateFunctionMappings
/*  15:    */ {
/*  16: 17 */   private final HashMap<String, AggregateFunctionName> metaColumnNameToFunctionMap = new HashMap();
/*  17: 18 */   private final HashMap<String, String> functionColumnToOriginalColumnMap = new HashMap();
/*  18: 19 */   private final HashMap<String, Integer> functionColumnToAppliedNodeTypeMap = new HashMap();
/*  19: 20 */   private final HashMap<Object, ValueAttributes> labelToFunctionMap = new HashMap();
/*  20:    */   public static final int SOURCE_AND_TARGET = 0;
/*  21:    */   public static final int SOURCE = 1;
/*  22:    */   public static final int TARGET = 2;
/*  23:    */   public static final String DEFAULT_WEIGHT_NAME = "weight";
/*  24:    */   
/*  25:    */   public void addFunctionMapping(String functionValueCol, String originalCol, AggregateFunctionName function)
/*  26:    */   {
/*  27: 27 */     this.metaColumnNameToFunctionMap.put(functionValueCol, function);
/*  28: 28 */     this.functionColumnToOriginalColumnMap.put(functionValueCol, 
/*  29: 29 */       originalCol);
/*  30: 30 */     this.functionColumnToAppliedNodeTypeMap.put(functionValueCol, 
/*  31: 31 */       new Integer(0));
/*  32:    */   }
/*  33:    */   
/*  34:    */   public void addFunctionMapping(String functionValueCol, String originalCol, AggregateFunctionName functionType, int nodeType)
/*  35:    */   {
/*  36: 36 */     this.metaColumnNameToFunctionMap.put(functionValueCol, functionType);
/*  37: 37 */     this.functionColumnToOriginalColumnMap.put(functionValueCol, 
/*  38: 38 */       originalCol);
/*  39: 39 */     this.functionColumnToAppliedNodeTypeMap.put(functionValueCol, 
/*  40: 40 */       new Integer(nodeType));
/*  41:    */   }
/*  42:    */   
/*  43:    */   public ValueAttributes addFunctionRow(Object id, ValueAttributes va)
/*  44:    */   {
/*  45: 44 */     this.labelToFunctionMap.put(id, va);
/*  46:    */     
/*  47: 46 */     return va;
/*  48:    */   }
/*  49:    */   
/*  50:    */   public AggregateFunctionName getFunctionFromColumnName(String columnName)
/*  51:    */   {
/*  52: 50 */     return (AggregateFunctionName)this.metaColumnNameToFunctionMap.get(columnName);
/*  53:    */   }
/*  54:    */   
/*  55:    */   public String getOriginalColumnFromFunctionColumn(String columnName)
/*  56:    */   {
/*  57: 54 */     return (String)this.functionColumnToOriginalColumnMap.get(columnName);
/*  58:    */   }
/*  59:    */   
/*  60:    */   public ValueAttributes getFunctionRow(Object id)
/*  61:    */   {
/*  62: 58 */     return (ValueAttributes)this.labelToFunctionMap.get(id);
/*  63:    */   }
/*  64:    */   
/*  65:    */   public int getAppliedNodeType(String columnName)
/*  66:    */   {
/*  67: 62 */     return ((Integer)this.functionColumnToAppliedNodeTypeMap.get(columnName)).intValue();
/*  68:    */   }
/*  69:    */   
/*  70:    */   public static void parseProperties(Schema input, Schema nodes, Schema edges, Properties properties, AggregateFunctionMappings nodeFunctionMappings, AggregateFunctionMappings edgeFunctionMappings, LogService log)
/*  71:    */     throws AggregateFunctionMappings.CompatibleAggregationNotFoundException
/*  72:    */   {
	  log.log(2, "WOWSERS");
/*  73: 76 */     if (properties != null)
/*  74:    */     {
/*  75: 77 */       HashSet<AggregateFunctionName> functionNames = new HashSet(
/*  76: 78 */         AssembleAggregateFunctions.defaultAssembly()
/*  77: 79 */         .getFunctionNames());
/*  78: 80 */       HashSet<String> columnNames = new HashSet();
/*  79: 82 */       for (int i = 0; i < input.getColumnCount(); i++) {
/*  80: 83 */         columnNames.add(input.getColumnName(i));
/*  81:    */       }
/*  82: 86 */       for (Iterator it = properties.keySet().iterator(); it
/*  83: 87 */             .hasNext();)
/*  84:    */       {
/*  85: 88 */         String key = (String)it.next();
/*  86: 89 */         String[] functionDefinitionLHS = key.split("\\.");
/*  87: 90 */         String[] functionDefinitionRHS = properties.getProperty(key)
/*  88: 91 */           .split("\\.");
/*  89: 92 */         String applyToNodeType = null;
/*  90: 93 */         int nodeType = -1;
/*  91:    */         
/*  92: 95 */         String sourceColumnName = functionDefinitionRHS[0];
/*  93: 96 */         Class columnType = input
/*  94: 97 */           .getColumnType(sourceColumnName);
/*  95: 98 */         AggregateFunctionName function = 
/*  96: 99 */           AggregateFunctionName.fromString(functionDefinitionRHS[(functionDefinitionRHS.length - 1)]);
/*  97:100 */         if (functionDefinitionRHS.length == 3) {
/*  98:101 */           applyToNodeType = functionDefinitionRHS[1];
/*  99:    */         }
/* 100:104 */         if (applyToNodeType == null) {
/* 101:105 */           nodeType = 0;
/* 102:107 */         } else if ("source".equalsIgnoreCase(applyToNodeType)) {
/* 103:108 */           nodeType = 1;
/* 104:109 */         } else if ("target".equalsIgnoreCase(applyToNodeType)) {
/* 105:110 */           nodeType = 2;
/* 106:    */         } else {
/* 107:112 */           nodeType = 0;
/* 108:    */         }
/* 109:116 */         String newColumnName = functionDefinitionLHS[(functionDefinitionLHS.length - 1)];
/* 110:118 */         if ((functionNames.contains(function)) && 
/* 111:119 */           (columnNames.contains(sourceColumnName)) && 
/* 112:120 */           (!columnNames.contains(newColumnName)))
/* 113:    */         {
/* 114:121 */           if (key.startsWith("edge."))
/* 115:    */           {
/* 116:122 */             if (!createColumn(newColumnName, function, columnType, 
/* 117:123 */               edges)) {
/* 118:124 */               throw new CompatibleAggregationNotFoundException(
/* 119:125 */                 String.format(
/* 120:126 */                 "Trying to make column '%s', could not find an aggregation function %s that applies to column type %s", new Object[] {
/* 121:127 */                 newColumnName, function, 
/* 122:128 */                 columnType.getName() }));
/* 123:    */             }
/* 124:130 */             edgeFunctionMappings.addFunctionMapping(newColumnName, 
/* 125:131 */               sourceColumnName, function);
/* 126:    */           }
/* 127:133 */           if (key.startsWith("node."))
/* 128:    */           {
/* 129:134 */             if (!createColumn(newColumnName, function, columnType, 
/* 130:135 */               nodes)) {
/* 131:136 */               throw new CompatibleAggregationNotFoundException(
/* 132:137 */                 String.format(
/* 133:138 */                 "Trying to make column '%s', could not find an aggregation function %s that applies to column type %s", new Object[] {
/* 134:139 */                 newColumnName, function, 
/* 135:140 */                 columnType.getName() }));
/* 136:    */             }
/* 137:142 */             nodeFunctionMappings.addFunctionMapping(newColumnName, 
/* 138:143 */               sourceColumnName, function, nodeType);
/* 139:    */           }
/* 140:    */         }
/* 141:147 */         if (!functionNames.contains(function)) {
/* 142:148 */           log.log(2, 
/* 143:149 */             "Unrecognized function: " + 
/* 144:150 */             function + 
/* 145:151 */             ".\nContinuing with " + 
/* 146:152 */             "extraction, but ignoring this specific analysis.");
/* 147:    */         }
/* 148:154 */         if (!columnNames.contains(sourceColumnName)) {
/* 149:155 */           log.log(2, 
/* 150:156 */             "Unrecognized column: " + 
/* 151:157 */             sourceColumnName + 
/* 152:158 */             ".\nContinuing with " + 
/* 153:159 */             "extraction, but ignoring this specific analysis.");
/* 154:    */         }
/* 155:161 */         if (columnNames.contains(newColumnName)) {
/* 156:162 */           log.log(2, 
/* 157:163 */             "BIEBER The column: " + 
/* 158:164 */             newColumnName + 
/* 159:165 */             " already exists." + 
/* 160:166 */             "\nContinuing with " + 
/* 161:167 */             "extraction, but ignoring this specific analysis.");
/* 162:    */         }
/* 163:    */       }
/* 164:    */     }
/* 165:    */   }
/* 166:    */   
/* 167:    */   public static void addDefaultEdgeWeightColumn(Schema inputGraphNodeSchema, Schema outputGraphEdgeSchema, AggregateFunctionMappings edgeFunctionMappings, String sourceColumnName)
/* 168:    */     throws AggregateFunctionMappings.CompatibleAggregationNotFoundException
/* 169:    */   {
/* 170:193 */     String newColumnName = "weight";
/* 171:194 */     AggregateFunctionName function = AggregateFunctionName.COUNT;
/* 172:195 */     Class columnType = inputGraphNodeSchema
/* 173:196 */       .getColumnType(sourceColumnName);
/* 174:198 */     if (!createColumn(newColumnName, function, columnType, outputGraphEdgeSchema)) {
/* 175:199 */       throw new CompatibleAggregationNotFoundException(
/* 176:200 */         String.format(
/* 177:201 */         "Trying to make column '%s', could not find an aggregation function %s that applies to column type %s", new Object[] {
/* 178:202 */         newColumnName, function, columnType.getName() }));
/* 179:    */     }
/* 180:204 */     edgeFunctionMappings.addFunctionMapping(newColumnName, 
/* 181:205 */       sourceColumnName, function);
/* 182:    */   }
/* 183:    */   
/* 184:    */   private static boolean createColumn(String newColumnName, AggregateFunctionName function, Class columnType, Schema newSchema)
/* 185:    */   {
/* 186:226 */     AbstractAggregateFunction aggFunc = 
/* 187:227 */       AssembleAggregateFunctions.defaultAssembly().getAggregateFunction(function, columnType);
/* 188:228 */     if (aggFunc == null) {
/* 189:229 */       return false;
/* 190:    */     }
/* 191:231 */     Class finalType = aggFunc.getType();
/* 192:232 */     newSchema.addColumn(newColumnName, finalType);
/* 193:233 */     return true;
/* 194:    */   }
/* 195:    */   
/* 196:    */   public static class CompatibleAggregationNotFoundException
/* 197:    */     extends Exception
/* 198:    */   {
/* 199:    */     private static final long serialVersionUID = 7588826870075190310L;
/* 200:    */     
/* 201:    */     public CompatibleAggregationNotFoundException() {}
/* 202:    */     
/* 203:    */     public CompatibleAggregationNotFoundException(String message)
/* 204:    */     {
/* 205:255 */       super();
/* 206:    */     }
/* 207:    */     
/* 208:    */     public CompatibleAggregationNotFoundException(Throwable cause)
/* 209:    */     {
/* 210:262 */       super();
/* 211:    */     }
/* 212:    */     
/* 213:    */     public CompatibleAggregationNotFoundException(String message, Throwable cause)
/* 214:    */     {
/* 215:269 */       super(cause);
/* 216:    */     }
/* 217:    */   }
/* 218:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.AggregateFunctionMappings
 * JD-Core Version:    0.7.0.1
 */