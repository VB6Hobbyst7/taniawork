/*  1:   */ import java.applet.Applet;
/*  2:   */ import java.awt.Color;
/*  3:   */ import java.awt.Component;
/*  4:   */ import java.awt.Container;
/*  5:   */ import java.awt.Font;
/*  6:   */ import java.awt.Label;
/*  7:   */ import java.net.URL;
/*  8:   */ 
/*  9:   */ public class BreastApplet
/* 10:   */   extends Applet
/* 11:   */ {
/* 12:   */   private static final long serialVersionUID = 1L;
/* 13:   */   
/* 14:   */   public void init()
/* 15:   */   {
/* 16: 8 */     super.init();
/* 17: 9 */     setBackground(Color.white);
/* 18:10 */     setForeground(Color.black);
/* 19:11 */     setFont(new Font("Serif", 0, 12));
/* 20:12 */     add(validHost());
/* 21:   */   }
/* 22:   */   
/* 23:   */   public Component validHost()
/* 24:   */   {
/* 25:17 */     String emailAddress = getParameter("email");
/* 26:19 */      return new BreastPanel(this, "bieber@ualberta.ca");
/* 36:   */   }
/* 37:   */ }


/* Location:           C:\Users\mark\Dropbox\breastcancerapplet\BreastAppletV81.jar
 * Qualified Name:     BreastApplet
 * JD-Core Version:    0.7.0.1
 */