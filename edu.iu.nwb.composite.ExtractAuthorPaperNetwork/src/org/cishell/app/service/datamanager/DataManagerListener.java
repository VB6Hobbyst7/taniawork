package org.cishell.app.service.datamanager;

import org.cishell.framework.data.Data;

public abstract interface DataManagerListener
{
  public abstract void dataAdded(Data paramData, String paramString);
  
  public abstract void dataLabelChanged(Data paramData, String paramString);
  
  public abstract void dataRemoved(Data paramData);
  
  public abstract void dataSelected(Data[] paramArrayOfData);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.datamanager.DataManagerListener
 * JD-Core Version:    0.7.0.1
 */