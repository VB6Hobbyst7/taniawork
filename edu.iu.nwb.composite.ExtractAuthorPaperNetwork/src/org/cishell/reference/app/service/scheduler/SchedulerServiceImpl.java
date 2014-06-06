/*   1:    */ package org.cishell.reference.app.service.scheduler;
/*   2:    */ 
/*   3:    */ import java.util.Calendar;
/*   4:    */ import java.util.NoSuchElementException;
/*   5:    */ import java.util.Timer;
/*   6:    */ import org.cishell.app.service.scheduler.SchedulerListener;
/*   7:    */ import org.cishell.app.service.scheduler.SchedulerService;
/*   8:    */ import org.cishell.framework.algorithm.Algorithm;
/*   9:    */ import org.osgi.framework.ServiceReference;
/*  10:    */ 
/*  11:    */ public class SchedulerServiceImpl
/*  12:    */   implements SchedulerService
/*  13:    */ {
/*  14:    */   private Timer schedulerTimer;
/*  15:    */   private AlgorithmSchedulerTask algorithmSchedulerTask;
/*  16:    */   private SchedulerListenerInformer schedulerListenerInformer;
/*  17: 96 */   private boolean isShutDown = true;
/*  18:    */   
/*  19:    */   public SchedulerServiceImpl()
/*  20:    */   {
/*  21: 99 */     initialize();
/*  22:    */   }
/*  23:    */   
/*  24:    */   public SchedulerServiceImpl(int maxSimultaneousAlgorithm)
/*  25:    */   {
/*  26:103 */     this();
/*  27:104 */     this.algorithmSchedulerTask.setMaxSimultaneousAlgorithms(maxSimultaneousAlgorithm);
/*  28:105 */     this.isShutDown = false;
/*  29:    */   }
/*  30:    */   
/*  31:    */   public final synchronized void setMaxSimultaneousAlgorithms(int max)
/*  32:    */   {
/*  33:109 */     this.algorithmSchedulerTask.setMaxSimultaneousAlgorithms(max);
/*  34:    */   }
/*  35:    */   
/*  36:    */   private final void initialize()
/*  37:    */   {
/*  38:113 */     this.schedulerTimer = new Timer(true);
/*  39:114 */     this.schedulerListenerInformer = new SchedulerListenerInformer();
/*  40:115 */     this.algorithmSchedulerTask = new AlgorithmSchedulerTask(this.schedulerListenerInformer);
/*  41:116 */     this.schedulerTimer.schedule(this.algorithmSchedulerTask, 0L, 500L);
/*  42:    */   }
/*  43:    */   
/*  44:    */   public final synchronized void shutDown()
/*  45:    */   {
/*  46:120 */     this.algorithmSchedulerTask.cancel();
/*  47:121 */     this.schedulerTimer.cancel();
/*  48:122 */     this.isShutDown = true;
/*  49:    */   }
/*  50:    */   
/*  51:    */   public final boolean isEmpty()
/*  52:    */   {
/*  53:126 */     return this.algorithmSchedulerTask.isEmpty();
/*  54:    */   }
/*  55:    */   
/*  56:    */   public final boolean isRunning()
/*  57:    */   {
/*  58:130 */     return this.algorithmSchedulerTask.isRunning();
/*  59:    */   }
/*  60:    */   
/*  61:    */   public final int numRunning()
/*  62:    */   {
/*  63:134 */     return this.algorithmSchedulerTask.numRunning();
/*  64:    */   }
/*  65:    */   
/*  66:    */   public final boolean isShutDown()
/*  67:    */   {
/*  68:138 */     return this.isShutDown;
/*  69:    */   }
/*  70:    */   
/*  71:    */   public boolean reschedule(Algorithm algorithm, Calendar newTime)
/*  72:    */   {
/*  73:143 */     ServiceReference reference = this.algorithmSchedulerTask.getServiceReference(algorithm);
/*  74:144 */     boolean canReschedule = false;
/*  75:    */     try
/*  76:    */     {
/*  77:147 */       AlgorithmTask.AlgorithmState algorithmState = 
/*  78:148 */         this.algorithmSchedulerTask.getAlgorithmState(algorithm);
/*  79:151 */       if (algorithmState.equals(AlgorithmTask.AlgorithmState.RUNNING))
/*  80:    */       {
/*  81:152 */         canReschedule = false;
/*  82:    */       }
/*  83:153 */       else if (algorithmState.equals(AlgorithmTask.AlgorithmState.STOPPED))
/*  84:    */       {
/*  85:154 */         this.algorithmSchedulerTask.purgeFinished();
/*  86:155 */         this.algorithmSchedulerTask.schedule(algorithm, reference, newTime);
/*  87:156 */         canReschedule = true;
/*  88:    */       }
/*  89:157 */       else if (algorithmState.equals(AlgorithmTask.AlgorithmState.NEW))
/*  90:    */       {
/*  91:158 */         this.algorithmSchedulerTask.cancel(algorithm);
/*  92:159 */         this.algorithmSchedulerTask.schedule(algorithm, reference, newTime);
/*  93:    */       }
/*  94:    */       else
/*  95:    */       {
/*  96:161 */         throw new IllegalStateException("Encountered an invalid state: " + algorithmState);
/*  97:    */       }
/*  98:    */     }
/*  99:    */     catch (NoSuchElementException localNoSuchElementException)
/* 100:    */     {
/* 101:164 */       this.algorithmSchedulerTask.schedule(algorithm, reference, newTime);
/* 102:165 */       canReschedule = true;
/* 103:    */     }
/* 104:167 */     return canReschedule;
/* 105:    */   }
/* 106:    */   
/* 107:    */   public void runNow(Algorithm algorithm, ServiceReference reference)
/* 108:    */   {
/* 109:173 */     schedule(algorithm, reference);
/* 110:    */   }
/* 111:    */   
/* 112:    */   public void schedule(Algorithm algorithm, ServiceReference reference)
/* 113:    */   {
/* 114:177 */     schedule(algorithm, reference, Calendar.getInstance());
/* 115:    */   }
/* 116:    */   
/* 117:    */   public void schedule(Algorithm algorithm, ServiceReference reference, Calendar time)
/* 118:    */   {
/* 119:181 */     this.algorithmSchedulerTask.schedule(algorithm, reference, time);
/* 120:    */   }
/* 121:    */   
/* 122:    */   public boolean unschedule(Algorithm algorithm)
/* 123:    */   {
/* 124:185 */     return this.algorithmSchedulerTask.cancel(algorithm);
/* 125:    */   }
/* 126:    */   
/* 127:    */   public void addSchedulerListener(SchedulerListener listener)
/* 128:    */   {
/* 129:189 */     this.schedulerListenerInformer.addSchedulerListener(listener);
/* 130:    */   }
/* 131:    */   
/* 132:    */   public void removeSchedulerListener(SchedulerListener listener)
/* 133:    */   {
/* 134:193 */     this.schedulerListenerInformer.removeSchedulerListener(listener);
/* 135:    */   }
/* 136:    */   
/* 137:    */   public synchronized void clearSchedule()
/* 138:    */   {
/* 139:197 */     this.algorithmSchedulerTask.cancel();
/* 140:198 */     this.schedulerTimer.cancel();
/* 141:    */     
/* 142:200 */     this.schedulerTimer = new Timer(true);
/* 143:201 */     this.algorithmSchedulerTask = new AlgorithmSchedulerTask(this.schedulerListenerInformer);
/* 144:    */     
/* 145:203 */     this.schedulerTimer.schedule(this.algorithmSchedulerTask, 0L, 500L);
/* 146:    */     
/* 147:205 */     this.schedulerListenerInformer.schedulerCleared();
/* 148:    */   }
/* 149:    */   
/* 150:    */   public Algorithm[] getScheduledAlgorithms()
/* 151:    */   {
/* 152:209 */     return this.algorithmSchedulerTask.getScheduledAlgorithms();
/* 153:    */   }
/* 154:    */   
/* 155:    */   public Calendar getScheduledTime(Algorithm algorithm)
/* 156:    */   {
/* 157:213 */     return this.algorithmSchedulerTask.getScheduledTime(algorithm);
/* 158:    */   }
/* 159:    */   
/* 160:    */   public ServiceReference getServiceReference(Algorithm algorithm)
/* 161:    */   {
/* 162:217 */     return this.algorithmSchedulerTask.getServiceReference(algorithm);
/* 163:    */   }
/* 164:    */   
/* 165:    */   public void setRunning(boolean isRunning)
/* 166:    */   {
/* 167:221 */     this.algorithmSchedulerTask.setRunning(isRunning);
/* 168:222 */     this.schedulerListenerInformer.schedulerRunStateChanged(isRunning);
/* 169:    */   }
/* 170:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.scheduler.SchedulerServiceImpl
 * JD-Core Version:    0.7.0.1
 */