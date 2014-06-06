/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*  2:   */ 
/*  3:   */ public class InvalidColumnNameException
/*  4:   */   extends Exception
/*  5:   */ {
/*  6:   */   private static final long serialVersionUID = 1L;
/*  7:   */   
/*  8:   */   public InvalidColumnNameException(String message)
/*  9:   */   {
/* 10: 7 */     super(message);
/* 11:   */   }
/* 12:   */   
/* 13:   */   public InvalidColumnNameException(Exception ex)
/* 14:   */   {
/* 15:11 */     super(ex);
/* 16:   */   }
/* 17:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.InvalidColumnNameException
 * JD-Core Version:    0.7.0.1
 */