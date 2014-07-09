/*   1:    */ public class CancerPatient
/*   2:    */ {
/*   3:    */   public static final int SELECT = 0;
/*   4:    */   public static final int MINOR = 1;
/*   5:    */   public static final int AVERAGE = 2;
/*   6:    */   public static final int MAJOR10 = 3;
/*   7:    */   public static final int MAJOR20 = 4;
/*   8:    */   public static final int MAJOR30 = 5;
/*   9:    */   public static final int FEMALE = 0;
/*  10:    */   public static final int MALE = 1;
/*  11:    */   String name;
/*  12:    */   int age;
/*  13:    */   int sex;
/*  14:    */   int comorbidity;
/*  15:    */   int risk;
/*  16:    */   boolean relapse;
/*  17: 66 */   protected static final float[] womenMortality = { 0.0F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 
/*  18: 67 */     0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 
/*  19: 68 */     0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.06F, 0.06F, 0.06F, 0.07F, 0.07F, 
/*  20: 69 */     0.08F, 0.08F, 0.09F, 0.1F, 0.1F, 0.11F, 0.12F, 0.13F, 0.14F, 0.14F, 
/*  21: 70 */     0.15F, 0.16F, 0.18F, 0.19F, 0.2F, 0.22F, 0.23F, 0.25F, 0.28F, 0.31F, 
/*  22: 71 */     0.34F, 0.37F, 0.41F, 0.45F, 0.49F, 0.54F, 0.59F, 0.65F, 0.71F, 0.79F, 
/*  23: 72 */     0.87F, 0.95F, 1.04F, 1.13F, 1.22F, 1.31F, 1.42F, 1.54F, 1.68F, 1.85F, 
/*  24: 73 */     2.02F, 2.21F, 2.42F, 2.64F, 2.87F, 2.85F, 3.71F, 3.75F, 4.12F, 4.53F, 
/*  25: 74 */     5.01F, 5.55F, 6.17F, 6.9F, 7.75F, 8.72F, 9.8F, 11.01F, 12.38F, 13.92F, 
/*  26: 75 */     15.65F, 17.59F, 19.780001F, 22.23F, 24.99F, 28.1F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  27: 76 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  28: 77 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  29: 78 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  30: 79 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  31: 80 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  32: 81 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  33: 82 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  34: 83 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  35: 84 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  36: 85 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  37: 86 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  38: 87 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F };
/*  39: 89 */   protected static final float[] menMortality = { 0.0F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 
/*  40: 90 */     0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.05F, 0.13F, 
/*  41: 91 */     0.14F, 0.14F, 0.15F, 0.15F, 0.14F, 0.15F, 0.16F, 0.17F, 0.17F, 0.18F, 
/*  42: 92 */     0.19F, 0.2F, 0.21F, 0.22F, 0.22F, 0.23F, 0.25F, 0.27F, 0.28F, 0.3F, 
/*  43: 93 */     0.32F, 0.34F, 0.37F, 0.39F, 0.37F, 0.41F, 0.44F, 0.48F, 0.53F, 0.58F, 
/*  44: 94 */     0.63F, 0.69F, 0.75F, 0.82F, 0.91F, 0.99F, 1.08F, 1.17F, 1.28F, 1.39F, 
/*  45: 95 */     1.52F, 1.65F, 1.8F, 1.96F, 2.2F, 2.38F, 2.58F, 2.8F, 3.03F, 3.29F, 
/*  46: 96 */     3.56F, 3.86F, 4.19F, 4.54F, 4.86F, 5.28F, 5.74F, 6.24F, 6.78F, 7.37F, 
/*  47: 97 */     8.01F, 8.7F, 9.46F, 10.28F, 11.17F, 12.14F, 13.2F, 14.34F, 15.59F, 16.940001F, 
/*  48: 98 */     18.41F, 20.01F, 21.75F, 23.639999F, 25.530001F, 27.57F, 29.780001F, 30.0F, 30.0F, 30.0F, 
/*  49: 99 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  50:100 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  51:101 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  52:102 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  53:103 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  54:104 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  55:105 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  56:106 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  57:107 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  58:108 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  59:109 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 
/*  60:110 */     30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F, 30.0F };
/*  61:    */   
/*  62:    */   public CancerPatient()
/*  63:    */   {
/*  64:127 */     this.name = new String();
/*  65:128 */     this.age = 60;
/*  66:129 */     this.sex = 0;
/*  67:130 */     this.comorbidity = 0;
/*  68:131 */     this.risk = 0;
/*  69:132 */     this.relapse = false;
/*  70:    */   }
/*  71:    */   
/*  72:    */   public CancerPatient(String newName, int newAge, int newSex, int newComorbidity, int newRisk, boolean newRelapse)
/*  73:    */   {
/*  74:156 */     setName(newName);
/*  75:157 */     setAge(newAge);
/*  76:158 */     setSex(newSex);
/*  77:159 */     setComorbidity(newComorbidity);
/*  78:160 */     setRisk(newRisk);
/*  79:161 */     setRelapse(newRelapse);
/*  80:    */   }
/*  81:    */   
/*  82:    */   public void setName(String newName)
/*  83:    */   {
/*  84:171 */     this.name = newName;
/*  85:    */   }
/*  86:    */   
/*  87:    */   public String getName()
/*  88:    */   {
/*  89:181 */     if (this.name == null) {
/*  90:182 */       return new String(" ");
/*  91:    */     }
/*  92:183 */     return this.name;
/*  93:    */   }
/*  94:    */   
/*  95:    */   public void setAge(int newAge)
/*  96:    */   {
/*  97:193 */     this.age = newAge;
/*  98:    */   }
/*  99:    */   
/* 100:    */   public int getAge()
/* 101:    */   {
/* 102:203 */     return this.age;
/* 103:    */   }
/* 104:    */   
/* 105:    */   public void setSex(int newSex)
/* 106:    */   {
/* 107:215 */     if (newSex < 0) {
/* 108:215 */       this.sex = 0;
/* 109:216 */     } else if (newSex > 1) {
/* 110:216 */       this.sex = 1;
/* 111:    */     } else {
/* 112:217 */       this.sex = newSex;
/* 113:    */     }
/* 114:    */   }
/* 115:    */   
/* 116:    */   public int getSex()
/* 117:    */   {
/* 118:229 */     return this.sex;
/* 119:    */   }
/* 120:    */   
/* 121:    */   public void setRisk(int newRisk)
/* 122:    */   {
/* 123:239 */     if (newRisk > 100) {
/* 124:239 */       this.risk = 100;
/* 125:240 */     } else if (newRisk < 0) {
/* 126:240 */       this.risk = 0;
/* 127:    */     } else {
/* 128:241 */       this.risk = newRisk;
/* 129:    */     }
/* 130:    */   }
/* 131:    */   
/* 132:    */   public int getRisk()
/* 133:    */   {
/* 134:251 */     return this.risk;
/* 135:    */   }
/* 136:    */   
/* 137:    */   public void setComorbidity(int newComorbidity)
/* 138:    */   {
/* 139:267 */     if ((newComorbidity > 5) || (newComorbidity < 0)) {
/* 140:267 */       this.comorbidity = 0;
/* 141:    */     } else {
/* 142:268 */       this.comorbidity = newComorbidity;
/* 143:    */     }
/* 144:    */   }
/* 145:    */   
/* 146:    */   public int getComorbidity()
/* 147:    */   {
/* 148:284 */     return this.comorbidity;
/* 149:    */   }
/* 150:    */   
/* 151:    */   public boolean getRelapse()
/* 152:    */   {
/* 153:293 */     return this.relapse;
/* 154:    */   }
/* 155:    */   
/* 156:    */   public void setRelapse(boolean newRelapse)
/* 157:    */   {
/* 158:302 */     this.relapse = newRelapse;
/* 159:    */   }
/* 160:    */ }


/* Location:           C:\Users\mark\Dropbox\breastcancerapplet\BreastAppletV81.jar
 * Qualified Name:     CancerPatient
 * JD-Core Version:    0.7.0.1
 */