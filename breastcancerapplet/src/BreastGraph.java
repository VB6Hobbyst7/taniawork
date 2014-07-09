/*   1:    */ import java.awt.Color;
/*   2:    */ import java.awt.Component;
/*   3:    */ import java.awt.Container;
/*   4:    */ import java.awt.Dimension;
/*   5:    */ import java.awt.Font;
/*   6:    */ import java.awt.Graphics;
/*   7:    */ import java.awt.Panel;
/*   8:    */ 
/*   9:    */ public class BreastGraph
/*  10:    */   extends Panel
/*  11:    */ {
/*  12:    */   private static final long serialVersionUID = 1L;
/*  13:    */   private Dimension mySize;
/*  14:    */   private double[][] osResults;
/*  15:    */   private String[] osStrings;
/*  16: 22 */   private boolean relapse = false;
/*  17:    */   public static final int ENGLISH = 0;
/*  18:    */   public static final int SPANISH = 1;
/*  19:    */   public static final int FRENCH = 2;
/*  20:    */   
/*  21:    */   public BreastGraph()
/*  22:    */   {
/*  23: 41 */     this(false);
/*  24:    */   }
/*  25:    */   
/*  26:    */   public BreastGraph(boolean useRelapse)
/*  27:    */   {
/*  28: 51 */     setBackground(Color.white);
/*  29: 52 */     this.relapse = useRelapse;
/*  30: 53 */     this.mySize = new Dimension(321, 280);
/*  31: 54 */     this.osStrings = new String[6];
/*  32: 55 */     this.osResults = new double[4][4];
/*  33: 56 */     setFont(new Font("Serif", 1, 12));
/*  34:    */   }
/*  35:    */   
/*  36:    */   public Dimension getMinimumSize()
/*  37:    */   {
/*  38: 59 */     return this.mySize;
/*  39:    */   }
/*  40:    */   
/*  41:    */   public Dimension getPreferredSize()
/*  42:    */   {
/*  43: 60 */     return this.mySize;
/*  44:    */   }
/*  45:    */   
/*  46:    */   public Dimension getMaximumSize()
/*  47:    */   {
/*  48: 61 */     return this.mySize;
/*  49:    */   }
/*  50:    */   
/*  51:    */   public void setResults(double[][] newResults, boolean newRelapse)
/*  52:    */   {
/*  53: 64 */     this.osResults = newResults;
/*  54: 65 */     this.relapse = newRelapse;
/*  55: 66 */     generateStrings(0);
/*  56: 67 */     repaint();
/*  57:    */   }
/*  58:    */   
/*  59:    */   private void generateStrings(int language)
/*  60:    */   {
/*  61: 71 */     switch (language)
/*  62:    */     {
/*  63:    */     case 1: 
/*  64:    */       break;
/*  65:    */     case 2: 
/*  66:    */       break;
/*  67:    */     default: 
/*  68: 74 */       generateStringsEnglish();
/*  69:    */     }
/*  70: 76 */     generateStringsEnglish();
/*  71:    */   }
/*  72:    */   
/*  73:    */   private void generateStringsEnglish()
/*  74:    */   {
/*  75: 81 */     if (this.relapse)
/*  76:    */     {
/*  77: 82 */       this.osStrings[0] = (String.valueOf(this.osResults[0][0]) + " alive and without cancer in 10 years.");
/*  78: 83 */       this.osStrings[1] = (String.valueOf(this.osResults[0][2]) + " relapse.");
/*  79: 84 */       this.osStrings[2] = (String.valueOf(this.osResults[0][3]) + " die of other causes.");
/*  80: 85 */       this.osStrings[3] = ("With hormonal therapy:   Benefit = " + String.valueOf(this.osResults[1][1]) + " without relapse.");
/*  81: 86 */       this.osStrings[4] = ("With chemotherapy:   Benefit = " + String.valueOf(this.osResults[2][1]) + " without relapse.");
/*  82: 87 */       this.osStrings[5] = ("With combined therapy:   Benefit = " + String.valueOf(this.osResults[3][1]) + " without relapse.");
/*  83:    */     }
/*  84:    */     else
/*  85:    */     {
/*  86: 89 */       this.osStrings[0] = (String.valueOf(this.osResults[0][0]) + " alive in 10 years.");
/*  87: 90 */       this.osStrings[1] = (String.valueOf(this.osResults[0][2]) + " die of cancer.");
/*  88: 91 */       this.osStrings[2] = (String.valueOf(this.osResults[0][3]) + " die of other causes.");
/*  89: 92 */       this.osStrings[3] = ("With hormonal therapy:   Benefit = " + String.valueOf(this.osResults[1][1]) + " alive.");
/*  90: 93 */       this.osStrings[4] = ("With chemotherapy:   Benefit = " + String.valueOf(this.osResults[2][1]) + " alive.");
/*  91: 94 */       this.osStrings[5] = ("With combined therapy:   Benefit = " + String.valueOf(this.osResults[3][1]) + " alive.");
/*  92:    */     }
/*  93:    */   }
/*  94:    */   
/*  95:    */   public void paint(Graphics g)
/*  96:    */   {
/*  97: 99 */     int res1 = 0;int res2 = 0;int res3 = 0;int res4 = 0;
/*  98:100 */     int startingPoint = 11;
/*  99:101 */     super.paint(g);
/* 100:    */     
/* 101:103 */     g.setColor(Color.white);
/* 102:104 */     g.fillRect(0, 0, 320, 279);
/* 103:105 */     g.setColor(Color.black);
/* 104:106 */     g.drawRect(0, 0, 320, 279);
/* 105:    */     
/* 106:108 */     g.drawString("No additional therapy:", 10, 18);
/* 107:    */     
/* 108:110 */     g.drawString(this.osStrings[3], 10, 134);
/* 109:    */     
/* 110:112 */     g.drawString(this.osStrings[4], 10, 184);
/* 111:    */     
/* 112:114 */     g.drawString(this.osStrings[5], 10, 234);
/* 113:115 */     g.drawRect(10, 240, 301, 25);
/* 114:    */     
/* 115:117 */     drawLegendItem(g, 10, 56, Color.green, this.osStrings[0]);
/* 116:118 */     drawLegendItem(g, 10, 76, Color.red, this.osStrings[1]);
/* 117:119 */     drawLegendItem(g, 10, 96, Color.blue, this.osStrings[2]);
/* 118:    */     
/* 119:    */ 
/* 120:122 */     res1 = (int)Math.round(this.osResults[0][0] * 3.0D);
/* 121:123 */     res2 = (int)Math.round(this.osResults[0][1] * 3.0D);
/* 122:124 */     res3 = (int)Math.round(this.osResults[0][2] * 3.0D);
/* 123:125 */     res4 = (int)Math.round(this.osResults[0][3] * 3.0D);
/* 124:    */     
/* 125:127 */     res2 += 300 - (res1 + res2 + res3 + res4);
/* 126:    */     
/* 127:129 */     draw1Graph(g, startingPoint, 25, res1, res2, res3, res4);
/* 128:    */     
/* 129:    */ 
/* 130:132 */     res1 = (int)Math.round(this.osResults[1][0] * 3.0D);
/* 131:133 */     res2 = (int)Math.round(this.osResults[1][1] * 3.0D);
/* 132:134 */     res3 = (int)Math.round(this.osResults[1][2] * 3.0D);
/* 133:135 */     res4 = (int)Math.round(this.osResults[1][3] * 3.0D);
/* 134:    */     
/* 135:137 */     res3 += 300 - (res1 + res2 + res3 + res4);
/* 136:    */     
/* 137:139 */     draw1Graph(g, startingPoint, 141, res1, res2, res3, res4);
/* 138:    */     
/* 139:    */ 
/* 140:142 */     res1 = (int)Math.round(this.osResults[2][0] * 3.0D);
/* 141:143 */     res2 = (int)Math.round(this.osResults[2][1] * 3.0D);
/* 142:144 */     res3 = (int)Math.round(this.osResults[2][2] * 3.0D);
/* 143:145 */     res4 = (int)Math.round(this.osResults[2][3] * 3.0D);
/* 144:    */     
/* 145:147 */     res3 += 300 - (res1 + res2 + res3 + res4);
/* 146:    */     
/* 147:149 */     draw1Graph(g, startingPoint, 191, res1, res2, res3, res4);
/* 148:    */     
/* 149:    */ 
/* 150:152 */     res1 = (int)Math.round(this.osResults[3][0] * 3.0D);
/* 151:153 */     res2 = (int)Math.round(this.osResults[3][1] * 3.0D);
/* 152:154 */     res3 = (int)Math.round(this.osResults[3][2] * 3.0D);
/* 153:155 */     res4 = (int)Math.round(this.osResults[3][3] * 3.0D);
/* 154:    */     
/* 155:157 */     res3 += 300 - (res1 + res2 + res3 + res4);
/* 156:    */     
/* 157:159 */     draw1Graph(g, startingPoint, 241, res1, res2, res3, res4);
/* 158:    */   }
/* 159:    */   
/* 160:    */   private void drawLegendItem(Graphics g, int posX, int posY, Color fillColor, String text)
/* 161:    */   {
/* 162:163 */     g.setColor(fillColor);
/* 163:164 */     g.fillRect(posX, posY, 12, 12);
/* 164:165 */     g.setColor(Color.black);
/* 165:166 */     g.drawRect(posX, posY, 12, 12);
/* 166:167 */     g.drawString(text, posX + 18, posY + 12);
/* 167:    */   }
/* 168:    */   
/* 169:    */   private void draw1Graph(Graphics g, int posX, int posY, int val1, int val2, int val3, int val4)
/* 170:    */   {
/* 171:171 */     int startingPoint = posX;
/* 172:172 */     if (val1 > 0)
/* 173:    */     {
/* 174:173 */       g.setColor(Color.green);
/* 175:174 */       g.fillRect(startingPoint, posY, val1, 24);
/* 176:175 */       startingPoint += val1;
/* 177:    */     }
/* 178:177 */     if (val2 > 0)
/* 179:    */     {
/* 180:178 */       g.setColor(Color.yellow);
/* 181:179 */       g.fillRect(startingPoint, posY, val2, 24);
/* 182:180 */       startingPoint += val2;
/* 183:    */     }
/* 184:182 */     if (val3 > 0)
/* 185:    */     {
/* 186:183 */       g.setColor(Color.red);
/* 187:184 */       g.fillRect(startingPoint, posY, val3, 24);
/* 188:185 */       startingPoint += val3;
/* 189:    */     }
/* 190:187 */     if (val4 > 0)
/* 191:    */     {
/* 192:188 */       g.setColor(Color.blue);
/* 193:189 */       g.fillRect(startingPoint, posY, val4, 24);
/* 194:    */     }
/* 195:191 */     g.setColor(Color.black);
/* 196:192 */     g.drawRect(posX - 1, posY - 1, 301, 25);
/* 197:    */   }
/* 198:    */ }


/* Location:           C:\Users\mark\Dropbox\breastcancerapplet\BreastAppletV81.jar
 * Qualified Name:     BreastGraph
 * JD-Core Version:    0.7.0.1
 */