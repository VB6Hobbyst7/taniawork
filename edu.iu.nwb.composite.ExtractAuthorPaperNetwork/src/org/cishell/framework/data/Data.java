package org.cishell.framework.data;

import java.util.Dictionary;

public abstract interface Data
{
  public abstract Dictionary<String, Object> getMetadata();
  
  public abstract Object getData();
  
  public abstract String getFormat();
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.data.Data
 * JD-Core Version:    0.7.0.1
 */