/*  1:   */ import java.awt.Button;
/*  2:   */ import java.awt.Color;
/*  3:   */ import java.awt.Component;
/*  4:   */ import java.awt.Container;
/*  5:   */ import java.awt.Dialog;
/*  6:   */ import java.awt.Font;
/*  7:   */ import java.awt.Frame;
/*  8:   */ import java.awt.GridBagConstraints;
/*  9:   */ import java.awt.GridBagLayout;
/* 10:   */ import java.awt.Insets;
/* 11:   */ import java.awt.Label;
/* 12:   */ import java.awt.Window;
/* 13:   */ import java.awt.event.ActionEvent;
/* 14:   */ import java.awt.event.ActionListener;
/* 15:   */ import java.awt.event.WindowEvent;
/* 16:   */ import java.awt.event.WindowListener;
/* 17:   */ import java.util.EventObject;
/* 18:   */ 
/* 19:   */ public class MessageDialog
/* 20:   */   extends Dialog
/* 21:   */   implements ActionListener, WindowListener
/* 22:   */ {
/* 23:   */   private static final long serialVersionUID = 1L;
/* 24: 6 */   Button okButton = new Button("OK");
/* 25:   */   
/* 26:   */   public MessageDialog(Frame frame, String title, boolean modal, Component message)
/* 27:   */   {
/* 28: 9 */     super(frame, title, modal);
/* 29:10 */     setForeground(Color.black);
/* 30:11 */     setFont(new Font("Serif", 0, 12));
/* 31:12 */     setLayout(new GridBagLayout());
/* 32:13 */     GridBagConstraints gbc = new GridBagConstraints();
/* 33:14 */     gbc.gridx = 1;
/* 34:15 */     gbc.gridy = 1;
/* 35:16 */     gbc.insets = new Insets(5, 5, 5, 5);
/* 36:17 */     gbc.fill = 0;
/* 37:18 */     add(message, gbc);
/* 38:19 */     gbc.gridy += 1;
/* 39:20 */     add(this.okButton, gbc);
/* 40:21 */     this.okButton.addActionListener(this);
/* 41:22 */     addWindowListener(this);
/* 42:23 */     setResizable(false);
/* 43:24 */     pack();
/* 44:25 */     setVisible(true);
/* 45:   */   }
/* 46:   */   
/* 47:   */   public MessageDialog(Frame frame, String title, boolean modal, String message)
/* 48:   */   {
/* 49:29 */     this(frame, title, modal, new Label(message));
/* 50:   */   }
/* 51:   */   
/* 52:   */   public void actionPerformed(ActionEvent evt)
/* 53:   */   {
/* 54:33 */     if (evt.getSource() == this.okButton)
/* 55:   */     {
/* 56:34 */       setVisible(false);
/* 57:35 */       dispose();
/* 58:   */     }
/* 59:   */   }
/* 60:   */   
/* 61:   */   public void windowClosing(WindowEvent evt)
/* 62:   */   {
/* 63:40 */     this.okButton.dispatchEvent(new ActionEvent(this.okButton, 1001, "OK"));
/* 64:   */   }
/* 65:   */   
/* 66:   */   public void windowOpened(WindowEvent evt) {}
/* 67:   */   
/* 68:   */   public void windowClosed(WindowEvent evt) {}
/* 69:   */   
/* 70:   */   public void windowIconified(WindowEvent evt) {}
/* 71:   */   
/* 72:   */   public void windowDeiconified(WindowEvent evt) {}
/* 73:   */   
/* 74:   */   public void windowActivated(WindowEvent evt) {}
/* 75:   */   
/* 76:   */   public void windowDeactivated(WindowEvent evt) {}
/* 77:   */ }


/* Location:           C:\Users\mark\Dropbox\breastcancerapplet\BreastAppletV81.jar
 * Qualified Name:     MessageDialog
 * JD-Core Version:    0.7.0.1
 */