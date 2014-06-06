/*   1:    */ package org.cishell.reference.app.service.filesaver;
/*   2:    */ 
/*   3:    */ import java.util.Arrays;
/*   4:    */ import java.util.Collection;
/*   5:    */ import java.util.Comparator;
/*   6:    */ import java.util.Dictionary;
/*   7:    */ import java.util.Enumeration;
/*   8:    */ import java.util.HashMap;
/*   9:    */ import java.util.Map;
/*  10:    */ import org.cishell.framework.algorithm.AlgorithmProperty;
/*  11:    */ import org.cishell.framework.data.Data;
/*  12:    */ import org.cishell.reference.app.service.persistence.AbstractDialog;
/*  13:    */ import org.cishell.service.conversion.Converter;
/*  14:    */ import org.eclipse.swt.custom.StyleRange;
/*  15:    */ import org.eclipse.swt.custom.StyledText;
/*  16:    */ import org.eclipse.swt.events.MouseAdapter;
/*  17:    */ import org.eclipse.swt.events.MouseEvent;
/*  18:    */ import org.eclipse.swt.events.SelectionAdapter;
/*  19:    */ import org.eclipse.swt.events.SelectionEvent;
/*  20:    */ import org.eclipse.swt.layout.FillLayout;
/*  21:    */ import org.eclipse.swt.layout.GridData;
/*  22:    */ import org.eclipse.swt.layout.GridLayout;
/*  23:    */ import org.eclipse.swt.widgets.Button;
/*  24:    */ import org.eclipse.swt.widgets.Caret;
/*  25:    */ import org.eclipse.swt.widgets.Composite;
/*  26:    */ import org.eclipse.swt.widgets.Group;
/*  27:    */ import org.eclipse.swt.widgets.List;
/*  28:    */ import org.eclipse.swt.widgets.Shell;
/*  29:    */ import org.osgi.framework.ServiceReference;
/*  30:    */ 
/*  31:    */ public class DataFormatChooser
/*  32:    */   extends AbstractDialog
/*  33:    */   implements AlgorithmProperty
/*  34:    */ {
/*  35:    */   protected Data data;
/*  36:    */   protected Converter[] converters;
/*  37:    */   private List converterListComponent;
/*  38:    */   private StyledText detailPane;
/*  39:    */   private Converter chosenConverter;
/*  40:    */   
/*  41:    */   public DataFormatChooser(Data data, Shell parent, Converter[] converters, String title)
/*  42:    */   {
/*  43: 43 */     super(parent, title, AbstractDialog.QUESTION);
/*  44: 44 */     this.data = data;
/*  45: 45 */     this.converters = alphabetizeConverters(filterConverters(converters));
/*  46:    */   }
/*  47:    */   
/*  48:    */   public Converter getChosenConverter()
/*  49:    */   {
/*  50: 49 */     return this.chosenConverter;
/*  51:    */   }
/*  52:    */   
/*  53:    */   private Composite initializeGUI(Composite parent)
/*  54:    */   {
/*  55: 53 */     Composite content = new Composite(parent, 0);
/*  56: 54 */     GridLayout layout = new GridLayout();
/*  57: 55 */     layout.numColumns = 2;
/*  58: 56 */     content.setLayout(layout);
/*  59:    */     
/*  60: 58 */     Group converterGroup = new Group(content, 0);
/*  61: 59 */     converterGroup.setText("Pick the Output Data Type");
/*  62: 60 */     converterGroup.setLayout(new FillLayout());
/*  63: 61 */     GridData persisterData = new GridData(1808);
/*  64: 62 */     persisterData.widthHint = 200;
/*  65: 63 */     converterGroup.setLayoutData(persisterData);
/*  66:    */     
/*  67: 65 */     this.converterListComponent = 
/*  68: 66 */       new List(converterGroup, 772);
/*  69: 67 */     initializeConverterListComponent();
/*  70: 68 */     this.converterListComponent.addMouseListener(new MouseAdapter()
/*  71:    */     {
/*  72:    */       public void mouseDoubleClick(MouseEvent mouseEvent)
/*  73:    */       {
/*  74: 70 */         List list = (List)mouseEvent.getSource();
/*  75: 71 */         int selection = list.getSelectionIndex();
/*  76: 73 */         if (selection != -1) {
/*  77: 74 */           DataFormatChooser.this.selectionMade(selection);
/*  78:    */         }
/*  79:    */       }
/*  80: 77 */     });
/*  81: 78 */     this.converterListComponent.addSelectionListener(new SelectionAdapter()
/*  82:    */     {
/*  83:    */       public void widgetSelected(SelectionEvent selectionEvent)
/*  84:    */       {
/*  85: 80 */         List list = (List)selectionEvent.getSource();
/*  86: 81 */         int selection = list.getSelectionIndex();
/*  87: 83 */         if (selection != -1) {
/*  88: 84 */           DataFormatChooser.this.updateDetailPane(DataFormatChooser.this.converters[selection]);
/*  89:    */         }
/*  90:    */       }
/*  91: 88 */     });
/*  92: 89 */     Group detailsGroup = new Group(content, 0);
/*  93: 90 */     detailsGroup.setText("Details");
/*  94: 91 */     detailsGroup.setLayout(new FillLayout());
/*  95: 92 */     GridData detailsData = new GridData(1808);
/*  96: 93 */     detailsData.widthHint = 200;
/*  97: 94 */     detailsGroup.setLayoutData(detailsData);
/*  98:    */     
/*  99: 96 */     this.detailPane = initializeDetailPane(detailsGroup);
/* 100:    */     
/* 101:    */ 
/* 102: 99 */     this.converterListComponent.setSelection(0);
/* 103:100 */     updateDetailPane(this.converters[0]);
/* 104:    */     
/* 105:102 */     return content;
/* 106:    */   }
/* 107:    */   
/* 108:    */   private void initializeConverterListComponent()
/* 109:    */   {
/* 110:109 */     for (int ii = 0; ii < this.converters.length; ii++) {
/* 111:110 */       if (this.converters[ii] != null)
/* 112:    */       {
/* 113:111 */         Dictionary converterProperties = this.converters[ii].getProperties();
/* 114:    */         
/* 115:    */ 
/* 116:114 */         String outData = null;
/* 117:    */         
/* 118:116 */         ServiceReference[] serviceReferences = this.converters[ii].getConverterChain();
/* 119:118 */         if ((serviceReferences != null) && (serviceReferences.length > 0)) {
/* 120:119 */           outData = (String)serviceReferences[(serviceReferences.length - 1)].getProperty(
/* 121:120 */             "label");
/* 122:    */         }
/* 123:123 */         if (outData == null) {
/* 124:124 */           outData = (String)converterProperties.get("label");
/* 125:    */         }
/* 126:131 */         if ((outData == null) || (outData.length() == 0)) {
/* 127:132 */           outData = this.converters[ii].getClass().getName();
/* 128:    */         }
/* 129:135 */         this.converterListComponent.add(outData);
/* 130:    */       }
/* 131:    */     }
/* 132:    */   }
/* 133:    */   
/* 134:    */   private StyledText initializeDetailPane(Group detailsGroup)
/* 135:    */   {
/* 136:141 */     StyledText detailPane = new StyledText(detailsGroup, 768);
/* 137:142 */     detailPane.setEditable(false);
/* 138:143 */     detailPane.getCaret().setVisible(false);
/* 139:    */     
/* 140:145 */     return detailPane;
/* 141:    */   }
/* 142:    */   
/* 143:    */   private void updateDetailPane(Converter converter)
/* 144:    */   {
/* 145:149 */     Dictionary converterProperties = converter.getProperties();
/* 146:150 */     Enumeration converterPropertiesKeys = converterProperties.keys();
/* 147:    */     
/* 148:152 */     this.detailPane.setText("");
/* 149:154 */     while (converterPropertiesKeys.hasMoreElements())
/* 150:    */     {
/* 151:155 */       Object key = converterPropertiesKeys.nextElement();
/* 152:156 */       Object value = converterProperties.get(key);
/* 153:    */       
/* 154:158 */       StyleRange styleRange = new StyleRange();
/* 155:159 */       styleRange.start = this.detailPane.getText().length();
/* 156:160 */       this.detailPane.append(key + ":\n");
/* 157:161 */       styleRange.length = (key.toString().length() + 1);
/* 158:162 */       styleRange.fontStyle = 1;
/* 159:163 */       this.detailPane.setStyleRange(styleRange);
/* 160:    */       
/* 161:165 */       this.detailPane.append(value + "\n");
/* 162:    */     }
/* 163:    */   }
/* 164:    */   
/* 165:    */   private Converter[] filterConverters(Converter[] allConverters)
/* 166:    */   {
/* 167:170 */     Map<String, Converter> lastInDataToConverter = new HashMap();
/* 168:172 */     for (int ii = 0; ii < allConverters.length; ii++)
/* 169:    */     {
/* 170:173 */       Converter converter = allConverters[ii];
/* 171:174 */       String lastInputData = getLastConverterInData(converter);
/* 172:176 */       if (lastInDataToConverter.containsKey(lastInputData))
/* 173:    */       {
/* 174:177 */         Converter alreadyStoredConverter = (Converter)lastInDataToConverter.get(lastInputData);
/* 175:178 */         Converter chosenConverter = 
/* 176:179 */           returnPreferredConverter(converter, alreadyStoredConverter);
/* 177:180 */         lastInDataToConverter.put(lastInputData, chosenConverter);
/* 178:    */       }
/* 179:    */       else
/* 180:    */       {
/* 181:182 */         lastInDataToConverter.put(lastInputData, converter);
/* 182:    */       }
/* 183:    */     }
/* 184:186 */     return (Converter[])lastInDataToConverter.values().toArray(new Converter[0]);
/* 185:    */   }
/* 186:    */   
/* 187:    */   private String getLastConverterInData(Converter converter)
/* 188:    */   {
/* 189:190 */     ServiceReference[] convChain = converter.getConverterChain();
/* 190:192 */     if (convChain.length >= 1)
/* 191:    */     {
/* 192:193 */       ServiceReference lastConverter = convChain[(convChain.length - 1)];
/* 193:194 */       String lastInData = (String)lastConverter.getProperty("in_data");
/* 194:    */       
/* 195:196 */       return lastInData;
/* 196:    */     }
/* 197:198 */     return "";
/* 198:    */   }
/* 199:    */   
/* 200:    */   private Converter returnPreferredConverter(Converter converter1, Converter converter2)
/* 201:    */   {
/* 202:203 */     Dictionary converter1Properties = converter1.getProperties();
/* 203:204 */     String converter1Lossiness = (String)converter1Properties.get("conversion");
/* 204:205 */     int converter1Quality = determineQuality(converter1Lossiness);
/* 205:    */     
/* 206:207 */     Dictionary converter2Properties = converter2.getProperties();
/* 207:208 */     String converter2Lossiness = (String)converter2Properties.get("conversion");
/* 208:209 */     int converter2Quality = determineQuality(converter2Lossiness);
/* 209:211 */     if (converter1Quality > converter2Quality) {
/* 210:212 */       return converter1;
/* 211:    */     }
/* 212:213 */     if (converter2Quality > converter1Quality) {
/* 213:214 */       return converter2;
/* 214:    */     }
/* 215:218 */     int converter1Length = converter1.getConverterChain().length;
/* 216:219 */     int converter2Length = converter2.getConverterChain().length;
/* 217:221 */     if (converter1Length > converter2Length) {
/* 218:222 */       return converter2;
/* 219:    */     }
/* 220:223 */     if (converter2Length > converter1Length) {
/* 221:224 */       return converter1;
/* 222:    */     }
/* 223:230 */     return converter1;
/* 224:    */   }
/* 225:    */   
/* 226:    */   private int determineQuality(String lossiness)
/* 227:    */   {
/* 228:236 */     if (lossiness == "lossy") {
/* 229:237 */       return 0;
/* 230:    */     }
/* 231:238 */     if (lossiness == null) {
/* 232:239 */       return 1;
/* 233:    */     }
/* 234:241 */     return 2;
/* 235:    */   }
/* 236:    */   
/* 237:    */   private Converter[] alphabetizeConverters(Converter[] converters)
/* 238:    */   {
/* 239:246 */     Arrays.sort(converters, new CompareAlphabetically());
/* 240:    */     
/* 241:248 */     return converters;
/* 242:    */   }
/* 243:    */   
/* 244:    */   protected void selectionMade(int selectedIndex)
/* 245:    */   {
/* 246:    */     try
/* 247:    */     {
/* 248:253 */       getShell().setVisible(false);
/* 249:254 */       this.chosenConverter = this.converters[selectedIndex];
/* 250:    */       
/* 251:256 */       close(true);
/* 252:    */     }
/* 253:    */     catch (Exception exception)
/* 254:    */     {
/* 255:259 */       throw new RuntimeException(exception);
/* 256:    */     }
/* 257:    */   }
/* 258:    */   
/* 259:    */   public void createDialogButtons(Composite parent)
/* 260:    */   {
/* 261:264 */     Button select = new Button(parent, 8);
/* 262:265 */     select.setText("Select");
/* 263:266 */     select.addSelectionListener(
/* 264:267 */       new SelectionAdapter()
/* 265:    */       {
/* 266:    */         public void widgetSelected(SelectionEvent selectionEvent)
/* 267:    */         {
/* 268:269 */           int index = DataFormatChooser.this.converterListComponent.getSelectionIndex();
/* 269:271 */           if (index != -1) {
/* 270:272 */             DataFormatChooser.this.selectionMade(index);
/* 271:    */           }
/* 272:    */         }
/* 273:276 */       });
/* 274:277 */     select.setFocus();
/* 275:    */     
/* 276:279 */     Button cancel = new Button(parent, 0);
/* 277:280 */     cancel.setText("Cancel");
/* 278:281 */     cancel.addSelectionListener(
/* 279:282 */       new SelectionAdapter()
/* 280:    */       {
/* 281:    */         public void widgetSelected(SelectionEvent selectionEvent)
/* 282:    */         {
/* 283:284 */           DataFormatChooser.this.close(false);
/* 284:    */         }
/* 285:    */       });
/* 286:    */   }
/* 287:    */   
/* 288:    */   public Composite createContent(Composite parent)
/* 289:    */   {
/* 290:291 */     if (this.converters.length == 1)
/* 291:    */     {
/* 292:292 */       close(true);
/* 293:    */       
/* 294:    */ 
/* 295:    */ 
/* 296:296 */       return parent;
/* 297:    */     }
/* 298:298 */     return initializeGUI(parent);
/* 299:    */   }
/* 300:    */   
/* 301:    */   private class CompareAlphabetically
/* 302:    */     implements Comparator<Converter>
/* 303:    */   {
/* 304:    */     private CompareAlphabetically() {}
/* 305:    */     
/* 306:    */     public int compare(Converter converter1, Converter converter2)
/* 307:    */     {
/* 308:304 */       String converter1Label = getLabel(converter1);
/* 309:305 */       String converter2Label = getLabel(converter2);
/* 310:307 */       if ((converter1Label != null) && (converter2Label != null)) {
/* 311:308 */         return converter1Label.compareTo(converter2Label);
/* 312:    */       }
/* 313:309 */       if (converter1Label == null) {
/* 314:310 */         return 1;
/* 315:    */       }
/* 316:311 */       if (converter2Label == null) {
/* 317:312 */         return -1;
/* 318:    */       }
/* 319:314 */       return 0;
/* 320:    */     }
/* 321:    */     
/* 322:    */     private String getLabel(Converter converter)
/* 323:    */     {
/* 324:319 */       String label = "";
/* 325:320 */       ServiceReference[] serviceReferences = converter.getConverterChain();
/* 326:322 */       if ((serviceReferences != null) && (serviceReferences.length > 0)) {
/* 327:323 */         label = (String)serviceReferences[(serviceReferences.length - 1)].getProperty(
/* 328:324 */           "label");
/* 329:    */       }
/* 330:327 */       return label;
/* 331:    */     }
/* 332:    */   }
/* 333:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.filesaver.DataFormatChooser
 * JD-Core Version:    0.7.0.1
 */