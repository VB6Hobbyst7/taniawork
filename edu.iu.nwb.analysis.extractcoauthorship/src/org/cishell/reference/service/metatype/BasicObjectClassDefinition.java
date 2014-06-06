/*  1:   */ package org.cishell.reference.service.metatype;
/*  2:   */ 
/*  3:   */ import java.io.IOException;
/*  4:   */ import java.io.InputStream;
/*  5:   */ import java.util.ArrayList;
/*  6:   */ import java.util.List;
/*  7:   */ import org.osgi.service.metatype.AttributeDefinition;
/*  8:   */ import org.osgi.service.metatype.ObjectClassDefinition;
/*  9:   */ 
/* 10:   */ public class BasicObjectClassDefinition
/* 11:   */   implements ObjectClassDefinition
/* 12:   */ {
/* 13:13 */   List<AttributeDefinition> optionalAttributeDefinitions = new ArrayList();
/* 14:14 */   List<AttributeDefinition> requiredAttributeDefinitions = new ArrayList();
/* 15:15 */   List<AttributeDefinition> allAttributeDefinitions = new ArrayList();
/* 16:   */   private String ID;
/* 17:   */   private String name;
/* 18:   */   private String description;
/* 19:   */   private InputStream icon;
/* 20:   */   
/* 21:   */   public BasicObjectClassDefinition(String ID, String name, String description, InputStream icon)
/* 22:   */   {
/* 23:22 */     this.ID = ID;
/* 24:23 */     this.name = name;
/* 25:24 */     this.description = description;
/* 26:25 */     this.icon = icon;
/* 27:   */   }
/* 28:   */   
/* 29:   */   public void addAttributeDefinition(int flag, AttributeDefinition definition)
/* 30:   */   {
/* 31:29 */     if (flag == 1) {
/* 32:30 */       this.requiredAttributeDefinitions.add(definition);
/* 33:31 */     } else if (flag == 2) {
/* 34:32 */       this.optionalAttributeDefinitions.add(definition);
/* 35:   */     }
/* 36:35 */     this.allAttributeDefinitions.add(definition);
/* 37:   */   }
/* 38:   */   
/* 39:   */   public AttributeDefinition[] getAttributeDefinitions(int flag)
/* 40:   */   {
/* 41:39 */     List<AttributeDefinition> results = new ArrayList();
/* 42:41 */     if (flag == 1) {
/* 43:42 */       results.addAll(this.requiredAttributeDefinitions);
/* 44:43 */     } else if (flag == 2) {
/* 45:44 */       results.addAll(this.optionalAttributeDefinitions);
/* 46:   */     } else {
/* 47:46 */       results.addAll(this.allAttributeDefinitions);
/* 48:   */     }
/* 49:49 */     return makeArray(results);
/* 50:   */   }
/* 51:   */   
/* 52:   */   private AttributeDefinition[] makeArray(List<AttributeDefinition> definitions)
/* 53:   */   {
/* 54:53 */     return (AttributeDefinition[])definitions.toArray(new AttributeDefinition[0]);
/* 55:   */   }
/* 56:   */   
/* 57:   */   public String getDescription()
/* 58:   */   {
/* 59:57 */     return this.description;
/* 60:   */   }
/* 61:   */   
/* 62:   */   public String getID()
/* 63:   */   {
/* 64:61 */     return this.ID;
/* 65:   */   }
/* 66:   */   
/* 67:   */   public InputStream getIcon(int arg0)
/* 68:   */     throws IOException
/* 69:   */   {
/* 70:65 */     return this.icon;
/* 71:   */   }
/* 72:   */   
/* 73:   */   public String getName()
/* 74:   */   {
/* 75:69 */     return this.name;
/* 76:   */   }
/* 77:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.service.metatype.BasicObjectClassDefinition
 * JD-Core Version:    0.7.0.1
 */