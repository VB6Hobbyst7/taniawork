package org.cishell.framework.algorithm;

import org.cishell.framework.data.Data;

public abstract interface Algorithm
{
  public abstract Data[] execute()
    throws AlgorithmExecutionException;
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.algorithm.Algorithm
 * JD-Core Version:    0.7.0.1
 */