/*  1:   */ package edu.iu.nwb.analysis.extractcoauthorship.metadata;
/*  2:   */ 
/*  3:   */ import java.util.HashMap;
/*  4:   */ import java.util.Set;
/*  5:   */ 
/*  6:   */ public abstract interface SupportedFileTypes
/*  7:   */ {
/*  8: 6 */   public static final CitationFormat bibtex = new CitationFormat("bibtex", "author", "test_type");
/*  9: 7 */   public static final CitationFormat isi = new CitationFormat("isi", "Authors", "test_type");
/* 10: 8 */   public static final CitationFormat scopus = new CitationFormat("scopus", "Authors", "test_type");
/* 11: 9 */   public static final CitationFormat endnote = new CitationFormat("endnote", "Authors", "test_type");
/* 12:11 */   public static final String[] supportedFormats = CitationFormat.getSupportedFormats();
/* 13:   */   
/* 14:   */   public static class CitationFormat
/* 15:   */   {
/* 16:14 */     private static HashMap nameToColumn = new HashMap();
/* 17:   */     
/* 18:   */     public CitationFormat(String name, String authorColumn, String testTypeColumn)
/* 19:   */     {
/* 20:17 */       nameToColumn.put(name, authorColumn);
					
/* 21:   */     }
/* 22:   */     
/* 23:   */     public static String getAuthorColumnByName(String name)
/* 24:   */     {
/* 25:21 */       return nameToColumn.get(name).toString();
/* 26:   */     }
/* 27:   */     public static String getTestTypeColumnByName(String name)
/* 24:   */     {
/* 25:21 */       return nameToColumn.get(name).toString();
/* 26:   */     }
/* 28:   */     public static String[] getSupportedFormats()
/* 29:   */     {
/* 30:25 */       String[] supportedFormats = new String[nameToColumn.size()];
/* 31:   */       
/* 32:27 */       supportedFormats = (String[])nameToColumn.keySet().toArray(supportedFormats);
/* 33:   */       
/* 34:29 */       return supportedFormats;
/* 35:   */     }
/* 36:   */   }
/* 37:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractcoauthorship_1.0.1.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractcoauthorship.metadata.SupportedFileTypes
 * JD-Core Version:    0.7.0.1
 */