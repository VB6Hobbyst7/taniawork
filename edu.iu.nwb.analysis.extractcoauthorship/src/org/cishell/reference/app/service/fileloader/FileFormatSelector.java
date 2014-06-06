/*   1:    */ package org.cishell.reference.app.service.fileloader;
/*   2:    */ 
/*   3:    */ import java.io.File;
/*   4:    */ import org.cishell.framework.algorithm.AlgorithmFactory;
/*   5:    */ import org.cishell.reference.app.service.persistence.AbstractDialog;
/*   6:    */ import org.eclipse.swt.events.MouseAdapter;
/*   7:    */ import org.eclipse.swt.events.MouseEvent;
/*   8:    */ import org.eclipse.swt.events.SelectionAdapter;
/*   9:    */ import org.eclipse.swt.events.SelectionEvent;
/*  10:    */ import org.eclipse.swt.layout.FillLayout;
/*  11:    */ import org.eclipse.swt.layout.GridData;
/*  12:    */ import org.eclipse.swt.layout.GridLayout;
/*  13:    */ import org.eclipse.swt.widgets.Button;
/*  14:    */ import org.eclipse.swt.widgets.Composite;
/*  15:    */ import org.eclipse.swt.widgets.Group;
/*  16:    */ import org.eclipse.swt.widgets.List;
/*  17:    */ import org.eclipse.swt.widgets.Shell;
/*  18:    */ import org.osgi.framework.BundleContext;
/*  19:    */ import org.osgi.framework.ServiceReference;
/*  20:    */ 
/*  21:    */ public class FileFormatSelector
/*  22:    */   extends AbstractDialog
/*  23:    */ {
/*  24:    */   private BundleContext bundleContext;
/*  25:    */   private AlgorithmFactory validator;
/*  26:    */   private ServiceReference[] validatorReferences;
/*  27:    */   private List validatorList;
/*  28:    */   
/*  29:    */   public FileFormatSelector(String title, Shell parent, BundleContext bundleContext, ServiceReference[] validatorReferences, File file)
/*  30:    */   {
/*  31: 50 */     super(parent, title, AbstractDialog.QUESTION);
/*  32: 51 */     this.bundleContext = bundleContext;
/*  33: 52 */     this.validatorReferences = validatorReferences;
/*  34:    */     
/*  35:    */ 
/*  36: 55 */     String descriptionFormat = 
/*  37: 56 */       "The file '%s' can be loaded using one or more of the following formats.%nPlease select the format you would like to try.";
/*  38:    */     
/*  39: 58 */     setDescription(String.format(descriptionFormat, new Object[] { file.getAbsolutePath() }));
/*  40: 59 */     setDetails(
/*  41: 60 */       "This dialog allows the user to choose among all available formats for loading the selected data model.  Choose any of the formats to continue loading the dataset.");
/*  42:    */   }
/*  43:    */   
/*  44:    */   public AlgorithmFactory getValidator()
/*  45:    */   {
/*  46: 66 */     return this.validator;
/*  47:    */   }
/*  48:    */   
/*  49:    */   private Composite initializeGUI(Composite parent)
/*  50:    */   {
/*  51: 70 */     Composite content = new Composite(parent, 0);
/*  52:    */     
/*  53: 72 */     GridLayout layout = new GridLayout();
/*  54: 73 */     layout.numColumns = 1;
/*  55: 74 */     content.setLayout(layout);
/*  56:    */     
/*  57: 76 */     Group validatorGroup = new Group(content, 0);
/*  58:    */     
/*  59: 78 */     validatorGroup.setText("Load as...");
/*  60: 79 */     validatorGroup.setLayout(new FillLayout());
/*  61: 80 */     GridData validatorListGridData = new GridData(1808);
/*  62: 81 */     validatorListGridData.widthHint = 200;
/*  63: 82 */     validatorGroup.setLayoutData(validatorListGridData);
/*  64:    */     
/*  65: 84 */     this.validatorList = new List(validatorGroup, 772);
/*  66:    */     
/*  67: 86 */     initializePersisterList();
/*  68: 87 */     this.validatorList.addMouseListener(new MouseAdapter()
/*  69:    */     {
/*  70:    */       public void mouseDoubleClick(MouseEvent mouseEvent)
/*  71:    */       {
/*  72: 89 */         List list = (List)mouseEvent.getSource();
/*  73: 90 */         int selection = list.getSelectionIndex();
/*  74: 92 */         if (selection != -1) {
/*  75: 93 */           FileFormatSelector.this.selectionMade(selection);
/*  76:    */         }
/*  77:    */       }
/*  78: 97 */     });
/*  79: 98 */     this.validatorList.addSelectionListener(new SelectionAdapter()
/*  80:    */     {
/*  81:    */       public void widgetSelected(SelectionEvent selectionEvent)
/*  82:    */       {
/*  83:100 */         List list = (List)selectionEvent.getSource();
/*  84:101 */         int selection = list.getSelectionIndex();
/*  85:    */       }
/*  86:108 */     });
/*  87:109 */     this.validatorList.setSelection(0);
/*  88:    */     
/*  89:111 */     return content;
/*  90:    */   }
/*  91:    */   
/*  92:    */   private void initializePersisterList()
/*  93:    */   {
/*  94:115 */     for (int ii = 0; ii < this.validatorReferences.length; ii++)
/*  95:    */     {
/*  96:116 */       String name = (String)this.validatorReferences[ii].getProperty("label");
/*  97:122 */       if ((name == null) || (name.length() == 0)) {
/*  98:123 */         name = this.validatorReferences[ii].getClass().getName();
/*  99:    */       }
/* 100:126 */       this.validatorList.add(name);
/* 101:    */     }
/* 102:    */   }
/* 103:    */   
/* 104:    */   private void selectionMade(int selectedIndex)
/* 105:    */   {
/* 106:131 */     this.validator = 
/* 107:132 */       ((AlgorithmFactory)this.bundleContext.getService(this.validatorReferences[selectedIndex]));
/* 108:133 */     close(true);
/* 109:    */   }
/* 110:    */   
/* 111:    */   public void createDialogButtons(Composite parent)
/* 112:    */   {
/* 113:165 */     Button select = new Button(parent, 8);
/* 114:166 */     select.setText("Select");
/* 115:167 */     select.addSelectionListener(new SelectionAdapter()
/* 116:    */     {
/* 117:    */       public void widgetSelected(SelectionEvent selectionEvent)
/* 118:    */       {
/* 119:169 */         int index = FileFormatSelector.this.validatorList.getSelectionIndex();
/* 120:171 */         if (index != -1) {
/* 121:172 */           FileFormatSelector.this.selectionMade(index);
/* 122:    */         }
/* 123:    */       }
/* 124:175 */     });
/* 125:176 */     select.setFocus();
/* 126:    */     
/* 127:178 */     Button cancel = new Button(parent, 0);
/* 128:179 */     cancel.setText("Cancel");
/* 129:180 */     cancel.addSelectionListener(new SelectionAdapter()
/* 130:    */     {
/* 131:    */       public void widgetSelected(SelectionEvent selectionEvent)
/* 132:    */       {
/* 133:182 */         FileFormatSelector.this.close(false);
/* 134:    */       }
/* 135:    */     });
/* 136:    */   }
/* 137:    */   
/* 138:    */   public Composite createContent(Composite parent)
/* 139:    */   {
/* 140:188 */     return initializeGUI(parent);
/* 141:    */   }
/* 142:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.fileloader.FileFormatSelector
 * JD-Core Version:    0.7.0.1
 */