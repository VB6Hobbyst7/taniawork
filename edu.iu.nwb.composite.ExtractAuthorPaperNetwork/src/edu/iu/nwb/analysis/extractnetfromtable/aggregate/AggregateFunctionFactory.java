package edu.iu.nwb.analysis.extractnetfromtable.aggregate;

public abstract interface AggregateFunctionFactory
{
  public abstract AbstractAggregateFunction getFunction(Class paramClass);
  
  public abstract AggregateFunctionName getType();
}


/* Location:           C:\Users\mark\Desktop\sci2\plugins\edu.iu.nwb.analysis.extractnetfromtable_1.0.2.jar
 * Qualified Name:     edu.iu.nwb.analysis.extractnetfromtable.aggregate.AggregateFunctionFactory
 * JD-Core Version:    0.7.0.1
 */