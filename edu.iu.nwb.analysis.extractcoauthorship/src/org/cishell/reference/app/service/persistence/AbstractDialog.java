/*   1:    */ package org.cishell.reference.app.service.persistence;
/*   2:    */ 
/*   3:    */ import org.eclipse.swt.events.SelectionAdapter;
/*   4:    */ import org.eclipse.swt.events.SelectionEvent;
/*   5:    */ import org.eclipse.swt.events.ShellAdapter;
/*   6:    */ import org.eclipse.swt.events.ShellEvent;
/*   7:    */ import org.eclipse.swt.graphics.Image;
/*   8:    */ import org.eclipse.swt.graphics.Point;
/*   9:    */ import org.eclipse.swt.graphics.Rectangle;
/*  10:    */ import org.eclipse.swt.layout.GridData;
/*  11:    */ import org.eclipse.swt.layout.GridLayout;
/*  12:    */ import org.eclipse.swt.widgets.Button;
/*  13:    */ import org.eclipse.swt.widgets.Composite;
/*  14:    */ import org.eclipse.swt.widgets.Control;
/*  15:    */ import org.eclipse.swt.widgets.Dialog;
/*  16:    */ import org.eclipse.swt.widgets.Display;
/*  17:    */ import org.eclipse.swt.widgets.Label;
/*  18:    */ import org.eclipse.swt.widgets.Shell;
/*  19:    */ import org.eclipse.swt.widgets.Text;
/*  20:    */ 
/*  21:    */ public abstract class AbstractDialog
/*  22:    */   extends Dialog
/*  23:    */ {
/*  24:    */   private static final int DETAILS_HEIGHT = 75;
/*  25:    */   public static Image INFORMATION;
/*  26:    */   public static Image WARNING;
/*  27:    */   public static Image ERROR;
/*  28:    */   public static Image QUESTION;
/*  29:    */   public static Image WORKING;
/*  30:    */   
/*  31:    */   static
/*  32:    */   {
/*  33: 31 */     Runnable runner = new Runnable()
/*  34:    */     {
/*  35:    */       public void run()
/*  36:    */       {
/*  37: 33 */         AbstractDialog.INFORMATION = Display.getDefault().getSystemImage(2);
/*  38: 34 */         AbstractDialog.WARNING = Display.getDefault().getSystemImage(8);
/*  39: 35 */         AbstractDialog.ERROR = Display.getDefault().getSystemImage(1);
/*  40: 36 */         AbstractDialog.QUESTION = Display.getDefault().getSystemImage(4);
/*  41: 37 */         AbstractDialog.WORKING = Display.getDefault().getSystemImage(16);
/*  42:    */       }
/*  43:    */     };
/*  44: 40 */     if (Display.getDefault().getThread() == Thread.currentThread()) {
/*  45: 41 */       runner.run();
/*  46:    */     } else {
/*  47: 43 */       Display.getDefault().asyncExec(runner);
/*  48:    */     }
/*  49:    */   }
/*  50:    */   
/*  51: 48 */   private String description = "";
/*  52: 49 */   private String detailsString = "";
/*  53:    */   private Text detailsText;
/*  54:    */   private Shell shell;
/*  55:    */   private Image image;
/*  56:    */   private boolean success;
/*  57:    */   private Composite header;
/*  58:    */   private Composite content;
/*  59:    */   private Composite buttons;
/*  60:    */   private Shell parent;
/*  61:    */   
/*  62:    */   public AbstractDialog(Shell parent, String title, Image image)
/*  63:    */   {
/*  64: 60 */     super(parent, 0);
/*  65: 61 */     setText(title);
/*  66: 62 */     this.image = image;
/*  67: 63 */     this.parent = parent;
/*  68: 64 */     init();
/*  69:    */   }
/*  70:    */   
/*  71:    */   public void close(boolean success)
/*  72:    */   {
/*  73: 68 */     this.shell.dispose();
/*  74: 69 */     this.success = success;
/*  75:    */   }
/*  76:    */   
/*  77:    */   public Shell getShell()
/*  78:    */   {
/*  79: 73 */     return this.shell;
/*  80:    */   }
/*  81:    */   
/*  82:    */   public void init()
/*  83:    */   {
/*  84: 77 */     if (this.shell != null) {
/*  85: 78 */       this.shell.dispose();
/*  86:    */     }
/*  87: 80 */     this.shell = new Shell(this.parent, 67696);
/*  88: 82 */     if (this.parent != null) {
/*  89: 83 */       this.shell.setImage(this.parent.getImage());
/*  90:    */     }
/*  91: 85 */     this.shell.setText(getText());
/*  92: 86 */     GridLayout layout = new GridLayout();
/*  93: 87 */     layout.numColumns = 1;
/*  94: 88 */     this.shell.setLayout(layout);
/*  95:    */   }
/*  96:    */   
/*  97:    */   public boolean open()
/*  98:    */   {
/*  99: 92 */     if (this.shell.getDisplay().getThread() == Thread.currentThread()) {
/* 100: 93 */       doOpen();
/* 101:    */     } else {
/* 102: 95 */       this.shell.getDisplay().syncExec(new Runnable()
/* 103:    */       {
/* 104:    */         public void run()
/* 105:    */         {
/* 106: 97 */           AbstractDialog.this.doOpen();
/* 107:    */         }
/* 108:    */       });
/* 109:    */     }
/* 110:101 */     Display display = getParent().getDisplay();
/* 111:103 */     while (!this.shell.isDisposed()) {
/* 112:104 */       if (!display.readAndDispatch()) {
/* 113:105 */         display.sleep();
/* 114:    */       }
/* 115:    */     }
/* 116:109 */     return this.success;
/* 117:    */   }
/* 118:    */   
/* 119:    */   protected void doOpen()
/* 120:    */   {
/* 121:113 */     this.success = true;
/* 122:    */     
/* 123:115 */     setupHeader();
/* 124:116 */     setupContent();
/* 125:117 */     setupButtons();
/* 126:    */     
/* 127:119 */     this.shell.pack();
/* 128:120 */     setLocation();
/* 129:121 */     this.shell.open();
/* 130:122 */     this.shell.addShellListener(new ShellAdapter()
/* 131:    */     {
/* 132:    */       public void shellClosed(ShellEvent e)
/* 133:    */       {
/* 134:124 */         AbstractDialog.this.success = false;
/* 135:    */       }
/* 136:    */     });
/* 137:    */   }
/* 138:    */   
/* 139:    */   private void setLocation()
/* 140:    */   {
/* 141:133 */     Point parentLocation = this.parent.getLocation();
/* 142:134 */     int parentWidth = this.parent.getSize().x;
/* 143:135 */     int parentHeight = this.parent.getSize().y;
/* 144:136 */     int shellWidth = this.shell.getSize().x;
/* 145:137 */     int shellHeight = this.shell.getSize().y;
/* 146:    */     
/* 147:139 */     int x = parentLocation.x + (parentWidth - shellWidth) / 2;
/* 148:140 */     int y = parentLocation.y + (parentHeight - shellHeight) / 2;
/* 149:141 */     this.shell.setLocation(x, y);
/* 150:    */   }
/* 151:    */   
/* 152:    */   public void setDescription(String description)
/* 153:    */   {
/* 154:152 */     this.description = description;
/* 155:    */   }
/* 156:    */   
/* 157:    */   public void setDetails(String details)
/* 158:    */   {
/* 159:163 */     this.detailsString = details;
/* 160:    */   }
/* 161:    */   
/* 162:    */   public abstract void createDialogButtons(Composite paramComposite);
/* 163:    */   
/* 164:    */   public abstract Composite createContent(Composite paramComposite);
/* 165:    */   
/* 166:    */   private void setupHeader()
/* 167:    */   {
/* 168:194 */     this.header = new Composite(this.shell, 0);
/* 169:195 */     this.header.setLayoutData(new GridData(1808));
/* 170:196 */     GridLayout layout = new GridLayout();
/* 171:197 */     layout.numColumns = 2;
/* 172:198 */     this.header.setLayout(layout);
/* 173:    */     
/* 174:200 */     Label canvas = new Label(this.header, 0);
/* 175:201 */     if (this.image != null) {
/* 176:202 */       canvas.setImage(this.image);
/* 177:    */     }
/* 178:204 */     GridData canvasData = new GridData();
/* 179:205 */     canvasData.heightHint = this.image.getBounds().height;
/* 180:206 */     canvas.setLayoutData(canvasData);
/* 181:    */     
/* 182:208 */     Label desc = new Label(this.header, 64);
/* 183:210 */     if ((this.description != null) && (!this.description.equals(""))) {
/* 184:211 */       desc.setText(this.description);
/* 185:    */     }
/* 186:    */   }
/* 187:    */   
/* 188:    */   private void setupContent()
/* 189:    */   {
/* 190:220 */     this.content = createContent(this.shell);
/* 191:222 */     if (this.content != null) {
/* 192:223 */       this.content.setLayoutData(new GridData(1808));
/* 193:    */     }
/* 194:    */   }
/* 195:    */   
/* 196:    */   private void setupButtons()
/* 197:    */   {
/* 198:234 */     this.buttons = new Composite(this.shell, 0);
/* 199:235 */     this.buttons.setLayoutData(new GridData(896));
/* 200:    */     
/* 201:    */ 
/* 202:    */ 
/* 203:    */ 
/* 204:240 */     createDialogButtons(this.buttons);
/* 205:241 */     Control[] controls = this.buttons.getChildren();
/* 206:242 */     GridLayout buttonsLayout = new GridLayout();
/* 207:243 */     buttonsLayout.numColumns = (controls.length + 1);
/* 208:244 */     buttonsLayout.makeColumnsEqualWidth = true;
/* 209:245 */     this.buttons.setLayout(buttonsLayout);
/* 210:248 */     for (int i = 0; i < controls.length; i++) {
/* 211:249 */       controls[i].setLayoutData(new GridData(768));
/* 212:    */     }
/* 213:253 */     final Button details = new Button(this.buttons, 8);
/* 214:254 */     details.setText("Details >>");
/* 215:255 */     details.setLayoutData(new GridData(768));
/* 216:256 */     details.addSelectionListener(new SelectionAdapter()
/* 217:    */     {
/* 218:    */       public synchronized void widgetSelected(SelectionEvent e)
/* 219:    */       {
/* 220:258 */         GridData data = (GridData)AbstractDialog.this.detailsText.getLayoutData();
/* 221:260 */         if (AbstractDialog.this.detailsText.getVisible())
/* 222:    */         {
/* 223:261 */           AbstractDialog.this.detailsText.setText("");
/* 224:262 */           details.setText("Details >>");
/* 225:263 */           data.heightHint = 0;
/* 226:264 */           data.grabExcessHorizontalSpace = false;
/* 227:265 */           data.grabExcessVerticalSpace = false;
/* 228:    */         }
/* 229:    */         else
/* 230:    */         {
/* 231:267 */           AbstractDialog.this.detailsText.setText(AbstractDialog.this.detailsString);
/* 232:268 */           details.setText("Details <<");
/* 233:269 */           data.heightHint = 75;
/* 234:270 */           data.grabExcessHorizontalSpace = true;
/* 235:271 */           data.grabExcessVerticalSpace = true;
/* 236:    */         }
/* 237:274 */         AbstractDialog.this.detailsText.setLayoutData(data);
/* 238:275 */         AbstractDialog.this.detailsText.setVisible(!AbstractDialog.this.detailsText.getVisible());
/* 239:    */         
/* 240:277 */         AbstractDialog.this.shell.setSize(AbstractDialog.this.shell.computeSize(-1, -1));
/* 241:278 */         AbstractDialog.this.shell.layout();
/* 242:    */       }
/* 243:281 */     });
/* 244:282 */     setupDetails();
/* 245:283 */     details.setEnabled((this.detailsString != null) && (!this.detailsString.equals("")));
/* 246:    */   }
/* 247:    */   
/* 248:    */   private void setupDetails()
/* 249:    */   {
/* 250:290 */     this.detailsText = new Text(this.shell, 2624);
/* 251:291 */     this.detailsText.setEditable(false);
/* 252:292 */     this.detailsText.setBackground(Display.getCurrent().getSystemColor(1));
/* 253:    */     
/* 254:294 */     GridData data = new GridData(1808);
/* 255:    */     
/* 256:296 */     data.widthHint = 400;
/* 257:    */     
/* 258:298 */     this.detailsText.setLayoutData(data);
/* 259:299 */     this.detailsText.setVisible(false);
/* 260:    */   }
/* 261:    */   
/* 262:    */   public static boolean openError(Shell parent, String title, String message, String details)
/* 263:    */   {
/* 264:315 */     return openOKDialog(parent, ERROR, title, message, details);
/* 265:    */   }
/* 266:    */   
/* 267:    */   public static boolean openInformation(Shell parent, String title, String message, String details)
/* 268:    */   {
/* 269:330 */     return openOKDialog(parent, INFORMATION, title, message, details);
/* 270:    */   }
/* 271:    */   
/* 272:    */   public static boolean openWarning(Shell parent, String title, String message, String details)
/* 273:    */   {
/* 274:345 */     return openOKDialog(parent, WARNING, title, message, details);
/* 275:    */   }
/* 276:    */   
/* 277:    */   public static boolean openQuestion(Shell parent, String title, String message, String details)
/* 278:    */   {
/* 279:361 */     return openConfirmDenyDialog(parent, QUESTION, title, message, details, "Yes", "No");
/* 280:    */   }
/* 281:    */   
/* 282:    */   public static boolean openConfirm(Shell parent, String title, String message, String details)
/* 283:    */   {
/* 284:377 */     return openConfirmDenyDialog(parent, QUESTION, title, message, details, "OK", "Cancel");
/* 285:    */   }
/* 286:    */   
/* 287:    */   private static boolean openOKDialog(Shell parent, Image image, String title, String message, String details)
/* 288:    */   {
/* 289:384 */     AbstractDialog okDialog = new AbstractDialog(parent, title, image)
/* 290:    */     {
/* 291:    */       public void createDialogButtons(Composite parent)
/* 292:    */       {
/* 293:386 */         Button ok = new Button(parent, 8);
/* 294:387 */         ok.setText("OK");
/* 295:388 */         ok.addSelectionListener(new SelectionAdapter()
/* 296:    */         {
/* 297:    */           public void widgetSelected(SelectionEvent e)
/* 298:    */           {
/* 299:390 */             //AbstractDialog.5.this.close(true);
/* 300:    */           }
/* 301:    */         });
/* 302:    */       }
/* 303:    */       
/* 304:    */       public Composite createContent(Composite parent)
/* 305:    */       {
/* 306:396 */         return null;
/* 307:    */       }
/* 308:398 */     };
/* 309:399 */     okDialog.setDescription(message);
/* 310:400 */     okDialog.setDetails(details);
/* 311:401 */     return okDialog.open();
/* 312:    */   }
/* 313:    */   
/* 314:    */   private static boolean openConfirmDenyDialog(Shell parent, Image image, String title, String message, String details, final String confirmLabel, final String denyLabel)
/* 315:    */   {
/* 316:408 */     AbstractDialog dialog = new AbstractDialog(parent, title, image)
/* 317:    */     {
/* 318:    */       public void createDialogButtons(Composite parent)
/* 319:    */       {
/* 320:410 */         Button confirm = new Button(parent, 8);
/* 321:411 */         if (confirmLabel != null) {
/* 322:412 */           confirm.setText(confirmLabel);
/* 323:    */         }
/* 324:413 */         confirm.addSelectionListener(new SelectionAdapter()
/* 325:    */         {
/* 326:    */           public void widgetSelected(SelectionEvent e)
/* 327:    */           {
/* 328:415 */             //AbstractDialog.6.this.close(true);
/* 329:    */           }
/* 330:417 */         });
/* 331:418 */         Button deny = new Button(parent, 8);
/* 332:419 */         if (denyLabel != null) {
/* 333:420 */           deny.setText(denyLabel);
/* 334:    */         }
/* 335:421 */         deny.addSelectionListener(new SelectionAdapter()
/* 336:    */         {
/* 337:    */           public void widgetSelected(SelectionEvent e)
/* 338:    */           {
/* 339:423 */            // AbstractDialog.6.this.close(false);
/* 340:    */           }
/* 341:    */         });
/* 342:    */       }
/* 343:    */       
/* 344:    */       public Composite createContent(Composite parent)
/* 345:    */       {
/* 346:429 */         return null;
/* 347:    */       }
/* 348:431 */     };
/* 349:432 */     dialog.setDescription(message);
/* 350:433 */     dialog.setDetails(details);
/* 351:434 */     return dialog.open();
/* 352:    */   }
/* 353:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.persistence.AbstractDialog
 * JD-Core Version:    0.7.0.1
 */