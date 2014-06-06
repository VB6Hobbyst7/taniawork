/*  1:   */ package org.cishell.reference.app.service.algorithminvocation;
/*  2:   */ 
/*  3:   */ import java.util.Dictionary;
/*  4:   */ import org.cishell.framework.CIShellContext;
/*  5:   */ import org.cishell.framework.algorithm.AlgorithmExecutionException;
/*  6:   */ import org.cishell.framework.data.Data;
/*  7:   */ import org.cishell.service.algorithminvocation.AlgorithmInvocationService;
/*  8:   */ import org.osgi.framework.ServiceReference;
/*  9:   */ 
/* 10:   */ public class AlgorithmInvocationServiceImpl
/* 11:   */   implements AlgorithmInvocationService
/* 12:   */ {
/* 13:   */   public Data[] runAlgorithm(String pid, Data[] inputData)
/* 14:   */     throws AlgorithmExecutionException
/* 15:   */   {
/* 16:14 */     return null;
/* 17:   */   }
/* 18:   */   
/* 19:   */   public Data[] wrapAlgorithm(String pid, CIShellContext callerCIShellContext, Data[] inputData, Dictionary<String, Object> parameters)
/* 20:   */     throws AlgorithmExecutionException
/* 21:   */   {
/* 22:23 */     return null;
/* 23:   */   }
/* 24:   */   
/* 25:   */   public ServiceReference createUniqueServiceReference(ServiceReference actualServiceReference)
/* 26:   */   {
/* 27:28 */     return null;
/* 28:   */   }
/* 29:   */   
/* 30:   */   public CIShellContext createUniqueCIShellContext(ServiceReference uniqueServiceReference)
/* 31:   */   {
/* 32:33 */     return null;
/* 33:   */   }
/* 34:   */ }


/* Location:           C:\Users\mark\Desktop\sci2\plugins\org.cishell.reference_1.0.0.jar
 * Qualified Name:     org.cishell.reference.app.service.algorithminvocation.AlgorithmInvocationServiceImpl
 * JD-Core Version:    0.7.0.1
 */