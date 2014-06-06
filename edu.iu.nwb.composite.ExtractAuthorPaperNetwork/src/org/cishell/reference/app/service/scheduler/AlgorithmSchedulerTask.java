/*   1:    */ package org.cishell.reference.app.service.scheduler;
/*   2:    */ 
/*   3:    */ import java.util.Calendar;
/*   4:    */ import java.util.Collection;
/*   5:    */ import java.util.Collections;
/*   6:    */ import java.util.Date;
/*   7:    */ import java.util.HashMap;
/*   8:    */ import java.util.Iterator;
/*   9:    */ import java.util.Map;
/*  10:    */ import java.util.Map.Entry;
/*  11:    */ import java.util.NoSuchElementException;
/*  12:    */ import java.util.Set;
/*  13:    */ import java.util.TimerTask;
/*  14:    */ import org.cishell.app.service.scheduler.SchedulerListener;
/*  15:    */ import org.cishell.framework.algorithm.Algorithm;
/*  16:    */ import org.cishell.framework.data.Data;
/*  17:    */ import org.osgi.framework.ServiceReference;
/*  18:    */ 
/*  19:    */ class AlgorithmSchedulerTask
/*  20:    */   extends TimerTask
/*  21:    */   implements SchedulerListener
/*  22:    */ {
/*  23:    */   public static final int AS_MANY_SIMULTANEOUS_ALGORITHMS_AS_NEEDED = -1;
/*  24:    */   private Map<Algorithm, AlgorithmTask> tasksByAlgorithms;
/*  25:    */   private Map<Algorithm, ServiceReference> serviceReferencesByAlgorithms;
/*  26:304 */   private volatile boolean isRunning = true;
/*  27:305 */   private volatile int runningTaskCount = 0;
/*  28:    */   private SchedulerListener schedulerListener;
/*  29:307 */   private int maxSimultaneousAlgorithms = -1;
/*  30:    */   
/*  31:    */   public final synchronized void setMaxSimultaneousAlgorithms(int max)
/*  32:    */   {
/*  33:318 */     if (max < -1) {
/*  34:319 */       this.maxSimultaneousAlgorithms = -1;
/*  35:    */     } else {
/*  36:321 */       this.maxSimultaneousAlgorithms = max;
/*  37:    */     }
/*  38:    */   }
/*  39:    */   
/*  40:    */   public synchronized Algorithm[] getScheduledAlgorithms()
/*  41:    */   {
/*  42:326 */     return (Algorithm[])this.tasksByAlgorithms.keySet().toArray(new Algorithm[0]);
/*  43:    */   }
/*  44:    */   
/*  45:    */   public final synchronized boolean isEmpty()
/*  46:    */   {
/*  47:330 */     return this.tasksByAlgorithms.size() == 0;
/*  48:    */   }
/*  49:    */   
/*  50:    */   public final synchronized int numRunning()
/*  51:    */   {
/*  52:334 */     return this.runningTaskCount;
/*  53:    */   }
/*  54:    */   
/*  55:    */   public AlgorithmSchedulerTask(SchedulerListener listener)
/*  56:    */   {
/*  57:338 */     this.tasksByAlgorithms = 
/*  58:339 */       Collections.synchronizedMap(new HashMap());
/*  59:340 */     this.serviceReferencesByAlgorithms = new HashMap();
/*  60:341 */     setSchedulerListener(listener);
/*  61:    */   }
/*  62:    */   
/*  63:    */   public final synchronized void setSchedulerListener(SchedulerListener listener)
/*  64:    */   {
/*  65:345 */     this.schedulerListener = listener;
/*  66:    */   }
/*  67:    */   
/*  68:    */   public final ServiceReference getServiceReference(Algorithm algorithm)
/*  69:    */   {
/*  70:349 */     return (ServiceReference)this.serviceReferencesByAlgorithms.get(algorithm);
/*  71:    */   }
/*  72:    */   
/*  73:    */   public final synchronized Calendar getScheduledTime(Algorithm algorithm)
/*  74:    */   {
/*  75:353 */     AlgorithmTask task = (AlgorithmTask)this.tasksByAlgorithms.get(algorithm);
/*  76:355 */     if (task != null) {
/*  77:356 */       return task.getScheduledTime();
/*  78:    */     }
/*  79:358 */     return null;
/*  80:    */   }
/*  81:    */   
/*  82:    */   public final synchronized boolean cancel(Algorithm algorithm)
/*  83:    */   {
/*  84:363 */     AlgorithmTask task = (AlgorithmTask)this.tasksByAlgorithms.get(algorithm);
/*  85:365 */     if (task == null) {
/*  86:366 */       return false;
/*  87:    */     }
/*  88:373 */     return task.cancel();
/*  89:    */   }
/*  90:    */   
/*  91:    */   public final synchronized void schedule(Algorithm alg, ServiceReference ref, Calendar time)
/*  92:    */   {
/*  93:377 */     AlgorithmTask task = (AlgorithmTask)this.tasksByAlgorithms.get(alg);
/*  94:379 */     if (task != null)
/*  95:    */     {
/*  96:380 */       AlgorithmTask.AlgorithmState state = task.getState();
/*  97:382 */       if (state.equals(AlgorithmTask.AlgorithmState.RUNNING)) {
/*  98:383 */         throw new RuntimeException(
/*  99:384 */           "Cannot schedule running algorithm. Check state of algorithm first.");
/* 100:    */       }
/* 101:389 */       if (state.equals(AlgorithmTask.AlgorithmState.NEW)) {
/* 102:390 */         throw new RuntimeException(
/* 103:391 */           "Algorithm is already scheduled to run. Cancel existing schedule first.");
/* 104:    */       }
/* 105:393 */       if (state.equals(AlgorithmTask.AlgorithmState.STOPPED)) {
/* 106:395 */         purgeFinished();
/* 107:    */       } else {
/* 108:398 */         throw new IllegalStateException(
/* 109:399 */           "State was not one of allowable states: " + state);
/* 110:    */       }
/* 111:    */     }
/* 112:403 */     new AlgorithmTask(alg, ref, time, this);
/* 113:    */   }
/* 114:    */   
/* 115:    */   public final synchronized int getMaxSimultaneousAlgs()
/* 116:    */   {
/* 117:407 */     return this.maxSimultaneousAlgorithms;
/* 118:    */   }
/* 119:    */   
/* 120:    */   public final synchronized void registerAlgorithmTask(Algorithm algorithm, AlgorithmTask algorithmTask)
/* 121:    */   {
/* 122:411 */     this.serviceReferencesByAlgorithms.put(algorithm, algorithmTask.getServiceReference());
/* 123:412 */     this.tasksByAlgorithms.put(algorithm, algorithmTask);
/* 124:    */   }
/* 125:    */   
/* 126:    */   public final synchronized AlgorithmTask.AlgorithmState getAlgorithmState(Algorithm algorithm)
/* 127:    */   {
/* 128:421 */     AlgorithmTask task = (AlgorithmTask)this.tasksByAlgorithms.get(algorithm);
/* 129:422 */     if (task == null) {
/* 130:423 */       throw new NoSuchElementException("Algorithm doesn't exist.");
/* 131:    */     }
/* 132:424 */     return task.getState();
/* 133:    */   }
/* 134:    */   
/* 135:    */   public final synchronized void purgeFinished()
/* 136:    */   {
/* 137:431 */     synchronized (this)
/* 138:    */     {
/* 139:432 */       Iterator<Map.Entry<Algorithm, AlgorithmTask>> entries = 
/* 140:433 */         this.tasksByAlgorithms.entrySet().iterator();
/* 141:435 */       while (entries.hasNext())
/* 142:    */       {
/* 143:436 */         Map.Entry<Algorithm, AlgorithmTask> entry = (Map.Entry)entries.next();
/* 144:437 */         AlgorithmTask task = (AlgorithmTask)entry.getValue();
/* 145:439 */         if (task.getState() == AlgorithmTask.AlgorithmState.STOPPED)
/* 146:    */         {
/* 147:440 */           entries.remove();
/* 148:441 */           this.serviceReferencesByAlgorithms.remove(entry.getKey());
/* 149:    */         }
/* 150:    */       }
/* 151:    */     }
/* 152:    */   }
/* 153:    */   
/* 154:    */   private final synchronized boolean limitReached()
/* 155:    */   {
/* 156:450 */     return (this.maxSimultaneousAlgorithms != -1) && (this.runningTaskCount >= this.maxSimultaneousAlgorithms);
/* 157:    */   }
/* 158:    */   
/* 159:    */   public void setRunning(boolean isRunning)
/* 160:    */   {
/* 161:455 */     this.isRunning = isRunning;
/* 162:    */   }
/* 163:    */   
/* 164:    */   public boolean isRunning()
/* 165:    */   {
/* 166:459 */     return this.isRunning;
/* 167:    */   }
/* 168:    */   
/* 169:    */   public void run()
/* 170:    */   {
/* 171:463 */     if (this.isRunning) {
/* 172:464 */       synchronized (this)
/* 173:    */       {
/* 174:466 */         Date now = Calendar.getInstance().getTime();
/* 175:    */         
/* 176:468 */         Collection<AlgorithmTask> tasks = this.tasksByAlgorithms.values();
/* 177:470 */         for (AlgorithmTask task : tasks)
/* 178:    */         {
/* 179:471 */           if (limitReached()) {
/* 180:472 */             return;
/* 181:    */           }
/* 182:475 */           if ((task.getState() == AlgorithmTask.AlgorithmState.NEW) && 
/* 183:476 */             (now.compareTo(task.getScheduledTime().getTime()) >= 0)) {
/* 184:478 */             task.start();
/* 185:    */           }
/* 186:    */         }
/* 187:    */       }
/* 188:    */     }
/* 189:    */   }
/* 190:    */   
/* 191:    */   public synchronized void algorithmScheduled(Algorithm algorithm, Calendar time)
/* 192:    */   {
/* 193:486 */     this.schedulerListener.algorithmScheduled(algorithm, time);
/* 194:    */   }
/* 195:    */   
/* 196:    */   public synchronized void algorithmStarted(Algorithm algorithm)
/* 197:    */   {
/* 198:490 */     this.runningTaskCount += 1;
/* 199:491 */     this.schedulerListener.algorithmStarted(algorithm);
/* 200:    */   }
/* 201:    */   
/* 202:    */   public synchronized void algorithmError(Algorithm algorithm, Throwable error)
/* 203:    */   {
/* 204:495 */     this.runningTaskCount -= 1;
/* 205:496 */     this.schedulerListener.algorithmError(algorithm, error);
/* 206:497 */     purgeFinished();
/* 207:    */   }
/* 208:    */   
/* 209:    */   public synchronized void algorithmFinished(Algorithm algorithm, Data[] createdDM)
/* 210:    */   {
/* 211:501 */     this.runningTaskCount -= 1;
/* 212:502 */     this.schedulerListener.algorithmFinished(algorithm, createdDM);
/* 213:503 */     purgeFinished();
/* 214:    */   }
/* 215:    */   
/* 216:    */   public synchronized void algorithmRescheduled(Algorithm algorithm, Calendar time)
/* 217:    */   {
/* 218:507 */     this.schedulerListener.algorithmRescheduled(algorithm, time);
/* 219:    */   }
/* 220:    */   
/* 221:    */   public synchronized void algorithmUnscheduled(Algorithm algorithm)
/* 222:    */   {
/* 223:512 */     this.schedulerListener.algorithmUnscheduled(algorithm);
/* 224:    */   }
/* 225:    */   
/* 226:    */   public synchronized void schedulerCleared()
/* 227:    */   {
/* 228:516 */     this.schedulerListener.schedulerCleared();
/* 229:    */   }
/* 230:    */   
/* 231:    */   public synchronized void schedulerRunStateChanged(boolean isRunning)
/* 232:    */   {
/* 233:520 */     this.schedulerListener.schedulerRunStateChanged(isRunning);
/* 234:    */   }
/* 235:    */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.scheduler.AlgorithmSchedulerTask
 * JD-Core Version:    0.7.0.1
 */