package org.cishell.app.service.datamanager;

import org.cishell.framework.data.Data;

public abstract interface DataManagerService
{
  public abstract void addData(Data paramData);
  
  public abstract void removeData(Data paramData);
  
  public abstract void setSelectedData(Data[] paramArrayOfData);
  
  public abstract Data[] getSelectedData();
  
  public abstract Data[] getAllData();
  
  public abstract void addDataManagerListener(DataManagerListener paramDataManagerListener);
  
  public abstract void removeDataManagerListener(DataManagerListener paramDataManagerListener);
  
  public abstract String getLabel(Data paramData);
  
  public abstract void setLabel(Data paramData, String paramString);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.datamanager.DataManagerService
 * JD-Core Version:    0.7.0.1
 */