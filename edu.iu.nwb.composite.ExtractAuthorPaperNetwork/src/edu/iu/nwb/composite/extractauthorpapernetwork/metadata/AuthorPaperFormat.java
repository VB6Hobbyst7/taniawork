/*  1:   */ package edu.iu.nwb.composite.extractauthorpapernetwork.metadata;
/*  2:   */ 
/*  3:   */ import java.util.Collection;
/*  4:   */ import java.util.Collections;
/*  5:   */ import java.util.HashMap;
/*  6:   */ import java.util.HashSet;
/*  7:   */ import java.util.Map;
/*  8:   */ 
/*  9:   */ public enum AuthorPaperFormat
/* 10:   */ {
/* 11:10 */   BIBTEX("bibtex", "author", "title"),  ISI("isi", "Authors", "Cite Me As"),  SCOPUS("scopus", "Authors", "Title"),  END_NOTE("endnote", "Author", "Title");
/* 12:   */   
/* 13:16 */   public static final Map<String, String> AUTHOR_NAME_COLUMNS_BY_FORMATS = Collections.unmodifiableMap(mapFormatsToNameColumns());
/* 14:18 */   public static final Map<String, String> PAPER_NAME_COLUMNS_BY_FORMATS = Collections.unmodifiableMap(mapFormatsToPaperColumns());
/* 15:20 */   public static final Collection<String> FORMATS_SUPPORTED = Collections.unmodifiableCollection(compileFormatsSupported());
/* 16:   */   private String format;
/* 17:   */   private String authorNameColumn;
/* 18:   */   private String paperNameColumn;
/* 19:   */   
/* 20:   */   private static Map<String, String> mapFormatsToNameColumns()
/* 21:   */   {
/* 22:23 */     Map<String, String> authorNameColumnsByFormats = new HashMap();
/* 23:25 */     for (AuthorPaperFormat format : values()) {
/* 24:26 */       authorNameColumnsByFormats.put(format.getFormat(), format.getAuthorNameColumn());
/* 25:   */     }
/* 26:29 */     return authorNameColumnsByFormats;
/* 27:   */   }
/* 28:   */   
/* 29:   */   private static Map<String, String> mapFormatsToPaperColumns()
/* 30:   */   {
/* 31:33 */     Map<String, String> paperNameColumnsByFormats = new HashMap();
/* 32:35 */     for (AuthorPaperFormat format : values()) {
/* 33:36 */       paperNameColumnsByFormats.put(format.getFormat(), format.getPaperNameColumn());
/* 34:   */     }
/* 35:39 */     return paperNameColumnsByFormats;
/* 36:   */   }
/* 37:   */   
/* 38:   */   private static Collection<String> compileFormatsSupported()
/* 39:   */   {
/* 40:43 */     Collection<String> formatsSupported = new HashSet();
/* 41:45 */     for (AuthorPaperFormat format : values()) {
/* 42:46 */       formatsSupported.add(format.getFormat());
/* 43:   */     }
/* 44:49 */     return formatsSupported;
/* 45:   */   }
/* 46:   */   
/* 47:   */   private AuthorPaperFormat(String format, String authorNameColumn, String paperNameColumn)
/* 48:   */   {
/* 49:57 */     this.format = format;
/* 50:58 */     this.authorNameColumn = authorNameColumn;
/* 51:59 */     this.paperNameColumn = paperNameColumn;
/* 52:   */   }
/* 53:   */   
/* 54:   */   public String getFormat()
/* 55:   */   {
/* 56:63 */     return this.format;
/* 57:   */   }
/* 58:   */   
/* 59:   */   public String getAuthorNameColumn()
/* 60:   */   {
/* 61:67 */     return this.authorNameColumn;
/* 62:   */   }
/* 63:   */   
/* 64:   */   public String getPaperNameColumn()
/* 65:   */   {
/* 66:71 */     return this.paperNameColumn;
/* 67:   */   }
/* 68:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\javasrc\important ones\edu.iu.nwb.composite.extractauthorpapernetwork_0.0.2.jar
 * Qualified Name:     edu.iu.nwb.composite.extractauthorpapernetwork.metadata.AuthorPaperFormat
 * JD-Core Version:    0.7.0.1
 */