/*   1:    */ package org.cishell.reference.app.service.scheduler;
/*   2:    */ 
/*   3:    */ import java.util.ArrayList;
/*   4:    */ import java.util.Calendar;
/*   5:    */ import java.util.List;
/*   6:    */ import org.cishell.app.service.scheduler.SchedulerListener;
/*   7:    */ import org.cishell.framework.algorithm.Algorithm;
/*   8:    */ import org.cishell.framework.data.Data;
/*   9:    */ 
/*  10:    */ class SchedulerListenerInformer
/*  11:    */   implements SchedulerListener
/*  12:    */ {
/*  13:    */   private List<SchedulerListener> schedulerListeners;
/*  14:    */   
/*  15:    */   public SchedulerListenerInformer()
/*  16:    */   {
/*  17:240 */     this.schedulerListeners = new ArrayList();
/*  18:    */   }
/*  19:    */   
/*  20:    */   public void addSchedulerListener(SchedulerListener listener)
/*  21:    */   {
/*  22:244 */     this.schedulerListeners.add(listener);
/*  23:    */   }
/*  24:    */   
/*  25:    */   public void removeSchedulerListener(SchedulerListener listener)
/*  26:    */   {
/*  27:248 */     this.schedulerListeners.remove(listener);
/*  28:    */   }
/*  29:    */   
/*  30:    */   public void algorithmScheduled(Algorithm algorithm, Calendar time)
/*  31:    */   {
/*  32:252 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  33:253 */       schedulerListener.algorithmScheduled(algorithm, time);
/*  34:    */     }
/*  35:    */   }
/*  36:    */   
/*  37:    */   public synchronized void algorithmStarted(Algorithm algorithm)
/*  38:    */   {
/*  39:258 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  40:259 */       schedulerListener.algorithmStarted(algorithm);
/*  41:    */     }
/*  42:    */   }
/*  43:    */   
/*  44:    */   public void algorithmError(Algorithm algorithm, Throwable error)
/*  45:    */   {
/*  46:264 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  47:265 */       schedulerListener.algorithmError(algorithm, error);
/*  48:    */     }
/*  49:    */   }
/*  50:    */   
/*  51:    */   public void algorithmFinished(Algorithm algorithm, Data[] createdDM)
/*  52:    */   {
/*  53:270 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  54:271 */       schedulerListener.algorithmFinished(algorithm, createdDM);
/*  55:    */     }
/*  56:    */   }
/*  57:    */   
/*  58:    */   public void algorithmRescheduled(Algorithm algorithm, Calendar time)
/*  59:    */   {
/*  60:276 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  61:277 */       schedulerListener.algorithmRescheduled(algorithm, time);
/*  62:    */     }
/*  63:    */   }
/*  64:    */   
/*  65:    */   public void algorithmUnscheduled(Algorithm algorithm)
/*  66:    */   {
/*  67:282 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  68:283 */       schedulerListener.algorithmUnscheduled(algorithm);
/*  69:    */     }
/*  70:    */   }
/*  71:    */   
/*  72:    */   public void schedulerCleared()
/*  73:    */   {
/*  74:288 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  75:289 */       schedulerListener.schedulerCleared();
/*  76:    */     }
/*  77:    */   }
/*  78:    */   
/*  79:    */   public void schedulerRunStateChanged(boolean isRunning)
/*  80:    */   {
/*  81:294 */     for (SchedulerListener schedulerListener : this.schedulerListeners) {
/*  82:295 */       schedulerListener.schedulerRunStateChanged(isRunning);
/*  83:    */     }
/*  84:    */   }
/*  85:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.scheduler.SchedulerListenerInformer
 * JD-Core Version:    0.7.0.1
 */