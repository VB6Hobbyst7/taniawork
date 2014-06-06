package org.cishell.app.service.filesaver;

import java.io.File;
import org.cishell.framework.data.Data;
import org.cishell.service.conversion.Converter;

public abstract interface FileSaverService
{
  public static final String ANY_FILE_EXTENSION = "file-ext:*";
  
  public abstract void registerListener(FileSaveListener paramFileSaveListener);
  
  public abstract void unregisterListener(FileSaveListener paramFileSaveListener);
  
  public abstract Converter promptForConverter(Data paramData, String paramString)
    throws FileSaveException;
  
  public abstract File promptForTargetFile()
    throws FileSaveException;
  
  public abstract File promptForTargetFile(String paramString)
    throws FileSaveException;
  
  public abstract File promptForTargetFile(Data paramData, String paramString)
    throws FileSaveException;
  
  public abstract File promptForTargetFile(File paramFile)
    throws FileSaveException;
  
  public abstract File promptForTargetFile(String paramString1, String paramString2)
    throws FileSaveException;
  
  public abstract File saveData(Data paramData)
    throws FileSaveException;
  
  public abstract File saveData(Data paramData, String paramString)
    throws FileSaveException;
  
  public abstract File saveData(Data paramData, Converter paramConverter)
    throws FileSaveException;
  
  public abstract File saveData(Data paramData, Converter paramConverter, File paramFile)
    throws FileSaveException;
  
  public abstract File save(File paramFile)
    throws FileSaveException;
  
  public abstract void saveTo(File paramFile1, File paramFile2)
    throws FileSaveException;
  
  public abstract String suggestFileName(Data paramData);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.filesaver.FileSaverService
 * JD-Core Version:    0.7.0.1
 */