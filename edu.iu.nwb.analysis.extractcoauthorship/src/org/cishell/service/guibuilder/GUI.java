package org.cishell.service.guibuilder;

import java.util.Dictionary;

public abstract interface GUI
{
  public abstract Dictionary openAndWait();
  
  public abstract void open();
  
  public abstract void close();
  
  public abstract boolean isClosed();
  
  public abstract void setSelectionListener(SelectionListener paramSelectionListener);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.guibuilder.GUI
 * JD-Core Version:    0.7.0.1
 */