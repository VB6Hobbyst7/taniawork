/*  1:   */ package edu.iu.nwb.analysis.extractnetfromtable.components;
/*  2:   */ 
/*  3:   */ public class NodeID
/*  4:   */ {
/*  5:   */   private String label;
/*  6:   */   private String bipartiteType;
/*  7:   */   
/*  8:   */   public NodeID(String label, String type)
/*  9:   */   {
/* 10:11 */     this.label = label;
/* 11:12 */     this.bipartiteType = type;
/* 12:   */   }
/* 13:   */   
/* 14:   */   public boolean equals(Object obj)
/* 15:   */   {
/* 16:22 */     if (this == obj) {
/* 17:23 */       return true;
/* 18:   */     }
/* 19:26 */     if (obj == null) {
/* 20:27 */       return false;
/* 21:   */     }
/* 22:30 */     if (!(obj instanceof NodeID)) {
/* 23:31 */       return false;
/* 24:   */     }
/* 25:34 */     NodeID other = (NodeID)obj;
/* 26:36 */     if (this.label == null)
/* 27:   */     {
/* 28:37 */       if (other.label != null) {
/* 29:38 */         return false;
/* 30:   */       }
/* 31:   */     }
/* 32:40 */     else if (!this.label.equals(other.label)) {
/* 33:41 */       return false;
/* 34:   */     }
/* 35:44 */     if (this.bipartiteType == null)
/* 36:   */     {
/* 37:45 */       if (other.bipartiteType != null) {
/* 38:46 */         return false;
/* 39:   */       }
/* 40:   */     }
/* 41:48 */     else if (!this.bipartiteType.equals(other.bipartiteType)) {
/* 42:49 */       return false;
/* 43:   */     }
/* 44:52 */     return true;
/* 45:   */   }
/* 46:   */   
/* 47:   */   public int hashCode()
/* 48:   */   {
/* 49:57 */     int result = 1;
/* 50:58 */     result = 31 * result + (this.bipartiteType == null ? 0 : this.bipartiteType.hashCode());
/* 51:59 */     result = 31 * result + (this.label == null ? 0 : this.label.hashCode());
/* 52:60 */     return result;
/* 53:   */   }
/* 54:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.components.NodeID
 * JD-Core Version:    0.7.0.1
 */