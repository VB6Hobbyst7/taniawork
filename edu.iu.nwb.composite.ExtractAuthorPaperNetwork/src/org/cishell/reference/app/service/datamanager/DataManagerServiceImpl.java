/*   1:    */ package org.cishell.reference.app.service.datamanager;
/*   2:    */ 
/*   3:    */ import java.util.Arrays;
/*   4:    */ import java.util.Dictionary;
/*   5:    */ import java.util.LinkedHashMap;
/*   6:    */ import java.util.LinkedHashSet;
/*   7:    */ import java.util.Map;
/*   8:    */ import java.util.Set;
/*   9:    */ import org.cishell.app.service.datamanager.DataManagerListener;
/*  10:    */ import org.cishell.app.service.datamanager.DataManagerService;
/*  11:    */ import org.cishell.framework.data.Data;
/*  12:    */ 
/*  13:    */ public class DataManagerServiceImpl
/*  14:    */   implements DataManagerService
/*  15:    */ {
/*  16: 29 */   private Map<Data, String> datumToLabel = new LinkedHashMap();
/*  17: 30 */   private Map<String, Data> labelToDatum = new LinkedHashMap();
/*  18: 31 */   private Map<String, Integer> labelToOccurrenceCount = new LinkedHashMap();
/*  19: 32 */   private Set<Data> data = new LinkedHashSet();
/*  20: 33 */   private Set<Data> selectedData = new LinkedHashSet();
/*  21: 34 */   private Set<DataManagerListener> listeners = new LinkedHashSet();
/*  22:    */   
/*  23:    */   public void addData(Data datum)
/*  24:    */   {
/*  25: 37 */     if (datum == null) {
/*  26: 38 */       return;
/*  27:    */     }
/*  28: 41 */     String label = (String)datum.getMetadata().get("Label");
/*  29: 42 */     String type = (String)datum.getMetadata().get("Type");
/*  30: 44 */     if (type == null)
/*  31:    */     {
/*  32: 45 */       type = "Unknown";
/*  33: 46 */       datum.getMetadata().put("Type", type);
/*  34:    */     }
/*  35: 50 */     if ((label == null) || ("".equals(label))) {
/*  36: 51 */       label = generateDefaultLabel(type);
/*  37:    */     }
/*  38: 54 */     addModel(datum, label);
/*  39: 56 */     for (DataManagerListener listener : this.listeners) {
/*  40: 57 */       listener.dataAdded(datum, label);
/*  41:    */     }
/*  42:    */   }
/*  43:    */   
/*  44:    */   private void addModel(Data datum, String label)
/*  45:    */   {
/*  46: 62 */     label = findUniqueLabel(label);
/*  47: 63 */     datum.getMetadata().put("Label", label);
/*  48:    */     
/*  49: 65 */     datum.getMetadata().put("Modified", new Boolean(true));
/*  50:    */     
/*  51: 67 */     this.datumToLabel.put(datum, label);
/*  52: 68 */     this.labelToDatum.put(label, datum);
/*  53: 69 */     this.data.add(datum);
/*  54:    */   }
/*  55:    */   
/*  56:    */   private String generateDefaultLabel(String dataType)
/*  57:    */   {
/*  58: 74 */     StackTraceElement[] stack = new Throwable().getStackTrace();
/*  59:    */     String label;
/*  60:    */     String label1;
/*  61: 76 */     if (stack.length > 2)
/*  62:    */     {
/*  63: 77 */       String className = stack[2].getClassName();
/*  64: 78 */       int lastDot = className.lastIndexOf(".");
/*  65: 80 */       if (className.length() > lastDot)
/*  66:    */       {
/*  67: 81 */         lastDot++;
/*  68: 82 */         className = className.substring(lastDot);
/*  69: 84 */         if (className.endsWith("Algorithm")) {
/*  70: 85 */           className = className.substring(0, className.lastIndexOf("Algorithm"));
/*  71:    */         }
/*  72: 88 */         if (className.endsWith("Factory")) {
/*  73: 89 */           className = className.substring(0, className.lastIndexOf("Factory"));
/*  74:    */         }
/*  75:    */       }
/*  76: 92 */       label1 = className;
/*  77:    */     }
/*  78:    */     else
/*  79:    */     {
/*  80: 94 */       label1 = "Unknown";
/*  81:    */     }
/*  82: 97 */     return String.format("%s.%s", new Object[] { label1, dataType });
/*  83:    */   }
/*  84:    */   
/*  85:    */   private String findUniqueLabel(String label)
/*  86:    */   {
/*  87:110 */     Integer occurenceCount = (Integer)this.labelToOccurrenceCount.get(label);
/*  88:112 */     if (occurenceCount == null)
/*  89:    */     {
/*  90:114 */       this.labelToOccurrenceCount.put(label, new Integer(1));
/*  91:    */       
/*  92:116 */       return label;
/*  93:    */     }
/*  94:120 */     int numOccurrencesVal = occurenceCount.intValue();
/*  95:    */     
/*  96:122 */     int newNumOccurrencesVal = numOccurrencesVal + 1;
/*  97:    */     
/*  98:124 */     String newLabel = label + "." + newNumOccurrencesVal;
/*  99:132 */     while (getModelForLabel(newLabel) != null)
/* 100:    */     {
/* 101:133 */       newNumOccurrencesVal++;
/* 102:134 */       newLabel = label + "." + newNumOccurrencesVal;
/* 103:    */     }
/* 104:140 */     this.labelToOccurrenceCount.put(label, new Integer(newNumOccurrencesVal));
/* 105:    */     
/* 106:    */ 
/* 107:    */ 
/* 108:    */ 
/* 109:    */ 
/* 110:    */ 
/* 111:    */ 
/* 112:    */ 
/* 113:    */ 
/* 114:    */ 
/* 115:    */ 
/* 116:152 */     this.labelToOccurrenceCount.put(newLabel, new Integer(1));
/* 117:    */     
/* 118:154 */     return newLabel;
/* 119:    */   }
/* 120:    */   
/* 121:    */   public void removeData(Data datum)
/* 122:    */   {
/* 123:200 */     String label = getLabel(datum);
/* 124:    */     
/* 125:202 */     this.labelToDatum.remove(label);
/* 126:203 */     this.datumToLabel.remove(datum);
/* 127:204 */     this.labelToOccurrenceCount.remove(label);
/* 128:205 */     this.data.remove(datum);
/* 129:207 */     for (DataManagerListener listener : this.listeners) {
/* 130:208 */       listener.dataRemoved(datum);
/* 131:    */     }
/* 132:    */   }
/* 133:    */   
/* 134:    */   public Data[] getSelectedData()
/* 135:    */   {
/* 136:213 */     return (Data[])this.selectedData.toArray(new Data[0]);
/* 137:    */   }
/* 138:    */   
/* 139:    */   public void setSelectedData(Data[] data)
/* 140:    */   {
/* 141:217 */     this.selectedData.clear();
/* 142:218 */     this.selectedData.addAll(Arrays.asList(data));
/* 143:220 */     for (int ii = 0; ii < data.length; ii++) {
/* 144:221 */       if (!this.data.contains(data[ii])) {
/* 145:222 */         addData(data[ii]);
/* 146:    */       }
/* 147:    */     }
/* 148:226 */     for (DataManagerListener listener : this.listeners) {
/* 149:227 */       listener.dataSelected(data);
/* 150:    */     }
/* 151:    */   }
/* 152:    */   
/* 153:    */   private Data getModelForLabel(String label)
/* 154:    */   {
/* 155:232 */     return (Data)this.labelToDatum.get(label);
/* 156:    */   }
/* 157:    */   
/* 158:    */   public String getLabel(Data datum)
/* 159:    */   {
/* 160:236 */     return (String)this.datumToLabel.get(datum);
/* 161:    */   }
/* 162:    */   
/* 163:    */   public synchronized void setLabel(Data datum, String label)
/* 164:    */   {
/* 165:240 */     String uniqueLabel = findUniqueLabel(label);
/* 166:241 */     this.datumToLabel.put(datum, uniqueLabel);
/* 167:242 */     this.labelToDatum.put(uniqueLabel, datum);
/* 168:244 */     for (DataManagerListener listener : this.listeners) {
/* 169:245 */       listener.dataLabelChanged(datum, label);
/* 170:    */     }
/* 171:    */   }
/* 172:    */   
/* 173:    */   public Data[] getAllData()
/* 174:    */   {
/* 175:250 */     return (Data[])this.data.toArray(new Data[0]);
/* 176:    */   }
/* 177:    */   
/* 178:    */   public void addDataManagerListener(DataManagerListener listener)
/* 179:    */   {
/* 180:254 */     this.listeners.add(listener);
/* 181:    */   }
/* 182:    */   
/* 183:    */   public void removeDataManagerListener(DataManagerListener listener)
/* 184:    */   {
/* 185:258 */     this.listeners.remove(listener);
/* 186:    */   }
/* 187:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.datamanager.DataManagerServiceImpl
 * JD-Core Version:    0.7.0.1
 */