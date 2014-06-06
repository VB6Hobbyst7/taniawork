package org.cishell.service.guibuilder;

import java.util.Dictionary;

public abstract interface SelectionListener
{
  public abstract void hitOk(Dictionary<String, Object> paramDictionary);
  
  public abstract void cancelled();
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.guibuilder.SelectionListener
 * JD-Core Version:    0.7.0.1
 */