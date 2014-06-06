package org.cishell.app.service.datamanager;

import org.cishell.framework.data.Data;

public class DataManagerAdapter
  implements DataManagerListener
{
  public void dataAdded(Data data, String label) {}
  
  public void dataRemoved(Data data) {}
  
  public void dataSelected(Data[] data) {}
  
  public void dataLabelChanged(Data data, String label) {}
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.datamanager.DataManagerAdapter
 * JD-Core Version:    0.7.0.1
 */