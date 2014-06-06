package org.cishell.service.algorithminvocation;

import java.util.Dictionary;
import org.cishell.framework.CIShellContext;
import org.cishell.framework.algorithm.Algorithm;
import org.cishell.framework.algorithm.AlgorithmCanceledException;
import org.cishell.framework.algorithm.AlgorithmCreationCanceledException;
import org.cishell.framework.algorithm.AlgorithmCreationFailedException;
import org.cishell.framework.algorithm.AlgorithmExecutionException;
import org.cishell.framework.algorithm.AlgorithmFactory;
import org.cishell.framework.data.Data;

public abstract interface FakeAlgorithmInvocationService
{
  public abstract Algorithm createAlgorithm(AlgorithmFactory paramAlgorithmFactory, Data[] paramArrayOfData, CIShellContext paramCIShellContext, boolean paramBoolean)
    throws AlgorithmCreationCanceledException, AlgorithmCreationFailedException;
  
  public abstract Algorithm createAlgorithm(AlgorithmFactory paramAlgorithmFactory, Data[] paramArrayOfData, Dictionary<String, Object> paramDictionary, CIShellContext paramCIShellContext, boolean paramBoolean)
    throws AlgorithmCreationCanceledException, AlgorithmCreationFailedException;
  
  public abstract Data[] invokeAlgorithm(Algorithm paramAlgorithm, boolean paramBoolean1, boolean paramBoolean2, boolean paramBoolean3)
    throws AlgorithmCanceledException, AlgorithmExecutionException;
  
  public abstract Data[] simpleInvokeAlgorithm(Algorithm paramAlgorithm, Thread paramThread)
    throws AlgorithmCanceledException, AlgorithmExecutionException;
  
  public abstract Data[] createAndInvokeAlgorithm(AlgorithmFactory paramAlgorithmFactory, Data[] paramArrayOfData, CIShellContext paramCIShellContext, boolean paramBoolean1, boolean paramBoolean2, boolean paramBoolean3)
    throws AlgorithmCreationCanceledException, AlgorithmCreationFailedException, AlgorithmCanceledException, AlgorithmExecutionException;
  
  public abstract Data[] createAndInvokeAlgorithm(AlgorithmFactory paramAlgorithmFactory, Data[] paramArrayOfData, Dictionary<String, Object> paramDictionary, CIShellContext paramCIShellContext, boolean paramBoolean1, boolean paramBoolean2, boolean paramBoolean3)
    throws AlgorithmCreationCanceledException, AlgorithmCreationFailedException, AlgorithmCanceledException, AlgorithmExecutionException;
  
  public abstract Data[] simpleCreateAndInvokeAlgorithm(AlgorithmFactory paramAlgorithmFactory, Data[] paramArrayOfData, Dictionary<String, Object> paramDictionary, CIShellContext paramCIShellContext, boolean paramBoolean)
    throws AlgorithmCreationCanceledException, AlgorithmCreationFailedException, AlgorithmCanceledException, AlgorithmExecutionException;
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.algorithminvocation.FakeAlgorithmInvocationService
 * JD-Core Version:    0.7.0.1
 */