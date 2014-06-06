package org.cishell.app.service.scheduler;

import java.util.Calendar;
import org.cishell.framework.algorithm.Algorithm;
import org.cishell.framework.data.Data;

public abstract class SchedulerAdapter
  implements SchedulerListener
{
  public void algorithmError(Algorithm algorithm, Throwable error) {}
  
  public void algorithmFinished(Algorithm algorithm, Data[] createdData) {}
  
  public void algorithmRescheduled(Algorithm algorithm, Calendar time) {}
  
  public void algorithmUnscheduled(Algorithm algorithm) {}
  
  public void algorithmScheduled(Algorithm algorithm, Calendar time) {}
  
  public void algorithmStarted(Algorithm algorithm) {}
  
  public void schedulerCleared() {}
  
  public void schedulerRunStateChanged(boolean isRunning) {}
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.scheduler.SchedulerAdapter
 * JD-Core Version:    0.7.0.1
 */