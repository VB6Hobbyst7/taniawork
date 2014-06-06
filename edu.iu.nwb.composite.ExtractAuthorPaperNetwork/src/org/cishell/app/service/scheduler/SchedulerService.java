package org.cishell.app.service.scheduler;

import java.util.Calendar;
import org.cishell.framework.algorithm.Algorithm;
import org.osgi.framework.ServiceReference;

public abstract interface SchedulerService
{
  public abstract void runNow(Algorithm paramAlgorithm, ServiceReference paramServiceReference);
  
  public abstract void schedule(Algorithm paramAlgorithm, ServiceReference paramServiceReference);
  
  public abstract void schedule(Algorithm paramAlgorithm, ServiceReference paramServiceReference, Calendar paramCalendar);
  
  public abstract boolean reschedule(Algorithm paramAlgorithm, Calendar paramCalendar);
  
  public abstract boolean unschedule(Algorithm paramAlgorithm);
  
  public abstract void addSchedulerListener(SchedulerListener paramSchedulerListener);
  
  public abstract void removeSchedulerListener(SchedulerListener paramSchedulerListener);
  
  public abstract boolean isRunning();
  
  public abstract void setRunning(boolean paramBoolean);
  
  public abstract Algorithm[] getScheduledAlgorithms();
  
  public abstract Calendar getScheduledTime(Algorithm paramAlgorithm);
  
  public abstract ServiceReference getServiceReference(Algorithm paramAlgorithm);
  
  public abstract void clearSchedule();
  
  public abstract boolean isEmpty();
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.scheduler.SchedulerService
 * JD-Core Version:    0.7.0.1
 */