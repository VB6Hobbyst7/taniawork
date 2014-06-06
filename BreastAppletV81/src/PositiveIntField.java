/*   1:    */ import java.awt.Component;
/*   2:    */ import java.awt.TextComponent;
/*   3:    */ import java.awt.TextField;
/*   4:    */ import java.awt.Toolkit;
/*   5:    */ import java.awt.event.InputEvent;
/*   6:    */ import java.awt.event.KeyEvent;
/*   7:    */ import java.awt.event.KeyListener;
/*   8:    */ import java.awt.event.TextEvent;
/*   9:    */ import java.awt.event.TextListener;
/*  10:    */ 
/*  11:    */ public class PositiveIntField
/*  12:    */   extends TextField
/*  13:    */   implements TextListener, KeyListener
/*  14:    */ {
/*  15:    */   private static final long serialVersionUID = 1L;
/*  16:    */   private int maxValue;
/*  17: 27 */   private String lastText = "";
/*  18:    */   
/*  19:    */   public PositiveIntField()
/*  20:    */   {
/*  21: 34 */     this(0, 3, 99);
/*  22:    */   }
/*  23:    */   
/*  24:    */   public PositiveIntField(int val, int width, int maxVal)
/*  25:    */   {
/*  26: 45 */     super(width);
/*  27: 46 */     this.maxValue = maxVal;
/*  28: 47 */     if (val > this.maxValue) {
/*  29: 47 */       val = this.maxValue;
/*  30:    */     }
/*  31: 48 */     if (val < 0) {
/*  32: 48 */       val = 0;
/*  33:    */     }
/*  34: 49 */     setText(String.valueOf(val));
/*  35: 50 */     this.lastText = getText();
/*  36: 51 */     addTextListener(this);
/*  37: 52 */     addKeyListener(this);
/*  38:    */   }
/*  39:    */   
/*  40:    */   public int getValue()
/*  41:    */   {
/*  42: 59 */     return Integer.parseInt(getText());
/*  43:    */   }
/*  44:    */   
/*  45:    */   public void setValue(int val)
/*  46:    */   {
/*  47: 67 */     String newText = String.valueOf(val);
/*  48: 68 */     if (!newText.equals(getText())) {
/*  49: 70 */       setText(newText);
/*  50:    */     }
/*  51:    */   }
/*  52:    */   
/*  53:    */   public void textValueChanged(TextEvent theEvent)
/*  54:    */   {
/*  55: 80 */     if (getText().equals(""))
/*  56:    */     {
/*  57: 81 */       setText("0");
/*  58: 82 */       selectAll();
/*  59:    */     }
/*  60:    */     try
/*  61:    */     {
/*  62: 85 */       int newValue = Integer.parseInt(getText());
/*  63: 86 */       if (newValue > this.maxValue) {
/*  64: 86 */         throw new NumberFormatException();
/*  65:    */       }
/*  66: 87 */       this.lastText = getText();
/*  67:    */     }
/*  68:    */     catch (NumberFormatException e)
/*  69:    */     {
/*  70: 89 */       Toolkit.getDefaultToolkit().beep();
/*  71: 90 */       setText(this.lastText);
/*  72:    */     }
/*  73:    */   }
/*  74:    */   
/*  75:    */   public void keyPressed(KeyEvent theEvent)
/*  76:    */   {
/*  77:100 */     char keyChar = theEvent.getKeyChar();
/*  78:101 */     if (((keyChar < '0') || (keyChar > '9')) && 
/*  79:102 */       (keyChar != '\b') && 
/*  80:103 */       (keyChar != '\t') && 
/*  81:104 */       (keyChar != '') && 
/*  82:105 */       (!theEvent.isActionKey())) {
/*  83:109 */       theEvent.consume();
/*  84:    */     }
/*  85:    */   }
/*  86:    */   
/*  87:    */   public void keyTyped(KeyEvent theEvent) {}
/*  88:    */   
/*  89:    */   public void keyReleased(KeyEvent theEvent) {}
/*  90:    */ }


/* Location:           C:\Users\mark\Dropbox\breastcancerapplet\BreastAppletV81.jar
 * Qualified Name:     PositiveIntField
 * JD-Core Version:    0.7.0.1
 */