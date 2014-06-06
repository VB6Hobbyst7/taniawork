package org.cishell.framework.algorithm;

import java.util.Dictionary;
import org.cishell.framework.CIShellContext;
import org.cishell.framework.data.Data;

public abstract interface AlgorithmFactory
{
  public abstract Algorithm createAlgorithm(Data[] paramArrayOfData, Dictionary<String, Object> paramDictionary, CIShellContext paramCIShellContext);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.algorithm.AlgorithmFactory
 * JD-Core Version:    0.7.0.1
 */