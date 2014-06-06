/*  1:   */ package org.cishell.reference.service.metatype;
/*  2:   */ 
/*  3:   */ import org.osgi.service.metatype.AttributeDefinition;
/*  4:   */ 
/*  5:   */ public class BasicAttributeDefinition
/*  6:   */   implements AttributeDefinition
/*  7:   */ {
/*  8:   */   private String id;
/*  9:   */   private String name;
/* 10:   */   private String description;
/* 11:   */   private int type;
/* 12:   */   private int cardinality;
/* 13:   */   private String[] defaultValue;
/* 14:   */   private AttributeValueValidator validator;
/* 15:   */   private String[] optionLabels;
/* 16:   */   private String[] optionValues;
/* 17:   */   
/* 18:   */   public BasicAttributeDefinition(String id, String name, String description, int type, int cardinality, String[] defaultValue, AttributeValueValidator validator, String[] optionLabels, String[] optionValues)
/* 19:   */   {
/* 20:18 */     this.id = id;
/* 21:19 */     this.name = name;
/* 22:20 */     this.description = description;
/* 23:21 */     this.type = type;
/* 24:22 */     this.cardinality = cardinality;
/* 25:23 */     this.defaultValue = defaultValue;
/* 26:25 */     if (validator == null) {
/* 27:26 */       this.validator = new AbstractAttributeValueValidator() {};
/* 28:   */     } else {
/* 29:28 */       this.validator = validator;
/* 30:   */     }
/* 31:31 */     this.optionLabels = optionLabels;
/* 32:32 */     this.optionValues = optionValues;
/* 33:   */   }
/* 34:   */   
/* 35:   */   public BasicAttributeDefinition(String id, String name, String description, int type)
/* 36:   */   {
/* 37:36 */     this(id, name, description, type, 0, null, null, null, null);
/* 38:   */   }
/* 39:   */   
/* 40:   */   public BasicAttributeDefinition(String id, String name, String description, int type, int cardinality, String[] defaultValue)
/* 41:   */   {
/* 42:40 */     this(id, name, description, type, cardinality, defaultValue, null, null, null);
/* 43:   */   }
/* 44:   */   
/* 45:   */   public BasicAttributeDefinition(String id, String name, String description, int type, String defaultValue)
/* 46:   */   {
/* 47:44 */     this(id, name, description, type, 0, new String[] { defaultValue });
/* 48:   */   }
/* 49:   */   
/* 50:   */   public BasicAttributeDefinition(String id, String name, String description, int type, int cardinality)
/* 51:   */   {
/* 52:48 */     this(id, name, description, type, cardinality, null, null, null, null);
/* 53:   */   }
/* 54:   */   
/* 55:   */   public BasicAttributeDefinition(String id, String name, String description, int type, String[] optionLabels, String[] optionValues)
/* 56:   */   {
/* 57:52 */     this(id, name, description, type, 0, null, null, optionLabels, optionValues);
/* 58:   */   }
/* 59:   */   
/* 60:   */   public int getCardinality()
/* 61:   */   {
/* 62:56 */     return this.cardinality;
/* 63:   */   }
/* 64:   */   
/* 65:   */   public String[] getDefaultValue()
/* 66:   */   {
/* 67:60 */     return this.defaultValue;
/* 68:   */   }
/* 69:   */   
/* 70:   */   public String getDescription()
/* 71:   */   {
/* 72:64 */     return this.description;
/* 73:   */   }
/* 74:   */   
/* 75:   */   public String getID()
/* 76:   */   {
/* 77:68 */     return this.id;
/* 78:   */   }
/* 79:   */   
/* 80:   */   public String getName()
/* 81:   */   {
/* 82:72 */     return this.name;
/* 83:   */   }
/* 84:   */   
/* 85:   */   public String[] getOptionLabels()
/* 86:   */   {
/* 87:76 */     return this.optionLabels;
/* 88:   */   }
/* 89:   */   
/* 90:   */   public String[] getOptionValues()
/* 91:   */   {
/* 92:80 */     return this.optionValues;
/* 93:   */   }
/* 94:   */   
/* 95:   */   public int getType()
/* 96:   */   {
/* 97:84 */     return this.type;
/* 98:   */   }
/* 99:   */   
/* :0:   */   public String validate(String value)
/* :1:   */   {
/* :2:88 */     return this.validator.validate(value);
/* :3:   */   }
/* :4:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.service.metatype.BasicAttributeDefinition
 * JD-Core Version:    0.7.0.1
 */