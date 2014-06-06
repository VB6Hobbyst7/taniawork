package org.cishell.service.conversion;

import org.cishell.framework.data.Data;

public abstract interface DataConversionService
{
  public abstract Converter[] findConverters(String paramString1, String paramString2);
  
  public abstract Converter[] findConverters(Data paramData, String paramString);
  
  public abstract Data convert(Data paramData, String paramString)
    throws ConversionException;
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.framework_1.0.0.jar
 * Qualified Name:     org.cishell.service.conversion.DataConversionService
 * JD-Core Version:    0.7.0.1
 */