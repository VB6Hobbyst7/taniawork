/*  1:   */ package org.cishell.framework.algorithm;
/*  2:   */ 
/*  3:   */ public abstract interface ProgressMonitor
/*  4:   */ {
/*  5:30 */   public static final ProgressMonitor NULL_MONITOR = new ProgressMonitor()
/*  6:   */   {
/*  7:   */     public void describeWork(String currentWork) {}
/*  8:   */     
/*  9:   */     public void done() {}
/* 10:   */     
/* 11:   */     public boolean isCanceled()
/* 12:   */     {
/* 13:33 */       return false;
/* 14:   */     }
/* 15:   */     
/* 16:   */     public boolean isPaused()
/* 17:   */     {
/* 18:34 */       return false;
/* 19:   */     }
/* 20:   */     
/* 21:   */     public void setCanceled(boolean value) {}
/* 22:   */     
/* 23:   */     public void setPaused(boolean value) {}
/* 24:   */     
/* 25:   */     public void start(int capabilities, int totalWorkUnits) {}
/* 26:   */     
/* 27:   */     public void start(int capabilities, double totalWorkUnits) {}
/* 28:   */     
/* 29:   */     public void worked(int work) {}
/* 30:   */     
/* 31:   */     public void worked(double work) {}
/* 32:   */   };
/* 33:   */   public static final int WORK_TRACKABLE = 2;
/* 34:   */   public static final int CANCELLABLE = 4;
/* 35:   */   public static final int PAUSEABLE = 8;
/* 36:   */   
/* 37:   */   public abstract void start(int paramInt1, int paramInt2);
/* 38:   */   
/* 39:   */   public abstract void start(int paramInt, double paramDouble);
/* 40:   */   
/* 41:   */   public abstract void worked(int paramInt);
/* 42:   */   
/* 43:   */   public abstract void worked(double paramDouble);
/* 44:   */   
/* 45:   */   public abstract void done();
/* 46:   */   
/* 47:   */   public abstract void setCanceled(boolean paramBoolean);
/* 48:   */   
/* 49:   */   public abstract boolean isCanceled();
/* 50:   */   
/* 51:   */   public abstract void setPaused(boolean paramBoolean);
/* 52:   */   
/* 53:   */   public abstract boolean isPaused();
/* 54:   */   
/* 55:   */   public abstract void describeWork(String paramString);
/* 56:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.algorithm.ProgressMonitor
 * JD-Core Version:    0.7.0.1
 */