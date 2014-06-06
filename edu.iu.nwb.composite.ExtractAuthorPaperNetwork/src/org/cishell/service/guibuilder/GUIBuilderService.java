package org.cishell.service.guibuilder;

import java.util.Dictionary;
import org.osgi.service.metatype.MetaTypeProvider;

public abstract interface GUIBuilderService
{
  public abstract GUI createGUI(String paramString, MetaTypeProvider paramMetaTypeProvider);
  
  public abstract Dictionary createGUIandWait(String paramString, MetaTypeProvider paramMetaTypeProvider);
  
  public abstract boolean showConfirm(String paramString1, String paramString2, String paramString3);
  
  public abstract boolean showQuestion(String paramString1, String paramString2, String paramString3);
  
  public abstract void showInformation(String paramString1, String paramString2, String paramString3);
  
  public abstract void showWarning(String paramString1, String paramString2, String paramString3);
  
  public abstract void showError(String paramString1, String paramString2, String paramString3);
  
  public abstract void showError(String paramString1, String paramString2, Throwable paramThrowable);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.guibuilder.GUIBuilderService
 * JD-Core Version:    0.7.0.1
 */