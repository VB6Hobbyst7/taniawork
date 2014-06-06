package org.cishell.service.algorithminvocation;

import java.util.Dictionary;
import org.cishell.framework.CIShellContext;
import org.cishell.framework.algorithm.AlgorithmExecutionException;
import org.cishell.framework.data.Data;
import org.osgi.framework.ServiceReference;

public abstract interface AlgorithmInvocationService
{
  public abstract Data[] runAlgorithm(String paramString, Data[] paramArrayOfData)
    throws AlgorithmExecutionException;
  
  public abstract Data[] wrapAlgorithm(String paramString, CIShellContext paramCIShellContext, Data[] paramArrayOfData, Dictionary<String, Object> paramDictionary)
    throws AlgorithmExecutionException;
  
  public abstract ServiceReference createUniqueServiceReference(ServiceReference paramServiceReference);
  
  public abstract CIShellContext createUniqueCIShellContext(ServiceReference paramServiceReference);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.algorithminvocation.AlgorithmInvocationService
 * JD-Core Version:    0.7.0.1
 */