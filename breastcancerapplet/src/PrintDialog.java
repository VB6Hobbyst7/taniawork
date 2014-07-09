/*  1:   */ import java.awt.Button;
/*  2:   */ import java.awt.Checkbox;
/*  3:   */ import java.awt.Choice;
/*  4:   */ import java.awt.Color;
/*  5:   */ import java.awt.Component;
/*  6:   */ import java.awt.Container;
/*  7:   */ import java.awt.Dialog;
/*  8:   */ import java.awt.Frame;
/*  9:   */ import java.awt.GridBagConstraints;
/* 10:   */ import java.awt.GridBagLayout;
/* 11:   */ import java.awt.Insets;
/* 12:   */ import java.awt.Label;
/* 13:   */ import java.awt.Panel;
/* 14:   */ import java.awt.Window;
/* 15:   */ import java.awt.event.ActionEvent;
/* 16:   */ import java.awt.event.ActionListener;
/* 17:   */ import java.awt.event.WindowEvent;
/* 18:   */ import java.awt.event.WindowListener;
/* 19:   */ import java.util.EventObject;
/* 20:   */ 
/* 21:   */ public class PrintDialog
/* 22:   */   extends Dialog
/* 23:   */   implements ActionListener, WindowListener
/* 24:   */ {
/* 25:   */   private static final long serialVersionUID = 1L;
/* 26:   */   private Checkbox all;
/* 27: 8 */   private Checkbox disclaimer = new Checkbox("Print Disclaimer Page", true);
/* 28: 9 */   private Checkbox blackAndWhite = new Checkbox("Optimize for black and white output", false);
/* 29:10 */   private Choice languageList = new Choice();
/* 30:11 */   private Button okButton = new Button("OK");
/* 31:12 */   private Button cancelButton = new Button("Cancel");
/* 32:13 */   private Label languageLabel = new Label("Language:");
/* 33:14 */   private boolean continuePrint = false;
/* 34:   */   
/* 35:   */   public PrintDialog(Frame aFrame, boolean relapse)
/* 36:   */   {
/* 37:17 */     super(aFrame, "Printout options", true);
/* 38:18 */     setForeground(Color.black);
/* 39:19 */     if (relapse) {
/* 40:20 */       this.all = new Checkbox("Print Disease-Free Survival Summary", true);
/* 41:   */     } else {
/* 42:21 */       this.all = new Checkbox("Print Overall Survival Summary", true);
/* 43:   */     }
/* 44:22 */     this.languageList.add("English");
/* 45:23 */     this.languageList.add("Spanish");
/* 46:24 */     this.languageList.add("French");
/* 47:25 */     this.languageList.add("Portuguese (Brazilian)");
/* 48:   */     
/* 49:27 */     Panel contents = new Panel();
/* 50:28 */     contents.setLayout(new GridBagLayout());
/* 51:29 */     GridBagConstraints gbc = new GridBagConstraints();
/* 52:30 */     gbc.anchor = 17;
/* 53:31 */     gbc.gridx = 1;
/* 54:32 */     gbc.gridy = 1;
/* 55:   */     
/* 56:34 */     contents.add(this.disclaimer, gbc);
/* 57:35 */     gbc.gridy += 1;
/* 58:36 */     contents.add(this.all, gbc);
/* 59:37 */     gbc.gridy += 1;
/* 60:38 */     contents.add(this.blackAndWhite, gbc);
/* 61:39 */     gbc.gridy += 1;
/* 62:40 */     gbc.anchor = 10;
/* 63:41 */     Panel tmp = new Panel();
/* 64:42 */     tmp.add(this.languageLabel);
/* 65:43 */     tmp.add(this.languageList);
/* 66:44 */     contents.add(tmp, gbc);
/* 67:45 */     gbc.gridy += 1;
/* 68:46 */     tmp = new Panel();
/* 69:47 */     tmp.add(this.okButton);
/* 70:48 */     tmp.add(this.cancelButton);
/* 71:49 */     contents.add(tmp, gbc);
/* 72:50 */     gbc.insets = new Insets(5, 5, 5, 5);
/* 73:51 */     setLayout(new GridBagLayout());
/* 74:52 */     add(contents, gbc);
/* 75:53 */     this.okButton.addActionListener(this);
/* 76:54 */     this.cancelButton.addActionListener(this);
/* 77:55 */     addWindowListener(this);
/* 78:56 */     pack();
/* 79:57 */     setResizable(false);
/* 80:58 */     setVisible(true);
/* 81:   */   }
/* 82:   */   
/* 83:   */   public void actionPerformed(ActionEvent e)
/* 84:   */   {
/* 85:62 */     if (e.getSource() == this.okButton) {
/* 86:63 */       this.continuePrint = true;
/* 87:   */     }
/* 88:65 */     setVisible(false);
/* 89:   */   }
/* 90:   */   
/* 91:   */   public boolean continuePrinting()
/* 92:   */   {
/* 93:69 */     return this.continuePrint;
/* 94:   */   }
/* 95:   */   
/* 96:   */   public boolean printDisclaimer()
/* 97:   */   {
/* 98:73 */     return this.disclaimer.getState();
/* 99:   */   }
/* :0:   */   
/* :1:   */   public boolean printAllTherapies()
/* :2:   */   {
/* :3:77 */     return this.all.getState();
/* :4:   */   }
/* :5:   */   
/* :6:   */   public int printLanguage()
/* :7:   */   {
/* :8:81 */     return this.languageList.getSelectedIndex();
/* :9:   */   }
/* ;0:   */   
/* ;1:   */   public boolean printBandW()
/* ;2:   */   {
/* ;3:85 */     return this.blackAndWhite.getState();
/* ;4:   */   }
/* ;5:   */   
/* ;6:   */   public void windowClosing(WindowEvent evt)
/* ;7:   */   {
/* ;8:89 */     this.cancelButton.dispatchEvent(new ActionEvent(this.cancelButton, 1001, "OK"));
/* ;9:   */   }
/* <0:   */   
/* <1:   */   public void windowOpened(WindowEvent evt) {}
/* <2:   */   
/* <3:   */   public void windowClosed(WindowEvent evt) {}
/* <4:   */   
/* <5:   */   public void windowIconified(WindowEvent evt) {}
/* <6:   */   
/* <7:   */   public void windowDeiconified(WindowEvent evt) {}
/* <8:   */   
/* <9:   */   public void windowActivated(WindowEvent evt) {}
/* =0:   */   
/* =1:   */   public void windowDeactivated(WindowEvent evt) {}
/* =2:   */ }


/* Location:           C:\Users\mark\Dropbox\breastcancerapplet\BreastAppletV81.jar
 * Qualified Name:     PrintDialog
 * JD-Core Version:    0.7.0.1
 */