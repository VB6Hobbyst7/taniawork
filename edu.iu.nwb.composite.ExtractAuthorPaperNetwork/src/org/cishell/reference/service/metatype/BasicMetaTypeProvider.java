/*  1:   */ package org.cishell.reference.service.metatype;
/*  2:   */ 
/*  3:   */ import org.osgi.service.metatype.MetaTypeProvider;
/*  4:   */ import org.osgi.service.metatype.ObjectClassDefinition;
/*  5:   */ 
/*  6:   */ public class BasicMetaTypeProvider
/*  7:   */   implements MetaTypeProvider
/*  8:   */ {
/*  9:   */   private ObjectClassDefinition definition;
/* 10:   */   
/* 11:   */   public BasicMetaTypeProvider(ObjectClassDefinition definition)
/* 12:   */   {
/* 13:11 */     this.definition = definition;
/* 14:   */   }
/* 15:   */   
/* 16:   */   public String[] getLocales()
/* 17:   */   {
/* 18:16 */     return null;
/* 19:   */   }
/* 20:   */   
/* 21:   */   public ObjectClassDefinition getObjectClassDefinition(String arg0, String arg1)
/* 22:   */   {
/* 23:21 */     return this.definition;
/* 24:   */   }
/* 25:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.service.metatype.BasicMetaTypeProvider
 * JD-Core Version:    0.7.0.1
 */