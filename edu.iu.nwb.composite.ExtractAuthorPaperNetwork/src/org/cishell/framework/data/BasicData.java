/*  1:   */ package org.cishell.framework.data;
/*  2:   */ 
/*  3:   */ import java.util.Dictionary;
/*  4:   */ import java.util.Hashtable;
/*  5:   */ 
/*  6:   */ public class BasicData
/*  7:   */   implements Data
/*  8:   */ {
/*  9:   */   private Dictionary<String, Object> properties;
/* 10:   */   private Object data;
/* 11:   */   private String format;
/* 12:   */   
/* 13:   */   public BasicData(Object data, String format)
/* 14:   */   {
/* 15:38 */     this(new Hashtable(), data, format);
/* 16:   */   }
/* 17:   */   
/* 18:   */   public BasicData(Dictionary<String, Object> properties, Object data, String format)
/* 19:   */   {
/* 20:48 */     this.properties = properties;
/* 21:49 */     this.data = data;
/* 22:50 */     this.format = format;
/* 23:   */   }
/* 24:   */   
/* 25:   */   public Object getData()
/* 26:   */   {
/* 27:57 */     return this.data;
/* 28:   */   }
/* 29:   */   
/* 30:   */   public Dictionary<String, Object> getMetadata()
/* 31:   */   {
/* 32:64 */     return this.properties;
/* 33:   */   }
/* 34:   */   
/* 35:   */   public String getFormat()
/* 36:   */   {
/* 37:71 */     return this.format;
/* 38:   */   }
/* 39:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.data.BasicData
 * JD-Core Version:    0.7.0.1
 */