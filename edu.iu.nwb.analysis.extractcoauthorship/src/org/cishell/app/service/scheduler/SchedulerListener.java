package org.cishell.app.service.scheduler;

import java.util.Calendar;
import org.cishell.framework.algorithm.Algorithm;
import org.cishell.framework.data.Data;

public abstract interface SchedulerListener
{
  public abstract void algorithmScheduled(Algorithm paramAlgorithm, Calendar paramCalendar);
  
  public abstract void algorithmRescheduled(Algorithm paramAlgorithm, Calendar paramCalendar);
  
  public abstract void algorithmUnscheduled(Algorithm paramAlgorithm);
  
  public abstract void algorithmStarted(Algorithm paramAlgorithm);
  
  public abstract void algorithmFinished(Algorithm paramAlgorithm, Data[] paramArrayOfData);
  
  public abstract void algorithmError(Algorithm paramAlgorithm, Throwable paramThrowable);
  
  public abstract void schedulerRunStateChanged(boolean paramBoolean);
  
  public abstract void schedulerCleared();
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.scheduler.SchedulerListener
 * JD-Core Version:    0.7.0.1
 */