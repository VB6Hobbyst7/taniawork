package org.cishell.service.conversion;

import java.util.Dictionary;
import org.cishell.framework.algorithm.AlgorithmFactory;
import org.cishell.framework.data.Data;
import org.osgi.framework.ServiceReference;

public abstract interface Converter
{
  public abstract ServiceReference[] getConverterChain();
  
  public abstract AlgorithmFactory getAlgorithmFactory();
  
  public abstract Dictionary getProperties();
  
  public abstract Data convert(Data paramData)
    throws ConversionException;
  
  public abstract String calculateLossiness();
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.conversion.Converter
 * JD-Core Version:    0.7.0.1
 */