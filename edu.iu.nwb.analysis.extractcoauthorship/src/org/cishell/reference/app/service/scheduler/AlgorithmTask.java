/*   1:    */ package org.cishell.reference.app.service.scheduler;
/*   2:    */ 
/*   3:    */ import com.google.common.base.Objects;
/*   4:    */ import java.util.Calendar;
/*   5:    */ import org.cishell.app.service.scheduler.SchedulerListener;
/*   6:    */ import org.cishell.framework.algorithm.Algorithm;
/*   7:    */ import org.cishell.framework.data.Data;
/*   8:    */ import org.osgi.framework.ServiceReference;
/*   9:    */ 
/*  10:    */ class AlgorithmTask
/*  11:    */   implements Runnable
/*  12:    */ {
/*  13:543 */   private volatile boolean isCanceled = false;
/*  14:    */   private final Algorithm algorithm;
/*  15:    */   private final Calendar scheduledTime;
/*  16:    */   private final ServiceReference serviceReference;
/*  17:    */   private volatile AlgorithmState state;
/*  18:    */   private Data[] result;
/*  19:    */   private Exception exceptionThrown;
/*  20:    */   private SchedulerListener schedulerListener;
/*  21:    */   
/*  22:    */   public final synchronized boolean cancel()
/*  23:    */   {
/*  24:563 */     if (this.isCanceled) {
/*  25:564 */       return true;
/*  26:    */     }
/*  27:567 */     if (this.state.equals(AlgorithmState.RUNNING)) {
/*  28:568 */       return false;
/*  29:    */     }
/*  30:571 */     this.state = AlgorithmState.STOPPED;
/*  31:572 */     this.isCanceled = true;
/*  32:    */     
/*  33:574 */     return this.isCanceled;
/*  34:    */   }
/*  35:    */   
/*  36:    */   public final synchronized void start()
/*  37:    */   {
/*  38:578 */     if (this.isCanceled) {
/*  39:579 */       return;
/*  40:    */     }
/*  41:582 */     setState(AlgorithmState.RUNNING);
/*  42:583 */     new Thread(this).start();
/*  43:    */   }
/*  44:    */   
/*  45:    */   public AlgorithmTask(Algorithm algorithm, ServiceReference serviceReference, Calendar scheduledTime, AlgorithmSchedulerTask algorithmSchedulerTask)
/*  46:    */   {
/*  47:591 */     this.algorithm = algorithm;
/*  48:592 */     this.serviceReference = serviceReference;
/*  49:593 */     this.scheduledTime = scheduledTime;
/*  50:594 */     this.schedulerListener = algorithmSchedulerTask;
/*  51:    */     
/*  52:596 */     algorithmSchedulerTask.registerAlgorithmTask(algorithm, this);
/*  53:597 */     init();
/*  54:    */   }
/*  55:    */   
/*  56:    */   public final synchronized Calendar getScheduledTime()
/*  57:    */   {
/*  58:604 */     Calendar calendar = Calendar.getInstance();
/*  59:605 */     calendar.setTime(this.scheduledTime.getTime());
/*  60:    */     
/*  61:607 */     return calendar;
/*  62:    */   }
/*  63:    */   
/*  64:    */   public final synchronized ServiceReference getServiceReference()
/*  65:    */   {
/*  66:611 */     return this.serviceReference;
/*  67:    */   }
/*  68:    */   
/*  69:    */   private final void init()
/*  70:    */   {
/*  71:615 */     this.result = null;
/*  72:616 */     setState(AlgorithmState.NEW);
/*  73:    */   }
/*  74:    */   
/*  75:    */   public final synchronized Data[] getResult()
/*  76:    */   {
/*  77:620 */     return this.result;
/*  78:    */   }
/*  79:    */   
/*  80:    */   private final synchronized void setState(AlgorithmState state)
/*  81:    */   {
/*  82:624 */     this.state = state;
/*  83:626 */     if (this.schedulerListener != null)
/*  84:    */     {
/*  85:627 */       this.state.performAction(
/*  86:628 */         this.algorithm, 
/*  87:629 */         this.schedulerListener, 
/*  88:630 */         this.scheduledTime, 
/*  89:631 */         getResult(), 
/*  90:632 */         this.exceptionThrown);
/*  91:633 */       this.isCanceled = this.state.isCanceledNow();
/*  92:    */     }
/*  93:    */   }
/*  94:    */   
/*  95:    */   public final synchronized AlgorithmState getState()
/*  96:    */   {
/*  97:638 */     return this.state;
/*  98:    */   }
/*  99:    */   
/* 100:    */   public void run()
/* 101:    */   {
/* 102:    */     try
/* 103:    */     {
/* 104:643 */       this.result = this.algorithm.execute();
/* 105:    */     }
/* 106:    */     catch (Exception e)
/* 107:    */     {
/* 108:645 */       this.exceptionThrown = e;
/* 109:646 */       setState(AlgorithmState.ERROR);
/* 110:    */     }
/* 111:    */     finally
/* 112:    */     {
/* 113:648 */       setState(AlgorithmState.STOPPED);
/* 114:    */     }
/* 115:    */   }
/* 116:    */   
/* 117:    */   static class AlgorithmState
/* 118:    */   {
/* 119:657 */     public static final AlgorithmState NEW = new AlgorithmState("NEW", false)
/* 120:    */     {
/* 121:    */       public void performAction(Algorithm algorithm, SchedulerListener schedulerListener, Calendar scheduledTime, Data[] result, Exception exceptionThrown)
/* 122:    */       {
/* 123:664 */         schedulerListener.algorithmScheduled(algorithm, scheduledTime);
/* 124:    */       }
/* 125:    */     };
/* 126:669 */     public static final AlgorithmState RUNNING = new AlgorithmState("RUNNING", false)
/* 127:    */     {
/* 128:    */       public void performAction(Algorithm algorithm, SchedulerListener schedulerListener, Calendar scheduledTime, Data[] result, Exception exceptionThrown)
/* 129:    */       {
/* 130:676 */         schedulerListener.algorithmStarted(algorithm);
/* 131:    */       }
/* 132:    */     };
/* 133:680 */     public static final AlgorithmState STOPPED = new AlgorithmState("STOPPED", true)
/* 134:    */     {
/* 135:    */       public void performAction(Algorithm algorithm, SchedulerListener schedulerListener, Calendar scheduledTime, Data[] result, Exception exceptionThrown)
/* 136:    */       {
/* 137:687 */         schedulerListener.algorithmFinished(algorithm, result);
/* 138:    */       }
/* 139:    */     };
/* 140:691 */     public static final AlgorithmState ERROR = new AlgorithmState("ERROR", true)
/* 141:    */     {
/* 142:    */       public void performAction(Algorithm algorithm, SchedulerListener schedulerListener, Calendar scheduledTime, Data[] result, Exception exceptionThrown)
/* 143:    */       {
/* 144:698 */         schedulerListener.algorithmError(algorithm, exceptionThrown);
/* 145:    */       }
/* 146:    */     };
/* 147:    */     private String name;
/* 148:    */     private boolean isCanceled;
/* 149:    */     
/* 150:    */     public AlgorithmState(String name, boolean isCanceled)
/* 151:    */     {
/* 152:706 */       this.name = name;
/* 153:707 */       this.isCanceled = isCanceled;
/* 154:    */     }
/* 155:    */     
/* 156:    */     public int hashCode()
/* 157:    */     {
/* 158:715 */       return Objects.hashCode(new Object[] { this.name });
/* 159:    */     }
/* 160:    */     
/* 161:    */     public boolean equals(Object obj)
/* 162:    */     {
/* 163:724 */       if (this == obj) {
/* 164:725 */         return true;
/* 165:    */       }
/* 166:727 */       if (obj == null) {
/* 167:728 */         return false;
/* 168:    */       }
/* 169:730 */       if (!(obj instanceof AlgorithmState)) {
/* 170:731 */         return false;
/* 171:    */       }
/* 172:733 */       AlgorithmState other = (AlgorithmState)obj;
/* 173:734 */       return Objects.equal(this.name, other.name);
/* 174:    */     }
/* 175:    */     
/* 176:    */     public void performAction(Algorithm algorithm, SchedulerListener schedulerListener, Calendar scheduledTime, Data[] result, Exception exceptionThrown)
/* 177:    */     {
/* 178:744 */       throw new IllegalStateException("Encountered illegal algorithm state: " + this);
/* 179:    */     }
/* 180:    */     
/* 181:    */     public boolean isCanceledNow()
/* 182:    */     {
/* 183:748 */       return this.isCanceled;
/* 184:    */     }
/* 185:    */   }
/* 186:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.scheduler.AlgorithmTask
 * JD-Core Version:    0.7.0.1
 */