package org.cishell.framework.algorithm;

import org.cishell.framework.data.Data;
import org.osgi.service.metatype.ObjectClassDefinition;

public abstract interface ParameterMutator
{
  public abstract ObjectClassDefinition mutateParameters(Data[] paramArrayOfData, ObjectClassDefinition paramObjectClassDefinition);
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.framework.algorithm.ParameterMutator
 * JD-Core Version:    0.7.0.1
 */