package org.cishell.app.service.fileloader;

import java.io.File;
import org.cishell.framework.CIShellContext;
import org.cishell.framework.algorithm.AlgorithmFactory;
import org.cishell.framework.algorithm.ProgressMonitor;
import org.cishell.framework.data.Data;
import org.osgi.framework.BundleContext;
import org.osgi.service.log.LogService;

public abstract interface FileLoaderService
{
  public abstract void registerListener(FileLoadListener paramFileLoadListener);
  
  public abstract void unregisterListener(FileLoadListener paramFileLoadListener);
  
  public abstract File[] getFilesToLoadFromUser(boolean paramBoolean, String[] paramArrayOfString)
    throws FileLoadException;
  
  public abstract Data[] loadFilesFromUserSelection(BundleContext paramBundleContext, CIShellContext paramCIShellContext, LogService paramLogService, ProgressMonitor paramProgressMonitor, boolean paramBoolean)
    throws FileLoadException;
  
  public abstract Data[] loadFiles(BundleContext paramBundleContext, CIShellContext paramCIShellContext, LogService paramLogService, ProgressMonitor paramProgressMonitor, File[] paramArrayOfFile)
    throws FileLoadException;
  
  public abstract Data[] loadFile(BundleContext paramBundleContext, CIShellContext paramCIShellContext, LogService paramLogService, ProgressMonitor paramProgressMonitor, File paramFile)
    throws FileLoadException;
  
  public abstract Data[] loadFileOfType(BundleContext paramBundleContext, CIShellContext paramCIShellContext, LogService paramLogService, ProgressMonitor paramProgressMonitor, File paramFile, String paramString1, String paramString2)
    throws FileLoadException;
  
  public abstract Data[] loadFileOfType(BundleContext paramBundleContext, CIShellContext paramCIShellContext, LogService paramLogService, ProgressMonitor paramProgressMonitor, File paramFile, AlgorithmFactory paramAlgorithmFactory)
    throws FileLoadException;
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.app.service.fileloader.FileLoaderService
 * JD-Core Version:    0.7.0.1
 */