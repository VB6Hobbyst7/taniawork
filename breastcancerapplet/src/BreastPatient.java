/*    1:     */ public class BreastPatient
/*    2:     */   extends CancerPatient
/*    3:     */ {
/*    4:  24 */   private int hormEffect = 0;
/*    5:  25 */   private int chemoEffect = 0;
/*    6:  26 */   private int combEffect = 0;
/*    7:  27 */   private int tumorSize = 0;
/*    8:  28 */   private int positiveNodes = 0;
/*    9:  29 */   private int erStatus = 0;
/*   10:  30 */   private int tumorGrade = 0;
/*   11:  31 */   private double[] curveResults = new double[36];
/*   12:  32 */   private double[] surviveResults = new double[5];
/*   13:  33 */   private double[][] results = { { 0.0D, 0.0D, 0.0D, 0.0D }, 
/*   14:  34 */     { 0.0D, 0.0D, 0.0D, 0.0D }, 
/*   15:  35 */     { 0.0D, 0.0D, 0.0D, 0.0D }, 
/*   16:  36 */     { 0.0D, 0.0D, 0.0D, 0.0D } };
/*   17:     */   public static final int ER_UNKNOWN = 0;
/*   18:     */   public static final int ER_POSITIVE = 1;
/*   19:     */   public static final int ER_NEGATIVE = 2;
/*   20:     */   public static final int NODE_NEG = 0;
/*   21:     */   public static final int NODE_1TO3 = 1;
/*   22:     */   public static final int NODE_4TO9 = 2;
/*   23:     */   public static final int NODE_10PLUS = 3;
/*   24:     */   public static final int GRADE_UNKNOWN = 0;
/*   25:     */   public static final int GRADE_1 = 1;
/*   26:     */   public static final int GRADE_2 = 2;
/*   27:     */   public static final int GRADE_3 = 3;
/*   28:     */   public static final int SIZE_0 = 0;
/*   29:     */   public static final int SIZE_1 = 1;
/*   30:     */   public static final int SIZE_2 = 2;
/*   31:     */   public static final int SIZE_3 = 3;
/*   32:     */   public static final int SIZE_4 = 4;
/*   33:     */   
/*   34:     */   public BreastPatient()
/*   35:     */   {
/*   36: 122 */     setComorbidity(1);
/*   37: 123 */     setERStatus(0);
/*   38: 124 */     setTumorGrade(0);
/*   39: 125 */     setTumorSize(0);
/*   40: 126 */     setPositiveNodes(0);
/*   41: 127 */     calculateRisk();
/*   42: 128 */     this.hormEffect = 23;
/*   43: 129 */     this.chemoEffect = 10;
/*   44: 130 */     this.combEffect = 31;
/*   45:     */   }
/*   46:     */   
/*   47:     */   public BreastPatient(String newName, int newAge, int newComorbidity, int newRisk, boolean newRelapse, int newHorm, int newChemo, int newComb)
/*   48:     */   {
/*   49: 147 */     super(newName, newAge, 0, newComorbidity, newRisk, newRelapse);
/*   50: 148 */     this.hormEffect = newHorm;
/*   51: 149 */     this.chemoEffect = newChemo;
/*   52: 150 */     this.combEffect = newComb;
/*   53:     */   }
/*   54:     */   
/*   55:     */   public void calculateResults()
/*   56:     */   {
/*   57: 162 */     int adjustedAge = getAge();
/*   58: 163 */     int yearsAdded = 0;
/*   59: 164 */     double mortBCMA = 0.0D;
/*   60: 165 */     double[] xcm = new double[101];
/*   61: 166 */     double xnma = 0.0D;
/*   62: 167 */     double[] xnmb = new double[15];
/*   63: 168 */     double[] mortCMT = new double[101];
/*   64: 169 */     double[] mortNMT = new double[101];
/*   65: 170 */     double[] mortTMT = new double[101];
/*   66: 171 */     double[] sur = new double[101];
/*   67: 172 */     double[] mortSurv = new double[101];
/*   68: 173 */     double sumNMort = 0.0D;
/*   69: 174 */     double sumCMort = 0.0D;
/*   70: 176 */     switch (getComorbidity())
/*   71:     */     {
/*   72:     */     case 3: 
/*   73: 177 */       yearsAdded = 10; break;
/*   74:     */     case 4: 
/*   75: 178 */       yearsAdded = 20; break;
/*   76:     */     case 5: 
/*   77: 179 */       yearsAdded = 30; break;
/*   78:     */     default: 
/*   79: 180 */       yearsAdded = 0;
/*   80:     */     }
/*   81: 184 */     if (getERStatus() == 1)
/*   82:     */     {
/*   83: 185 */       xcm[0] = 0.25D;
/*   84: 186 */       xcm[1] = 0.51D;
/*   85: 187 */       xcm[2] = 1.01D;
/*   86: 188 */       xcm[3] = 1.52D;
/*   87: 189 */       xcm[4] = 1.72D;
/*   88: 190 */       xcm[5] = 1.92D;
/*   89: 191 */       xcm[6] = 2.02D;
/*   90: 192 */       xcm[7] = 2.02D;
/*   91: 193 */       xcm[8] = 2.02D;
/*   92: 194 */       xcm[9] = 2.02D;
/*   93: 195 */       for (int i = 10; i <= 100; i++) {
/*   94: 196 */         xcm[i] = (2.02D * Math.pow(0.8705000000000001D, i - 10));
/*   95:     */       }
/*   96:     */     }
/*   97: 197 */     else if (getERStatus() == 2)
/*   98:     */     {
/*   99: 198 */       xcm[0] = 0.66D;
/*  100: 199 */       xcm[1] = 1.3D;
/*  101: 200 */       xcm[2] = 2.24D;
/*  102: 201 */       xcm[3] = 3.14D;
/*  103: 202 */       xcm[4] = 2.66D;
/*  104: 203 */       xcm[5] = 1.45D;
/*  105: 204 */       xcm[6] = 1.19D;
/*  106: 205 */       xcm[7] = 0.95D;
/*  107: 206 */       xcm[8] = 0.78D;
/*  108: 207 */       xcm[9] = 0.63D;
/*  109: 208 */       for (int i = 10; i <= 100; i++) {
/*  110: 209 */         xcm[i] = (0.47D * Math.pow(0.8120000000000001D, i - 10));
/*  111:     */       }
/*  112:     */     }
/*  113:     */     else
/*  114:     */     {
/*  115: 212 */       xcm[0] = 0.25D;
/*  116: 213 */       xcm[1] = 0.51D;
/*  117: 214 */       xcm[2] = 1.01D;
/*  118: 215 */       xcm[3] = 1.52D;
/*  119: 216 */       xcm[4] = 1.72D;
/*  120: 217 */       xcm[5] = 1.92D;
/*  121: 218 */       xcm[6] = 2.02D;
/*  122: 219 */       xcm[7] = 2.02D;
/*  123: 220 */       xcm[8] = 2.02D;
/*  124: 221 */       xcm[9] = 2.02D;
/*  125: 222 */       for (int i = 10; i <= 100; i++) {
/*  126: 223 */         xcm[i] = (2.02D * Math.pow(0.8705000000000001D, i - 10));
/*  127:     */       }
/*  128:     */     }
/*  129: 227 */     for (int loop = 0; loop < 4; loop++)
/*  130:     */     {
/*  131: 229 */       mortBCMA = (100.0D - getRisk()) / 100.0D;
/*  132: 230 */       mortBCMA = 1.0D - Math.pow(mortBCMA, 0.066666667D);
/*  133: 231 */       mortBCMA *= 100.0D;
/*  134: 232 */       switch (loop)
/*  135:     */       {
/*  136:     */       case 1: 
/*  137: 233 */         mortBCMA *= (100 - getHormoneEffect()) / 100.0D; break;
/*  138:     */       case 2: 
/*  139: 234 */         mortBCMA *= (100 - getChemoEffect()) / 100.0D; break;
/*  140:     */       case 3: 
/*  141: 235 */         mortBCMA *= (100 - getCombinedEffect()) / 100.0D;
/*  142:     */       }
/*  143: 239 */       for (int i = 0; i <= 100; i++) {
/*  144: 240 */         mortCMT[i] = (100.0D * (1.0D - Math.pow((100.0D - mortBCMA) / 100.0D, xcm[i])));
/*  145:     */       }
/*  146: 244 */       if (adjustedAge < 20) {
/*  147: 244 */         adjustedAge = 20;
/*  148:     */       }
/*  149: 245 */       if (adjustedAge > 90) {
/*  150: 245 */         adjustedAge = 90;
/*  151:     */       }
/*  152: 246 */       xnma = 160.36000000000001D - 4.04D * adjustedAge + 0.03D * Math.pow(adjustedAge, 2.0D);
/*  153: 247 */       for (int i = 0; i < 15; i++)
/*  154:     */       {
/*  155: 248 */         xnmb[i] = (xnma + 4.3D * i);
/*  156: 249 */         if (xnmb[i] > 100.0D) {
/*  157: 250 */           xnmb[i] = 100.0D;
/*  158:     */         }
/*  159: 251 */         if (getComorbidity() == 0) {
/*  160: 252 */           xnmb[i] /= 100.0D;
/*  161: 254 */         } else if (getComorbidity() == 1) {
/*  162: 255 */           xnmb[i] = ((xnmb[i] / 100.0D + 1.0D) / 2.0D);
/*  163:     */         } else {
/*  164: 256 */           xnmb[i] = 1.0D;
/*  165:     */         }
/*  166:     */       }
/*  167: 259 */       for (int i = 0; i < 15; i++) {
/*  168: 260 */         mortNMT[i] = (CancerPatient.womenMortality[(adjustedAge + i + yearsAdded)] * xnmb[i]);
/*  169:     */       }
/*  170: 261 */       for (int i = 15; i < 101; i++)
/*  171:     */       {
/*  172: 262 */         mortNMT[i] = CancerPatient.womenMortality[(adjustedAge + i + yearsAdded)];
/*  173: 263 */         if (mortNMT[i] > 20.0D) {
/*  174: 263 */           mortNMT[i] = 20.0D;
/*  175:     */         }
/*  176:     */       }
/*  177: 267 */       for (int i = 0; i < 101; i++) {
/*  178: 268 */         mortTMT[i] = (100.0D - (mortCMT[i] + mortNMT[i]));
/*  179:     */       }
/*  180: 272 */       sur[0] = 100.0D;
/*  181: 273 */       mortSurv[0] = 100.0D;
/*  182: 274 */       for (int i = 1; i < 101; i++)
/*  183:     */       {
/*  184: 275 */         sur[i] = (sur[(i - 1)] * (100.0D - mortNMT[(i - 1)]) / 100.0D);
/*  185: 276 */         if (sur[i] < 0.0D) {
/*  186: 276 */           sur[i] = 0.0D;
/*  187:     */         }
/*  188: 277 */         mortSurv[i] = (mortSurv[(i - 1)] * mortTMT[(i - 1)] / 100.0D);
/*  189: 278 */         if (mortSurv[i] < 0.0D) {
/*  190: 278 */           mortSurv[i] = 0.0D;
/*  191:     */         }
/*  192:     */       }
/*  193: 282 */       switch (loop)
/*  194:     */       {
/*  195:     */       case 0: 
/*  196: 283 */         for (int i = 0; i < 7; i++)
/*  197:     */         {
/*  198: 284 */           this.curveResults[i] = sur[(5 * i)];
/*  199: 285 */           this.curveResults[(i + 7)] = mortSurv[(5 * i)];
/*  200:     */         }
/*  201: 287 */         break;
/*  202:     */       case 1: 
/*  203: 288 */         for (int i = 0; i < 7; i++) {
/*  204: 289 */           this.curveResults[(i + 14)] = mortSurv[(5 * i)];
/*  205:     */         }
/*  206: 291 */         break;
/*  207:     */       case 2: 
/*  208: 292 */         for (int i = 0; i < 7; i++) {
/*  209: 293 */           this.curveResults[(i + 21)] = mortSurv[(5 * i)];
/*  210:     */         }
/*  211: 295 */         break;
/*  212:     */       case 3: 
/*  213: 296 */         for (int i = 0; i < 7; i++) {
/*  214: 297 */           this.curveResults[(i + 28)] = mortSurv[(5 * i)];
/*  215:     */         }
/*  216:     */       }
/*  217: 302 */       for (int i = 0; i < 36; i++)
/*  218:     */       {
/*  219: 303 */         if (this.curveResults[i] < 0.0D) {
/*  220: 303 */           this.curveResults[i] = 0.0D;
/*  221:     */         }
/*  222: 304 */         if (this.curveResults[i] > 100.0D) {
/*  223: 304 */           this.curveResults[i] = 100.0D;
/*  224:     */         }
/*  225:     */       }
/*  226: 308 */       if (loop == 0)
/*  227:     */       {
/*  228: 309 */         sumNMort = 100.0D;
/*  229: 310 */         for (int i = 1; i < 101; i++) {
/*  230: 311 */           sumNMort += sur[i];
/*  231:     */         }
/*  232: 312 */         this.surviveResults[0] = (sumNMort / 100.0D);
/*  233:     */       }
/*  234: 314 */       sumNMort = 0.0D;
/*  235: 315 */       for (int i = 0; i < 101; i++) {
/*  236: 316 */         sumNMort += mortSurv[i];
/*  237:     */       }
/*  238: 317 */       this.surviveResults[(loop + 1)] = (sumNMort / 100.0D);
/*  239: 320 */       for (int i = 0; i < 51; i++) {
/*  240: 321 */         mortNMT[i] *= mortSurv[i];
/*  241:     */       }
/*  242: 323 */       for (int i = 0; i < 51; i++) {
/*  243: 324 */         mortCMT[i] *= mortSurv[i];
/*  244:     */       }
/*  245: 327 */       sumNMort = 0.0D;
/*  246: 328 */       sumCMort = 0.0D;
/*  247: 329 */       for (int i = 0; i < 10; i++)
/*  248:     */       {
/*  249: 330 */         sumNMort += mortNMT[i];
/*  250: 331 */         sumCMort += mortCMT[i];
/*  251:     */       }
/*  252: 333 */       sumNMort /= 100.0D;
/*  253: 334 */       sumCMort /= 100.0D;
/*  254:     */       
/*  255:     */ 
/*  256: 337 */       sumNMort = Math.round(sumNMort * 10.0D) / 10.0D;
/*  257: 338 */       sumCMort = Math.round(sumCMort * 10.0D) / 10.0D;
/*  258: 341 */       if (loop == 0)
/*  259:     */       {
/*  260: 342 */         this.results[0][3] = sumNMort;
/*  261: 343 */         this.results[0][2] = sumCMort;
/*  262: 344 */         this.results[0][1] = 0.0D;
/*  263: 345 */         this.results[0][0] = (Math.round((100.0D - sumNMort - sumCMort) * 10.0D) / 10.0D);
/*  264:     */       }
/*  265:     */       else
/*  266:     */       {
/*  267: 348 */         this.results[loop][3] = sumNMort;
/*  268: 349 */         this.results[loop][2] = sumCMort;
/*  269: 350 */         this.results[loop][0] = this.results[0][0];
/*  270: 351 */         this.results[loop][1] = (Math.round((100.0D - this.results[loop][2] - this.results[loop][3] - this.results[loop][0]) * 10.0D) / 10.0D);
/*  271:     */       }
/*  272:     */     }
/*  273:     */   }
/*  274:     */   
/*  275:     */   public void calculateRisk()
/*  276:     */   {
/*  277: 373 */     int nodeCode = getPositiveNodes();
/*  278: 374 */     int tumorCode = getTumorSize();
/*  279:     */     
/*  280:     */ 
/*  281:     */ 
/*  282: 378 */     double newCode = 5555.0D;
/*  283: 380 */     if (nodeCode > 0)
/*  284:     */     {
/*  285: 381 */       if (tumorCode == 1) {
/*  286: 381 */         tumorCode = 0;
/*  287:     */       }
/*  288: 382 */       if (tumorCode == 2) {
/*  289: 382 */         tumorCode = 1;
/*  290:     */       }
/*  291: 383 */       if (tumorCode == 3) {
/*  292: 383 */         tumorCode = 1;
/*  293:     */       }
/*  294: 384 */       if (tumorCode == 4) {
/*  295: 384 */         tumorCode = 2;
/*  296:     */       }
/*  297:     */     }
/*  298: 389 */     int indexCode = getPositiveNodes() * 1000 + tumorCode * 100 + getTumorGrade() * 10 + getERStatus();
/*  299: 390 */     switch (indexCode)
/*  300:     */     {
/*  301:     */     case 0: 
/*  302: 395 */       setRisk(4); break;
/*  303:     */     case 1: 
/*  304: 396 */       setRisk(3); break;
/*  305:     */     case 2: 
/*  306: 397 */       setRisk(6); break;
/*  307:     */     case 10: 
/*  308: 398 */       setRisk(2); break;
/*  309:     */     case 11: 
/*  310: 399 */       setRisk(1); break;
/*  311:     */     case 12: 
/*  312: 400 */       setRisk(3); break;
/*  313:     */     case 20: 
/*  314: 401 */       setRisk(4); break;
/*  315:     */     case 21: 
/*  316: 402 */       setRisk(3); break;
/*  317:     */     case 22: 
/*  318: 403 */       setRisk(5); break;
/*  319:     */     case 30: 
/*  320: 404 */       setRisk(6); break;
/*  321:     */     case 31: 
/*  322: 405 */       setRisk(5); break;
/*  323:     */     case 32: 
/*  324: 406 */       setRisk(8); break;
/*  325:     */     case 100: 
/*  326: 408 */       setRisk(10); break;
/*  327:     */     case 101: 
/*  328: 409 */       setRisk(8); break;
/*  329:     */     case 102: 
/*  330: 410 */       setRisk(15); break;
/*  331:     */     case 110: 
/*  332: 411 */       setRisk(4); break;
/*  333:     */     case 111: 
/*  334: 412 */       setRisk(3); break;
/*  335:     */     case 112: 
/*  336: 413 */       setRisk(6); break;
/*  337:     */     case 120: 
/*  338: 414 */       setRisk(9); break;
/*  339:     */     case 121: 
/*  340: 415 */       setRisk(8); break;
/*  341:     */     case 122: 
/*  342: 416 */       setRisk(14); break;
/*  343:     */     case 130: 
/*  344: 417 */       setRisk(14); break;
/*  345:     */     case 131: 
/*  346: 418 */       setRisk(13); break;
/*  347:     */     case 132: 
/*  348: 419 */       setRisk(17); break;
/*  349:     */     case 200: 
/*  350: 421 */       setRisk(23); break;
/*  351:     */     case 201: 
/*  352: 422 */       setRisk(20); break;
/*  353:     */     case 202: 
/*  354: 423 */       setRisk(29); break;
/*  355:     */     case 210: 
/*  356: 424 */       setRisk(11); break;
/*  357:     */     case 211: 
/*  358: 425 */       setRisk(9); break;
/*  359:     */     case 212: 
/*  360: 426 */       setRisk(16); break;
/*  361:     */     case 220: 
/*  362: 427 */       setRisk(19); break;
/*  363:     */     case 221: 
/*  364: 428 */       setRisk(17); break;
/*  365:     */     case 222: 
/*  366: 429 */       setRisk(29); break;
/*  367:     */     case 230: 
/*  368: 430 */       setRisk(27); break;
/*  369:     */     case 231: 
/*  370: 431 */       setRisk(24); break;
/*  371:     */     case 232: 
/*  372: 432 */       setRisk(31); break;
/*  373:     */     case 300: 
/*  374: 434 */       setRisk(30); break;
/*  375:     */     case 301: 
/*  376: 435 */       setRisk(27); break;
/*  377:     */     case 302: 
/*  378: 436 */       setRisk(36); break;
/*  379:     */     case 310: 
/*  380: 437 */       setRisk(15); break;
/*  381:     */     case 311: 
/*  382: 438 */       setRisk(14); break;
/*  383:     */     case 312: 
/*  384: 439 */       setRisk(20); break;
/*  385:     */     case 320: 
/*  386: 440 */       setRisk(26); break;
/*  387:     */     case 321: 
/*  388: 441 */       setRisk(24); break;
/*  389:     */     case 322: 
/*  390: 442 */       setRisk(33); break;
/*  391:     */     case 330: 
/*  392: 443 */       setRisk(33); break;
/*  393:     */     case 331: 
/*  394: 444 */       setRisk(32); break;
/*  395:     */     case 332: 
/*  396: 445 */       setRisk(35); break;
/*  397:     */     case 400: 
/*  398: 447 */       setRisk(34); break;
/*  399:     */     case 401: 
/*  400: 448 */       setRisk(31); break;
/*  401:     */     case 402: 
/*  402: 449 */       setRisk(41); break;
/*  403:     */     case 410: 
/*  404: 450 */       setRisk(17); break;
/*  405:     */     case 411: 
/*  406: 451 */       setRisk(16); break;
/*  407:     */     case 412: 
/*  408: 452 */       setRisk(23); break;
/*  409:     */     case 420: 
/*  410: 453 */       setRisk(30); break;
/*  411:     */     case 421: 
/*  412: 454 */       setRisk(28); break;
/*  413:     */     case 422: 
/*  414: 455 */       setRisk(38); break;
/*  415:     */     case 430: 
/*  416: 456 */       setRisk(38); break;
/*  417:     */     case 431: 
/*  418: 457 */       setRisk(36); break;
/*  419:     */     case 432: 
/*  420: 458 */       setRisk(40); break;
/*  421:     */     case 1000: 
/*  422: 460 */       setRisk(24); break;
/*  423:     */     case 1001: 
/*  424: 461 */       setRisk(21); break;
/*  425:     */     case 1002: 
/*  426: 462 */       setRisk(31); break;
/*  427:     */     case 1010: 
/*  428: 463 */       setRisk(10); break;
/*  429:     */     case 1011: 
/*  430: 464 */       setRisk(9); break;
/*  431:     */     case 1012: 
/*  432: 465 */       setRisk(13); break;
/*  433:     */     case 1020: 
/*  434: 466 */       setRisk(18); break;
/*  435:     */     case 1021: 
/*  436: 467 */       setRisk(17); break;
/*  437:     */     case 1022: 
/*  438: 468 */       setRisk(30); break;
/*  439:     */     case 1030: 
/*  440: 469 */       setRisk(33); break;
/*  441:     */     case 1031: 
/*  442: 470 */       setRisk(30); break;
/*  443:     */     case 1032: 
/*  444: 471 */       setRisk(33); break;
/*  445:     */     case 1100: 
/*  446: 473 */       setRisk(42); break;
/*  447:     */     case 1101: 
/*  448: 474 */       setRisk(40); break;
/*  449:     */     case 1102: 
/*  450: 475 */       setRisk(50); break;
/*  451:     */     case 1110: 
/*  452: 476 */       setRisk(22); break;
/*  453:     */     case 1111: 
/*  454: 477 */       setRisk(20); break;
/*  455:     */     case 1112: 
/*  456: 478 */       setRisk(30); break;
/*  457:     */     case 1120: 
/*  458: 479 */       setRisk(36); break;
/*  459:     */     case 1121: 
/*  460: 480 */       setRisk(35); break;
/*  461:     */     case 1122: 
/*  462: 481 */       setRisk(48); break;
/*  463:     */     case 1130: 
/*  464: 482 */       setRisk(48); break;
/*  465:     */     case 1131: 
/*  466: 483 */       setRisk(45); break;
/*  467:     */     case 1132: 
/*  468: 484 */       setRisk(52); break;
/*  469:     */     case 1200: 
/*  470: 486 */       setRisk(54); break;
/*  471:     */     case 1201: 
/*  472: 487 */       setRisk(53); break;
/*  473:     */     case 1202: 
/*  474: 488 */       setRisk(65); break;
/*  475:     */     case 1210: 
/*  476: 489 */       setRisk(30); break;
/*  477:     */     case 1211: 
/*  478: 490 */       setRisk(27); break;
/*  479:     */     case 1212: 
/*  480: 491 */       setRisk(40); break;
/*  481:     */     case 1220: 
/*  482: 492 */       setRisk(47); break;
/*  483:     */     case 1221: 
/*  484: 493 */       setRisk(46); break;
/*  485:     */     case 1222: 
/*  486: 494 */       setRisk(61); break;
/*  487:     */     case 1230: 
/*  488: 495 */       setRisk(61); break;
/*  489:     */     case 1231: 
/*  490: 496 */       setRisk(58); break;
/*  491:     */     case 1232: 
/*  492: 497 */       setRisk(65); break;
/*  493:     */     case 2000: 
/*  494: 499 */       setRisk(45); break;
/*  495:     */     case 2001: 
/*  496: 500 */       setRisk(41); break;
/*  497:     */     case 2002: 
/*  498: 501 */       setRisk(55); break;
/*  499:     */     case 2010: 
/*  500: 502 */       setRisk(24); break;
/*  501:     */     case 2011: 
/*  502: 503 */       setRisk(22); break;
/*  503:     */     case 2012: 
/*  504: 504 */       setRisk(31); break;
/*  505:     */     case 2020: 
/*  506: 505 */       setRisk(36); break;
/*  507:     */     case 2021: 
/*  508: 506 */       setRisk(33); break;
/*  509:     */     case 2022: 
/*  510: 507 */       setRisk(45); break;
/*  511:     */     case 2030: 
/*  512: 508 */       setRisk(54); break;
/*  513:     */     case 2031: 
/*  514: 509 */       setRisk(52); break;
/*  515:     */     case 2032: 
/*  516: 510 */       setRisk(60); break;
/*  517:     */     case 2100: 
/*  518: 512 */       setRisk(59); break;
/*  519:     */     case 2101: 
/*  520: 513 */       setRisk(56); break;
/*  521:     */     case 2102: 
/*  522: 514 */       setRisk(64); break;
/*  523:     */     case 2110: 
/*  524: 515 */       setRisk(32); break;
/*  525:     */     case 2111: 
/*  526: 516 */       setRisk(31); break;
/*  527:     */     case 2112: 
/*  528: 517 */       setRisk(38); break;
/*  529:     */     case 2120: 
/*  530: 518 */       setRisk(47); break;
/*  531:     */     case 2121: 
/*  532: 519 */       setRisk(45); break;
/*  533:     */     case 2122: 
/*  534: 520 */       setRisk(60); break;
/*  535:     */     case 2130: 
/*  536: 521 */       setRisk(67); break;
/*  537:     */     case 2131: 
/*  538: 522 */       setRisk(63); break;
/*  539:     */     case 2132: 
/*  540: 523 */       setRisk(66); break;
/*  541:     */     case 2200: 
/*  542: 525 */       setRisk(73); break;
/*  543:     */     case 2201: 
/*  544: 526 */       setRisk(70); break;
/*  545:     */     case 2202: 
/*  546: 527 */       setRisk(77); break;
/*  547:     */     case 2210: 
/*  548: 528 */       setRisk(42); break;
/*  549:     */     case 2211: 
/*  550: 529 */       setRisk(41); break;
/*  551:     */     case 2212: 
/*  552: 530 */       setRisk(50); break;
/*  553:     */     case 2220: 
/*  554: 531 */       setRisk(60); break;
/*  555:     */     case 2221: 
/*  556: 532 */       setRisk(58); break;
/*  557:     */     case 2222: 
/*  558: 533 */       setRisk(74); break;
/*  559:     */     case 2230: 
/*  560: 534 */       setRisk(80); break;
/*  561:     */     case 2231: 
/*  562: 535 */       setRisk(76); break;
/*  563:     */     case 2232: 
/*  564: 536 */       setRisk(79); break;
/*  565:     */     case 3000: 
/*  566: 538 */       setRisk(68); break;
/*  567:     */     case 3001: 
/*  568: 539 */       setRisk(65); break;
/*  569:     */     case 3002: 
/*  570: 540 */       setRisk(75); break;
/*  571:     */     case 3010: 
/*  572: 541 */       setRisk(46); break;
/*  573:     */     case 3011: 
/*  574: 542 */       setRisk(43); break;
/*  575:     */     case 3012: 
/*  576: 543 */       setRisk(52); break;
/*  577:     */     case 3020: 
/*  578: 544 */       setRisk(58); break;
/*  579:     */     case 3021: 
/*  580: 545 */       setRisk(55); break;
/*  581:     */     case 3022: 
/*  582: 546 */       setRisk(65); break;
/*  583:     */     case 3030: 
/*  584: 547 */       setRisk(73); break;
/*  585:     */     case 3031: 
/*  586: 548 */       setRisk(70); break;
/*  587:     */     case 3032: 
/*  588: 549 */       setRisk(80); break;
/*  589:     */     case 3100: 
/*  590: 551 */       setRisk(77); break;
/*  591:     */     case 3101: 
/*  592: 552 */       setRisk(75); break;
/*  593:     */     case 3102: 
/*  594: 553 */       setRisk(84); break;
/*  595:     */     case 3110: 
/*  596: 554 */       setRisk(53); break;
/*  597:     */     case 3111: 
/*  598: 555 */       setRisk(50); break;
/*  599:     */     case 3112: 
/*  600: 556 */       setRisk(59); break;
/*  601:     */     case 3120: 
/*  602: 557 */       setRisk(67); break;
/*  603:     */     case 3121: 
/*  604: 558 */       setRisk(64); break;
/*  605:     */     case 3122: 
/*  606: 559 */       setRisk(74); break;
/*  607:     */     case 3130: 
/*  608: 560 */       setRisk(81); break;
/*  609:     */     case 3131: 
/*  610: 561 */       setRisk(79); break;
/*  611:     */     case 3132: 
/*  612: 562 */       setRisk(87); break;
/*  613:     */     case 3200: 
/*  614: 564 */       setRisk(88); break;
/*  615:     */     case 3201: 
/*  616: 565 */       setRisk(87); break;
/*  617:     */     case 3202: 
/*  618: 566 */       setRisk(93); break;
/*  619:     */     case 3210: 
/*  620: 567 */       setRisk(66); break;
/*  621:     */     case 3211: 
/*  622: 568 */       setRisk(63); break;
/*  623:     */     case 3212: 
/*  624: 569 */       setRisk(73); break;
/*  625:     */     case 3220: 
/*  626: 570 */       setRisk(80); break;
/*  627:     */     case 3221: 
/*  628: 571 */       setRisk(77); break;
/*  629:     */     case 3222: 
/*  630: 572 */       setRisk(86); break;
/*  631:     */     case 3230: 
/*  632: 573 */       setRisk(91); break;
/*  633:     */     case 3231: 
/*  634: 574 */       setRisk(90); break;
/*  635:     */     case 3232: 
/*  636: 575 */       setRisk(95);
/*  637:     */     }
/*  638: 580 */     if (getRelapse())
/*  639:     */     {
/*  640: 581 */       double erVar = 1.45D;
/*  641: 582 */       if (getERStatus() == 1) {
/*  642: 582 */         erVar = 1.6D;
/*  643: 583 */       } else if (getERStatus() == 2) {
/*  644: 583 */         erVar = 1.1D;
/*  645:     */       }
/*  646: 585 */       newCode = getRisk();
/*  647: 586 */       newCode = (100.0D - newCode) / 100.0D;
/*  648: 587 */       newCode = 1.0D - Math.pow(newCode, 0.1D);
/*  649: 588 */       newCode = 1.0D - (0.015D + erVar * newCode);
/*  650: 589 */       newCode = Math.pow(newCode, 10.0D);
/*  651: 590 */       newCode = 100.0D - 100.0D * newCode;
/*  652: 591 */       setRisk((int)Math.round(newCode));
/*  653:     */     }
/*  654: 597 */     if ((this.age < 35) && (this.erStatus != 2))
/*  655:     */     {
/*  656: 598 */       double tmpRisk = getRisk();
/*  657: 599 */       tmpRisk = (100.0D - tmpRisk) / 100.0D;
/*  658: 600 */       tmpRisk = 1.0D - Math.pow(tmpRisk, 0.1D);
/*  659: 601 */       tmpRisk = 1.0D - 1.5D * tmpRisk;
/*  660: 602 */       tmpRisk = Math.pow(tmpRisk, 10.0D);
/*  661: 603 */       tmpRisk = 100.0D - 100.0D * tmpRisk;
/*  662: 604 */       setRisk((int)Math.round(tmpRisk));
/*  663:     */     }
/*  664:     */   }
/*  665:     */   
/*  666:     */   public String[][] generateDisplayStrings()
/*  667:     */   {
/*  668: 817 */     String[][] theStrings = new String[4][4];
/*  669: 818 */     if (getRelapse())
/*  670:     */     {
/*  671: 819 */       theStrings[0][0] = new String(this.results[0][0] + " alive and without cancer.");
/*  672: 820 */       theStrings[0][1] = new String("");
/*  673: 821 */       theStrings[0][2] = new String(this.results[0][2] + " relapse.");
/*  674: 822 */       theStrings[0][3] = new String(this.results[0][3] + " die of other causes.");
/*  675: 823 */       for (int i = 1; i < 4; i++)
/*  676:     */       {
/*  677: 824 */         theStrings[i][0] = new String(this.results[i][0] + " alive and without cancer. Plus...");
/*  678: 825 */         theStrings[i][1] = new String(this.results[i][1] + " alive due to therapy.");
/*  679: 826 */         theStrings[i][2] = new String(this.results[i][2] + " relapse.");
/*  680: 827 */         theStrings[i][3] = new String(this.results[i][3] + " die of other causes.");
/*  681:     */       }
/*  682:     */     }
/*  683:     */     else
/*  684:     */     {
/*  685: 830 */       theStrings[0][0] = new String(this.results[0][0] + " alive in 10 years.");
/*  686: 831 */       theStrings[0][1] = new String("");
/*  687: 832 */       theStrings[0][2] = new String(this.results[0][2] + " die due to cancer.");
/*  688: 833 */       theStrings[0][3] = new String(this.results[0][3] + " die of other causes.");
/*  689: 834 */       for (int i = 1; i < 4; i++)
/*  690:     */       {
/*  691: 835 */         theStrings[i][0] = new String(this.results[i][0] + " alive in 10 years. Plus...");
/*  692: 836 */         theStrings[i][1] = new String(this.results[i][1] + " alive due to therapy.");
/*  693: 837 */         theStrings[i][2] = new String(this.results[i][2] + " die due to cancer.");
/*  694: 838 */         theStrings[i][3] = new String(this.results[i][3] + " die of other causes.");
/*  695:     */       }
/*  696:     */     }
/*  697: 841 */     return theStrings;
/*  698:     */   }
/*  699:     */   
/*  700:     */   public int getChemoEffect()
/*  701:     */   {
/*  702: 855 */     return this.chemoEffect;
/*  703:     */   }
/*  704:     */   
/*  705:     */   public int getCombinedEffect()
/*  706:     */   {
/*  707: 868 */     return this.combEffect;
/*  708:     */   }
/*  709:     */   
/*  710:     */   public int getHormoneEffect()
/*  711:     */   {
/*  712: 881 */     return this.hormEffect;
/*  713:     */   }
/*  714:     */   
/*  715:     */   public int getERStatus()
/*  716:     */   {
/*  717: 900 */     return this.erStatus;
/*  718:     */   }
/*  719:     */   
/*  720:     */   public int getPositiveNodes()
/*  721:     */   {
/*  722: 920 */     return this.positiveNodes;
/*  723:     */   }
/*  724:     */   
/*  725:     */   public double[][] getResults()
/*  726:     */   {
/*  727: 934 */     return this.results;
/*  728:     */   }
/*  729:     */   
/*  730:     */   public int[][] getRoundedResults()
/*  731:     */   {
/*  732: 948 */     int[][] myResults = { new int[4], new int[4], new int[4], new int[4] };
/*  733: 949 */     for (int i = 0; i < 4; i++)
/*  734:     */     {
/*  735: 950 */       for (int j = 0; j < 4; j++) {
/*  736: 951 */         myResults[i][j] = ((int)Math.round(this.results[i][j]));
/*  737:     */       }
/*  738: 953 */       int difference = 100 - myResults[i][0] - myResults[i][1] - myResults[i][2] - myResults[i][3];
/*  739: 954 */       myResults[i][2] += difference;
/*  740:     */     }
/*  741: 956 */     return myResults;
/*  742:     */   }
/*  743:     */   
/*  744:     */   public double[] getResultsCurve()
/*  745:     */   {
/*  746: 969 */     return this.curveResults;
/*  747:     */   }
/*  748:     */   
/*  749:     */   public double[] getResultsSurvival()
/*  750:     */   {
/*  751: 983 */     return this.surviveResults;
/*  752:     */   }
/*  753:     */   
/*  754:     */   public int getTumorGrade()
/*  755:     */   {
/*  756:1003 */     return this.tumorGrade;
/*  757:     */   }
/*  758:     */   
/*  759:     */   public int getTumorSize()
/*  760:     */   {
/*  761:1029 */     return this.tumorSize;
/*  762:     */   }
/*  763:     */   
/*  764:     */   public void setChemoEffect(int newChemo)
/*  765:     */   {
/*  766:1047 */     if (newChemo > 100) {
/*  767:1047 */       this.chemoEffect = 100;
/*  768:1048 */     } else if (newChemo < 0) {
/*  769:1048 */       this.chemoEffect = 0;
/*  770:     */     } else {
/*  771:1049 */       this.chemoEffect = newChemo;
/*  772:     */     }
/*  773:     */   }
/*  774:     */   
/*  775:     */   public void setCombinedEffect(int newComb)
/*  776:     */   {
/*  777:1067 */     if (newComb > 100) {
/*  778:1067 */       this.combEffect = 100;
/*  779:1068 */     } else if (newComb < 0) {
/*  780:1068 */       this.combEffect = 0;
/*  781:     */     } else {
/*  782:1069 */       this.combEffect = newComb;
/*  783:     */     }
/*  784:     */   }
/*  785:     */   
/*  786:     */   public void setHormoneEffect(int newHorm)
/*  787:     */   {
/*  788:1087 */     if (newHorm > 100) {
/*  789:1087 */       this.hormEffect = 100;
/*  790:1088 */     } else if (newHorm < 0) {
/*  791:1088 */       this.hormEffect = 0;
/*  792:     */     } else {
/*  793:1089 */       this.hormEffect = newHorm;
/*  794:     */     }
/*  795:     */   }
/*  796:     */   
/*  797:     */   public void setERStatus(int newER)
/*  798:     */   {
/*  799:1111 */     if (newER > 2) {
/*  800:1111 */       this.erStatus = 0;
/*  801:1112 */     } else if (newER < 0) {
/*  802:1112 */       this.erStatus = 0;
/*  803:     */     } else {
/*  804:1113 */       this.erStatus = newER;
/*  805:     */     }
/*  806:     */   }
/*  807:     */   
/*  808:     */   public void setPositiveNodes(int newNode)
/*  809:     */   {
/*  810:1136 */     if ((newNode > 3) || (newNode < 0)) {
/*  811:1136 */       this.positiveNodes = 0;
/*  812:     */     } else {
/*  813:1137 */       this.positiveNodes = newNode;
/*  814:     */     }
/*  815:     */   }
/*  816:     */   
/*  817:     */   public void setTumorGrade(int newGrade)
/*  818:     */   {
/*  819:1160 */     if ((newGrade > 3) || (newGrade < 0)) {
/*  820:1160 */       this.tumorGrade = 0;
/*  821:     */     } else {
/*  822:1161 */       this.tumorGrade = newGrade;
/*  823:     */     }
/*  824:     */   }
/*  825:     */   
/*  826:     */   public void setTumorSize(int newSize)
/*  827:     */   {
/*  828:1188 */     if ((newSize > 4) || (newSize < 0)) {
/*  829:1188 */       this.tumorSize = 0;
/*  830:     */     } else {
/*  831:1189 */       this.tumorSize = newSize;
/*  832:     */     }
/*  833:     */   }
/*  834:     */ }


/* Location:           C:\Users\mark\Dropbox\breastcancerapplet\BreastAppletV81.jar
 * Qualified Name:     BreastPatient
 * JD-Core Version:    0.7.0.1
 */